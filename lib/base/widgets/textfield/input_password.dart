import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class InputPassword extends StatefulWidget {
  const InputPassword({
    super.key,
    this.label = 'Password',
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.textColor = appTextColor,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.contentPadding,
    this.enable = true,
    this.controller,
    this.validation,
    this.inputFormatters,
    this.hint = '',
    this.textStyle,
    this.hintStyle,
    this.errorTextStyle,
    this.keyboardType = TextInputType.text,
    this.maxLength = 30,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.obsecureText = true,
    this.inputShape = TextFieldShape.box,
    this.cursorColor = primaryColor,
    this.textAlign = TextAlign.start,
    this.isRequired = false,
    this.requiredText = 'Required',
    this.showRequiredText = false,
    this.requiredTextStyle,
    this.isOptional = false,
    this.optitonalText = 'Optional',
    this.optionalTextStyle,
    this.labelTextStyle,
    this.outlineColor,
    this.borderRadius = 10,
    this.hintColor = appHintColor,
    this.maxLines = 1,
    this.action = TextInputAction.done,
    this.readOnly = false,
    this.errorMessage,
  });
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? color;
  final Color textColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final EdgeInsets? contentPadding;
  final bool enable;
  final TextEditingController? controller;
  final String? Function(String? value)? validation;
  final List<TextInputFormatter>? inputFormatters;
  final String hint;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorTextStyle;
  final TextInputType keyboardType;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final bool obsecureText;
  final TextFieldShape inputShape;
  final Color cursorColor;
  final TextAlign textAlign;
  final bool isRequired;
  final String requiredText;
  final TextStyle? requiredTextStyle;
  final bool showRequiredText;
  final bool isOptional;
  final String optitonalText;
  final TextStyle? optionalTextStyle;
  final TextStyle? labelTextStyle;
  final Color? outlineColor;
  final double borderRadius;
  final Color hintColor;
  final int maxLines;
  final TextInputAction action;
  final bool readOnly;
  final String? errorMessage;

  @override
  InputPasswordState createState() => InputPasswordState();
}

class InputPasswordState extends State<InputPassword> {
  bool _obsecureText = false;

  @override
  void initState() {
    _obsecureText = widget.obsecureText;
    super.initState();
  }

  void toggleShow() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputPrimary(
      label: widget.label,
      prefixIcon: widget.prefixIcon,
      suffixIcon: IconPassword(
        isShow: _obsecureText,
        onTap: toggleShow,
      ),
      color: widget.color,
      textColor: widget.textColor,
      margin: widget.margin,
      padding: widget.padding,
      contentPadding: widget.contentPadding,
      enable: widget.enable,
      controller: widget.controller,
      validation: widget.validation,
      inputFormatters: widget.inputFormatters,
      hint: widget.hint,
      textStyle: widget.textStyle,
      hintStyle: widget.hintStyle,
      errorTextStyle: widget.errorTextStyle,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization,
      obsecureText: _obsecureText,
      inputShape: widget.inputShape,
      cursorColor: widget.cursorColor,
      textAlign: widget.textAlign,
      isRequired: widget.isRequired,
      requiredText: widget.requiredText,
      showRequiredText: widget.showRequiredText,
      requiredTextStyle: widget.requiredTextStyle,
      isOptional: widget.isOptional,
      optitonalText: widget.optitonalText,
      optionalTextStyle: widget.optionalTextStyle,
      labelTextStyle: widget.labelTextStyle,
      outlineColor: widget.outlineColor,
      borderRadius: widget.borderRadius,
      hintColor: widget.hintColor,
      maxLines: widget.maxLines,
      action: widget.action,
      readOnly: widget.readOnly,
      errorMessage: widget.errorMessage,
    );
  }
}

class IconPassword extends StatelessWidget {
  const IconPassword({super.key, this.onTap, required this.isShow});
  final Function()? onTap;
  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        isShow ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
    );
  }
}
