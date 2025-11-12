import 'package:flutter_riverpod/legacy.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shylo/models/exception.dart';

import '../models/client.dart';
import 'databasecontroller.dart';

class ClientController extends StateNotifier<List<Client>> {
  ClientController() : super([]);

  // fetch all client
  Future<void> fetchAllClient() async {
    try {
      final results = await DbController.database.db!
          .collection('clientCollection')
          .find()
          .toList();
      state = [];
      for (var item in results) {
        state = [...state, Client.fromJson(item)];
      }
    } catch (e) {
      rethrow;
    }
  }

  // add a client
  Future<void> addClient(Client client) async {
    try {
      final results = await DbController.database.db!
          .collection('clientCollection')
          .findOne({'name': client.name});
      if (results == null) {
        // add client to DB
        await DbController.database.db!
            .collection('clientCollection')
            .insert(client.clientToJson());
        // add Client to state
        final resultsB = await DbController.database.db!
            .collection('clientCollection')
            .findOne({'name': client.name});
        state = [...state, Client.fromJson(resultsB!)];
      } else {
        throw MyException(message: 'Client Already Exists');
      }
    } catch (e) {
      
      rethrow;
    }
  }

  Future<String> getUserName(ObjectId id)async{
    final results = await DbController.database.db!.collection('clientCollection').findOne({"_id": id});
    return results!['name'];
  }
}

final clientProvider = StateNotifierProvider<ClientController, List<Client>>(
  (ref) => ClientController(),
);
