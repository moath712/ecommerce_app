import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/manager/cart_logic/cart_logic.dart';
import 'package:ecommerce_app/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CheckOutBar extends StatelessWidget {
  const CheckOutBar({
    super.key,
    required this.cartNotifier,
    required this.totalPrice,
  });

  final CartState cartNotifier;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('carts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('items')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return SizedBox(
            height: 100,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              height: 40,
                              child: InkWell(
                                onTap: () => cartNotifier.confirmOrder(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                   color:   const Color(0xFFBB6BD9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Confirm Order',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "TOTAL",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.cartpink),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${totalPrice.toString()}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.totalpink),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.only(bottom: 400),
            child: Center(
              child: Text(
                "No items in your cart",
                style: TextStyle(fontSize: 25),
              ),
            ),
          );
        }
      },
    );
  }
}
