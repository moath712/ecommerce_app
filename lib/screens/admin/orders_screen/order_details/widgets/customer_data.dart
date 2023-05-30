import 'package:flutter/material.dart';

class CustomerData extends StatelessWidget {
  const CustomerData({
    super.key,
    required this.userData,
  });

  final userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Container(
                    width: 45,
                    height: 45,
                    color: Colors.blue,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "Customer",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('${userData['firstName']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('${userData['Phone Number']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('Address :${userData['address']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('Street name :${userData['streetName']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            'Building name :${userData['buildingNumber']}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
