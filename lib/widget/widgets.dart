import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final String pageHeader;

  CustomBackButton({required this.pageHeader});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                pageHeader,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
