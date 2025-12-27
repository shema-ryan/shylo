import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:shylo/models/client.dart';
import 'package:shylo/models/moneyformat.dart';
import 'loan.dart';

class PdfCreator {
  static Future<void> generateLoansReport({
    required List<Loan> loans,
    required String identifier,
    required List<Client> clients,
  }) async {
    String getName(ObjectId id) {
      final client = clients.firstWhere((element) => element.id == id);
      return '${client.surName} ${client.lastName}';
    }

    final Directory loansDirectory;
    if (!await Directory(r'C:\Reports\Loans').exists()) {
      loansDirectory = await Directory(
        r'C:\Reports\Loans',
      ).create(recursive: true);
    } else {
      loansDirectory = Directory(r'C:\Reports\Loans');
    }
    try {
      final logo = await rootBundle.load('assets/images/skylo.png');
      final logobytes = logo.buffer.asUint8List();
      final year = DateTime.now().year;
      final month = DateTime.now().month;
      final day = DateTime.now().day;
      final File pdfFile = File(
        '${loansDirectory.path}/loansReport-$day-$month-$year-${loans.first.loanStatus.name}.pdf',
      );
      final pdf = Document();
      pdf.addPage(
        MultiPage(
          maxPages: 100,
          pageFormat: PdfPageFormat.a4,
          header: (context) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(MemoryImage(logobytes), height: 50, width: 50),
                  Text(
                    'SHYLO ENTERPRISE.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                'RE : REPORT FOR ${identifier.toUpperCase()}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          footer: (context) =>
              Text('Live like they dream', style: TextStyle(fontSize: 10)),
          build: (context) => [
            SizedBox(height: 20),
            Table(
              border: TableBorder(
                verticalInside: BorderSide(color: PdfColor.fromHex('#808080')),
                top: BorderSide(color: PdfColor.fromHex('#808080')),
                horizontalInside: BorderSide(
                  color: PdfColor.fromHex('#808080'),
                ),
                bottom: BorderSide(color: PdfColor.fromHex('#808080')),
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Name', style: TextStyle(fontSize: 12)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Principle (Ugx)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Rate', style: TextStyle(fontSize: 12)),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Amount (Ugx)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Balance (Ugx)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('DueDate', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                for (Loan loan in loans)
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          getName(loan.client),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${loan.principleAmount.ceil()}'.toMoney(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${loan.interestRate}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${loan.calculateTotalAmount()}'.toMoney(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${ loan.calculateTotalAmount() - loan.calculatePaidAmount()}'
                              .toMoney(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          DateFormat.yMd().format(loan.dueDate),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );

      await pdfFile.writeAsBytes(await pdf.save());
    } catch (e) {
      rethrow;
    }
  }
}
