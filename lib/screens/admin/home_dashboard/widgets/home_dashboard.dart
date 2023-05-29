import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/dashboard_model/home_dashboard_model.dart';
import 'package:fl_chart/fl_chart.dart';

final dataProvider = StreamProvider<DataModel>((ref) async* {
  final userStream = FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs.length.toDouble());
  final orderStream = FirebaseFirestore.instance
      .collection('orders')
      .snapshots()
      .map((snapshot) => snapshot.docs.length.toDouble());

  await for (final userCount in userStream) {
    await for (final orderCount in orderStream) {
      yield DataModel(users: [userCount], orders: [orderCount]);
    }
  }
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsyncValue = ref.watch(dataProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: dataAsyncValue.when(
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
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
                    // rest of your UI...
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
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
}
