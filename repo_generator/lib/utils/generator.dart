import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:pretty_json/pretty_json.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_core/env.dart' as env;

import 'package:studyu_repo_generator/utils/cli.dart';
import 'package:studyu_repo_generator/utils/database.dart';
import 'package:studyu_repo_generator/utils/file.dart';
import 'package:studyu_repo_generator/utils/gitlab.dart';

Future<void> generateRepo(GitlabClient gl, String studyId) async {
  print('Generating repo...');
  final dotEnv = DotEnv()..load();
  final generatedProjectPath = dotEnv['STUDYU_PROJECT_PATH'] ?? 'generated';

  // Fetch study schema and subjects data
  print('Fetching study data...');
  final study = await fetchStudySchema(studyId);
  final subjects = await fetchSubjects(studyId);

  print('Creating gitlab repo ${study.title}');
  // Create Gitlab project
  final projectProperties = await gl.createProject(study.title!);
  if (projectProperties == null) {
    print('Could not create project');
    return;
  }
  final projectId = (projectProperties['id'] as int).toString();

  // Generate ssh key
  print('Generating RSA key pair...');
  try {
    File('gitlabkey.pub').deleteSync();
    File('gitlabkey').deleteSync();
  } catch (e) {
    print(e);
  }
  await cliGenerateSshKey();
  final public = File('gitlabkey.pub').readAsStringSync();
  final private = File('gitlabkey').readAsStringSync();

  print('Adding deploy key...');
  await gl.addDeployKey(projectId: projectId, title: 'update_key', key: public, canPush: true);

  print('Creating project variables for session, studyId and key');
  // session cannot be masked due to format
  await gl.createProjectVariable(
    projectId: projectId,
    key: 'session',
    value: env.client.auth.session()!.persistSessionString,
  );
  await gl.createProjectVariable(projectId: projectId, key: 'study_id', value: studyId, masked: true);
  // Key cannot be masked due to format
  await gl.createProjectVariable(projectId: projectId, key: 'key', value: private);

  print('Creating project environment variables for supabase');
  await gl.createProjectVariable(
    projectId: projectId,
    key: 'STUDYU_SUPABASE_URL',
    value: env.supabaseUrl,
    masked: true,
  );
  await gl.createProjectVariable(
    projectId: projectId,
    key: 'STUDYU_SUPABASE_PUBLIC_ANON_KEY',
    value: env.supabaseAnonKey,
    masked: true,
  );

  // Generate files from nbconvert-template copier CLI
  print('Generating project files with copier...');
  final scaleQuestionIds = study.observations.expand((observation) {
    return (observation as QuestionnaireTask)
        .questions
        .questions
        .where((q) => q.type == AnnotatedScaleQuestion.questionType || q.type == VisualAnalogueQuestion.questionType)
        .map((q) => q.id);
  }).toList(growable: false);
  await cliGenerateCopierProject(
    generatedProjectPath,
    study.title!,
    scaleQuestionIds,
    Uri.encodeComponent(projectProperties['http_url_to_repo'] as String),
  );

  // Save study schema and subjects data
  print('Saving study schema and subjects as json...');
  await File(p.join(generatedProjectPath, 'data', 'study.schema.json')).writeAsString(prettyJson(study.toJson()));
  await File(p.join(generatedProjectPath, 'data', 'subjects.csv')).writeAsString(subjects);

  // Read all files in generated and make commit
  print('Collecting files into Gitlab commit...');
  final commitActions = allFilesInDir(generatedProjectPath).map((file) {
    final unixFilePath =
        p.Context(style: p.Style.posix).joinAll(p.split(p.relative(file.path, from: generatedProjectPath)));

    return gl.commitAction(filePath: unixFilePath, content: file.readAsStringSync());
  }).toList();

  print('Committing to Gitlab...');
  await gl.makeCommit(
    projectId: projectId,
    message: 'Generated project from copier-studyu\n\nhttps://github.com/hpi-studyu/copier-studyu',
    actions: commitActions,
  );

  print('Add repo entry to database...');
  try {
    await Repo(
      projectId,
      env.client.auth.user()!.id,
      studyId,
      GitProvider.gitlab,
      projectProperties['web_url'] as String,
      projectProperties['http_url_to_repo'] as String,
    ).save();
  } catch (e) {
    print(e);
  }

  print('Deleting generated files...');
  File(generatedProjectPath).deleteSync(recursive: true);
  print('Finished generating project');
}

Future<void> updateRepo(GitlabClient gl, String projectId, String studyId) async {
  // Update sessionToken project var
  print('Updating project session variable...');
  gl.updateProjectVariable(
    projectId: projectId,
    key: 'session',
    value: env.client.auth.session()!.persistSessionString,
  );

  print('Fetching study schema and subjects');
  final study = await fetchStudySchema(studyId);
  final subjects = await fetchSubjects(studyId);

  print('Committing to Gitlab...');
  await gl.makeCommit(
    projectId: projectId,
    message: 'Updating data and triggering CI notebook html refresh',
    actions: [
      gl.commitAction(filePath: 'data/study.schema.json', content: prettyJson(study.toJson()), action: 'update'),
      gl.commitAction(filePath: 'data/subjects.csv', content: subjects, action: 'update'),
    ],
  );
  // Make git commit
}
