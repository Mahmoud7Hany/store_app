import 'package:flutter/material.dart';
import '../model/item.dart';
import '../shared/colors.dart';
import '../widget/app_bar.dart';

// صفحه التفاصيل اللي هتظهر لما اضغط علي اي منتج
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.product});
  // هيخزن البيانات اللي تم استلامه عند الضغط علي تفاصيل اي منتج يروح يعرض الصوره بتعت المنتج والسعر اللي تم اسلامهم
  // اللي تم انشاه واللي متخزن فيه البيانات يتاعت كل منتج class Item عند الضغط علي اي منتج وهيجيب البيانات دي منHomePage تم استلامها من صفحه
  final Item product;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // const Details({Key? key}) : super(key: key);

  bool isShowMore = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [
              AppBarWidget(),
            ],
            backgroundColor: appbarGreen,
            title: const Text("Details screen"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // هيعرض صوره المنتج
                Image.asset(widget.product.imgPath),
                const SizedBox(
                  height: 11,
                ),
                // هيعرض سعر المنتج
                Text(
                  "\$ ${widget.product.price}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 129, 129),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    // هيظهر نجوم علي اساس ان هيا تقيم المنتج وهكذا
                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 26,
                          color: Color.fromARGB(255, 255, 191, 0),
                        ),
                        Icon(
                          Icons.star,
                          size: 26,
                          color: Color.fromARGB(255, 255, 191, 0),
                        ),
                        Icon(
                          Icons.star,
                          size: 26,
                          color: Color.fromARGB(255, 255, 191, 0),
                        ),
                        Icon(
                          Icons.star,
                          size: 26,
                          color: Color.fromARGB(255, 255, 191, 0),
                        ),
                        Icon(
                          Icons.star,
                          size: 26,
                          color: Color.fromARGB(255, 255, 191, 0),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.edit_location,
                          size: 26,
                          color: Color.fromARGB(168, 3, 65, 27),
                          // color: Color.fromARGB(255, 186, 30, 30),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.product.location,
                          style: const TextStyle(fontSize: 19),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Details : ",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // هيعرض الوصف بتع كل منتج
                Text(
                  widget.product.productDetails,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: isShowMore ? 3 : null,
                  overflow: TextOverflow.fade,
                ),
                // maxLines هو مش هيظهر غير 3 اللي تم تحديدهم في Text لما اضغط عليه هيظهر باقي ال
                TextButton(
                    onPressed: () {
                      setState(() {
                        isShowMore = !isShowMore;
                      });
                    },
                    child: Text(
                      isShowMore ? "Show more" : "Show less",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
