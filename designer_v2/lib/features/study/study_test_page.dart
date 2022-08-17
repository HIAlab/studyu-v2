import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyu_designer_v2/common_views/banner.dart';
import 'package:studyu_designer_v2/common_views/text_paragraph.dart';
import 'package:studyu_designer_v2/features/study/study_page_view.dart';
import 'package:studyu_designer_v2/features/study/study_test_controller.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';

class StudyTestScreen extends StudyPageWidget {
  const StudyTestScreen(studyId, {Key? key})
      : super(studyId, key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyTestControllerProvider(studyId));
    final frameController = ref.watch(studyTestPlatformControllerProvider(studyId));

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
                text: "Study cannot be tested yet".hardcoded,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextParagraph(
                text: "Please make sure the following fields are set: ${state.missingRequirements!.keys}".hardcoded
              ),
            ]
        ),
        style: BannerStyle.warning
    );
  }
}