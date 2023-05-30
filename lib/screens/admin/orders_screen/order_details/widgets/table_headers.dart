import 'package:flutter/material.dart';

class TableHeadrs extends StatelessWidget {
  const TableHeadrs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              horizontal: 8, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context)
                          .size
                          .width *
                      0.2,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 45,
                      ),
                      Text("product"),
                    ],
                  )),
              SizedBox(
                  width: MediaQuery.of(context)
                          .size
                          .width *
                      0.07,
                  child: const Text("color")),
              SizedBox(
                  width: MediaQuery.of(context)
                          .size
                          .width *
                      0.07,
                  child: const Text("quantity")),
              SizedBox(
                  width: MediaQuery.of(context)
                          .size
                          .width *
                      0.07,
                  child: const Text("Unit price")),
            ],
          ),
        ),
      ),
    );
  }
}
