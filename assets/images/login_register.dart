  // signIn(String username, String password) async {
  //   try {
  //     String apiEndpoint = "$baseUrl/login";
  //     // var url = Uri.parse(apiEndpoint);
  //     final Dio dio = Dio();
  //     var formData = FormData.fromMap({
  //       'email': username,
  //       'password': password,
  //     });
  //     var response = await dio.post(
  //       apiEndpoint,
  //       data: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       if (response.data["success"]) {
  //         var res = response.data;
  //         return res;
  //       } else {
  //         error = response.data["msg"];
  //         return null;
  //       }
  //     } else if (response.statusCode == 404) {
  //       // wrong user password
  //       return null;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //     print(e);
  //   }
  // }

  // signUp(
  //     {required String username,
  //     required String password,
  //     required String name}) async {
  //   try {
  //     String apiEndpoint = "$baseUrl/register";

  //     // var url = Uri.parse(apiEndpoint);
  //     final Dio dio = Dio();
  //     var formData = FormData.fromMap({
  //       'email': username, 'password': password, 'name': name,
  //       'confirm_password': password,
  //       // 'file':
  //       //     await MultipartFile.fromFile('./text.txt', filename: 'upload.txt')
  //     });
  //     var response = await dio.post(
  //       apiEndpoint,
  //       data: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       if (response.data["success"]) {
  //         var res = response.data;
  //         return res;
  //       } else {
  //         error = response.data["msg"];
  //         return null;
  //       }
  //     } else if (response.statusCode == 404) {
  //       // wrong user password
  //       return null;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //     print(e);
  //   }
  // }
  // }