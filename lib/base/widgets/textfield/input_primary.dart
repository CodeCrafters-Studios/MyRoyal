import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';

enum TextFieldShape { box, line }

enum TextFieldState { focus, error, disabled, none }

class InputPrimary extends StatelessWidget {
  const InputPrimary({
    super.key,
    this.label = '',
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
    this.textCapitalization = TextCapitalization.sentences,
    this.obsecureText = false,
    this.inputShape = TextFieldShape.box,
    this.cursorColor = primary,
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
    this.onTap,
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
  final Function()? onTap;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty || isRequired || isOptional) ...[
            Row(
              children: [
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: labelTextStyle ?? TS.labelLarge,
                  ),
                if (isRequired)
                  Text(
                    '*',
                    style: TS.bodyLarge.copyWith(color: Colors.red),
                  ),
                const Spacer(),
                if (showRequiredText)
                  Text(
                    requiredText,
                    style: requiredTextStyle,
                  ),
                if (isOptional)
                  Text(
                    optitonalText,
                    style: optionalTextStyle,
                  ),
              ],
            ),
            4.verticalSpace,
          ],
          TextFormField(
            scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16 * 4,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              border: inputShape == TextFieldShape.box
                  ? OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)),
                      borderSide:
                          BorderSide(color: outlineColor ?? Colors.transparent),
                    )
                  : null,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              enabled: enable,
              fillColor: color ?? inputColor,
              filled: true,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hoverColor: outlineColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: outlineColor ?? primary),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              ),
              enabledBorder: inputShape == TextFieldShape.box
                  ? OutlineInputBorder(
                      borderSide:
                          BorderSide(color: outlineColor ?? Colors.transparent),
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)),
                    )
                  : null,
              hintText: hint,
              hintStyle: hintStyle ?? TS.bodyLarge.copyWith(color: hintColor),
              errorMaxLines: 2,
              errorStyle: errorTextStyle,
              errorText: errorMessage,
              prefixIconConstraints:
                  const BoxConstraints(maxHeight: 42, maxWidth: 56),
            ),
            onChanged: onChanged,
            controller: controller,
            enabled: enable,
            cursorColor: cursorColor,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
              if (inputFormatters != null) ...inputFormatters!,
            ],
            maxLines: maxLines,
            keyboardType: keyboardType,
            obscureText: obsecureText,
            onTapOutside: (event) => AppUtils.dismissKeyboard(),
            readOnly: readOnly,
            style: textStyle ?? TS.labelLarge,
            textAlign: textAlign,
            textInputAction: action,
            validator: validation,
            textCapitalization: textCapitalization,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
