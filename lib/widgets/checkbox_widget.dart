import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget(
      {super.key, required this.setValue, required this.isChecked});

  final Function(bool value) setValue;
  final bool isChecked;

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(0xff4D81E7);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Color(0xff4D81E7),
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: widget.isChecked,
      onChanged: (bool? value) {
        widget.setValue(value!);
        setState(() {});
      },
    );
  }
}
