abstract class StoreEvent {
  const StoreEvent();
}

class StoreProductsRequested extends StoreEvent{}

class StoreProductsAddedToCart extends StoreEvent {
  final int cartId;

  const StoreProductsAddedToCart(this.cartId);
}

class StoreProductsRemovedFromCart extends StoreEvent {
  final int cartId;

  const StoreProductsRemovedFromCart(this.cartId);
}
