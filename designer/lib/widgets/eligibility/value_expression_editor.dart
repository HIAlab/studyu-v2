import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:studyu_core/core.dart';

import './choice_expression_editor_section.dart';

class ValueExpressionEditor extends StatefulWidget {
  final ValueExpression expression;
  final List<Question> questions;
  final void Function(Expression newExpression) updateExpression;

  const ValueExpressionEditor({
    @required this.expression,
    @required this.questions,
    @required this.updateExpression,
    Key key,
  }) : super(key: key);

  @override
  _ValueExpressionEditorState createState() => _ValueExpressionEditorState();
}

class _ValueExpressionEditorState extends State<ValueExpressionEditor> {
  Question targetQuestion;

  @override
  void initState() {
    if (widget.expression.target != null) {
      targetQuestion = widget.questions.where((q) => q.id == widget.expression.target).toList()[0];
    } else {
      targetQuestion = null;
    }
    super.initState();
  }

  void _changeExpressionTarget(Question newTarget) {
    ValueExpression newExpression;
    if (newTarget is BooleanQuestion) {
      newExpression = BooleanExpression();
    } else if (newTarget is ChoiceQuestion) {
      final newChoiceExpression = ChoiceExpression.withId();
      newExpression = newChoiceExpression;
    }
    setState(() {
      targetQuestion = newTarget;
    });
    newExpression.target = newTarget.id;
    widget.updateExpression(newExpression);
  }

  @override
  Widget build(BuildContext context) {
    final expressionBody = _buildExpressionBody();

    return Column(
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context).target),
            const SizedBox(width: 10),
            DropdownButton<Question>(
              value: targetQuestion,
              onChanged: _changeExpressionTarget,
              items: widget.questions
                  .map((question) => DropdownMenuItem(value: question, child: Text(question.prompt)))
                  .toList(),
            )
          ],
        ),
        if (expressionBody != null) expressionBody
      ],
    );
  }

  Widget _buildExpressionBody() {
    switch (widget.expression.runtimeType) {
      case ChoiceExpression:
        return ChoiceExpressionEditorSection(
          expression: widget.expression as ChoiceExpression,
          targetQuestion: targetQuestion as ChoiceQuestion,
        );
      default:
        return null;
    }
  }
}
