import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc_2/repository/store_repository.dart';
import 'package:learn_bloc_2/store.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(const StoreState()) {
    on<StoreProductsRequested>(_handleStoreProductsRequested);
    on<StoreProductsAddedToCart>(_handleStoreProductsAddedToCart);
    on<StoreProductsRemovedFromCart>(_handleStoreProductsRemoveFromCart);
  }

  final StoreRepository api = StoreRepository();

  Future<void> _handleStoreProductsRequested(
    StoreProductsRequested event,
    Emitter<StoreState> emit,
  ) async {
    try {
      emit(state.copyWith(
        productStatus: StoreRequest.requestInProgress,
      ));

      final response = await api.getProducts();

      emit(state.copyWith(
        productStatus: StoreRequest.requestSuccess,
        products: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        productStatus: StoreRequest.requestFailed,
      ));
    }
  }

  Future<void> _handleStoreProductsAddedToCart(
    StoreProductsAddedToCart event,
    Emitter<StoreState> emit,
  ) async {
    emit(state.copyWith(cartIds: {...state.cartIds, event.cartId}));
  }
  Future<void> _handleStoreProductsRemoveFromCart(
    StoreProductsRemovedFromCart event,
    Emitter<StoreState> emit,
  ) async {
    emit(state.copyWith(cartIds:{...state.cartIds}..remove(event.cartId)));
  }
}
