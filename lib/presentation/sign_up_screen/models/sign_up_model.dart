/// This class is used in the [SignUpScreen] screen.

// ignore_for_file: must_be_immutable
class SignUpModel {
  SignUpModel({
    this.email,
    this.operatorId,
    this.macAddress,
    this.serverUrl,
  }) {
    email = email ?? '';
    operatorId = operatorId ?? '';
    macAddress = macAddress ?? '';
    serverUrl = serverUrl ?? '';
  }

  String? email;
  String? operatorId;
  String? macAddress;
  String? serverUrl;

  SignUpModel copyWith({
    String? email,
    String? operatorId,
    String? macAddress,
    String? serverUrl,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      operatorId: operatorId ?? this.operatorId,
      macAddress: macAddress ?? this.macAddress,
      serverUrl: serverUrl ?? this.serverUrl,
    );
  }
}
