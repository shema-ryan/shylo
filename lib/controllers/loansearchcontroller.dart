import 'package:flutter_riverpod/legacy.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/models/client.dart';
import 'package:shylo/models/loan.dart';

final searchProvider = StateProvider<String>((_) {
  return '';
});
final filteredProvider =
    StateProvider.family<
      List<Loan>,
      ({DateTime? firstdate, DateTime? lastDate , List<Loan> allLoans})
    >((ref, ({DateTime? firstdate, DateTime? lastDate , List<Loan> allLoans}) date) {
      final searchText = ref.watch(searchProvider);
      final allClients = ref.watch(clientProvider);
           if (searchText == '' && date.lastDate != null) {
            print('we are here');
 
        return [
          ...date.allLoans.where(
            (element) =>
                date.lastDate!.isAfter(element.obtainDate) &&
                date.firstdate!.isBefore(element.obtainDate)
          ),
        ];
      }
      if (searchText.isNotEmpty && date.lastDate == null) {
        final List<Client> userList = allClients
            .where(
              (element) =>
                  element.surName.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ) ||
                  element.lastName.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
            )
            .toList();
        if (userList.isNotEmpty) {
          final List<Loan> loans = [];
          for (Client client in userList) {
            loans.addAll(date.allLoans.where((loans) => loans.client == client.id));
          }
          return loans;
        }
        if (userList.isEmpty) return [];
      }
      if (searchText.isNotEmpty && date.lastDate != null) {

        final List<Client> userList = allClients
            .where(
              (element) =>
                  element.surName.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ) ||
                  element.lastName.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
            )
            .toList();
        if (userList.isNotEmpty) {
          final List<Loan> loans = [];
          for (Client client in userList) {
            loans.addAll(
              date.allLoans.where(
                (loans) =>
                    loans.client == client.id &&
                    loans.obtainDate.isAfter(date.firstdate!) &&
                    loans.obtainDate.isBefore(date.lastDate!),
              ),
            );
          }
          return loans;
        }
        if (userList.isEmpty) return [];
      }
    
      return date.allLoans;
    });
