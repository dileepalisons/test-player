import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppInputText extends StatefulWidget {
  const AppInputText({
    Key? key,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.prefixText,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.border = true,
    this.shadow = false,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.minLines,
    this.onChanged,
    this.borderColor = Colors.black,
    this.suffixText,
    this.suffixIcon,
    this.radius = 12,
  }) : super(key: key);
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Color? cursorColor;
  final String? prefixText;
  final Widget? prefixIcon;
  final String? suffixText;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final bool border;
  final Color borderColor;
  final bool shadow;
  final bool readOnly;
  final bool obscureText;
  final int? minLines;
  final double radius;
  final ValueChanged<String>? onChanged;

  @override
  State<AppInputText> createState() => _AppInputTextState();
}

class _AppInputTextState extends State<AppInputText> {
  String translatedHint = '';

  @override
  void initState() {
    translatedHint = widget.hintText ?? "";

    super.initState();
  }

  @override
  void didUpdateWidget(AppInputText oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderSide: widget.border
          ? BorderSide(color: widget.borderColor, width: 1)
          : BorderSide.none,
    );
    return Container(
      child: TextField(
        readOnly: widget.readOnly,
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: TextStyle(),
        keyboardType: widget.keyboardType,
        cursorColor: widget.cursorColor,
        textAlign: widget.textAlign,
        maxLines: (widget.minLines != null && widget.minLines! > 1)
            ? widget.minLines
            : 1,
        minLines: widget.minLines,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          hintText: translatedHint,
          prefixIcon: widget.prefixText != null || widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                  child: widget.prefixText != null
                      ? Text(
                          widget.prefixText!,
                          style: TextStyle(),
                        )
                      : widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.suffixText != null || widget.suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                  child: widget.suffixText != null
                      ? Text(
                          widget.suffixText!,
                          style: TextStyle(),
                        )
                      : widget.suffixIcon,
                )
              : null,
          filled: true,
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder.copyWith(
              borderSide: BorderSide(color: Colors.green)),
          errorBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          fillColor: Colors.white,
          focusColor: Colors.white,
        ),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!.call(value);
          }
        },
      ),
    );
  }
}
