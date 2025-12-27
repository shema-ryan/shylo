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
          .findOne({'uniqueId': client.id});
      if (results == null) {
        // add client to DB
        await DbController.database.db!
            .collection('clientCollection')
            .insert(client.clientToJson());
        // add Client to state
        final resultsB = await DbController.database.db!
            .collection('clientCollection')
            .findOne({'uniqueId': client.uniqueId});
        state = [...state, Client.fromJson(resultsB!)];
      } else {
        throw MyException(message: 'Client Already Exists');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteClient({required ObjectId id}) async {
    try {
      await DbController.database.db!
          .collection('clientCollection')
          .remove(where.eq('_id', id));
      state.removeWhere((client) => client.id == id);
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  // <--- updating client data Data --->
  Future<void> updateClient({required Client client}) async {
    try {
      await DbController.database.db!
          .collection('clientCollection')
          .update(
            where.eq('_id', client.id),
            modify
                .set('status', client.status.name)
                .set('email', client.email)
                .set('currentLocation', client.currentLocation)
                .set('phoneNumber', client.phoneNumber)
                .set('kinName', client.kinName)
                .set('kinNumber', client.kinNumber)
                .set('kinNin', client.kinNin)
                .set('privatePhoneNumber', client.privatePhoneNumber)
                .set('kinRelation', client.kinRelation)
                .set('kinLocation', client.kinLocation),
          );
      final index = state.indexWhere((element) => element.id == client.id);
      state.removeAt(index);
      state.insert(index, client);
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  String getUserName(ObjectId id)  {
   final client =  state.firstWhere((object)=> object.id == id);
    return '${client.surName} ${client.lastName}';
  }
}

final clientProvider = StateNotifierProvider<ClientController, List<Client>>(
  (ref) => ClientController(),
);

// section for searching a certain client
final searchText = StateProvider<String>((ref) =>'');
// the 
final filteredClientProvider = StateProvider<List<Client>>((ref) {
  final searchString = ref.watch(searchText);
  final allClient = ref.watch(clientProvider);
  if (searchString.isEmpty) {
    return allClient;
  } else {
    return [
      ...allClient.where(
        (element) => element.uniqueId == int.parse(searchString),
      ),
    ];
  }
});
