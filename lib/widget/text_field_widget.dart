import 'package:flutter/material.dart';

// بتعنا اللي هيتكرار معنا TextField صفحه
const decorationTextfield = InputDecoration(
  // To delete borders
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    ),
  ),
  // fillColor: Colors.red,
  filled: true,
  contentPadding: EdgeInsets.all(8),
);

// طريقه اخري استخدم اي وحده من الاتنينس
// class TextFieldWidget extends StatelessWidget {
//   const TextFieldWidget(
//       {super.key,
//       required this.textInputType,
//       required this.isPassword,
//       required this.hintText,
//       required this.controller});

//   final TextInputType textInputType;
//   final bool isPassword;
//   final String hintText;
//   final TextEditingController controller;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       // TextField بيسمع اي تغير بيحصل في controller
//       controller: controller,
//       keyboardType: textInputType,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hintText,
//         // لحذف الحدود
//         enabledBorder: OutlineInputBorder(
//           borderSide: Divider.createBorderSide(context),
//         ),
//         // TextField لما اضغط علي
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.grey,
//           ),
//         ),
//         // color بقول له فعل الحقل خليه كله لونه اللي اخترتها اللون الافتراضي بتعه نفس اللون اللي فيfilled بالكامل و TextField اللون اللي بيظهر داخل fillColor
//         //  fillColor: Colors.amber,
//         filled: true,
//         // TextField يعمل مسافه داخليه داخل الحدود في
//         contentPadding: const EdgeInsets.all(8),
//       ),
//     );
//   }
// }
