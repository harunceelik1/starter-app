// me({required String token}) async {
//     try {
//       String apiEndpoint = "$baseUrl/me";

//       final Dio dio = Dio();
//       dio.options.headers["authorization"] = "Bearer $token";

//       var response = await dio.get(apiEndpoint);
//       if (response.statusCode == 200) {
//         if (response.data["success"]) {
//           var res = response.data;
//           return res;
//         } else {
//           return null;
//         }
//       } else if (response.statusCode == 404) {
//         // wrong user password
//         return response.data;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }