import 'package:dio/dio.dart';
import 'package:e_commerce/constants/api_constants.dart';
import '../models/product.dart';

class ProductService {
  final _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<Product>> fetchAll() async {
    try {
      final res = await _dio.get(ApiConstants.productsEndpoint);
      return (res.data as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      print("error;$e");
    }
    return [];
  }

  Future<List<Product>> fetchByCategory(String category) async {
    try {
      final res = await _dio.get(
          '${ApiConstants.categoriesEndpoint}/$category/${ApiConstants.productsEndpoint}');
      return (res.data as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      print("error;$e");
    }
    return [];
  }


  Future<List<String>> fetchCategories() async {
    try {
      final res = await _dio.get(ApiConstants.categoriesEndpoint);
      return (res.data as List).map((e) => e['id'].toString()).toList();
    } catch (e) {
      print("error: $e");
      return [];
    }
  }
}
