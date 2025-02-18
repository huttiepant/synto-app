import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandInputField extends StatefulHookWidget {
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
    this.enabled = true,
    this.textAlign = TextAlign.left,
    this.maxLength,
    this.maxLines,
    this.onSubmit,
    this.errorText,
  });

  final String hint;
  final String name;
  final String title;
  final String? errorText;
  final bool expands;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType inputType;
  final bool selectAllOnFocus;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final TextAlign textAlign;
  final dynamic validator;
  final void Function(String value)? onSubmit;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty)
            Text(
              widget.title,
              style: GoogleFonts.plusJakartaSans().copyWith(
                  color:
                      widget.errorText != null ? Colors.red : Color(0xff6C7278),
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.24,
                  fontSize: 12),
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
                onChanged: field.didChange,
                onSubmitted: (value) {
                  if (widget.onSubmit == null) return;
                  widget.onSubmit!(value);
                  _controller.text = '';
                  field.reset();
                  _focusNode.requestFocus();
                },
                textAlign: widget.textAlign,
                enabled: widget.enabled,
                obscureText: widget.obscureText,
                style: GoogleFonts.inter().copyWith(
                  color: Color(0xff1A1C1E),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.14,
                ),
                keyboardType: widget.inputType,
                controller: _controller,
                inputFormatters: widget.inputFormatters,
                maxLines: widget.maxLines ?? 1,
                maxLength: widget.maxLength,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: widget.errorText != null
                              ? Colors.red
                              : Color(0xffEDF1F3))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.errorText != null
                            ? Colors.red
                            : Colors.black,
                      )),
                  filled: true,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 12.5),
                  hintStyle: GoogleFonts.inter().copyWith(
                      color: Color(0xff1A1C1E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.14),
                  hintText: widget.hint,
                  fillColor: Colors.white,
                ),
              );
            },
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            widget.errorText ?? '',
            style: GoogleFonts.inter().copyWith(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
