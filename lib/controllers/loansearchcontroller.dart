import 'package:flutter_riverpod/legacy.dart';

import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/models/client.dart';
import 'package:shylo/models/loan.dart';
final searchProvider = StateProvider<String>((_){
  return '';
});
final filteredProvider = StateProvider.family<List<Loan> , List<Loan>>((ref , loans){
  final searchText = ref.watch(searchProvider);
  final allClients = ref.watch(clientProvider);
  if(searchText.isNotEmpty){
    final List<Client> userList = allClients.where((element)=> element.surName.contains(searchText)).toList();
   if(userList.isNotEmpty) return [... loans.where((element)=> element.client == userList[0].id)];
   if(userList.isEmpty) return [];
  }
  return loans ;
});