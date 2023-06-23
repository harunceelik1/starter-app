import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/model/color.dart';
import 'package:starter/model/padding.dart';

import '../../api/api.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../widgets/inputWidgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final SettingsCubit settings;
  int currentImageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  TextEditingController passwdController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  UserApi userApi = UserApi();
  // NewsApi newsApi = NewsApi();

  List<String> imagePaths = [
    "assets/images/woman.png",
    "assets/images/girl.png",
    "assets/images/boy.png",
    "assets/images/man.png",
  ];
  List<String> warnings = [];
  List<String> data = [];
  bool loading = false;
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

  login() async {
    if (mounted)
      setState(() {
        loading = true;
      });

    List<String> msgs = [];
    if (emailController.text.trim().isEmpty ||
        passwdController.text.trim().isEmpty) {
      msgs.add("fill_Box");
    }

    if (msgs.isEmpty) {
      final api = UserApi();
      final result = await api.loginRequest(
        email: emailController.text,
        password: passwdController.text,
      );
      if (result == null) {
        msgs.add('invalid_credentials');

        showWarnings();
      } else {
        // login successfull
        // userApi.me(token: result["token"]);
        List<String> data = [
          result["name"].toString(),
          result["email"].toString(),
          result["phone"].toString(),
          result["address"].toString(),
          result["token"].toString(),
        ];
        settings.userLogin(
            data); // userLogin çağrısında data'yı userInfo olarak kullan
        GoRouter.of(context).go('/news');
      }
    } else {
      msgs.add("wrong");

      showWarnings();
    }
    if (mounted)
      setState(() {
        warnings = msgs;
        loading = false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    settings = context.read<SettingsCubit>();
    // newsApi.getNews();
    // print(userApi.me(token: token));

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn);
    //fastLinearToSlowEaseIn,easeOutCirc

    // İlk resmi gösterme ve ardından animasyonu başlatma
    currentImageIndex = 0; // İlk resim index'i
    _animationController.forward();

    startImageAnimation();
  }

  void startImageAnimation() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        //if (mounted) ifadesi, Flutter widget'ının mevcut durumunu kontrol etmek için kullanılır.
        //if (mounted) ifadesi, widget'ın mevcut durumda olduğunu kontrol ederek, setState() çağrısını yapmadan önce güvenlik sağlar. Eğer setState() çağrısı mevcut olmayan bir widget için yapılırsa, hata oluşur. Bu durumu kontrol etmek için if (mounted) kullanılır ve sadece widget mevcut durumda ise setState() çağrısı yapılır.
        setState(() {
          currentImageIndex = (currentImageIndex + 1) % imagePaths.length;
        });
        if (_animationController != null) {
          _animationController.reset();
          _animationController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      appColors.gradientColor,
                      appColors.gradientColor2,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: appColors.white, width: 5),
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                appColors.circleGradient,
                                appColors.circleGradient1,
                              ],
                            )),
                        child: CircleAvatar(
                          radius: 92,
                          backgroundColor: appColors.transparent,
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.scale(
                                scale: _animation.value,
                                child:
                                    Image.asset(imagePaths[currentImageIndex]),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).getTranslate("login"),
                        style: GoogleFonts.bebasNeue(
                            fontSize: 24, color: appColors.white),
                      ),

                      // ignore: prefer_const_constructors
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              // ignore: prefer_const_constructors
              InputWidget(
                icon: Icons.email,
                text: AppLocalizations.of(context).getTranslate("enter_email"),
                obscureText: false,
                showImage: false,
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: emailController,
              ),
              // ignore: prefer_const_constructors
              InputWidget(
                icon: Icons.vpn_key,
                text: AppLocalizations.of(context).getTranslate("password"),
                obscureText: true,
                showImage: true,
                onChanged: (value) {
                  setState(() {});
                },
                textEdit: passwdController,
              ),
              // Container(
              //   margin: EdgeInsets.only(right: 20, top: 20),
              //   alignment: Alignment.centerRight,
              //   child: InkWell(
              //       onTap: () {
              //         // Navigator.of(context).pushNamed("/changePass");
              //         // GoRouter.of(context).pushNamed('changePass');
              //       },
              //       child: Text("Forget Password ? ")),
              // ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: MyPadding.horizontal20,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    login();

                    // userApi.loginRequest(context, emailController.text,
                    //     passwdController.text, warnings);
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
                          appColors.gradientColor2,
                        ],
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).getTranslate("login"),
                      style: GoogleFonts.bebasNeue(
                          fontSize: 20, color: appColors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).getTranslate("need_account"),
                    ),
                    GestureDetector(
                      onTap: (() {
                        // Navigator.of(context)
                        //     .pushReplacementNamed('/registerScreen');
                        // Navigator.of(context).pushNamed("/registerScreen");
                        // GoRouter.of(context).push("/registerScreen");
                        GoRouter.of(context).push('/register');
                      }),
                      child: Text(
                        AppLocalizations.of(context)
                            .getTranslate("register_now"),
                        style: TextStyle(color: appColors.registerColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
