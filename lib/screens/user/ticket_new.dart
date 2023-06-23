import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../api/api.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../model/padding.dart';
import '../../widgets/inputWidgets.dart';
import 'package:starter/model/color.dart';

import '../../widgets/snack.dart';

class TicketNew extends StatefulWidget {
  const TicketNew({super.key});

  @override
  State<TicketNew> createState() => _TicketNewState();
}

class _TicketNewState extends State<TicketNew> {
  late final SettingsCubit settings;
  UserApi userApi = UserApi();

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  bool loading = false;
  List<String> msgs = [];
  List<String> warnings = [];
  final basliklar = ["Muhasebe", "Öğrenci İşleri", "Rektör"];
  String? _selectedValue; // Başlangıçta null değerini atayın

  warning() {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: snackDesign(
            text1: AppLocalizations.of(context).getTranslate('message_control'),
            colorSnack: appColors.snackRed,
            image: Image.asset("assets/images/warning1.png"),
            image2: Image.asset("assets/images/oops.png"),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  succesfulTicket() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackDesign(
          text1: AppLocalizations.of(context).getTranslate("succesful_message"),
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

  ticketRequest() async {
    setState(() {
      loading = true;
    });

    List<String> msgs = [];
    if (titleController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      msgs.add("message_control");
    }

    if (msgs.isEmpty) {
      // everything is ok
      // i can login
      final api = UserApi();
      final result = await api.ticketRequest(
        title: titleController.text.toString().trim(),
        message: messageController.text.toString().trim(),
        topic: _selectedValue.toString(),
        token: settings.state.userInfo[4].toString(),
      );
      if (result == null) {
        print("sa");
      } else {
        // register successfull
        succesfulTicket();
        // userApi.getTicketsList(token: settings.state.userInfo[4]);

        GoRouter.of(context).go('/tickets');
      }
    }
    if (msgs.isNotEmpty) {
      warning();
    }
    setState(() {
      warnings = msgs;
      loading = false;
    });
  }

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).getTranslate("support_request"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)
                      .getTranslate("create_support_req"),
                  style: GoogleFonts.bebasNeue(fontSize: 36),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: MyPadding.inputLeftRightBottom,
                  padding: MyPadding.inputLeftRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(10),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusColor: appColors.transparent,
                      hoverColor: appColors.transparent,
                      fillColor: appColors.transparent,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: appColors.purple,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: settings.state.darkMode
                              ? appColors.white
                              : appColors.black,
                        ),
                      ),
                    ),
                    value: _selectedValue,
                    icon: Icon(
                      Iconsax.arrow_circle_down,
                      color: settings.state.darkMode
                          ? appColors.white
                          : appColors.black,
                    ),
                    hint: Text(
                        AppLocalizations.of(context).getTranslate("subject")),
                    items: basliklar.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value as String;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: MyPadding.inputLeftRightBottom,
                  padding: MyPadding.inputLeftRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      fillColor: appColors.transparent,
                      labelText: AppLocalizations.of(context)
                          .getTranslate("topic_title"),
                      suffixIcon: Icon(Icons.support_agent),
                      hoverColor: appColors.transparent,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: appColors.purple,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: settings.state.darkMode
                              ? appColors.white
                              : appColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: MyPadding.inputLeftRightBottom,
                  padding: MyPadding.inputLeftRight,
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                          .getTranslate("complaint"),
                      fillColor: appColors.transparent,
                      hoverColor: appColors.transparent,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: appColors.purple,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: settings.state.darkMode
                              ? appColors.white
                              : appColors.black,
                        ),
                      ),
                    ),
                    maxLines: 10, // allow user to enter 5 line in textfield
                    keyboardType: TextInputType
                        .multiline, // user keyboard will have a button to move cursor to next line
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                    padding: MyPadding.horizontal20,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          ticketRequest();
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
                            AppLocalizations.of(context).getTranslate("send"),
                            style: GoogleFonts.bebasNeue(
                                fontSize: 20, color: appColors.white),
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
