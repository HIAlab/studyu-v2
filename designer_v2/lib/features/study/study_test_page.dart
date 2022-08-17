import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyu_designer_v2/common_views/banner.dart';
import 'package:studyu_designer_v2/common_views/text_paragraph.dart';
import 'package:studyu_designer_v2/features/study/study_page_view.dart';
import 'package:studyu_designer_v2/features/study/study_test_controller.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';
import 'package:studyu_designer_v2/services/notification_service.dart';
import 'package:studyu_designer_v2/services/notification_types.dart';
import 'package:studyu_designer_v2/services/notifications.dart';

class StudyTestScreen extends StudyPageWidget {
  const StudyTestScreen(studyId, {Key? key})
      : super(studyId, key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyTestControllerProvider(studyId));
    final frameController = ref.watch(studyTestPlatformControllerProvider(studyId));

    load().then((value) => value ? null : showHelp(ref));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        frameController!.frameWidget,
        const SizedBox(height: 24.0),
        Text("This is the preview mode.\nPress reset to "
            "remove the test progress and start over again.".hardcoded,
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 12.0),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.restart_alt),
                label: Text("Reset".hardcoded),
                onPressed: (!state.canTest) ? null : () {
                  frameController.sendCmd("reset");
                },
              ),
              TextButton.icon(
                  icon: const Icon(Icons.open_in_new_sharp),
                  label: Text("Open in new tab".hardcoded),
                  onPressed: (!state.canTest) ? null : () {
                    frameController.openNewPage();
                  },
              ),
            ]
        ),
      ],
    );
  }

  @override
  Widget? banner(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyTestControllerProvider(studyId));

    if (state.canTest) {
      return null;
    }
    return BannerBox(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextParagraph(
                text: "This study cannot be previewed yet".hardcoded,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextParagraph(
                text: "The preview is not available until the following study information is specified: ${state.missingRequirements!.keys}".hardcoded
              ),
            ]
        ),
        style: BannerStyle.warning,
    );
  }

  Future<bool> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool? visited = prefs.getBool('testScreenVisited');
      if (visited != null) {
        return visited;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }

  Future<bool> save() async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('testScreenVisited', true);
      return true;
    });
    return false;
  }

  showHelp(WidgetRef ref) {
    ref.read(notificationServiceProvider).show(
        Notifications.welcomeTestMode,
        actions: [
          NotificationAction(
              label: "Got it!".hardcoded,
              onSelect: Future.value,
              isDestructive: false
          ),
        ]
    );
    save();
  }
}
