import 'package:flutter/material.dart';

class DrawerData extends StatelessWidget {
  const DrawerData({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40.0,
          child: ClipOval(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: userData['imageUrl'] != null
                  ? Image.network(
                      userData['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Icon(Icons.account_circle, size: 80.0);
                      },
                    )
                  : const Icon(Icons.account_circle, size: 80.0),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          userData['firstName'],
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
      ],
    );
  }
}
