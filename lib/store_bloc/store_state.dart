import '../model/product_model.dart';

enum StoreRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailed,
}

class StoreState {
 const StoreState({
   this.products = const[],
   this.productStatus = StoreRequest.unknown,
   this.cartIds=const{},
 });

  final List<ProductModel> products;
  final StoreRequest productStatus;
  final Set<int> cartIds;

 StoreState copyWith({
    List<ProductModel>? products,
    StoreRequest? productStatus,
    Set<int>? cartIds,
  }) {
    return StoreState(
      products: products ?? this.products,
      productStatus: productStatus ?? this.productStatus,
      cartIds: cartIds ?? this.cartIds,
    );
  }
}
