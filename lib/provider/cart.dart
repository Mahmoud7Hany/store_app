import 'package:flutter/material.dart';
import '../model/item.dart';

// من اى صفحة ونستطيع التعديل عليها data لكى نصل الى الـ provider نحن نستخدم الـ
class Cart with ChangeNotifier {
  // الخاصه بك اللي عوز توصل لها من اي مكان data هنا هتكتب ال
  // بتعتنا دي خاصه بعربة التسوق List
  List selectedProducts = [];

  // هنا هيجمع ليا سعر المنتجات اللي تم اضافته في عربة التسوق
  int price = 0;

// لاضافه عنصر في عربه التسوق
  add(Item product) {
    // List selectedProducts بقول له اعمل اضافه للمنتج لما المستخدم يضغط علي اضافه لعربه التسوق يتم اضافه هذا المنتج في
    selectedProducts.add(product);
    // ضيف سعر المنتج + سعر المنتج اللي تم اضافته في عربه التسوق
    price += product.price.round();

    // علشان يعمل رفرش لالصفحه method في نهاية كل notifyListeners(); استخدم
    notifyListeners();
  }

// لازاله عنصر من عربه التسوق
  delete(Item product) {
    // هنا بقول له لما اضغط علي الزر روح احذف عنصر من عربه التسوق
    selectedProducts.remove(product);
    // نقص العنصر اللي اتمسح واحسب القيمه اللي تم ازالته من عربه التسوق
    price -= product.price.round();

    notifyListeners();
  }

// في المكان اللي عوز تستخدمه فقط itemCount وتعمل اضافه لنفس الكود لا الكود ده بيوفر عليك وقت وهتضيف الكود  widget وبدل ما تروح عند كل selectedProducts.length معني هذا الكود ان تم تخزين الكود اللي في داخله
  get itemCount {
    return selectedProducts.length;
  }
}
