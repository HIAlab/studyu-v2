import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_designer_v2/common_views/action_popup_menu.dart';
import 'package:studyu_designer_v2/common_views/empty_body.dart';
import 'package:studyu_designer_v2/common_views/form_table_layout.dart';
import 'package:studyu_designer_v2/common_views/primary_button.dart';
import 'package:studyu_designer_v2/common_views/standard_table.dart';

typedef FormArrayTableRowLabelProvider<T> = String Function(T item);
typedef WidgetBuilderAt<T> = Widget Function(
    BuildContext context, T item, int rowIdx);

class FormArrayTable<T> extends StatelessWidget {
  const FormArrayTable({
    required this.control,
    required this.items,
    required this.onSelectItem,
    required this.getActionsAt,
    this.onNewItem,
    required this.onNewItemLabel,
    required this.rowTitle,
    this.rowPrefix,
    this.leadingWidget,
    this.sectionTitle,
    this.sectionTitleDivider = true,
    this.emptyIcon,
    this.emptyTitle,
    this.emptyDescription,
    Key? key
  })
      : assert(sectionTitle == null || leadingWidget == null,
            "Cannot specify both sectionTitle and leadingWidget"),
        super(key: key);

  final AbstractControl control;

  final List<T> items;
  final OnSelectHandler<T> onSelectItem;
  final ActionsProviderAt<T> getActionsAt;
  final VoidCallback? onNewItem;
  final FormArrayTableRowLabelProvider<T> rowTitle;

  final String onNewItemLabel;
  final String? sectionTitle;

  final IconData? emptyIcon;
  final String? emptyTitle;
  final String? emptyDescription;

  final bool? sectionTitleDivider;

  final WidgetBuilderAt<T>? rowPrefix;

  final Widget? leadingWidget;

  static final List<StandardTableColumn> columns = [
    const StandardTableColumn(
        label: '', // don't care (showTableHeader=false)
        columnWidth: FlexColumnWidth()),
  ];

  @override
  Widget build(BuildContext context) {
    final hasEmptyWidget =
        emptyIcon != null || emptyTitle != null || emptyDescription != null;

    Widget? leading;
    if (leadingWidget != null) {
      leading = leadingWidget;
    } else if (sectionTitle != null) {
      leading = FormTableLayout(
          rowDivider: (sectionTitleDivider ?? false)
              ? const Divider()
              : const SizedBox.shrink(),
          rows: [
            FormTableRow(
                label: sectionTitle!,
                input: Container(),
                labelStyle: Theme.of(context).textTheme.headline6)
          ]
      );
    }

    return StandardTable<T>(
      items: items,
      columns: columns,
      onSelectItem: onSelectItem,
      buildCellsAt: _buildRow,
      trailingActionsAt: getActionsAt,
      cellSpacing: 10.0,
      rowSpacing: 5.0,
      minRowHeight: 40.0,
      showTableHeader: false,
      leadingWidget: leading ?? const SizedBox.shrink(),
      trailingWidget: _newItemButton(),
      emptyWidget: (hasEmptyWidget)
          ? Padding(
              padding: const EdgeInsets.only(top: 24),
              child: EmptyBody(
                  icon: emptyIcon,
                  title: emptyTitle,
                  description: emptyDescription,
                  button: _newItemButton()),
            )
          : null,
    );
  }

  List<Widget> _buildRow(
      BuildContext context, T item, int rowIdx, Set<MaterialState> states) {
    final theme = Theme.of(context);
    final tableTextStyleSecondary =
        theme.textTheme.bodyText1!.copyWith(color: theme.colorScheme.secondary);

    return [
      SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            (rowPrefix != null)
                ? rowPrefix!(context, item, rowIdx)
                : const SizedBox.shrink(),
            Text(
              rowTitle(item),
              style: tableTextStyleSecondary.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    ];
  }

  Widget _newItemButton() {
    if (control.disabled) {
      return const SizedBox.shrink();
    }
    return PrimaryButton(
      icon: Icons.add,
      text: onNewItemLabel,
      onPressed: onNewItem,
    );
  }
}