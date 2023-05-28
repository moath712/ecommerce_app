import 'package:ecommerce_app/screens/admin/home_dashboard/models/home_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
        // TODO: use stream provider instead
        SingleChildScrollView(
          child: FutureBuilder<DataModel>(
            future: _fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2.2,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.white,
                        child: BarChart(
                          BarChartData(
                            barGroups: _generateBarGroups(data),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Users',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Colors.blue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: const [
                                  Text(
                                    'Orders',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Colors.green,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(DataModel data) {
    final userBar = data.users
        .asMap()
        .map((index, value) => MapEntry(
            index,
            BarChartRodData(
              toY: value,
              color: Colors.blue,
            )))
        .values
        .toList();

    final orderBar = data.orders
        .asMap()
        .map((index, value) => MapEntry(
            index,
            BarChartRodData(
              toY: value,
              color: Colors.green,
            )))
        .values
        .toList();

    return [
      BarChartGroupData(x: 1, barRods: userBar, showingTooltipIndicators: [0]),
      BarChartGroupData(x: 2, barRods: orderBar, showingTooltipIndicators: [0]),
    ];
  }

  Future<DataModel> _fetchData() async {
    // Fetch data from Firestore and process it
    final users = await FirebaseFirestore.instance.collection('users').get();
    final orders = await FirebaseFirestore.instance.collection('orders').get();

    // Mock data
    final List<double> userNumbers = [users.docs.length.toDouble()];
    final List<double> orderNumbers = [orders.docs.length.toDouble()];

    return DataModel(users: userNumbers, orders: orderNumbers);
  }
}
