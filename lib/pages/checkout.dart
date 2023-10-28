import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../shared/colors.dart';
import '../widget/app_bar.dart';

// صفحه الدفع
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text('Checkout Screen'),
        actions: const [
          AppBarWidget(),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: 550,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cart.selectedProducts.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(cart.selectedProducts[index].name),
                    subtitle: Text(
                        "${cart.selectedProducts[index].price} - ${cart.selectedProducts[index].location}"),
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(cart.selectedProducts[index].imgPath),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        cart.delete(cart.selectedProducts[index]);
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(BTNpink),
              padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
            ),
            child: Text(
              "Pay \$${cart.price}",
              style: const TextStyle(fontSize: 19),
            ),
          ),
        ],
      ),
    );
  }
}
