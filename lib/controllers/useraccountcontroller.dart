import 'package:flutter_riverpod/legacy.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/controllers/encrpytioncontroller.dart';
import 'package:shylo/models/exception.dart';
import 'package:shylo/models/usermodel.dart';

class UserAccountController extends StateNotifier<UserAccount?> {
  UserAccountController() : super(null);
  //loging
  Future<void> signIn({
    required String userName,
    required String passWord,
  }) async {
    try {
      // check existence
      final result = await DbController.database.db!
          .collection('userAccountCollection')
          .findOne({"userName": userName});
      if (result == null || result.isEmpty) {
        throw MyException(message: 'User Not Found');
      }
      if (!EncryptionController.decryptPassword(
        plainPassword: passWord,
        hashedPassword: result['passWord'],
      )) {
        throw MyException(message: 'Wrong PassWord');
      }
      state = UserAccount.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  // logout a user
  void logOut(){
    state = null ;
  }

}

final userAccountProvider =
    StateNotifierProvider<UserAccountController, UserAccount?>(
      (ref) => UserAccountController(),
    );
