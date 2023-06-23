import 'package:flutter/material.dart';
import 'package:starter/model/color.dart';

class BreakingNewsCard extends StatefulWidget {
  BreakingNewsCard(this.news, {Key? key}) : super(key: key);
  Map<String, dynamic> news;

  @override
  State<BreakingNewsCard> createState() => _BreakingNewsCardState();
}

class _BreakingNewsCardState extends State<BreakingNewsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: widget.news["urlToImage"] != null
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.news["urlToImage"].toString()),
                    )),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: [appColors.transparent, appColors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.news["title"],
                        maxLines: 3,
                        style: TextStyle(
                          color: appColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        widget.news["author"].toString(),
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
