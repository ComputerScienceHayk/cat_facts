import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cat_facts/main.dart';
import 'package:cat_facts/res/colors.dart';
import 'package:cat_facts/common_widgets/custom_circular_progress.dart';

class CustomButton extends StatelessWidget {
  final String? text, tooltip;
  final void Function()? onTap;
  final Color backgroundColor, borderColor, loaderColor;
  final double? borderRadius, width;
  final double height;
  final Widget? leading, secondary;
  final MainAxisAlignment alignment;
  final TextAlign? textAlign;
  final bool isLoading;
  final TextStyle? textStyle;

  const CustomButton({
      required this.height,
      Key? key,
      this.text,
      this.tooltip,
      this.onTap,
      this.backgroundColor = transparent,
      this.borderColor = transparent,
      this.loaderColor = black,
      this.borderRadius,
      this.alignment = MainAxisAlignment.center,
      this.width,
      this.leading,
      this.secondary,
      this.textAlign = TextAlign.center,
      this.isLoading = false,
      this.textStyle,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius:
                BorderRadius.circular(borderRadius ?? size.width * .05),
          ),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(borderRadius ?? size.width * .05),
            onTap: !isLoading ? onTap : null,
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: min(height, width ?? size.width) * .3,
                      width: min(height, width ?? size.width) * .3,
                      child: CustomCircularProgress(
                        color: loaderColor,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : Row(mainAxisAlignment: alignment, children: [
                    if (leading != null)
                      Padding(
                        padding:
                            EdgeInsets.only(right: (width ?? size.width) * .05),
                        child: leading,
                      ),
                    if ((leading != null || secondary != null))
                      Text(
                        text ?? '',
                        style: textStyle ??
                            StyleText.blackText(14, FontWeight.w400),
                        textAlign: textAlign,
                        maxLines: 1,
                      ),
                    if (leading == null && secondary == null)
                      Expanded(
                        child: Text(
                          text ?? '',
                          style: textStyle ??
                              StyleText.blackText(14, FontWeight.w400),
                          textAlign: textAlign,
                          maxLines: 1,
                        ),
                      ),
                    if (secondary != null)
                      Padding(
                        padding: EdgeInsets.only(
                            left: width == double.infinity
                                ? 10
                                : (width ?? size.width) / 30),
                        child: secondary,
                      ),
                  ],
            ),
          ),
      ),
    );
  }
}
