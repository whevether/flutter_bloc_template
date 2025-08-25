import 'package:flutter_bloc_template/app/base/base_stateless_widget.dart';
import 'package:flutter_bloc_template/widget/local_image.dart';
import 'package:flutter_bloc_template/widget/net_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/app_color.dart';

class UserPhoto extends BaseStatelessWidget {
  final String? url;
  final bool showBoder;
  final double size;
  final double? radiusSize;

  /// Allow user to do operation when user tap on profile circle.
  final VoidCallback? onTap;

  /// Allow user to do operation when user long press on profile circle.
  final VoidCallback? onLongPress;
  final Icon? icon;
  final Color? color;
  const UserPhoto({
    this.url,
    this.showBoder = true,
    this.size = 48,
    super.key,
    this.icon,
    this.color,
    this.onTap,
    this.radiusSize,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    
    if (url == null || (url?.isEmpty ?? true)) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: showBoder
                ? Border.all(
                    color: color!= null ? color!.withValues(alpha: .2) : AppColor.color0089FF.withValues(alpha: .2),
                  )
                : null,
            color: color ?? AppColor.color0089FF,
            borderRadius: super.circular(radiusSize ?? size / 2),
          ),
          child: icon ?? Icon(
            Icons.person_outlined,
            color: AppColor.backgroundColor,
            size: super.setFontSize(24),
          ),
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: super.circular(radiusSize ?? size / 2),
          border: showBoder
              ? Border.all(
                  color: color!= null ? color!.withValues(alpha: .2) : AppColor.color0089FF.withValues(alpha: .2),
                )
              : null,
        ),
        child: !url!.contains("http")
            ? LocalImage(
                url!,
                width: size,
                height: size,
                borderRadius: size,
              )
            : NetImage(
                url!,
                width: size,
                height: size,
                borderRadius: size,
              ),
      ),
    );
  }
}