import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/localizations/localizations.dart';
import 'package:starter/model/color.dart';
import 'package:starter/model/padding.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../widgets/common_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final SettingsCubit settings;

  // NewsApi api = NewsApi();
  askLogout() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).getTranslate("logout")),
        content:
            Text(AppLocalizations.of(context).getTranslate("logout_confirm")),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(AppLocalizations.of(context).getTranslate("yes")),
            onPressed: () {
              settings.userLogout();
              Navigator.of(context).pop();
              GoRouter.of(context).replace('/login');
            },
          ),
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context).getTranslate("no")),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
    print(settings.state.userInfo);

    Future.delayed(Duration.zero).then((value) => {
          if (settings.state.userLoggedIn)
            {}
          else
            {
              GoRouter.of(context).replace('/profile'),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).getTranslate('profile_screen'),
          ),
          actions: [
            Padding(
              padding: MyPadding.horizontal8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).push('/settings');
                    },
                    child: Icon(
                      Iconsax.setting_24,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go('/news');
                    },
                    child: Icon(Icons.newspaper_outlined),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      askLogout();
                    },
                    child: Icon(
                      Iconsax.logout_14,
                    ),
                  ),
                ],
              ),
            ),
          ],
          elevation: 0,
        ),
        body: content(),
      ),
    );
  }

  Widget content() {
    var mediaHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: MyPadding.horizontal20,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                width: double.infinity,
                child: Image.asset("assets/images/personel.png")),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  summaryDisplay(
                    AppLocalizations.of(context).getTranslate('name'),
                    settings.state.userInfo[0],
                    Icon(
                      Iconsax.user,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  summaryDisplay(
                    AppLocalizations.of(context).getTranslate('enter_email'),
                    settings.state.userInfo[1],
                    Icon(
                      Iconsax.document,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  summaryDisplay(
                    AppLocalizations.of(context).getTranslate('phone'),
                    settings.state.userInfo[2],
                    Icon(
                      Iconsax.call,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  summaryDisplay(
                    AppLocalizations.of(context).getTranslate('adress'),
                    settings.state.userInfo[3],
                    Icon(
                      Iconsax.location,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).go('/tickets');
                        },
                        child: CircleAvatar(
                          backgroundColor: appColors.transparent,
                          radius: 20,
                          child: Image.asset(
                            "assets/images/help.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).push('/ticket_new');
                        },
                        child: CircleAvatar(
                          backgroundColor: appColors.transparent,
                          radius: 20,
                          child: Image.asset(
                            "assets/images/call-center.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
