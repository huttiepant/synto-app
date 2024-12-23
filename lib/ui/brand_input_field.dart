import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandInputField extends StatefulWidget {
  const BrandInputField({
    super.key,
    this.hint = '',
    required this.name,
    required this.title,
    required this.expands,
    this.inputFormatters,
    required this.inputType,
    required this.selectAllOnFocus,
    this.validator,
    this.obscureText = false,
    this.error = false,
    this.enabled = true,
    this.textAlign = TextAlign.left,
    this.maxLength,
    this.maxLines,
  });

  final String hint;
  final String name;
  final String title;
  final bool expands;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType inputType;
  final bool selectAllOnFocus;
  final bool error;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final TextAlign textAlign;
  final dynamic validator;

  @override
  State<BrandInputField> createState() => _BrandInputFieldState();
}

class _BrandInputFieldState extends State<BrandInputField> {
  final FocusNode _focusNode = FocusNode();

  late TextEditingController _controller;
  bool isFocused = false;

  void onFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.selectAllOnFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    }

    if (_focusNode.hasFocus != isFocused) {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initControllerAndSubs();
  }

  void initControllerAndSubs() {
    _controller = TextEditingController(text: '');

    isFocused = _focusNode.hasFocus;

    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.notoSans().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 10),
            ),
            SizedBox(
              height: 5,
            ),
            FormBuilderField(
              name: widget.name,
              validator: widget.validator,
              builder: (FormFieldState<dynamic> field) {
                if (_controller.text.isEmpty) {
                  _controller.text = field.value ?? '';
                }
                return TextField(
                  onChanged: (value) => field.didChange(value),
                  textAlign: widget.textAlign,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  style: GoogleFonts.notoSans().copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      height: 13.62 / 10.0,
                      fontWeight: FontWeight.w400),
                  keyboardType: widget.inputType,
                  controller: _controller,
                  inputFormatters: widget.inputFormatters,
                  maxLines: widget.maxLines ?? 1,
                  maxLength: widget.maxLength,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: false,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    hintStyle: GoogleFonts.notoSans().copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        height: 13.62 / 10.0,
                        fontWeight: FontWeight.w400),
                    hintText: widget.hint,
                    fillColor: Colors.white,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
