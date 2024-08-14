import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryIcon extends StatelessWidget {
  CategoryIcon({
    Key? key,
    required this.category,
    this.padding = 10.0,
    required this.logo,
    required this.onTap,
    required this.boxColor,
  }) : super(key: key);

  final String category;
  final String logo;
  final double padding;
  final VoidCallback onTap;
  Color boxColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: boxColor,
              width: 3,
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(logo, height: 40),
              Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
