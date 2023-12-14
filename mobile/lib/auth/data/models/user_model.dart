// class UserModel {
//   String uid;
//   String? email;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is UserModel &&
//           runtimeType == other.runtimeType &&
//           uid == other.uid &&
//           email == other.email;
//
//   @override
//   int get hashCode => uid.hashCode ^ email.hashCode;
//
//   UserModel(this.uid, this.email);
// }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String uid,
    String? email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
