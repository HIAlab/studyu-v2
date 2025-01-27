import 'package:flutter/material.dart';
import 'package:studyu_core/core.dart';

import './expression_editor.dart';

class NotExpressionEditor extends StatefulWidget {
  final NotExpression expression;
  final List<Question> questions;

  const NotExpressionEditor({@required this.expression, @required this.questions, Key key}) : super(key: key);

  @override
  _NotExpressionEditorState createState() => _NotExpressionEditorState();
}

class _NotExpressionEditorState extends State<NotExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return ExpressionEditor(
      expression: widget.expression.expression,
      questions: widget.questions,
      updateExpression: (newExpression) {
        setState(() {
          widget.expression.expression = newExpression;
        });
      },
    );
  }
}
