import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/app_style.dart';
import 'package:aivox/app/base/base_state.dart';
import 'package:aivox/app/base/base_stateful_widget.dart';

class NetImage extends BaseStatefulWidget {
  final String picUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;
  final bool progress;
  const NetImage(this.picUrl,
      {this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.borderRadius = 0,
      this.progress = false,
      super.key});

  @override
  State<NetImage> createState() => _NetImageState();
}

class _NetImageState extends BaseState<NetImage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var picUrl = widget.picUrl;
    if (picUrl.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
        ),
        child: const Icon(
          Icons.image,
          color: Colors.grey,
          size: 24,
        ),
      );
    }
    picUrl = picUrl.contains('localhost') ? picUrl.replaceAll('localhost', AppConstant.serverUrl) : picUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: ExtendedImage.network(
        picUrl,
        fit: widget.fit,
        height: widget.height,
        width: widget.width,
        shape: BoxShape.rectangle,
        handleLoadingProgress: widget.progress,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // headers: const {'Referer': "http://www.dmzj.com/"},
        loadStateChanged: (e) {
          if (e.extendedImageLoadState == LoadState.loading) {
            animationController.reset();
            final double? progress =
                e.loadingProgress?.expectedTotalBytes != null
                    ? e.loadingProgress!.cumulativeBytesLoaded /
                        e.loadingProgress!.expectedTotalBytes!
                    : null;
            if (widget.progress) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                    ),
                    super.sizedBox(height: 4),
                    Text(
                      '${((progress ?? 0.0) * 100).toInt()}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: .1),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.grey,
                size: 24,
              ),
            );
          }
          if (e.extendedImageLoadState == LoadState.failed) {
            animationController.reset();
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: .1),
              ),
              child: const Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 24,
              ),
            );
          }
          if (e.extendedImageLoadState == LoadState.completed) {
            if (e.wasSynchronouslyLoaded) {
              return e.completedWidget;
            }
            animationController.forward();

            return FadeTransition(
              opacity: animationController,
              child: e.completedWidget,
            );
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
