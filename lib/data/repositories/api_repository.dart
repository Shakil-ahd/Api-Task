import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/customer_model.dart';
import '../../utils/app_constants.dart';

class ApiRepository {
  Future<UserModel> login(
    String username,
    String password,
  ) async {
    final urlString =
        "${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}?UserName=$username&Password=$password&ComId=${ApiConstants.defaultComId}";
    final uri = Uri.parse(urlString);

    try {
      log("Attempting Login: $uri");

      final res = await http.get(
        uri,
        headers: {"Accept": "application/json"},
      );

      log("Login Status: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final user = UserModel.fromJson(data);

        if (user.token != null) {
          final prefs =
              await SharedPreferences.getInstance();
          await prefs.setString(
            PrefKeys.token,
            user.token!,
          );
          return user;
        } else {
          throw Exception("Token missing in response");
        }
      } else {
        throw Exception("Login failed: ${res.statusCode}");
      }
    } catch (e) {
      log("Login Error: $e");
      rethrow;
    }
  }

  Future<List<CustomerModel>> getCustomers({
    required int pageNo,
    required int pageSize,
    String searchQuery = '',
    String sortBy = 'Balance',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrefKeys.token);

    if (token == null)
      throw Exception("Unauthorized: No token found");

    final urlString =
        "${ApiConstants.baseUrl}${ApiConstants.customerListEndpoint}?searchquery=$searchQuery&pageNo=$pageNo&pageSize=$pageSize&SortyBy=$sortBy";
    final uri = Uri.parse(urlString);

    try {
      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
        },
      );

      if (res.statusCode == 200) {
        if (res.body.trim().isEmpty) return [];

        final data = jsonDecode(res.body);

        final list =
            (data['CustomerList'] ?? []) as List<dynamic>;

        return list
            .map((e) => CustomerModel.fromJson(e))
            .toList();
      } else if (res.statusCode == 401) {
        throw Exception("Unauthorized");
      } else {
        throw Exception(
          "Failed to fetch customers: ${res.statusCode}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
