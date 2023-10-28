import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

// Firestore صفحه الحصول علي البيانات من
class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore({super.key, required this.documentId});

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  // dialogUsernameController اللي هيا اي حاجه تكتب فيها بيحفظها في متغير اسمه TextField خاص بارسال البيانات في TextEditingController
  final dialogUsernameController = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  // اللي انت انشاته واللي هيتعمل عليه التعديلcollection بتكتب فيه اسم
  CollectionReference users = FirebaseFirestore.instance.collection('usersss');

  // بيعمل شرط علي حقل الادخال ان القيمه متكونشي فارغه
  final _formKey = GlobalKey<FormState>();

// بيستخدم لعرض مربع اكتب فيه التعديل وزرين واحد بيعمل تعديل والتاني بيعمل الغاء
  myDialog(Map data, dynamic myKey) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: const EdgeInsets.all(22),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                      validator: (data) {
                        return data!.isEmpty
                            ? "Cannot input an empty value."
                            : null;
                      },
                      controller: dialogUsernameController,
                      maxLength: 20,
                      decoration: InputDecoration(hintText: " ${data[myKey]}")),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // اللي عوز اعمل له تعديل Value اللي في داخله ويغير KEY يعمل تعديل لي document.uid هنا بقول له يروح لي
                          users
                              .doc(credential!.uid)
                              .update({myKey: dialogUsernameController.text});
                          setState(() {
                            dialogUsernameController
                                .clear(); // هذا السطر لمسح النص بعد الاضافه بنجاح
                            Navigator.pop(context);
                          });
                        } else {
                          // showSnackBar(context, "Please enter the field.");
                        }
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // addnewtask();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Firestore اللي انت انشاته في collection بتكتب اسم
    CollectionReference users =
        FirebaseFirestore.instance.collection('usersss');

    return FutureBuilder<DocumentSnapshot>(
      // Firestore اللي موجود في document بيستخدم للحصول علي البيانات من future: users.doc(documentId).get(),
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        // Firestore اللي موجود في document بتاعك اللي متخزن في Key بتكتب اسم data داخل data هنا لو كل حاجه تمام وتم الاتصتال بقاعده البيانات بنجاح وتم الحصول علي البيانات ينفذ ده وتم تخزين الداتا في متغير اسمه
        if (snapshot.connectionState == ConnectionState.done) {
          // Map بيتم الحصول علي البيانات علي شكل
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 9),
              // usersss اللي انا انشاته باسم collection داخل document اللي هو البيانات اللي محتاجه واللي المستخدم ادخله وهو بينشاء الحساب اللي متخزنه في Value للحصول علي Key بستخدم
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Username: ${data['username']}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Firestore لحذف البيانات من
                          // users اللي انشاته اللي متخزن فيه collection اللي داخل document من field بيستخدم هذا الكود لازاله
                          setState(() {
                            users
                                .doc(credential!.uid)
                                .update({"username": FieldValue.delete()});
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                      ),
                      IconButton(
                        onPressed: () {
                          myDialog(data, 'username');
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email: ${data['email']}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     myDialog(data, 'email');
                  //   },
                  //   icon: const Icon(Icons.edit),
                  // )
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password: ${data['pass']}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     myDialog(data, 'pass');
                  //   },
                  //   icon: const Icon(Icons.edit),
                  // )
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Age: ${data['age']} years old",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     myDialog(data, 'age');
                  //   },
                  //   icon: const Icon(Icons.edit),
                  // )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Title: ${data['title']} ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'title');
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue))
                ],
              ),

              Center(
                child: TextButton(
                  onPressed: () {
                    // Firestore الخاص ب document بيحذف جميع الداتا بتاعت المستخدم اللي تم تخزينه في
                    setState(() {
                      users.doc(credential!.uid).delete();
                    });
                  },
                  child: const Text(
                    'Delete Data',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
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
