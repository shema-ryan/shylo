import 'package:flutter_riverpod/legacy.dart';
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
}

final clientProvider = StateNotifierProvider<ClientController, List<Client>>(
  (ref) => ClientController(),
);
