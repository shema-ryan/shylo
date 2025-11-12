import 'package:mongo_dart/mongo_dart.dart';
enum MartialStatus{
  single , 
  married , 
  divorced,
}
class Client {
  final ObjectId? id;
  final String name;
  final String email;
  final double phoneNumber;
  final bool gender;
  final String currentLocation;
  final double privatePhoneNumber;
  final String kinName;
  final double kinNumber;
  final String kinLocation;
  final String kinRelation;
  final String nin ; 
  final String kinNin;


  const Client({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.currentLocation,
    required this.email,
    required this.gender,
    required this.kinLocation,
    required this.kinName,
    required this.kinNumber,
    required this.kinRelation,
    required this.privatePhoneNumber,
    required this.nin,
    required this.kinNin,
  });

  Client.fromJson(Map<String, dynamic> clientJson)
    : id = clientJson['_id'],
      name = clientJson['name'],
      nin = clientJson['nin'],
      kinNin = clientJson['kinNin'],
      currentLocation = clientJson['currentLocation'],
      email = clientJson['email'],
      gender = clientJson['gender'],
      kinLocation = clientJson['kinLocation'],
      kinName = clientJson['kinName'],
      kinNumber = clientJson['kinNumber'],
      kinRelation = clientJson['kinRelation'],
      phoneNumber = clientJson['phoneNumber'],
      privatePhoneNumber = clientJson['privatePhoneNumber'];

  Map<String, dynamic> clientToJson() => {
    if (id != null) '_id': id,
    'name': name,
    'currentLocation': currentLocation,
    'email': email,
    'gender': gender,
    'kinLocation': kinLocation,
    'kinName': kinName,
    'kinNumber': kinNumber,
    'kinRelation': kinRelation,
    'phoneNumber': phoneNumber,
    'privatePhoneNumber': privatePhoneNumber,
    'nin':nin , 
    'kinNin': kinNin,
  };
}
