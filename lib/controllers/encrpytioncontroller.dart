import 'package:dbcrypt/dbcrypt.dart';

class EncryptionController {
  static final _dbcrypt = DBCrypt();
  //encrypt password
  static String encryptPassword({required String userPassWord}) =>
      _dbcrypt.hashpw(userPassWord, _dbcrypt.gensalt());
  // decrypt password 
  static bool decryptPassword({
    required String plainPassword,
    required String hashedPassword,
  }) => _dbcrypt.checkpw(plainPassword, hashedPassword);
}
