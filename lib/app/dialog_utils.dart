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
    List<Widget>? actions,
  }) async {
    var result = await showBottomSheetCommon<bool>(
      [
        Column(
          children: [
            SizedBox(height: 20.h),
            buildBottomSheetHeader(title: title, showClose: true),
            SizedBox(height: 20.h),
            SingleChildScrollView(
              child: selectable
                  ? SelectableText(content, style: TextStyle(fontSize: 16.sp))
                  : Text(
                      content,
                      style: TextStyle(fontSize: 16.sp),
                    ),
            ),
            const Spacer(),
            buildActionWidget(cancelText: cancel ?? '取消',submitText: confirm??'确定' ),
          ],
        ),
      ],
      'alert_dialog',
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(16.r),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 160.h,
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
      height: height,
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
        showClose
            ? Positioned(
                top: 0,
                left: 0,
                child: InkWell(
                  child: Icon(Icons.close_sharp, color: closeColor),
                  onTap: () {
                    
                    if (onClose != null) {
                      onClose();
                    }else{
                      SmartDialog.dismiss();
                    }
                  },
                ),
              )
            : const SizedBox.shrink(),
        isManage
            ? Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    
                    if (onManage != null) {
                      onManage();
                    }else{
                      SmartDialog.dismiss();
                    }
                  },
                  child: Text(
                    '管理',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        title != null
            ? SizedBox(
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
              )
            : const SizedBox.shrink(),
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
                foregroundColor: AppColor.black333,
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
                  color: AppColor.black333,
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
  static Future<T?> showBottomSheetCommon<T>(
    List<Widget> widget,
    String tag, {
    double? height,
    double? maxHeight,
    double? maxWidth,
    bool showTopBorder = false,
    Color? backgroundColor,
    bool? clickMaskDismiss = true,
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Duration? displayTime,
    BorderRadiusGeometry borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(40),
      topRight: Radius.circular(40),
    ),
  }) async {
    var result = await SmartDialog.show<T>(
      tag: tag,
      alignment: alignment,
      clickMaskDismiss: clickMaskDismiss,
      displayTime: displayTime,
      builder: (_) {
        return Container(
          // width: double.infinity,
          height: height ?? 358.h,
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? 500.w,
            maxWidth: maxWidth ?? double.infinity,
          ),
          margin: margin,
          padding:
              padding ?? EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
          decoration: ShapeDecoration(
            color: backgroundColor ?? AppColor.backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Stack(
            children: [
              showTopBorder
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6.h,
                          width: 37.5.w,
                          margin: EdgeInsets.only(top: 10.w),
                          decoration: ShapeDecoration(
                            color: AppColor.borderTopColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Padding(padding: EdgeInsets.only(top: 20.w)),
              ...widget,
            ],
          ),
        );
      },
    );
    return result;
  }

  /// 检查更新
  static void checkUpdate({bool showMsg = false}) async {
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
          [
            Column(
              children: [
                SizedBox(height: 36.h),
                buildBottomSheetHeader(
                  showClose: false,
                  closeColor: AppColor.backgroundColorDark,
                  title: "发现新版本 v${versionInfo.versionNo}",
                ),
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
                const Spacer(),
                buildActionWidget(
                  submitText: '去下载',
                  cancelText: versionInfo.updateType == 0 ? null : '跳过',
                  onCancel: () {
                    SmartDialog.dismiss(result: false);
                  },
                  onSubmit: () {
                    SmartDialog.dismiss(result: true);
                  },
                ),
              ],
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
