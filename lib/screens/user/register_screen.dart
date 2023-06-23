import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starter/model/padding.dart';

import '../../api/api.dart';
import '../../localizations/localizations.dart';
import '../../widgets/inputWidgets.dart';
import '../../widgets/snack.dart';
import 'package:starter/model/color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController passwdController = TextEditingController();
  TextEditingController passwdController2 = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool loading = false;
  List<String> msgs = [];
  List<String> warnings = [];

  showWarnings() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).getTranslate('warning')),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).getTranslate('close')),
          ),
        ],
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: warnings
                .map((e) => Container(
                    width: double.infinity,
                    padding: MyPadding.showPadding,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocalizations.of(context).getTranslate(e),
                      textAlign: TextAlign.start,
                    )))
                .toList()),
      ),
    );
  }

  register() async {
    setState(() {
      loading = true;
    });

    List<String> msgs = [];
    if (emailController.text.trim().isEmpty) {
      msgs.add("mail_required");
    }
    if (passwdController.text.trim().length < 6 ||
        passwdController2.text.trim().length < 6) {
      msgs.add("passwd_length");
    }

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);

    if (!emailValid) {
      msgs.add("email_format");
    }

    if (nameController.text.trim().isEmpty) {
      msgs.add("name_required");
    }

    if (phoneController.text.trim().isEmpty) {
      msgs.add("phone_required");
    }

    if (msgs.isEmpty) {
      // everything is ok
      // i can login

      final api = UserApi();
      final result = await api.registerRequest(
        email: emailController.text.trim(),
        phone: phoneController.text.toString().trim(),
        name: nameController.text.trim(),
        password: passwdController.text.trim(),
        confirmPassword: passwdController2.text.trim(),
      );
      if (result == null) {
        setState(() {
          msgs.add("register_failed");
        });
      } else {
        // register successfull
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: snackDesign(
              text1: AppLocalizations.of(context)
                  .getTranslate("succesful_register"),
              colorSnack: appColors.snackGreen,
              image: Image.asset("assets/images/ok.png"),
              image2: Image.asset("assets/images/blur.png"),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }
    }
    if (msgs.isNotEmpty) {
      showWarnings();
    }
    setState(() {
      warnings = msgs;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Icon(
                Iconsax.document_upload4,
                size: 80,
              ),
              SizedBox(
                height: 15,
              ),
              Text(AppLocalizations.of(context).getTranslate("register"),
                  style: GoogleFonts.bebasNeue(fontSize: 36)),
              SizedBox(
                height: 10,
              ),
              Text(AppLocalizations.of(context).getTranslate("fill_Box"),
                  style: GoogleFonts.bebasNeue(fontSize: 18)),
              SizedBox(
                height: 30,
              ),
              InputWidget(
                icon: Iconsax.user,
                text: AppLocalizations.of(context).getTranslate("name"),
                obscureText: false,
                showImage: false,
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: nameController,
              ),
              InputWidget(
                icon: Iconsax.sms,
                text: AppLocalizations.of(context).getTranslate("enter_email"),
                obscureText: false,
                showImage: false,
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: emailController,
              ),
              InputWidget(
                icon: Iconsax.call_add,
                text: AppLocalizations.of(context).getTranslate("phone"),
                obscureText: false,
                showImage: false,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: phoneController,
              ),

              // ignore: prefer_const_constructors
              InputWidget(
                icon: Iconsax.key,
                text: AppLocalizations.of(context).getTranslate("password"),
                obscureText: true,
                showImage: true,
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: passwdController,
              ),
              InputWidget(
                icon: Iconsax.key,
                text: AppLocalizations.of(context)
                    .getTranslate("confirm_password"),
                obscureText: true,
                showImage: true,
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: passwdController2,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: MyPadding.horizontal20,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    register();

                    // Navigator.of(context).pushReplacementNamed("/homeScreen");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          appColors.gradientColor,
                          appColors.gradientColor2
                        ],
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).getTranslate("register"),
                      style: GoogleFonts.bebasNeue(
                          fontSize: 18, color: appColors.white),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
