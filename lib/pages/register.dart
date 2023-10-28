// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/pages/sign_in.dart';
import '../shared/colors.dart';
import '../widget/container_circle.dart';
import '../widget/show_snack_bar_widget.dart';
import '../widget/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;

// صفحه انشاء حساب
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final SizedBox sizedBox15 = const SizedBox(height: 15);
  bool isLoading = false;
  bool isVisibility = true;
  //Global variable
  // Firebase Storage
  String? imgName;
  // التحقق من حقل الادخال
  final _formKey = GlobalKey<FormState>();

  // إنشاء مستخدم بالبريد الإلكتروني وكلمة المرور

  // TextField يتم استخدام هذا الكود لارسال وربط البيانات المستلمه من المستخدم في
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final titleController = TextEditingController();
  register() async {
    // true هنا بقول له قبل ما تروح تنشاء حساب غير القيمه دي ل
    setState(() {
      isLoading = true;
    });
    try {
      // بتستخدم لانشاء مستخدم بالبريد الإلكتروني وكلمة المرور
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Firebase Storage تحميل الصورة إلى
      // $imgName ويضيف في داخله الصوره Storage يعني هينشاء ملف بالاسم ده داخل users-images/
      final storageRef = FirebaseStorage.instance.ref("users-images/$imgName");
      await storageRef.putFile(imgPath!);
      // Storage الحصول علي لينك الصوره اللي اترفعت علي
      String link = await storageRef.getDownloadURL();

      // Firestore
      // ويتم حفظ الداتا فيه Firestore بعد تسجيل الحساب يروح يرسل الداتا الي المستخدم ادخلها في
      // اللي انشاته collection هنا بتكتب بيوصل لي
      CollectionReference users =
          FirebaseFirestore.instance.collection('usersss');

      // usersss اللي انا انشاتها باسم collection بالاسم ده داخل document بينشاء
      users
          .doc(credential.user!.uid)
          // Start collection اللي تم انشاها الداتا دي داخل document بيضيف لي داخل
          .set({
            'imageLink': link,
            'username': usernameController.text,
            'age': ageController.text,
            "title": titleController.text,
            "email": emailController.text,
            "pass": passwordController.text,
          })
          // بيشتغل بعد تخزين الداتا بنجاح then
          .then((value) => print("User Added"))
          // error في حاله حصل catchError
          .catchError((error) => print("Failed to add user: $error"));

      // بعد نجاح التسجيل، قم بمسح النصوص في الحقول
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      } else {
        showSnackBar(context, 'ERROR - please try again later');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    // false هنا بقي بقول له بعد ما تروح تنشاء حساب وتخزن البيانات بتعته روح رجع القيمه تاني لي
    setState(() {
      isLoading = false;
    });
  }

// باختصار علشان ده حوار كبير هيا بتعمل تحديث في اداء التطبيق
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    usernameController.dispose();
    ageController.dispose();
    titleController.dispose();
    super.dispose();
  }

