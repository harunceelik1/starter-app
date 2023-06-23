import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/api/api.dart';
import 'package:intl/intl.dart';
import 'package:starter/model/color.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../model/padding.dart';

class TicketId extends StatefulWidget {
  TicketId({super.key, required this.id});
  final String id;

  @override
  State<TicketId> createState() => _TicketIdState();
}

class _TicketIdState extends State<TicketId> {
  TextEditingController titleController = TextEditingController();

  late final SettingsCubit settings;
  bool loading = false;
  UserApi userApi = UserApi();
  Map<String, dynamic> ticket = {};
  List<dynamic> messageList = [];
  askLogout() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).getTranslate("status_close")),
        content: Text(
            AppLocalizations.of(context).getTranslate("status_close_confirm")),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(AppLocalizations.of(context).getTranslate("yes")),
            onPressed: () {
              Navigator.of(context).pop();
              closeTicket();
              GoRouter.of(context).go('/tickets');
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
    loadTicketDetails();
  }

  Future<void> loadTicketDetails() async {
    final token = settings.state.userInfo[4];
    dynamic result = await userApi.getId(token: token, id: widget.id);
    if (result != null && result.isNotEmpty) {
      setState(() {
        ticket = result['ticket'];
        messageList = jsonDecode(ticket['messages']) ?? [];
      });
    }
  }

  Future<void> closeTicket() async {
    final token = settings.state.userInfo[4];
    dynamic result = await userApi.closeTicket(token: token, id: widget.id);
    if (result != null && result['ticket'] != null) {
      ticket = result['ticket'];
      messageList = jsonDecode(ticket['messages']) ?? [];
      ticket['status'] = 'user_closed'; // Status durumunu güncelle
    }
  }

  Future<void> ticketRequest() async {
    List<String> msgs = [];
    if (titleController.text.trim().isEmpty) {
      msgs.add("message_control");
    }

    if (msgs.isEmpty) {
      // API'ye metni gönder
      final api = UserApi();
      final result = await api.postMessage(
        message: titleController.text.toString().trim(),
        token: settings.state.userInfo[4].toString(),
        id: widget.id,
      );
    }
    loadTicketDetails();
  }

  @override
  Widget build(BuildContext context) {
    String ticketTitle = ticket['title'].toString();
    String ticketStatus = ticket['status'].toString();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).getTranslate('details_tickets'),
          ),
          actions: [
            Padding(
              padding: MyPadding.horizontal8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
          children: [
            if (ticket.isEmpty)
              Text(
                AppLocalizations.of(context).getTranslate("ticket_not_found"),
              )
            else
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.grey[200],
                    title: Text(
                      AppLocalizations.of(context).getTranslate("title") +
                          "$ticketTitle",
                      style: TextStyle(color: appColors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).getTranslate("status") +
                              " $ticketStatus ",
                          style: TextStyle(color: appColors.black),
                        ),
                        Text(
                          AppLocalizations.of(context).getTranslate("date") +
                              _formatDateTime(ticket['updated_at']),
                          style: TextStyle(color: appColors.black),
                        )
                      ],
                    ),
                    trailing: Icon(
                      Iconsax.message,
                      color: appColors.black,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: appColors.transparent,
                      child: Image.asset("assets/images/help-desk.png"),
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  var message = messageList[index];
                  bool isUser = message['user'];
                  String messageText = message['message'].toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(messageText),
                      tileColor: isUser ? Colors.green : Colors.red,
                      subtitle: Text(
                        _formatDateTime(ticket['updated_at']),
                      ),
                      trailing: Icon(Iconsax.message),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: MyPadding.inputLeftRightBottom,
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        fillColor: appColors.transparent,
                        labelText: AppLocalizations.of(context)
                            .getTranslate("your_message"),
                        suffixIcon: InkWell(
                            onTap: () {
                              ticketRequest();
                            },
                            child: Icon(Icons.arrow_right)),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: InkWell(
                    onTap: () {
                      askLogout();
                    },
                    child: Icon(
                      Iconsax.close_circle,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}
