import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/admin/orders_screen/order_details/widgets/customer_data.dart';
import 'package:ecommerce_app/screens/admin/orders_screen/order_details/widgets/price_bar.dart';
import 'package:ecommerce_app/screens/admin/orders_screen/order_details/widgets/print_receipt_button.dart';
import 'package:ecommerce_app/screens/admin/orders_screen/order_details/widgets/table_headers.dart';
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

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Center(
          child: Container(
            decoration: const BoxDecoration(),
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 232, 236, 237),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Image.asset(ImageAssets.back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Order Details",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: constraints.maxHeight / 1.5,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 28),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.date_range_outlined),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            child: Text(
                                              ' ${DateFormat.yMd().add_jm().format((order['timestamp'] as Timestamp).toDate())}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PrintReceiptButton(order: order),
                                  ],
                                ),
                                CustomerData(userData: userData),
                                const TableHeadrs(),
                                ...cartItems.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Row(
                                                children: [
                                                  Image.network(
                                                    item['imageURL'],
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                  Text(" ${item['title']}"),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              child: Row(
                                                children: [
                                                  if (item['selectedColor'] !=
                                                      null)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(
                                                            int.parse(
                                                                '0xFF${item['selectedColor']['hex'].substring(1)}')),
                                                        radius: 10,
                                                      ),
                                                    ),
                                                  const SizedBox(width: 8),
                                                  if (item['selectedColor'] !=
                                                      null)
                                                    Text(
                                                        ' ${item['selectedColor']['color']}'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                child: Text(
                                                    '${item['userQuantity']}')),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                child:
                                                    Text('${item['price']}')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                          PriceBar(totalPrice: totalPrice),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
