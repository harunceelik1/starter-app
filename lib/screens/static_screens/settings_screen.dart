import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/model/color.dart';
import 'package:starter/model/padding.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsCubit settings;

  @override
  dynamic _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
            AppLocalizations.of(context).getTranslate('language_selection')),
        message: Text(
            AppLocalizations.of(context).getTranslate('language_selection2')),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              settings.changeLanguage("tr");
              Navigator.pop(context);
            },
            child: const Text('Turkce'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              settings.changeLanguage("en");
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).getTranslate('cancel')),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    settings = context.read<SettingsCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).getTranslate('settings'),
          ),
        ),
        body: Padding(
          padding: MyPadding.vertical10,
          child: Column(
            children: [
              Padding(
                padding: MyPadding.horizontal20,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      child: Icon(Iconsax.user),
                    ),
                    Padding(
                      padding: MyPadding.all8,
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context)
                              .getTranslate('welcome')),
                          Text(
                            settings.state.userInfo[0],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              settingTile(
                function: _showActionSheet,
                colors: settings.state.darkMode
                    ? appColors.iconBackgroundDark
                    : appColors.iconBackgroundLight,
                icon: Icon(Iconsax.global),
                text: AppLocalizations.of(context).getTranslate('language'),
                icon1: Icon(Iconsax.arrow_circle_down),
              ),
              SizedBox(
                height: 10,
              ),
              settingTile(
                  colors: settings.state.darkMode
                      ? appColors.iconBackgroundDark
                      : appColors.iconBackgroundLight,
                  function: _showActionSheet,
                  icon: settings.state.darkMode
                      ? Icon(Iconsax.moon)
                      : Icon(Iconsax.sun_15),
                  text: AppLocalizations.of(context).getTranslate('darkMode'),
                  icon1: SwitcherButton(
                    size: 45,
                    value: settings.state.darkMode,
                    onChange: (value) {
                      settings.changeDarkMode(value);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class settingTile extends StatelessWidget {
  String text;
  Icon icon;
  Widget icon1;
  Color colors;
  Function(BuildContext) function;
  settingTile({
    required this.text,
    required this.function,
    required this.icon,
    required this.icon1,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyPadding.horizontal20,
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.circular(15),
            ),
            child: icon,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
          ),
          Spacer(),
          InkWell(
              onTap: () {
                function(context);
              },
              child: icon1),
        ],
      ),
    );
  }
}
