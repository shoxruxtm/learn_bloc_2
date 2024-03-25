import 'package:dio/dio.dart';
import 'package:learn_bloc_2/model/product_model.dart';

class StoreRepository {
  final Dio _client = Dio(
    BaseOptions(baseUrl: 'https://fakestoreapi.com/products'),
  );

  Future<List<ProductModel>> getProducts() async {
    final response = await _client.get('');
    return (response.data as List)
        .map((e) => ProductModel(
              id: e['id'],
              title: e['title'],
              image: e['image'],
            ))
        .toList();
  }
}
