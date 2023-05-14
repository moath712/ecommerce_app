import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';

class ImageDescription extends StatelessWidget {
  const ImageDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              Image.asset(
                ImageAssets.bg,
                height: 550.0,
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
