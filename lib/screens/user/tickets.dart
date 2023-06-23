import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../api/api.dart';
import '../../bloc/settings/settings_cubit.dart';
import 'package:starter/model/color.dart';

import '../../localizations/localizations.dart';
import '../../model/padding.dart';
import '../../widgets/snack.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  late final SettingsCubit settings;
  bool loading = false;
  UserApi userApi = UserApi();
  List<dynamic> ticketList = [];
  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    setState(() {
      loading = true;
    });

    final token = settings.state.userInfo[4];
    final result = await userApi.getTicketsList(token: token);

    if (result != null) {
      setState(() {
        ticketList = result;
      });
    }

    setState(() {
      loading = false;
    });
  }

  warning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackDesign(
          text1: AppLocalizations.of(context).getTranslate('status_control'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).getTranslate('support_req_list'),
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
                    GoRouter.of(context).go('/profile');
                  },
                  child: Icon(
                    Iconsax.user,
                  ),
                ),
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            Center(child: CircularProgressIndicator())
          else if (ticketList.isEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context).getTranslate("ticket_not_found"),
                style: GoogleFonts.bebasNeue(fontSize: 24),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: ticketList.length,
                itemBuilder: (context, index) {
                  var ticket = ticketList[index];
                  String ticketTitle = ticket['title'].toString();
                  String ticketStatus = ticket['status'].toString();
                  String ticketId = ticket['id'].toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1,
                            color: settings.state.darkMode
                                ? appColors.snackRed
                                : appColors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.grey[200],
                      title: Text(
                        AppLocalizations.of(context).getTranslate("title") +
                            "$ticketTitle",
                        style: TextStyle(
                            color: settings.state.darkMode
                                ? appColors.black
                                : appColors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                    .getTranslate("status") +
                                " $ticketStatus ",
                            style: TextStyle(
                                color: settings.state.darkMode
                                    ? appColors.black
                                    : appColors.black),
                          ),
                          Text(
                            AppLocalizations.of(context).getTranslate(
                                  "date",
                                ) +
                                _formatDateTime(ticket['updated_at']),
                            style: TextStyle(
                                color: settings.state.darkMode
                                    ? appColors.black
                                    : appColors.black),
                          )
                        ],
                      ),
                      trailing: Icon(
                        Iconsax.arrow_right_34,
                        color: settings.state.darkMode
                            ? appColors.black
                            : appColors.black,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: appColors.transparent,
                        child: Image.asset("assets/images/help-desk.png"),
                      ),
                      onTap: () {
                        print("tıklandı");

                        if (ticketStatus == "user_closed") {
                          warning();
                        } else {
                          GoRouter.of(context)
                              .pushReplacement('/ticket_id/$ticketId');
                        }
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}
