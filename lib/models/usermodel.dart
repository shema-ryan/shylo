import 'package:mongo_dart/mongo_dart.dart';

enum UserRoles { customer, loanofficer, administrator, investor }

class UserModel {
  final ObjectId? userId;
  final String userName;
  final String passWord;
  final String ninNumber;

  final List<UserRoles> roles;
  const UserModel({
    this.userId,
    required this.userName,
    required this.passWord,
    required this.roles,

    required this.ninNumber,
  });

  // userModel from Json
  UserModel.fromJson(Map<String, dynamic> userJson)
    :
    userId = userJson['_id'],
      userName = userJson['userName'],
      passWord = userJson['passWord'],
      ninNumber = userJson['ninNumber'],
      roles = [
        ...(userJson['roles'] as List<dynamic>).map(
          (element) => UserRoles.values.singleWhere((value) => value.name == element.toString()),
        ),
      ];

  // userModel to json
  Map<String, dynamic> userModelToJson() => {
    'userName': userName,
    'passWord': passWord,
    'ninNumber': ninNumber,
    'roles': [...roles.map((userRole) => userRole.name)],
    
  };
}
