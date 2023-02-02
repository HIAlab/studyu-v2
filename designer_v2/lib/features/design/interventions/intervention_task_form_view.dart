import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_designer_v2/common_views/form_control_label.dart';
import 'package:studyu_designer_v2/common_views/form_table_layout.dart';
import 'package:studyu_designer_v2/features/design/interventions/intervention_task_form_controller.dart';
import 'package:studyu_designer_v2/features/design/shared/schedule/schedule_controls_view.dart';
import 'package:studyu_designer_v2/features/forms/form_validation.dart';
import 'package:studyu_designer_v2/localization/app_translation.dart';

class InterventionTaskFormView extends StatelessWidget {
  const InterventionTaskFormView({required this.formViewModel, Key? key}) : super(key: key);

  final InterventionTaskFormViewModel formViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormTableLayout(rowLayout: FormTableRowLayout.vertical, rows: [
          FormTableRow(
            control: formViewModel.taskTitleControl,
            label: tr.form_field_intervention_task_title,
            labelHelpText: tr.form_field_intervention_task_title_tooltip,
            input: ReactiveTextField(
              formControl: formViewModel.taskTitleControl,
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              validationMessages: formViewModel.taskTitleControl.validationMessages,
            ),
          ),
          FormTableRow(
            control: formViewModel.taskDescriptionControl,
            label: tr.form_field_intervention_task_description,
            labelHelpText: tr.form_field_intervention_task_description_tooltip,
            input: ReactiveTextField(
              formControl: formViewModel.taskDescriptionControl,
              inputFormatters: [
                LengthLimitingTextInputFormatter(2000),
              ],
              validationMessages: formViewModel.taskDescriptionControl.validationMessages,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: tr.form_field_intervention_task_description_hint,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12.0),
        ReactiveFormConsumer(builder: (context, form, child) {
          return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            ReactiveCheckbox(
              formControl: formViewModel.markAsCompletedControl,
            ),
            const SizedBox(width: 3.0),
            FormControlLabel(
              formControl: formViewModel.markAsCompletedControl,
              text: tr.form_field_intervention_task_mark_as_completed_label,
            ),
          ]);
        }),
        const SizedBox(height: 24.0),
        ScheduleControls(formViewModel: formViewModel),
      ],
    );
  }
}
