import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyu_designer_v2/common_views/under_construction.dart';
import 'package:studyu_designer_v2/features/study/study_page_view.dart';

class StudyAnalyzeScreen extends StudyPageWidget {
  const StudyAnalyzeScreen(studyId, {Key? key}) : super(studyId, key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const UnderConstruction();
  }
}