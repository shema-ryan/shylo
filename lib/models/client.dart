import 'package:mongo_dart/mongo_dart.dart';
enum MartialStatus { single, married, divorced }
class Client {
  final double uniqueId;
  final ObjectId? id;
  final String surName;
  final String lastName;
  final String email;
  final double phoneNumber;
  final bool gender;
  final MartialStatus status;
  final String currentLocation;
  final double privatePhoneNumber;
  final String kinName;
  final double kinNumber;
  final String kinLocation;
  final String kinRelation;
  final String nin;
  final String kinNin;
  final String guaranterName;
  final String guaranterNin;
  final double guaranterPhoneNumber;

  const Client({
    required this.guaranterPhoneNumber,
    required this.guaranterNin,
    required this.guaranterName,
    required this.uniqueId,
    required this.status,
    required this.id,
    required this.lastName,
    required this.surName,
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
      guaranterNin = clientJson['guaranterNin'],
      guaranterPhoneNumber =clientJson['guaranterPhoneNumber'] ,
      guaranterName = clientJson['guaranterName'],
      uniqueId =clientJson['uniqueId'],
      surName = clientJson['surName'],
      lastName = clientJson['lastName'],
      status = MartialStatus.values.firstWhere(
        (test) => test.name == clientJson['status'],
      ),
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
      privatePhoneNumber = clientJson['privatePhoneNumber'] ;

  Map<String, dynamic> clientToJson() => {
    if (id != null) '_id': id,
    'guaranterName': guaranterName,
    'guaranterPhoneNumber': guaranterPhoneNumber,
    'guaranterNin': guaranterNin,
    'surName': surName.trim(),
    'lastName': lastName.trim(),
    'status': status.name,
    'uniqueId': uniqueId,
    'currentLocation': currentLocation,
    'email': email,
    'gender': gender,
    'kinLocation': kinLocation,
    'kinName': kinName,
    'kinNumber': kinNumber,
    'kinRelation': kinRelation,
    'phoneNumber': phoneNumber,
    'privatePhoneNumber': privatePhoneNumber,
    'nin': nin,
    'kinNin': kinNin,
  };
}
