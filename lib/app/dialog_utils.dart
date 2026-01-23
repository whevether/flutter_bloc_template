import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/app/utils.dart';
import 'package:flutter_bloc_template/request/common_request.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_bloc_template/app/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  /// 提示弹窗
  /// - `content` 内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容，留空为确定
  /// - `cancel` 取消按钮内容，留空为取消
  static Future<bool> showAlertDialog(
    String content, {
    String title = '',
    String? confirm,
    String? cancel,
    bool selectable = false,
    bool barrierDismissible = true,
    Widget? actionSpacer,
    List<Widget>? actions,
  }) async {
    var result = await showBottomSheetCommon<bool>(
      header: buildBottomSheetHeader(title: title, showClose: true),
      footer: buildActionWidget(
          cancelText: cancel ?? '取消', submitText: confirm ?? '确定'),
      [
        SizedBox(height: 20.h),
        SingleChildScrollView(
          child: selectable
              ? SelectableText(content, style: TextStyle(fontSize: 16.sp))
              : Text(
                  content,
                  style: TextStyle(fontSize: 16.sp),
                ),
        ),
        actionSpacer ??
            SizedBox(
              height: 15.h,
            ),
      ],
      'alert_dialog',
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(16.r),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      clickMaskDismiss: false,
    );
    return result ?? false;
  }

  //选项弹窗
  static Future<T?> showOptionDialog<T>(
    List<T> contents,
    T value, {
    String title = '',
    double? height,
  }) async {
    var list = contents.map((e) {
      if (e.toString().isEmpty) {
        return const SizedBox.shrink();
      }
      return RadioListTile<T>(
        title: Text(e.toString()),
        value: e,
      );
    }).toList();
    var result = await showBottomSheetCommon<T>(
      [
        RadioGroup(
          onChanged: (e) {
            SmartDialog.dismiss(result: e);
          },
          groupValue: value,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              buildBottomSheetHeader(title: title, showClose: true),
              SizedBox(height: 20.h),
              ...list,
            ],
          ),
        )
      ],
      'radio_group',
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(40.r),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      clickMaskDismiss: false,
    );
    return result;
  }

  // bottom sheet 头
  static Widget buildBottomSheetHeader({
    bool showClose = false,
    bool isManage = false,
    String? title,
    VoidCallback? onClose,
    Color? closeColor,
    VoidCallback? onManage,
  }) {
    return Stack(
      children: [
        if (showClose)
          Positioned(
            top: 0,
            left: 0,
            child: InkWell(
              child: Icon(Icons.close_sharp, color: closeColor),
              onTap: () {
                if (onClose != null) {
                  onClose();
                } else {
                  SmartDialog.dismiss();
                }
              },
            ),
          ),
        if (isManage)
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                if (onManage != null) {
                  onManage();
                } else {
                  SmartDialog.dismiss();
                }
              },
              child: Text(
                '管理',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        if (title != null)
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: closeColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  //底部按钮
  static Widget buildActionWidget({
    String? cancelText,
    String? submitText,
    void Function()? onCancel,
    void Function()? onSubmit,
  }) {
    onCancel = onCancel ??
        () {
          SmartDialog.dismiss(result: false);
        };
    onSubmit = onSubmit ??
        () {
          SmartDialog.dismiss(result: true);
        };
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: [
        if (cancelText != null)
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: 8.w,
                  horizontal: 16.w,
                ),
                backgroundColor: AppColor.backgroundColor,
                foregroundColor: AppColor.color8E9AB0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.w,
                    color: AppColor.borderTopColor,
                  ),
                  borderRadius: BorderRadius.circular(48.r),
                ),
              ),
              child: Text(
                cancelText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.color8E9AB0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (cancelText != null) SizedBox(width: 20.w),
        if (submitText != null)
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: 8.w,
                  horizontal: 16.w,
                ),
                backgroundColor: AppColor.color0089FF,
                foregroundColor: AppColor.backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48.r)),
              ),
              child: Text(
                submitText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 打开弹窗
  static Future<T?> showBottomSheetCommon<T>(List<Widget> widget, String tag,
      {double? maxHeight, // 依然保留最大高度限制，防止超出屏幕
      double? maxWidth,
      bool showTopBorder = false,
      Color? backgroundColor,
      bool? clickMaskDismiss = true,
      Alignment alignment = Alignment.bottomCenter,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding,
      Widget? header,
      Widget? footer,
      Duration? displayTime,
      BorderRadiusGeometry? borderRadius}) async {
    var result = await SmartDialog.show<T>(
      tag: tag,
      alignment: alignment,
      clickMaskDismiss: clickMaskDismiss,
      displayTime: displayTime,
      builder: (_) {
        return Container(
          // 1. 去掉固定 height，让内容决定高度
          constraints: BoxConstraints(
            // 设置最大高度，通常建议为屏幕高度的 80% 或传入的值
            maxHeight: maxHeight ?? 0.8.sh,
            maxWidth: maxWidth ?? double.infinity,
          ),
          margin: margin,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: ShapeDecoration(
            color: backgroundColor ?? AppColor.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ??
                  BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
            ),
          ),
          // 2. 使用 SafeArea 确保底部内容不被遮挡（如果是 bottomCenter 弹出）
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min, // 3. 关键：设置为 min，高度才会自适应
              children: [
                // 顶部横条
                if (showTopBorder)
                  Container(
                    height: 6.h,
                    width: 37.5.w,
                    margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    decoration: BoxDecoration(
                      color: AppColor.borderTopColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                if (header != null) header,
                // 4. 内容区域使用 Flexible + SingleChildScrollView
                // 这样当内容少时自适应，内容多时可滚动且不会报错
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget,
                    ),
                  ),
                ),
                if (footer != null) footer,
              ],
            ),
          ),
        );
      },
    );
    return result;
  }

  /// 检查更新
  static void checkUpdate({bool showMsg = false, Widget? actionSpacer}) async {
    try {
      int currentVer = Utils.parseVersion(Utils.packageInfo.version);
      CommonRequest request = CommonRequest();
      var versionInfo = await request.checkUpdate();
      if (versionInfo == null) {
        return;
      }
      int skipVersion = LocalStorageService.instance.getValue<int>(
        LocalStorageService.kSkipVersion,
        0,
      );
      int version = Utils.parseVersion(versionInfo.versionNo);
      if (version > currentVer &&
          versionInfo.updateStatus == 1 &&
          version > skipVersion) {
        var result = await showBottomSheetCommon<bool>(
          header: buildBottomSheetHeader(
            showClose: false,
            closeColor: AppColor.backgroundColorDark,
            title: "发现新版本 v${versionInfo.versionNo}",
          ),
          footer: buildActionWidget(
            submitText: '去下载',
            cancelText: versionInfo.updateType == 0 ? null : '跳过',
            onCancel: () {
              SmartDialog.dismiss(result: false);
            },
            onSubmit: () {
              SmartDialog.dismiss(result: true);
            },
          ),
          [
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 200.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(Icons.system_update),
                    SizedBox(height: 10.h),
                    Text(
                      versionInfo.versionName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.backgroundColorDark,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      versionInfo.content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.backgroundColorDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionSpacer ??
                SizedBox(
                  height: 30.h,
                ),
          ],
          'updateApp',
          showTopBorder: true,
          backgroundColor: AppColor.backgroundColor,
          clickMaskDismiss: false,
        );
        if (result == true) {
          Utils.openLaunchUrlString(versionInfo.downUrl);
        } else {
          if (versionInfo.updateType == 2) {
            LocalStorageService.instance.setValue<int>(
              LocalStorageService.kSkipVersion,
              version,
            );
          }
        }
      } else {
        if (showMsg) {
          SmartDialog.showToast("当前已经是最新版本了");
        }
      }
    } catch (e) {
      Log.logPrint(e);
      if (showMsg) {
        SmartDialog.showToast("检查更新失败");
      }
    }
  }
}