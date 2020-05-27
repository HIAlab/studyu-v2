import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../database/models/intervention.dart';

class ProgressRow extends StatefulWidget {
  final List<Intervention> plannedInterventions;

  const ProgressRow({Key key, this.plannedInterventions}) : super(key: key);
  @override
  _ProgressRowState createState() => _ProgressRowState();
}

class _ProgressRowState extends State<ProgressRow> {
  Widget _buildInterventionSegment(BuildContext context, Intervention intervention) {
    final theme = Theme.of(context);
    return Expanded(
        child: Column(
      children: [
        RawMaterialButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('$Intervention: ${intervention.name}'),
                    ));
          },
          elevation: 0,
          fillColor: theme.accentColor,
          child: Icon(
            intervention.name == 'Exercise' ? MdiIcons.dumbbell : MdiIcons.pill,
            color: Colors.white,
            size: 18,
          ),
          shape: CircleBorder(),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            color: theme.accentColor,
            thickness: 8,
            indent: 34,
            endIndent: 34,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MdiIcons.run, size: 30),
              SizedBox(width: 8),
              ...widget.plannedInterventions.map((i) => _buildInterventionSegment(context, i)),
              SizedBox(width: 8),
              Icon(MdiIcons.flagCheckered, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
