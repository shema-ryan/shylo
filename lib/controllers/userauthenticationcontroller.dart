import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/controllers/encrpytioncontroller.dart';
import 'package:shylo/models/exception.dart';
import 'package:shylo/models/usermodel.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';

class UserAuthenticationController extends StateNotifier<UserModel?> {
  UserAuthenticationController()
    : super(
        UserModel(
          userName: '',
          passWord: '',
          roles: [],
          imagePath: '',
          ninNumber: '',
        ),
      );

  //register a user

  Future<void> registerUser({
    required String userName,
    required String passWord,
  }) async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['jpg', 'png', 'jpeg'],
      );
      final XFile? file = await FileSelectorPlatform.instance.openFile(
        acceptedTypeGroups: [typeGroup],
      );
      if (file == null) {
        throw MyException(message: 'No Imageselected');
      }
      final imageBuffer = await file.readAsBytes();
      final convertedImage = base64Encode(imageBuffer);
      // encrypt password
      final hashedPassWord = EncryptionController.encryptPassword(
        userPassWord: passWord,
      );
      // create userModel
      final userModel = UserModel(
        userName: userName.toLowerCase(),
        passWord: hashedPassWord,
        ninNumber: 'something great is about to happen',
        roles: [UserRoles.administrator, UserRoles.loanofficer],
        imagePath: convertedImage,
      );
      // SAVE USERMODEL IN DATABASE
      await DbController.database.db!
          .collection('userCollection')
          .insert(userModel.userModelToJson());
    } catch (e) {
      rethrow;
    }
  }

  // Log a user
  Future<void> login({required String name, required String passWord}) async {
    try {
      final results = await DbController.database.db!
          .collection('userCollection')
          .findOne({'userName': name});
      if (results == null || results.isEmpty) {
        throw MyException(message: 'No userFound');
      }
      // check if password match
      if (!EncryptionController.decryptPassword(
        plainPassword: passWord,
        hashedPassword: results['passWord'],
      )) {
        throw MyException(message: 'Wrong PassWord');
      }
      
      // store a user
      state = UserModel.fromJson(results);
    } catch (e) {
      rethrow;
    }
  }
}

final userAuthenticationProvider =
    StateNotifierProvider<UserAuthenticationController, UserModel?>(
      (ref) => UserAuthenticationController(),
    );
