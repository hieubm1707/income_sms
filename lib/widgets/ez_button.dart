// Flutter imports:R

import 'package:flutter/material.dart';

enum EzButtonType { fill, outline, transparent }

const defaultMinWidth = 70.0;
const defaultMinHeight = 36.0;
const defaultPadding = 20;

class EzButton extends StatelessWidget {
  const EzButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.titleStyle,
    this.height = 50,
    this.enable = true,
    this.borderRadius = 100,
    this.color,
    this.disableColor,
    this.buttonType = EzButtonType.fill,
    this.fullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
    this.hasSpacer = true,
    this.horizontalPadding = 20,
    this.margin,
    this.isProgressing = false,
  });

  /// Required and not null
  final void Function() onPressed;

  /// Display content of button
  /// Required and not null
  final String title;

  /// Display button with title style
  /// Default is Theme.of(context).textTheme.titleMedium
  final TextStyle? titleStyle;

  /// Display button with height
  /// Default is 53
  final double height;

  /// Set this property to false to make button disable
  /// Default is true
  final bool enable;

  /// Display button with border radius
  /// Default is 100
  final double borderRadius;

  /// Display button color when button is enable
  /// Default is Theme.of(context).primaryColor
  final Color? color;

  /// Disable button color is disableColor when button is disable
  /// Default is Theme.of(context).disabledColor
  final Color? disableColor;

  /// Display button with fill style or outline style
  /// Default is EzButtonType.fill to make button has fill style
  /// If you want to make button has outline style,
  /// Set this property to EzButtonType.outline
  final EzButtonType buttonType;

  /// Set this property to true to make button has full width
  /// Default is true
  final bool fullWidth;

  /// Display icon at the beginning of button
  final Widget? prefixIcon;

  /// Display icon at the end of button
  final Widget? suffixIcon;

  /// Add this property to make button has spacer between icon and title
  /// Default is true
  /// If you want to use this property, you must set fullWidth = true
  final bool hasSpacer;

  /// Add this property to make button has horizontal padding
  /// Default is AppPadding.mediumValue
  final double horizontalPadding;

  final bool isProgressing;

  ///
  ///
  final EdgeInsetsGeometry? margin;

  static const ezColorKey = 'ezColor';
  static const ezDisableColorKey = 'ezDisableColor';
  static const ezBorderRadiusKey = 'ezBorderRadius';
  static const ezBorderKey = 'ezBorder';
  static const ezTitleStyleKey = 'ezTitleStyle';

  Map<String, dynamic> getButtonProperty(final BuildContext context) {
    var ezColor = color ?? Theme.of(context).primaryColor;
    final ezDisableColor = disableColor ?? Theme.of(context).disabledColor;
    final ezBorderRadius = BorderRadius.circular(borderRadius);
    var ezBorder =
        enable ? Border.all(color: ezColor) : Border.all(color: ezDisableColor);
    var ezTitleStyle = titleStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white);
    switch (buttonType) {
      case EzButtonType.fill:
        {
          ezColor = enable ? ezColor : ezDisableColor;
          break;
        }
      case EzButtonType.outline:
        {
          ezTitleStyle = titleStyle ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: enable ? ezColor : ezDisableColor,
                  );
          ezColor = Colors.transparent;
          break;
        }
      case EzButtonType.transparent:
        {
          ezTitleStyle = titleStyle ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: enable ? ezColor : ezDisableColor,
                  );
          ezColor = Colors.transparent;
          ezBorder = Border.all(color: Colors.transparent);
          break;
        }
    }
    return {
      ezColorKey: ezColor,
      ezBorderRadiusKey: ezBorderRadius,
      ezBorderKey: ezBorder,
      ezTitleStyleKey: ezTitleStyle,
    };
  }

  Decoration _buildBoxDecoration(final BuildContext context) {
    final buttonProperties = getButtonProperty(context);
    final ezColor = buttonProperties[ezColorKey] as Color;
    final ezBorderRadius = buttonProperties[ezBorderRadiusKey] as BorderRadius;
    final ezBorder = buttonProperties[ezBorderKey] as Border;

    return BoxDecoration(
      color: ezColor,
      borderRadius: ezBorderRadius,
      border: ezBorder,
    );
  }

  Widget _buildButtonTitle(final BuildContext context) {
    final buttonProperties = getButtonProperty(context);
    final ezTitleStyle = buttonProperties[ezTitleStyleKey] as TextStyle;
    return fullWidth
        ? Expanded(
            child: Text(
              title,
              style: ezTitleStyle,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          )
        : Text(
            title,
            style: ezTitleStyle,
            maxLines: 1,
            textAlign: TextAlign.center,
          );
  }

  Widget _buildPrefixIcon() {
    return prefixIcon != null
        ? Padding(
            padding: EdgeInsets.only(
              right: fullWidth ? 20 : 4,
            ),
            child: prefixIcon,
          )
        : const SizedBox();
  }

  Widget _buildSuffixIcon() {
    return suffixIcon != null
        ? Padding(
            padding: EdgeInsets.only(
              left: fullWidth ? 20 : 12,
            ),
            child: suffixIcon,
          )
        : const SizedBox();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: height,
      width: fullWidth ? double.infinity : null,
      margin: margin ?? const EdgeInsets.all(12),
      decoration: _buildBoxDecoration(context),
      constraints: const BoxConstraints(
        minHeight: defaultMinHeight,
        minWidth: defaultMinWidth,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enable
              ? () {
                  if (isProgressing) return;
                  onPressed.call();
                }
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: isProgressing
                ? Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPrefixIcon(),
                      _buildButtonTitle(context),
                      _buildSuffixIcon(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
