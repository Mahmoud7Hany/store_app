import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widget/app_bar.dart';
import '../model/item.dart';
import '../provider/cart.dart';
import '../shared/colors.dart';
import '../widget/drawer_widget.dart';
import 'details_page.dart';

// دي الصفحه الرائسيه اللي هتكون فيها المنتجات
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          actions: const [
            AppBarWidget(),
          ],
          backgroundColor: appbarGreen,
          title: const Text("Home"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 22),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 33),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailsPage(product: items[index]),
                        ));
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: const Color.fromARGB(66, 73, 127, 110),
                      trailing: IconButton(
                          color: const Color.fromARGB(255, 62, 94, 70),
                          onPressed: () {
                            cart.add(items[index]);
                          },
                          icon: const Icon(Icons.add)),
                      // '${cart.selectedProducts.length}',
                      leading: Text("\$ ${items[index].price}"),
                      title: const Text(
                        "",
                      ),
                    ),
                    child: Stack(children: [
                      Positioned(
                        top: -3,
                        bottom: -9,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: Image.asset(items[index].imgPath)),
                      ),
                    ]),
                  ),
                );
              }),
        ));
  }
}
