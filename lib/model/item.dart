// هنا بستخدم العناصر اللي هتضاف معايه في المتجر اللي هتظهر لما اضغط علي اي منتج فهيظهر ليا تفاصيل المنتج من صور ووصف وسعر وهكذا
class Item {
  String imgPath;
  double price;
  String location;
  String productDetails;
  String name;

  Item(
      {required this.imgPath,
      required this.price,
      this.location = 'Main Branch',
      required this.productDetails,
      required this.name});
}

final List<Item> items = [
  Item(
      name: 'product1',
      price: 12.99,
      imgPath: "assets/img/1.webp",
      location: 'Mahmoud Shop',
      productDetails:
          'Romantic Red Rose Bouquet: Make Valentines Day more romantic with this beautiful red rose bouquet. The deep red colors of the roses, combined with their shiny green leaves, express love and passion.'),
  Item(
      name: 'product2',
      price: 25.0,
      imgPath: "assets/img/2.webp",
      productDetails:
          "Pure White Rose Bouquet: White roses symbolize purity and innocence. This bouquet is a perfect gift for formal occasions like weddings and graduations."),
  Item(
      name: 'product3',
      price: 45.0,
      imgPath: "assets/img/3.webp",
      productDetails:
          "Lovely Pink Rose Bouquet: The pink rose bouquet is a perfect choice for a birthday gift or congratulations. It combines beauty and sweetness."),
  Item(
      name: 'product4',
      price: 55.99,
      imgPath: "assets/img/4.webp",
      productDetails:
          "Royal Blue Sea Rose Bouquet: The royal blue sea rose bouquet features attractive blue colors, expressing tranquility and serenity. It is suitable for those looking to relax and enjoy the beauty of the sea."),
  Item(
      name: 'product5',
      price: 22.0,
      imgPath: "assets/img/5.webp",
      productDetails:
          "Velvet Black Rose Bouquet: The black rose can symbolize mystery and allure. This bouquet is an attention-grabber with its elegance and luxury."),
  Item(
      name: 'product6',
      price: 35.0,
      imgPath: "assets/img/6.webp",
      productDetails:
          "Fiery Orange Rose Bouquet: The orange rose signifies vitality and energy. This bouquet conveys enthusiasm and optimism."),
  Item(
      name: 'product7',
      price: 45.99,
      imgPath: "assets/img/7.webp",
      productDetails:
          "Mixed Rose Bouquet: A bouquet that combines a variety of colors, expressing the diversity and beauty of life. It's suitable for various occasions."),
  Item(
      name: 'product8',
      price: 70.0,
      imgPath: "assets/img/8.webp",
      productDetails:
          "Christmas Rose Bouquet: A bouquet adorned with colors and ornaments of the holiday season. It adds a charming and festive touch to your home during the holiday season."),
];
