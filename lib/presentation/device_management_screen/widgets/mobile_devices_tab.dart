import 'package:family_wifi/presentation/device_management_screen/models/mobile_device_info_model.dart';
import 'package:family_wifi/presentation/device_management_screen/provider/device_management_provider.dart';
import 'package:family_wifi/presentation/device_management_screen/widgets/mobile_device_item_view.dart';
import 'package:family_wifi/presentation/home_screen/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:family_wifi/core/app_export.dart';
import 'package:family_wifi/l10n/app_localization_extension.dart';

class MobileDevicesTab extends StatelessWidget {
  late final bool shrinkWrap;
  MobileDevicesTab({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DeviceManagementProvider>();
    return _buildMobileDevicesList(controller);
  }

  Widget _buildMobileDevicesList(
    DeviceManagementProvider deviceMngmtController,
  ) {
    return StreamProvider<List<MobileDeviceInfoModel>?>.value(
      initialData: deviceMngmtController.mobileDevicesInitialData,
      value: deviceMngmtController.mobileDevices,
      child: Consumer<List<MobileDeviceInfoModel>?>(
        builder:
            (
              BuildContext context,
              List<MobileDeviceInfoModel>? value,
              Widget? child,
            ) {
              final itemCount = value?.length ?? 0;
              final items = value ?? [];
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: shrinkWrap,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return MobileDeviceItemView(
                    device: items[index],
                    /*onIconTap: () {
                        NavigatorService.pushNamed(
                          AppRoutes.networkDevicesManagementScreen,
                        );
                      },*/
                    onPauseTap: () {
                      _handlePauseToggle(
                        context,
                        deviceMngmtController,
                        items[index],
                      );
                    },
                  );
                },
              );
            },
      ),
    );
  }

  Future<void> _handlePauseToggle(
    BuildContext context,
    DeviceManagementProvider deviceMngmtController,
    MobileDeviceInfoModel device,
  ) async {
    final result = await deviceMngmtController.toggleDevicePause(device);
    if (result.isSessionExpired) {
      NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
      return;
    }

    if (result.isSuccess) {
      final message = await result.messageKey!.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: appTheme.colorFF4CAF,
        ),
      );
      return;
    }

    final title =
        result.titleKey != null
            ? await result.titleKey!.tr()
            : result.messageKey != null
            ? await result.messageKey!.tr()
            : null;
    final message =
        result.message ??
        (result.messageKey != null
            ? await result.messageKey!.tr()
            : await 'something_went_wrong'.tr());
    context.read<HomeProvider>().alertStateProvider.showAlert(
          message,
          title: title,
        );
  }
}
