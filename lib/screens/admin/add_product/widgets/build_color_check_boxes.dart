import 'package:flutter/material.dart';

class ColorCheckbox extends StatefulWidget {
  final MapEntry<String, String> entry;
  final List<Map<String, String>> selectedColorsWithHex;

  const ColorCheckbox({super.key, required this.entry, required this.selectedColorsWithHex});

  @override
 State<ColorCheckbox> createState() => _ColorCheckboxState();
}

class _ColorCheckboxState extends State<ColorCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: 
                  Color(int.parse('0xFF${widget.entry.value.substring(1)}')),
              radius: 10,
            ),
          ),
          const SizedBox(width: 10),
          Text(widget.entry.key),
        ],
      ),
      value: widget.selectedColorsWithHex
          .any((element) => element['color'] == widget.entry.key),
      onChanged: (bool? newValue) {
        setState(() {
          if (newValue!) {
            widget.selectedColorsWithHex.add(
              {'color': widget.entry.key, 'hex': widget.entry.value},
            );
          } else {
            widget.selectedColorsWithHex
                .removeWhere((element) => element['color'] == widget.entry.key);
          }
        });
      },
    );
  }
}
