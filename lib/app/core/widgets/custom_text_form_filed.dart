import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.initialValue,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.contentPadding,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      initialValue: widget.initialValue,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      onTap: widget.onTap,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText && widget.suffixIcon == null
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : widget.suffixIcon,
        labelStyle: theme.textTheme.bodyMedium,
        hintStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.hintColor,
        ),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ??
            theme.colorScheme.surface.withOpacity(0.05),
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.dividerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
