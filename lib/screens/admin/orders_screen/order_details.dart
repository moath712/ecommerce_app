import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final userData = order['userData'];
    final cartItems = order['cartItems'] as List<dynamic>;

    final totalPrice = cartItems.fold(
      0.0,
      (double previousValue, item) =>
          previousValue + ((item['price'] ?? 0) * (item['userQuantity'] ?? 1)),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 6,
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset(ImageAssets.back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: userData['photoUrl'] != null
                              ? Image.network(
                                  userData['photoUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(Icons.account_circle,
                                        size: 80.0);
                                  },
                                )
                              : const Icon(Icons.account_circle, size: 80.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Customer Information:",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' ${DateFormat.yMd().add_jm().format((order['timestamp'] as Timestamp).toDate())}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Name : ${userData['firstName']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tel : ${userData['Phone Number']}'),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 6,
                  ),
                  ...cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(item['imageURL']),
                        title: Text(item['title']),
                        subtitle: Row(
                          children: [
                            if (item['selectedColor'] != null)
                              CircleAvatar(
                                backgroundColor: Color(int.parse(
                                    '0xFF${item['selectedColor']['hex'].substring(1)}')),
                                radius: 10,
                              ),
                            const SizedBox(width: 8),
                            if (item['selectedColor'] != null)
                              Text('Color: ${item['selectedColor']['color']}'),
                          ],
                        ),
                        trailing: Text('Quantity: ${item['userQuantity']}'),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 6,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
