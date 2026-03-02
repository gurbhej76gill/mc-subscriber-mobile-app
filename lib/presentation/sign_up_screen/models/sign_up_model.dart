/// This class is used in the [SignUpScreen] screen.

// ignore_for_file: must_be_immutable
class SignUpModel {
  SignUpModel({
    this.email,
    this.operatorId,
  }) {
    email = email ?? '';
    operatorId = operatorId ?? '';
  }

  String? email;
  String? operatorId;

  SignUpModel copyWith({
    String? email,
    String? operatorId,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      operatorId: operatorId ?? this.operatorId,
    );
  }
}
