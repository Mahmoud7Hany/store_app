// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store_app/pages/sign_in.dart';
import '../shared/colors.dart';
import 'package:intl/intl.dart';
import '../shared/data_from_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../shared/user_image_from_firestore.dart';
import 'package:path/path.dart' show basename;

// Firestore الحصول علي البيانات من
// دي صفحه عرض معلومات عن المستخدم مثل اسم المستخدم والحساب وكلمه المرور وهكذا
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // علشان اقدر اتحكم فيه credential بيستخدم لتخزين تسجيل الدخول داخل متغير
  final credential = FirebaseAuth.instance.currentUser;

  // intl لاستخدام الوقت الخاص ب مكتبه Time
  // String date = DateFormat("MMMM d, y").format(DateTime.now());
  // String timeNow = DateFormat('hh : mm : ss a').format(DateTime.now());

// بتعاك collection هنا بتكتب اسم
  // CollectionReference users = FirebaseFirestore.instance.collection('usersss');

  // تحميل الصور اله الشاشه الخاصه بنا
  File? imgPath;
  uploadImage() async {
    final pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          //  الحصول على اسم الصورة فقط
          imgName = basename(pickedImg.path);
          //  إنشاء إسم فريد لكل صورة مكون من رقم عشوائي
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  // غير الصوره اللي تم رفعه علشان اعمل استبدال للصوره واضيف الصوره الجديده Firestore رفع صوره علي
  String? imgName;
  // [database] firestore للصورة في url تخزين عنوان
  CollectionReference users = FirebaseFirestore.instance.collection('usersss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // false هو شرط التحقق يجب إزالة الصفحات القديمة نقوم بتعيين الشرط على أنه دائمًا يجب إزالة الصفحات السابقهfalse بيستخدم لازاله الصفحه السابقه و pushAndRemoveUntil
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            },
            label: const Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: appbarGreen,
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(125, 78, 91, 110),
                  ),
                  child: Stack(
                    children: [
                      // ClipOval ولو موجود صوره يعرض CircleAvatar هنا بعمل شرط لو مش موجود صوره يعرض
                      imgPath == null
                          ? const ImageUserFromFirestore()
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 103,
                        child: IconButton(
                          onPressed: () async {
                            await uploadImage();
                            // يعني ليست ب !=
                            if (imgPath != null) {
                              // Firestore هيعمل تحديث للصوره. هيشيل الصوره القديمه ويضيف صوره جديده علي
                              final storageRef = FirebaseStorage.instance
                                  .ref("users-images/$imgName");
                              await storageRef.putFile(imgPath!);
                              // للصورة URL احصل على عنوان
                              String url = await storageRef.getDownloadURL();
                              // القديم ويضيف الجديد ويعرض الصوره URL بيعمل استبدال لعنوان
                              users.doc(credential!.uid).update({
                                "imageLink": url,
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Color.fromARGB(255, 94, 115, 128),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 177, 255),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "Info from firebase Auth",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 11),
                  Text(
                    "Email: ${credential!.email}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    // Authentication الحصول علي بيانات من
                    "Created date: ${DateFormat("MMMM d, y").format(credential!.metadata.creationTime!)}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    // Authentication الحصول علي بيانات من
                    "Last Signed In: ${DateFormat("MMMM d, y").format(credential!.metadata.lastSignInTime!)} ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: TextButton(
                  onPressed: () {
                    // firebase الخاص ب Authentication بيحذف جميع الداتا بتاعت المستخدم اللي تم تخزينه في
                    setState(() {
                      // لحذف المستخدم
                      credential!.delete();
                      // Firestore لحذف الداتا بتاعت المستخدم من
                      CollectionReference users =
                          FirebaseFirestore.instance.collection('usersss');
                      users.doc(credential!.uid).delete();

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false);
                    });
                  },
                  child: const Text(
                    'Delete Data',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              // Firestore احصل على البيانات من
              Center(
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 131, 177, 255),
                      borderRadius: BorderRadius.circular(11)),
                  child: const Text(
                    "Info from firebase firestore",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              // Firestore احصل على البيانات من
              //  علشان اقدر اوصل لي اسم المستخدم الخاص باليوزر اللي بيكون عباره عن firestore اللي موجود في ال document اللي هو documentId بتستخدم الكلاس وبتضيف له
              // credential!.uid بشكل ده وعوزه يفتح حسب المستخدم ففي الحاله دي هستخدم uA3CZ2Xsu4YgSabGcxnKdNY8vtI2
              GetDataFromFirestore(documentId: credential!.uid)
            ],
          ),
        ),
      ),
    );
  }
}
