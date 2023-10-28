import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/pages/home_page.dart';
import '../pages/checkout.dart';
import '../pages/profile_page.dart';
import '../pages/sign_in.dart';
import '../shared/user_image_from_firestore.dart';
import '../shared/user_name_from_firestore.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
// AppBar اللي هيظهر في Drawer دي صفحه

  @override
  Widget build(BuildContext context) {
    // يستخدم للوصول لمعلومات الشخص اللي عمل تسجيل الدخول باستخدام جوجل
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/test.jpg"),
                      fit: BoxFit.cover),
                ),
                // Firestore بستخدم الطريقه دي للحصول علي بيانات اسم المستخدم اللي متخزنه داخل
                accountName: UserNameFromFirestore(documentId: user.uid),
                accountEmail: Text(
                  // الخاص بتسجيل الدخول بالفاير بيز Authentication بحصل علي البريد الاكتروني من
                  user.email!,
                  // 'test2',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    // fontSize: 15,
                  ),
                ),
                currentAccountPictureSize: const Size.square(80),
                // Firestore صورة المستخدم من
                currentAccountPicture: const ImageUserFromFirestore(),
              ),
              ListTile(
                  title: const Text("Home"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  }),
              ListTile(
                  title: const Text("My products"),
                  leading: const Icon(Icons.add_shopping_cart),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutPage(),
                        ));
                  }),
              ListTile(
                title: const Text("About"),
                leading: const Icon(Icons.help_center),
                onTap: () {},
              ),
              ListTile(
                  title: const Text("Profile Page"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  }),
              ListTile(
                  title: const Text("Logout"),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () async {
                    // بيستخدم لعمل تسجيل خروج
                    await FirebaseAuth.instance.signOut();
                    // false هو شرط التحقق يجب إزالة الصفحات القديمة نقوم بتعيين الشرط على أنه دائمًا يجب إزالة الصفحات السابقهfalse بيستخدم لازاله الصفحه السابقه و pushAndRemoveUntil
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  }),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: const Text("Developed by Mahmoud Hany © 2024",
                style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }
}
