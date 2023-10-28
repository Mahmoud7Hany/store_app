// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:store_app/pages/forgot_password.dart';
import 'package:store_app/pages/home_page.dart';
import 'package:store_app/pages/register.dart';
import 'package:store_app/pages/verify_email_page.dart';
import '../provider/google_signin.dart';
import '../shared/colors.dart';
import '../widget/show_snack_bar_widget.dart';
import '../widget/text_field_widget.dart';

//  صفحه تسجيل الدخول
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isVisibility = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

// نفس طريقه الشرح
  // signIn() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //     showSnackBar(context, "Hello ${emailController.text}");
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, "ERROR : ${e.code}");
  //     // print(e.code);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  bool isFirstTime = true; //   يحدد ما إذا كان المستخدم مسجل لأول مرة او لا

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      showSnackBar(context, "Hello ${emailController.text}");

      // هنا يجب عمل التحقق مما إذا كان المستخدم مسجل لأول مرة أم لا
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        //  لمعرفة ذلك Firebase للتحقق مما إذا كان المستخدم مسجل لأول مرة أم لا. يمكنك الاعتماد على الخصائص الخاصة بـ
        isFirstTime = !user.emailVerified;
      }
      // isFirstTime عند تسجيل المستخدم بنجاح، قم بالتحقق من قيمة هذا المتغير وفتح الصفحة المناسبة بناءً عليه.

      // إذا كان المستخدم مسجل لأول مرة، قم بفتح صفحة التحقق من البريد
      if (isFirstTime) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VerifyEmailPage(),
          ),
        );
      } else {
        // إذا كان المستخدم قد قام بالتحقق من بريده الإلكتروني بالفعل، قم بفتح الصفحة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR: ${e.code}");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // الخاص بكل مساحه في الصفحه SizedBox
  final SizedBox sizedBox30 = const SizedBox(height: 22);

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text('Sign in'),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  TextFormField(
                    // بيستخدم لعمل تحقق علي الحقل
                    validator: (email) {
                      return email!.isEmpty ? "Enter Your Email" : null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffixIcon: const Icon(Icons.email),
                    ),
                  ),
                  sizedBox30,
                  TextFormField(
                      validator: (password) {
                        return password!.isEmpty ? "Enter Your Password" : null;
                      },
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
                      )),
                  sizedBox30,
                  ElevatedButton(
                    onPressed: () async {
                      // if (!mounted) return;
                      if (_formKey.currentState!.validate()) {
                        await signIn();
                      } else {
                        showSnackBar(context, "Please enter the field.");
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
                            "Sign in",
                            style: TextStyle(fontSize: 19),
                          ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: const Text("Forgot password?",
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
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
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text('sign up',
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  const SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.6,
                        )),
                        Text(
                          "OR",
                          style: TextStyle(),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // الخاص بتسجيل الدخول باستخدام جوجل
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 27),
                    child: GestureDetector(
                      onTap: () {
                        googleSignInProvider.googlelogin();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color.fromARGB(255, 200, 67, 79),
                                width: 1)),
                        child: SvgPicture.asset(
                          color: const Color.fromARGB(255, 200, 67, 79),
                          "assets/icons/google.svg",
                          height: 27,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
