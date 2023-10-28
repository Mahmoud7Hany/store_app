import 'package:flutter/material.dart';

// اللي عليه علامه صح بستخدمه للتحقق من كلمه المرور Container هنا الشكل بتع
class ContainerCircle extends StatelessWidget {
  const ContainerCircle({super.key, required this.text, required this.color});

  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: const Color.fromARGB(255, 189, 189, 189)),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(width: 11),
        Text(text)
      ],
    );
  }
}
