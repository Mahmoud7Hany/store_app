import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/pages/sign_in.dart';
import 'package:store_app/pages/verify_email_page.dart';
import 'package:store_app/provider/cart.dart';
import 'package:store_app/provider/google_signin.dart';
import 'package:store_app/widget/show_snack_bar_widget.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // او لا لو حصل اي تغير يروح يغيره في جميع الصفاحات Cart اللي انشاته اللي اسمه class مسؤول علشان يشوف حصل اي تغير في ال ChangeNotifierProvider
    return MultiProvider(
      // ChangeNotifierProvider طب لو عندي واحد مكانها Provider دي بتستحدم لو عندي اكتر من MultiProvider
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // بتستخدم لعمل شرط ان هو عمل تسجيل دخول قبل كده صحيح لو ايوه يفتح الصفحه الرئيسية علطول لو لا يفتح صفحه تسجيل الدخول ويسجل الحساب
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const VerifyEmailPage(); // لهيروح لصفحه الرئسيه او صفحه التحقق من البريد لو هو اول مره يفتح الحساب بعد انشاءه
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