// Password موجود في التحقق الخاصه ب Container تعمل تحقق علي كل
  bool isPassword8Char = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  onPasswordChanged(String password) {
    // وبعدين اتاكد ان المستخدم ادخل 8 حروف false هنا بقول له رجع كل مره القيمه ب
    isPassword8Char = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

// الخاص بكل مساحه في الصفحه SizedBox
  final SizedBox sizedBox26 = const SizedBox(height: 22);

  // تحميل الصور اله الشاشه الخاصه بنا
  File? imgPath;
  uploadImage(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          // Firebase Storage اسم الصوره اللي بيترفع علي imgName الحصول علي
          imgName = basename(pickedImg.path);
          // اضافه رقم عشوائي لاسم الصوره علشان ميكونشي في اسم متشابه
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print('=============================');
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
    Navigator.pop(context);
  }

// وتختار عوز تحمل الصوره من الاستديو او من الكاميره showModal بتستخدم لما اضغط علي زر الكاميره لاضافه صوره يظهر
  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(18),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.camera);
                },
                child: Container(
                  color: const Color.fromARGB(169, 224, 222, 214),
                  height: 50,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 30,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        "From Camera",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.gallery);
                },
                child: Container(
                  color: const Color.fromARGB(169, 224, 222, 214),
                  height: 50,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.photo_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        "From Gallery",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  sizedBox26,
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: Stack(
                      children: [
                        // ClipOval ولو موجود صوره يعرض CircleAvatar هنا بعمل شرط لو مش موجود صوره يعرض
                        imgPath == null
                            ? const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/img/avatar.png'),
                              )
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
                              // await uploadImage();
                              showmodel();
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

                  sizedBox26,
                  TextFormField(
                    validator: (username) {
                      return username!.isEmpty ? "Enter Your username" : null;
                    },
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    // obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your username : ",
                        suffixIcon: const Icon(Icons.person)),
                  ),
                  sizedBox26,
                  TextFormField(
                      validator: (age) {
                        return age!.isEmpty ? "Enter Your age" : null;
                      },
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                          hintText: "Enter Your age : ",
                          suffixIcon: const Icon(Icons.pest_control_rodent))),
                  sizedBox26,
                  TextFormField(
                      validator: (title) {
                        return title!.isEmpty ? "Enter Your title" : null;
                      },
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                          hintText: "Enter Your title : ",
                          suffixIcon: const Icon(Icons.person_outline))),

                  sizedBox26,
                  TextFormField(
                    // بيستخدم لعمل تحقق علي الحقل
                    validator: (email) {
                      return email!.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                          ? null
                          : "Enter a valid email";
                    },
                    // الكود ده بيعمل تحقق كل ما يحصل تغير فيه يعني كل ما حرف يكتب فيه
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    // obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Email : ",
                        suffixIcon: const Icon(Icons.email)),
                  ),
                  sizedBox26,
                  TextFormField(
                    onChanged: (password) {
                      onPasswordChanged(password);
                    },
                    validator: (password) {
                      return password!.length < 8
                          ? "Enter at least 8 characters"
                          : null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: isVisibility,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Password : ",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibility = !isVisibility;
                          });
                        },
                        icon: isVisibility
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  sizedBox15,
                  ContainerCircle(
                      text: 'At least 8 Characters',
                      color: isPassword8Char ? Colors.green : Colors.white),
                  sizedBox15,
                  ContainerCircle(
                      text: 'At least 1 number',
                      color:
                          isPasswordHas1Number ? Colors.green : Colors.white),
                  sizedBox15,
                  ContainerCircle(
                      text: 'Has Uppercase',
                      color: hasUppercase ? Colors.green : Colors.white),
                  sizedBox15,
                  ContainerCircle(
                      text: 'Has Lowercase',
                      color: hasLowercase ? Colors.green : Colors.white),
                  sizedBox15,
                  ContainerCircle(
                      text: 'Has Special Characters !@#\$%^&*',
                      color:
                          hasSpecialCharacters ? Colors.green : Colors.white),
                  sizedBox26,
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       register();
                  //     } else {
                  //       showSnackBar(context, 'Please enter the field.');
                  //     }else {}

                  //   },
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all(BTNgreen),
                  //     padding:
                  //         MaterialStateProperty.all(const EdgeInsets.all(12)),
                  //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8))),
                  //   ),
                  //   child: isLoading
                  //       ? const CircularProgressIndicator(
                  //           color: Colors.white,
                  //         )
                  //       : const Text(
                  //           "Register",
                  //           style: TextStyle(fontSize: 19),
                  //         ),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      // عمل شرط ان ميعملشي انشاء حساب غير لما ادخل جميع الشروط المطلوبه فيه وكل شرط هيتحقق هيتعمل علامه صح قدامه ان هو تم بنجاح غير كده ميفعلشي الكود ويطلب من المستخدم اكمال جميع شروط الحقل
                      if (isPassword8Char &&
                          isPasswordHas1Number &&
                          hasUppercase &&
                          hasLowercase &&
                          hasSpecialCharacters) {
                        if (_formKey.currentState!.validate() &&
                            imgName != null &&
                            imgPath != null) {
                          // تم تحقيق جميع الشروط بنجاح
                          await register();
                          if (!mounted) return;
                          // يرسل رساله للمستخدم ان تم انشاء الحساب showSnackBar
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          // يتم فحص وجود لزم المستخدم يضيف صورهimgName و imgPath هنا
                          if (imgName == null || imgPath == null) {
                            showSnackBar(context, 'Please upload an image.');
                          } else {
                            showSnackBar(context, 'Please enter the field.');
                          }
                        }
                      } else {
                        String missingRequirements = '';
                        if (!isPassword8Char) {
                          missingRequirements += 'At least 8 Characters';
                        }
                        if (!isPasswordHas1Number) {
                          missingRequirements += 'At least 1 number';
                        }
                        if (!hasUppercase) {
                          missingRequirements += 'Has Uppercase';
                        }
                        if (!hasLowercase) {
                          missingRequirements += 'Has Lowercase';
                        }
                        if (!hasSpecialCharacters) {
                          missingRequirements +=
                              'Has Special Characters !@#\$%^&*';
                        }
                        missingRequirements = missingRequirements.substring(
                            0,
                            missingRequirements.length -
                                0); // لإزالة الفاصلة والمسافة الزائدة في نهاية السلسلة
                        showSnackBar(context,
                            'Password requirements not met: $missingRequirements');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(BTNgreen),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Register",
                            style: TextStyle(fontSize: 19),
                          ),
                  ),

                  sizedBox26,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do not have an account?",
                          style: TextStyle(fontSize: 18)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'sign in',
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
