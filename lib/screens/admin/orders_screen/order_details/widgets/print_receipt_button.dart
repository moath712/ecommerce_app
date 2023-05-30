
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class PrintReceiptButton extends StatelessWidget {
  const PrintReceiptButton({
    super.key,
    required this.order,
  });

  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 15, horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Material(
          color: Colors.grey,
          child: InkWell(
            onTap: () async {
              final doc =
                  await _generateDocument(
                      order);
              await Printing.sharePdf(
                  bytes: await doc.save(),
                  filename:
                      'Style My Space Receipt.pdf');
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.print,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<pw.Document> _generateDocument(Map<String, dynamic> order) async {
  final userData = order['userData'];
  final cartItems = order['cartItems'] as List<dynamic>;

  final totalPrice = cartItems.fold(
    0.0,
    (double previousValue, item) =>
        previousValue + ((item['price'] ?? 0) * (item['userQuantity'] ?? 1)),
  );

  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Header(level: 0, child: pw.Text('Style My Space receipt')),
          pw.Paragraph(
              text: 'Thank you for your purchase, ${userData['firstName']}!'),
          pw.Paragraph(text: 'Your total price was \$$totalPrice.'),
          pw.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['Item', 'Color', 'Quantity', 'Price'],
              for (var item in cartItems)
                <String>[
                  item['title'] ?? '',
                  item['selectedColor'] != null
                      ? item['selectedColor']['color']
                      : 'N/A',
                  '${item['userQuantity'] ?? '1'}',
                  '\$${item['price'] ?? '0'}',
                ],
            ],
          ),
        ],
      ),
    ),
  );

  return doc;
}
