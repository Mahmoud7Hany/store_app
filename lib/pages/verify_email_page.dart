// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/pages/home_page.dart';
import '../shared/colors.dart';
import '../widget/show_snack_bar_widget.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

// التحقق من البريد الإلكتروني بعد تسجيل الدخول
// شرط لزم تكون عمل انشاء حساب الاول علشان يقدر يعمل تسجيل وبعد كده يظهر تحقق او يفتح الصفحه الرئسيه
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

// بيتم تشغيله تلقائي اول ما افتح الصفحه initState
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      // ارسل ايميل التفعيل تلقائي اول ما الصفحه تفتح
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (!mounted) {
          // تحقق من أن الصفحة لا تزال موجودة قبل استخدام setState
          timer.cancel();
          return;
        }
        // عندما نضغط على الرابط الموجود على الياهو
        await FirebaseAuth.instance.currentUser!.reload();
        // هل تم التحقق من البريد الإلكتروني أم لا (تم النقر على الرابط أم لا) (صواب أم خطأ)
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (isEmailVerified) {
          timer.cancel();
        }
      });
    }
  }

// ارسل ايميل التفعيل لما اضغط علي الزر ولما افتح الصفحه تلقائي
  sendVerificationEmail() async {
    try {
      // لارسال كود التفعيل
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      // لما اضغط علي الزر ميعملشي ارسال للكود غير بعد 5 ثواني
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      showSnackBar(context, "ERROR => ${e.toString()}");
      print(e.toString());
    }
  }

// بتحسن من اداء التطبيق true يتم تشغيل هذا بعد انتهاء الوقت لما يكون القيمه بتعته ب dispose
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify Email"),
              elevation: 0,
              backgroundColor: appbarGreen,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A verification email has been sent to your email. If you haven't received the email, please click on the Verification Email button.",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // لارسال اميل لما اضغط علي الزر
                      canResendEmail ? sendVerificationEmail() : null;
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(BTNgreen),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: const Text(
                      "Resent Email",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(BTNpink),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
