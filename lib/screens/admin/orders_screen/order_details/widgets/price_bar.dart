
import 'package:flutter/material.dart';

class PriceBar extends StatelessWidget {
  const PriceBar({
    super.key,
    required this.totalPrice,
  });

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 60,
            right: 20,
          ),
          child: Row(
            children: [
              const Text(
                'Total: ',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                ' \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
