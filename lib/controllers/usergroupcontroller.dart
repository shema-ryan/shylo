import 'package:flutter_riverpod/legacy.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/models/usermodel.dart';

import '../models/exception.dart';
import 'encrpytioncontroller.dart';

class UserGroupController extends StateNotifier<List<UserAccount>> {
  UserGroupController() : super([]);

  // fetchAll accounts
  Future<void> fetchAllUserAccount() async {
    try {
      final List<UserAccount> userAccounts = [];
      final results = await DbController.database.db!
          .collection('userAccountCollection')
          .find()
          .toList();

      for (var userMap in results) {
        userAccounts.insert(0, UserAccount.fromJson(userMap));
      }
      state = userAccounts;
    } catch (e) {
      rethrow;
    }
  }

  // delete an account from db ;
  Future<void> deleteUserAccount(ObjectId objectId) async {
    try {
      await DbController.database.db!
          .collection('userAccountCollection')
          .deleteOne({'_id': objectId});
      //remove from the state ;
      state.removeWhere((user) => user.objectId == objectId);
      //Update the state
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  //Change password
  Future<void> changePassWord({
    required ObjectId objectId,
    required String passWord,
  }) async {
    try {
      await DbController.database.db!
          .collection('userAccountCollection')
          .update(where.eq('_id', objectId), modify.set('passWord', passWord));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserRights({
    required ObjectId id,
    required List<UserRoles> userRoles,
  }) async {
    try {
      await DbController.database.db!
          .collection('userAccountCollection')
          .update(
            where.eq('_id', id),
            modify.set(
              'userRoles',
              userRoles.map((element) => element.name).toList(),
            ),
          );

      // GRAB the index of the user
      final index = state.indexWhere((element) => element.objectId == id);
      final copy = state.firstWhere((element) => element.objectId == id);
      // remove old userAccount
      state.removeWhere((element) => element.objectId == id);
      state.insert(
        index,
        UserAccount(
          ninNumber: copy.ninNumber,
          objectId: copy.objectId,
          userName: copy.userName,
          date: copy.date,
          passWord: copy.passWord,
          userRoles: userRoles,
          email: copy.email,
          phoneNumber: copy.phoneNumber,
        ),
      );
      //let's tell our ui about the changes
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerUser({required UserAccount userAccount}) async {
    try {
      // check if the user exit
      final results = await DbController.database.db!
          .collection('userAccountCollection')
          .findOne({'userName': userAccount.userName});
      if (results != null) {
        throw MyException(message: 'user Already Exist');
      }
      // Hashing password
      final hashedPassWord = EncryptionController.encryptPassword(
        userPassWord: userAccount.passWord,
      );
      await DbController.database.db!
          .collection('userAccountCollection')
          .insert(userAccount.copyWith(hashedPassWord).toJson());
      final addedUser = await DbController.database.db!
          .collection('userAccountCollection')
          .findOne({'userName': userAccount.userName});

      state.add(UserAccount.fromJson(addedUser!));
      state = [...state];
    } catch (error) {
      rethrow;
    }
  }
}

final userGroupProvider =
    StateNotifierProvider<UserGroupController, List<UserAccount>>(
      (ref) => UserGroupController(),
    );

// normal search algorithm here

final searchProvider = StateProvider<String>((ref) => '');
final filteredUserProvider = StateProvider<List<UserAccount>>((ref) {
  final searchText = ref.watch(searchProvider);
  final allUserAccount = ref.watch(userGroupProvider);
  return searchText.trim().isEmpty
      ? allUserAccount
      : allUserAccount
            .where((element) => element.userName.contains(searchText))
            .toList();
});
