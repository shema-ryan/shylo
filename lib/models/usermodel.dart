import 'package:mongo_dart/mongo_dart.dart';

enum UserRoles { loanofficer, administrator, investor }

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
    : userId = userJson['_id'],
      userName = userJson['userName'],
      passWord = userJson['passWord'],
      ninNumber = userJson['ninNumber'],
      roles = [
        ...(userJson['roles'] as List<dynamic>).map(
          (element) => UserRoles.values.singleWhere(
            (value) => value.name == element.toString(),
          ),
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

class UserAccount {
  final ObjectId? objectId;
  final String userName;
  final String passWord;
  final double phoneNumber ;
  final String email; 
  final String ninNumber;
  final DateTime date;
  final List<UserRoles> userRoles;
  UserAccount({
    required this.ninNumber,
    required this.objectId,
    required this.userName,
    required this.date,
    required this.passWord,
    required this.userRoles,
    required this.email,
    required this.phoneNumber
  });
    UserAccount.fromJson(Map<String, dynamic> userAccountJson)
    : objectId = userAccountJson['_id'],
      userName = userAccountJson['userName'],
      ninNumber = userAccountJson['ninNumber'],
      passWord = userAccountJson['passWord'],
      date = userAccountJson['date'],
      phoneNumber = userAccountJson['phoneNumber'],
      email = userAccountJson['email'],
      userRoles = (userAccountJson['userRoles'] as List<dynamic>)
          .map(
            (roleName) =>
                UserRoles.values.firstWhere((role) => role.name == roleName.toString()),
          )
          .toList();
  
  UserAccount copyWith(String hashedPassword) {
    return UserAccount(
      email: email,
      phoneNumber: phoneNumber,
      ninNumber: ninNumber,
      objectId: objectId,
      userName: userName,
      date: date,
      passWord: hashedPassword,
      userRoles: userRoles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (objectId != null) '_id': objectId,
      'userName': userName,
      'passWord': passWord,
      'date': date,
      'ninNumber': ninNumber,
      'email': email, 
      'phoneNumber': phoneNumber,
      'userRoles': [...userRoles.map((role) => role.name)],
    };
  }
}
