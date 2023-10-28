import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// firestore الحصول علي اسم المستخدم من
class UserNameFromFirestore extends StatefulWidget {
  final String documentId;
  const UserNameFromFirestore({super.key, required this.documentId});

  @override
  State<UserNameFromFirestore> createState() => _UserNameFromFirestoreState();
}

class _UserNameFromFirestoreState extends State<UserNameFromFirestore> {
  final credential = FirebaseAuth.instance.currentUser;
  // اللي انت انشاته واللي هيتعمل عليه التعديلcollection بتكتب فيه اسم
  CollectionReference users = FirebaseFirestore.instance.collection('usersss');

  @override
  Widget build(BuildContext context) {
    // Firestore اللي انت انشاته في collection بتكتب اسم
    CollectionReference users =
        FirebaseFirestore.instance.collection('usersss');

    return FutureBuilder<DocumentSnapshot>(
      // اللي هيكون لينك الصوره بتاعت المستخدم Firestore اللي موجود في document بيستخدم للحصول علي البيانات من future: users.doc(credential!.uid).get(),
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        // Firestore اللي موجود في document بتاعك اللي متخزن في Key اسم data بتكتب داخل data هنا لو كل حاجه تمت بنجاح وتم تخزين الداتا في متغير اسمه
        if (snapshot.connectionState == ConnectionState.done) {
          // data وتخزينها داخل Map بيتم الحصول علي البيانات علي شكل
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // بتاعك الي متسمي بيه لو مش فاهم انظهر للسطر 37 في الكود هنا Key علشان الداتا رجعه فيه وبتكتب اسم data بتكتب اسم data['username']
          return Text(
            // ?? استخدم اللي بعد العلامه دي Null معنها اني بقول له روح نفذ هذا الكود ولو القيمه بتعته ب ??
            data['username'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        // Firestore بيستخدم في حاله تحميل البيانات من
        return const Text('');
      },
    );
  }
}
