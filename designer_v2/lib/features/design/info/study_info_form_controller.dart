import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer_v2/common_views/icon_picker.dart';
import 'package:studyu_designer_v2/features/design/info/study_info_form_data.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model.dart';
import 'package:studyu_designer_v2/utils/validation.dart';

class StudyInfoFormViewModel extends FormViewModel<StudyInfoFormData> {
  StudyInfoFormViewModel({
    required this.study,
    super.delegate,
    super.formData,
    super.autosave = true,
  });

  final Study study;

  // - Form fields

  // TODO: publish vs autosave validators
  final FormControl<String> titleControl =
      FormControl(validators: [Validators.required]);
  final FormControl<IconOption> iconControl = FormControl();
  final FormControl<String> descriptionControl = FormControl();
  final FormControl<String> organizationControl = FormControl();
  final FormControl<String> institutionalReviewBoardControl = FormControl();
  final FormControl<String> institutionalReviewBoardNumberControl =
      FormControl();
  final FormControl<String> researchersControl = FormControl();
  final FormControl<String> emailControl = FormControl(
      validators: [Validators.email]);
  final FormControl<String> websiteControl = FormControl(
      validators: [Validators.pattern(Patterns.url)]);
  final FormControl<String> phoneControl = FormControl();

  @override
  FormGroup get form => FormGroup({
    'title': titleControl,
    'icon': iconControl,
    'description': descriptionControl,
    'organization': organizationControl,
    'institutionalReviewBoard': institutionalReviewBoardControl,
    'institutionalReviewBoardNumber': institutionalReviewBoardNumberControl,
    'researchers': researchersControl,
    'email': emailControl,
    'website': websiteControl,
    'phone': phoneControl,
  });

  @override
  void setControlsFrom(StudyInfoFormData data) {
    titleControl.value = data.title;
    iconControl.value = IconOption(data.iconName);
    descriptionControl.value = data.description;
    organizationControl.value = data.contactInfoFormData.organization;
    institutionalReviewBoardControl.value =
        data.contactInfoFormData.institutionalReviewBoard;
    institutionalReviewBoardNumberControl.value =
        data.contactInfoFormData.institutionalReviewBoardNumber;
    researchersControl.value = data.contactInfoFormData.researchers;
    emailControl.value = data.contactInfoFormData.email;
    websiteControl.value = data.contactInfoFormData.website;
    phoneControl.value = data.contactInfoFormData.phone;
  }

  @override
  StudyInfoFormData buildFormData() {
    return StudyInfoFormData(
      title: titleControl.value!, // required
      iconName: iconControl.value?.name ?? '',
      description: descriptionControl.value,
      contactInfoFormData: StudyContactInfoFormData(
        organization: organizationControl.value,
        institutionalReviewBoard: institutionalReviewBoardControl.value,
        institutionalReviewBoardNumber:
            institutionalReviewBoardNumberControl.value,
        researchers: researchersControl.value,
        email: emailControl.value,
        website: websiteControl.value,
        phone: phoneControl.value,
      )
    );
  }

  @override
  Map<FormMode, String> get titles => throw UnimplementedError(); // unused
}