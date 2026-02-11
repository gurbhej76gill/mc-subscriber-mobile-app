/// This class is used in the [SignUpScreen] screen.

// ignore_for_file: must_be_immutable
class SignUpModel {
  SignUpModel({
    this.email,
    this.operatorId,
    this.macAddress,
  }) {
    email = email ?? '';
    operatorId = operatorId ?? '';
    macAddress = macAddress ?? '';
  }

  String? email;
  String? operatorId;
  String? macAddress;

  SignUpModel copyWith({
    String? email,
    String? operatorId,
    String? macAddress,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      operatorId: operatorId ?? this.operatorId,
      macAddress: macAddress ?? this.macAddress,
    );
  }
}
