import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectDialog {
  static showOptionDialog({
    required BuildContext context,
    required List<String> options,
    required Function(int index) onOptionSelect,
  }) {
    final length = options.length;
    final double height = length * 50 + 100;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        List<Widget> list = [];
        for (int i = 0; i < length; i++) {
          list.add(
            GestureDetector(
              onTap: () {
                onOptionSelect(i);
                Get.back();
              },
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    options[i],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          );
          if (i < length - 1) {
            list.add(
              Divider(
                height: 1,
                color: Colors.grey,
              ),
            );
          }
        }
        return Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          height: height,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.topLeft,
                child: Column(
                  children: list,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Huỷ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
