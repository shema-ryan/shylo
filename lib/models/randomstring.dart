import 'dart:math';

String generateRandomString(int length) {
  const String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
    length, 
    (_) => chars.codeUnitAt(rnd.nextInt(chars.length))
  ));
}