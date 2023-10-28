import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

// firestore الحصول علي صوره المستخدم من
class ImageUserFromFirestore extends StatefulWidget {
  const ImageUserFromFirestore({super.key});

  @override
  State<ImageUserFromFirestore> createState() => _ImageUserFromFirestoreState();
}

class _ImageUserFromFirestoreState extends State<ImageUserFromFirestore> {
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
      future: users.doc(credential!.uid).get(),
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
          return CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            radius: 70,
            backgroundImage: NetworkImage(data['imageLink']),
          );
        }
        // Firestore بيستخدم في حاله تحميل البيانات من
        return const CircularProgressIndicator(
          color: BTNgreen,
        );
      },
    );
  }
}
