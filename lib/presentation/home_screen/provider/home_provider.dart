import 'package:family_wifi/core/network/result.dart';
import 'package:family_wifi/core/utils/alert_state_provider.dart';
import 'package:family_wifi/core/utils/base_bloc.dart';
import 'package:family_wifi/core/utils/loading_state_provider.dart';
import 'package:family_wifi/core/utils/navigator_service.dart';
import 'package:family_wifi/l10n/app_localization_extension.dart';
import 'package:family_wifi/presentation/home_screen/bottom_bar_item.dart';
import 'package:family_wifi/presentation/home_screen/models/subscriber_info.dart';
import 'package:family_wifi/presentation/home_screen/models/topology_info.dart';
import 'package:family_wifi/presentation/home_screen/repository/home_repository.dart';
import 'package:family_wifi/routes/app_routes.dart';
import 'package:flutter/material.dart';

class HomeProvider with BaseBloc {
  late final HomeRepository _repository;
  final PageController pageController = PageController(initialPage: 0);

  final ValueNotifier<BottomBarItem> selectedNavBarItem =
      ValueNotifier<BottomBarItem>(NAV_BOTTOM_BAR_ITEMS[0]);

  final ValueNotifier<SubscriberInfo?> subscriberInfo =
      ValueNotifier<SubscriberInfo?>(null);

  final ValueNotifier<TopologyInfo?> topologyInfo =
      ValueNotifier<TopologyInfo?>(null);

  HomeProvider(
    LoadingStateProvider loadingStateProvider,
    AlertStateProvider alertStateProvider,
    this._repository,
  ) {
    initialize(loadingStateProvider, alertStateProvider);
  }

  void onNavBarItemSelected(index) {
    selectedNavBarItem.value = NAV_BOTTOM_BAR_ITEMS.firstWhere(
      (item) => item.index == index,
    );
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    selectedNavBarItem.dispose();
    subscriberInfo.dispose();
    super.dispose();
  }

  void init() {
    fetchLatestData();
  }

  Future<void> fetchLatestData({bool showPopupLoader = true}) async {
    await fetchTopologyInfo();
  }

  Future<void> initialSubscribe({bool showPopupLoader = true}) async {
    return;
  }

  Future<void> fetchTopologyInfo() async {
    try {
      Result result = await _repository.topology();

      if (result.isSuccess) {
        topologyInfo.value = result.message;
        // topologyInfo.value = TopologyInfo.fromJson(
        //   jsonDecode(
        //     '{"boardId":"5591dbe0-f836-4a92-83a2-d5c0b75b10a","edges":{"mesh":[],"wired":[]},"external":[],"nodes":[{"aps":[{"band":"2","bssid":"dc:62:79:65:23:34","channel":6,"clients":[{"connected":3551,"inactive":8,"rssi":-40,"rx_rate_bitrate":6000,"rx_rate_chwidth":20,"station":"fe:d1:47:83:81:61","tx_rate_bitrate":65000}],"mode":"ap","ssid":"TestSSID-2G","timestamp":"2025-11-12T12:28:09+05:30"},{"band":"5","bssid":"dc:62:79:65:23:33","channel":136,"clients":null,"mode":"ap","ssid":"TestSSID-5G","timestamp":"2025-11-12T12:28:09+05:30"}],"mesh":[],"serial":"AA:BB:CC:DD:EE:FF"}],"timestamp":"2025-11-12T06:58:09Z"}',
        //   ),
        // );
      } else if (result.sessionExpired) {
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
      } else {
        showAlert(result.message, title: await 'topology_request_failed'.tr());
      }
    } catch (error) {
      dismissLoading();
    }
  }
}
