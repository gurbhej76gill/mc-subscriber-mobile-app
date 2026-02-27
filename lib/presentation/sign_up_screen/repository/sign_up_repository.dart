import 'dart:async';

import 'package:family_wifi/core/network/api_constants.dart';
import 'package:family_wifi/core/network/api_exception.dart';
import 'package:family_wifi/core/network/api_helper.dart';
import 'package:family_wifi/core/network/result.dart';
import 'package:family_wifi/core/utils/print_log_helper.dart';
import 'package:family_wifi/l10n/app_localization_extension.dart';
import 'package:family_wifi/presentation/sign_up_screen/models/sign_up_model.dart';
import 'package:family_wifi/presentation/sign_up_screen/models/sign_up_result.dart';

class SignUpRepository {
  late final ApiHelper _apiHelper;

  SignUpRepository(ApiHelper apiHelper) {
    this._apiHelper = apiHelper;
  }

  Future<Result> createAccount(SignUpModel signUpModel, {bool resend = false})
      async {
    try {
      final parameters = <String, dynamic>{
        'email': signUpModel.email,
        'registrationId': signUpModel.operatorId,
      };
      if (resend) {
        parameters['resend'] = true;
      }
      Map<String, dynamic> result = await _apiHelper.request(
        ApiConstants.subscriber,
        requestType: RequestType.POST,
        parameters: parameters,
      );
      SignUpResult signUpResult = SignUpResult.fromJson(result);
      if (signUpResult.userId != null) {
        return Result.success(signUpResult);
      } else {
        return Result.error(await 'invalid_signup_result'.tr());
      }
    } catch (error, stack) {
      logPrint('$error, \n$stack');
      return handleApiException(error);
    }
  }

  Future<Result> requestVerificationEmailResend(SignUpModel signUpModel) async {
    return createAccount(signUpModel, resend: true);
  }

  Future<Result> handleApiException(dynamic exception) async {
    if (exception is ApiException) {
      return Result.error(
        exception.translate ? await exception.message.tr() : exception.message,
      );
    } else if (exception is TimeoutException) {
      bool available = await ApiHelper.check(checkActiveInternet: true);
      return Result.error(
        available
            ? await 'unable_to_reach_server'.tr()
            : await 'out_of_coverage'.tr(),
      );
    } else {
      return Result.error(await 'something_went_wrong'.tr());
    }
  }
}
