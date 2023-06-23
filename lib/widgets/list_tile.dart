import 'dart:ffi';

import 'package:flutter/material.dart';

class NewsListTile extends StatefulWidget {
  NewsListTile(this.news, {Key? key}) : super(key: key);
  Map<String, dynamic> news;

  @override
  State<NewsListTile> createState() => _NewsListTileState();
}

class _NewsListTileState extends State<NewsListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.all(12.0),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.news["urlToImage"].toString()),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
                flex: 5,
                child: Column(
                  children: [
                    Text(
                      widget.news["title"],
                      maxLines: 3,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(widget.news["description"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white54,
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
