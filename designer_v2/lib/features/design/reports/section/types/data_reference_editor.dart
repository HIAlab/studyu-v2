import 'package:flutter/material.dart';
import 'package:studyu_core/core.dart';

class DataReferenceEditor<T> extends StatefulWidget {
  final DataReference<T> reference;
  final List<Task> availableTaks;
  final void Function(DataReference<T> newReference) updateReference;

  const DataReferenceEditor({
    super.key,
    required this.reference,
    required this.availableTaks,
    required this.updateReference,
  });

  @override
  DataReferenceEditorState<T> createState() => DataReferenceEditorState<T>();
}

class DataReferenceEditorState<T> extends State<DataReferenceEditor<T>> {
  void _changeTarget(_DataReferenceIdentifier? identifier) {
    if (identifier == null) return;
    final newReference = DataReference<T>(identifier.task, identifier.property);

    widget.updateReference(newReference);
  }

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<_DataReferenceIdentifier>>[];
    for (final task in widget.availableTaks) {
      for (final entry in task.getAvailableProperties().entries) {
        if (entry.value == T) {
          items.add(
            DropdownMenuItem<_DataReferenceIdentifier>(
              value: _DataReferenceIdentifier(task.id, entry.key),
              child: Text('${task.title} > ${task.getHumanReadablePropertyName(entry.key)}'),
            ),
          );
        }
      }
    }

    return Row(
      children: [
        Text('AppLocalizations.of(context).data_source'),
        DropdownButton<_DataReferenceIdentifier>(
          value: widget.reference != null
              ? _DataReferenceIdentifier(widget.reference.task, widget.reference.property)
              : null,
          onChanged: _changeTarget,
          items: items,
        ),
      ],
    );
  }
}

@immutable
class _DataReferenceIdentifier {
  final String task;
  final String property;

  const _DataReferenceIdentifier(this.task, this.property);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _DataReferenceIdentifier &&
              runtimeType == other.runtimeType &&
              task == other.task &&
              property == other.property;

  @override
  int get hashCode => task.hashCode ^ property.hashCode;
}
