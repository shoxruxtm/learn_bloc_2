import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc_2/store.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  void _addToCard(int cartId) {
    context.read<StoreBloc>().add(StoreProductsAddedToCart(cartId));
  }

  void _removeFromCard(int cartId) {
    context.read<StoreBloc>().add(StoreProductsRemovedFromCart(cartId));
  }

  void _viewCarts() {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: BlocProvider.value(
                value: context.read<StoreBloc>(),
                child: child,
              ),
            );
          },
          pageBuilder: (_, __, ___) => const CartScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state.productStatus == StoreRequest.requestInProgress) {
              return const CircularProgressIndicator();
            }
            if (state.productStatus == StoreRequest.requestFailed) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Problem loading products"),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequested());
                    },
                    child: const Text("Try again"),
                  ),
                ],
              );
            }
            if (state.productStatus == StoreRequest.unknown) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shop_outlined,
                    size: 60,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 10),
                  const Text("No products to view"),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequested());
                    },
                    child: const Text("Load products"),
                  ),
                ],
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final inCart = state.cartIds.contains(product.id);
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
                          onPressed: inCart
                              ? () => _removeFromCard(product.id)
                              : () => _addToCard(product.id),
                          style: ButtonStyle(
                            backgroundColor: inCart
                                ? MaterialStateProperty.all(Colors.black12)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: inCart
                                ? const [
                                    Icon(
                                      Icons.remove_shopping_cart,
                                      color: Colors.black45,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Remove from cart",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ]
                                : const [
                                    Icon(Icons.add_shopping_cart),
                                    SizedBox(width: 10),
                                    Text("Add to cart"),
                                  ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            shape: CircleBorder(),
            clipBehavior: Clip.none,
            onPressed: _viewCarts,
            tooltip: "view cart",
            child: const Icon(Icons.shopping_cart),
          ),
          BlocBuilder<StoreBloc, StoreState>(
            builder: (context, state) {
              if (state.cartIds.isEmpty) {
                return Container();
              }
              return Positioned(
                right: -3,
                bottom: 35,
                child: CircleAvatar(
                  backgroundColor: Colors.tealAccent,
                  radius: 12,
                  child: Text(state.cartIds.length.toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
