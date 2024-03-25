import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc_2/store.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasEmptyCart =
        context.select<StoreBloc, bool>((value) => value.state.cartIds.isEmpty);

    final cartProduct = context.select<StoreBloc, List<ProductModel>>(
      (b) => b.state.products
          .where((element) => b.state.cartIds.contains(element.id))
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: hasEmptyCart
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Your cart is empty"),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: ()=>Navigator.pop(context),
                    child: const Text("Add product"),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: cartProduct.length,
              itemBuilder: (context, index) {
                final product = cartProduct[index];
                return Card(
                  key: ValueKey(product.id),
                  child: Column(
                    children: [
                      Flexible(
                        child: Image.network(product.image),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () => context
                              .read<StoreBloc>()
                              .add(StoreProductsRemovedFromCart(product.id)),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black12)),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.remove_shopping_cart,
                                  color: Colors.black45,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Remove from cart",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
