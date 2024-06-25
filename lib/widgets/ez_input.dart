import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EzInput extends StatefulWidget {
  const EzInput({
    super.key,
    this.initialValue = '',
    this.textStyle,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onSaved,
    this.radius = 8,
    this.enable = true,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.autovalidateMode,
    this.readOnly = false,
    this.inputFormatters,
    this.maxLines,
    this.isTextArea = false,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.margin,
    this.errorStyle,
    this.label,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.disableColor,
  });

  // The initial value of the input.
  // Default is empty
  final String initialValue;
  // The text style for the input.
  // Default is Theme.of(context).textTheme.bodyLarge,
  final TextStyle? textStyle;
  // The focus node for the input.
  final FocusNode? focusNode;
  // The controller to manage the input.
  final TextEditingController? controller;
  // Callback when the input value changes.
  final void Function(String?)? onChanged;
  // Callback when saving the input value.
  final void Function(String?)? onSaved;
  // The radius of the input's corners.
  // Default is 8,
  final double radius;
  // Enable or disable the input.
  // Default is true,
  final bool enable;
  // Whether the input is a password field.
  // Default is false, and max lines must 1 to use
  final bool isPassword;
  // The keyboard type to display.
  // Default is text type
  final TextInputType keyboardType;
  // Autofocus the input when the screen is opened.
  // Default is false
  final bool autofocus;
  // Auto-validation mode for the input.
  final AutovalidateMode? autovalidateMode;
  // Read-only mode for the input.
  // Default is false
  final bool readOnly;
  // List of input formatters.
  final List<TextInputFormatter>? inputFormatters;
  // Maximum number of lines for multi-line input.
  // Default is 1 line with normal input and 8 lines with text area
  final int? maxLines;
  // Whether the input is a multi-line text area.
  // Default is false
  final bool isTextArea;
  // The action to take when the Enter key is pressed on the keyboard.
  // Default is done action
  final TextInputAction? textInputAction;
  // Function to validate the input value.
  final String? Function(String?)? validator;
  // Horizontal margin for the input.
  // Default is 16.r
  final EdgeInsetsGeometry? margin;
  // The error text style.
  // Default is Theme.of(context).textTheme.bodyMedium?
  // .copyWith(color: Theme.of(context).colorScheme.error),
  final TextStyle? errorStyle;
  // The label for the input.
  final String? label;
  // The label's text style.
  final TextStyle? labelStyle;
  // The hint text for the input.
  final String? hintText;
  // The hint text style.
  final TextStyle? hintStyle;
  // Prefix icon for the input.
  final Widget? prefixIcon;
  // suffixIcon icon for the input.
  final Widget? suffixIcon;
  // Disable Color
  final Color? disableColor;

  @override
  State<EzInput> createState() => _EzInputState();
}

class _EzInputState extends State<EzInput> {
  TextEditingController ezController = TextEditingController();
  bool passwordVisible = true;

  @override
  void initState() {
    ezController =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    super.initState();
    ezController.addListener(() {
      if (ezController.text.length <= 1) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(),
          TextFormField(
            onChanged: (final value) {
              unawaited(HapticFeedback.lightImpact());
              widget.onChanged?.call(value);
            },
            onSaved: (final value) => widget.onSaved?.call(value),
            validator: (final value) => widget.validator?.call(value),
            style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
            keyboardType: widget.keyboardType,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            autovalidateMode: widget.autovalidateMode,
            readOnly: widget.readOnly,
            inputFormatters: widget.inputFormatters,
            controller: ezController,
            enabled: widget.enable,
            obscureText: widget.isPassword && passwordVisible,
            obscuringCharacter: '●',
            maxLines:
                widget.isTextArea ? widget.maxLines ?? 8 : widget.maxLines ?? 1,
            textInputAction: widget.textInputAction,
            decoration: buildInputDececoration(),
          ),
        ],
      ),
    );
  }

  Widget buildLabel() {
    return widget.label != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style:
                  widget.labelStyle ?? Theme.of(context).textTheme.titleMedium!,
            ),
          )
        : const SizedBox.shrink();
  }

  InputDecoration buildInputDececoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(12),
      hintText: widget.hintText,
      hintStyle: widget.hintStyle ??
          Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).dividerColor),
      enabled: widget.enable,
      suffixIcon: buildSuffixIconTextField(),
      suffixIconColor: buildFocusIconColor(),
      prefixIcon: widget.prefixIcon,
      prefixIconColor: buildFocusIconColor(),
      fillColor: widget.enable
          ? Colors.transparent
          : widget.disableColor ?? Theme.of(context).cardColor,
      filled: !widget.enable,
      focusedBorder: focusBorder(),
      hoverColor: Colors.transparent,
      border: defaultBorder(),
      disabledBorder: defaultBorder(),
      enabledBorder: defaultBorder(),
      errorBorder: errorBorder(),
      focusedErrorBorder: focusErrorBorder(),
      errorStyle: widget.errorStyle ??
          Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
    );
  }

  Widget buildSuffixIconTextField() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon!;
    }
    if (widget.isPassword) {
      return IconButton(
        onPressed: () => setState(() {
          passwordVisible = !passwordVisible;
        }),
        icon: Icon(
          passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
      );
    }
    return ezController.text.isNotEmpty
        ? Align(
            alignment: Alignment.topCenter,
            widthFactor: 1,
            heightFactor: widget.maxLines != null
                ? (widget.maxLines! / 2) - 0.5
                : widget.isTextArea
                    ? 3.5
                    : 1,
            child: IconButton(
              onPressed: () => ezController.clear(),
              icon: const Icon(Icons.cancel_outlined),
            ),
          )
        : const SizedBox.shrink();
  }

  Color? buildFocusIconColor() {
    return MaterialStateColor.resolveWith(
      (final states) => states.contains(MaterialState.focused)
          ? Theme.of(context).primaryColor
          : Theme.of(context).dividerColor,
    );
  }

  OutlineInputBorder defaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    );
  }

  OutlineInputBorder focusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
    );
  }

  OutlineInputBorder focusErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 1.5,
      ),
    );
  }
}
