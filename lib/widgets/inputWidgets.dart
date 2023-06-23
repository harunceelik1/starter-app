import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/model/color.dart';
import 'package:starter/model/padding.dart';
import '../bloc/settings/settings_cubit.dart';

class InputWidget extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool obscureText;
  final bool showImage;
  final TextEditingController textEdit;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const InputWidget({
    Key? key,
    required this.text,
    required this.icon,
    this.obscureText = false,
    required this.showImage,
    required this.textEdit,
    this.onChanged,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _gorunurluk = false;
  late SettingsCubit settings;
  bool mode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MyPadding.inputLeftRightBottom,
      padding: MyPadding.inputLeftRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: TextField(
        inputFormatters: widget.inputFormatters,
        controller: widget.textEdit,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText && !_gorunurluk,
        decoration: InputDecoration(
          fillColor: appColors.transparent,
          hoverColor: appColors.transparent,
          icon: Icon(
            widget.icon,
          ),
          hintText: widget.text,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: appColors.purple,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: appColors.grey,
            ),
          ),
          suffixIcon: widget.obscureText
              ? _gorunurluk
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _gorunurluk = false;
                        });
                      },
                      child: Icon(
                        Iconsax.eye,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _gorunurluk = true;
                        });
                      },
                      child: Icon(
                        Iconsax.eye_slash,
                      ),
                    )
              : null,
        ),
      ),
    );
  }
}
