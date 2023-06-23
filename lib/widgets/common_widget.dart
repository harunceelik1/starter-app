import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/model/color.dart';
import 'package:starter/model/padding.dart';

Widget summaryDisplay(String title, String subtitle, Widget icon) {
  return ClipRRect(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: appColors.deepPurple),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: MyPadding.all8,
        child: Row(
          children: [
            icon,
            Padding(
              padding: MyPadding.horizontal12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: appColors.grey),
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
