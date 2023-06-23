import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bloc/settings/settings_cubit.dart';

class UserApi {
  Future<dynamic> loginRequest({
    required String email,
    required String password,
  }) async {
    var requestData = {
      'email': email,
      'password': password,
    };
    List<String> userList = [];

    try {
      var response = await Dio()
          .post('https://api.qline.app/api/login', data: requestData);

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          // print(res);
          return res;
        } else {
          var error = response.data["msg"];
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
      print(e);
    }
  }

  Future<dynamic> registerRequest(
      {required String email,
      required String password,
      required String name,
      required String phone,
      required String confirmPassword}) async {
    var requestData = {
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'confirm_password': confirmPassword,
    };

    try {
      var response = await Dio()
          .post('https://api.qline.app/api/register', data: requestData);

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          return res;
        } else {
          var error = response.data["msg"];
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
      print(e);
    }
  }

  Future<dynamic> ticketRequest({
    required String title,
    required String message,
    required String topic,
    required String token,
  }) async {
    var requestData = {
      'title': title,
      'message': message,
      'topic': topic,
      'token': token
    };

    try {
      final Dio dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      var response = await dio.post(
        'https://api.qline.app/api/tickets',
        data: requestData,
      );

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          print(res);

          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> closeTicket({
    required String id,
    required String token,
  }) async {
    var requestData = {'id': id, 'token': token};

    try {
      final Dio dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      var response = await dio.post(
        'https://api.qline.app/api/tickets/close',
        data: requestData,
      );

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          print(res);

          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> postMessage(
      {required String message,
      required String id,
      required String token}) async {
    var requestData = {
      'method': "PUT",
      'message': message,
      'id': id,
      'token': token
    };

    try {
      final Dio dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      var response = await dio.post(
        'https://api.qline.app/api/tickets/respond',
        data: requestData,
      );

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          print(res);

          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>?> getTicketsList({required String token}) async {
    try {
      final Dio dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      var response = await dio.get('https://api.qline.app/api/tickets');

      if (response.statusCode == 200) {
        if (response.data is List<dynamic>) {
          response.data.sort((a, b) {
            DateTime dateA = DateTime.parse(a['updated_at']);
            DateTime dateB = DateTime.parse(b['updated_at']);
            return dateB.compareTo(dateA);
          });
          return response.data as List<dynamic>;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<dynamic> getId({required String token, required String id}) async {
    try {
      String apiEndpoint = "https://api.qline.app/api/tickets/messages?id=$id";

      final Dio dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      var response = await dio.get(apiEndpoint);
      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          print(res);

          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  me({required String token}) async {
    try {
      String apiEndpoint = "https://api.qline.app/api/me";

      final Dio dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      var response = await dio.get(apiEndpoint);
      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          print(res);

          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
