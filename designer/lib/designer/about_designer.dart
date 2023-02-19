import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer/designer/help_wrapper.dart';
import 'package:studyu_designer/models/app_state.dart';

class AboutDesigner extends StatefulWidget {
  @override
  _AboutDesignerState createState() => _AboutDesignerState();
}

class _AboutDesignerState extends State<AboutDesigner> {
  Study _draftStudy;
  final GlobalKey<FormBuilderState> _editFormKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _draftStudy = context.read<AppState>().draftStudy;
  }

  Future<void> _pickIcon() async {
    final icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.custom],
      customIconPack: {for (var key in MdiIcons.getIconsName()) key: MdiIcons.fromString(key)},
    );

    final iconName = iconMap.keys.firstWhere((k) => iconMap[k] == icon.codePoint, orElse: () => null);
    setState(() {
      _draftStudy.iconName = iconName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<AppState>().draftStudy == null) return Container();
    final theme = Theme.of(context);
    return DesignerHelpWrapper(
      helpTitle: AppLocalizations.of(context).about_help_title,
      helpText: AppLocalizations.of(context).about_help_body,
      studyPublished: _draftStudy.published,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _editFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // readonly: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'title',
                      maxLength: 40,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).title),
                      initialValue: _draftStudy.title,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'description',
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).description),
                      initialValue: _draftStudy.description,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _pickIcon,
                            child: Text(AppLocalizations.of(context).choose_icon),
                          ),
                        ),
                        if (MdiIcons.fromString(_draftStudy.iconName) != null)
                          Expanded(child: Icon(MdiIcons.fromString(_draftStudy.iconName)))
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(AppLocalizations.of(context).contact_details, style: theme.textTheme.titleLarge),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'organization',
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).organization),
                      initialValue: _draftStudy.contact.organization,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'institutionalReviewBoard',
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).irb),
                      initialValue: _draftStudy.contact.institutionalReviewBoard,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'institutionalReviewBoardNumber',
                      maxLength: 40,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).irb_number),
                      initialValue: _draftStudy.contact.institutionalReviewBoardNumber,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'researchers',
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).researchers),
                      initialValue: _draftStudy.contact.researchers,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'website',
                      validator: FormBuilderValidators.url(),
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).website),
                      initialValue: _draftStudy.contact.website,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'email',
                      validator: FormBuilderValidators.email(),
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).email),
                      initialValue: _draftStudy.contact.email,
                    ),
                    FormBuilderTextField(
                      onChanged: _saveFormChanges,
                      name: 'phone',
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).phone),
                      initialValue: _draftStudy.contact.phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFormChanges(value) {
    _editFormKey.currentState.save();
    if (_editFormKey.currentState.validate()) {
      setState(() {
        _draftStudy
          ..title = _editFormKey.currentState.value['title'] as String
          ..description = _editFormKey.currentState.value['description'] as String
          ..contact.organization = _editFormKey.currentState.value['organization'] as String
          ..contact.institutionalReviewBoard = _editFormKey.currentState.value['institutionalReviewBoard'] as String
          ..contact.institutionalReviewBoardNumber =
              _editFormKey.currentState.value['institutionalReviewBoardNumber'] as String
          ..contact.researchers = _editFormKey.currentState.value['researchers'] as String
          ..contact.website = _editFormKey.currentState.value['website'] as String
          ..contact.email = _editFormKey.currentState.value['email'] as String
          ..contact.phone = _editFormKey.currentState.value['phone'] as String;
      });
    }
  }
}
