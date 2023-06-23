import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:starter/model/color.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../model/padding.dart';
import '../../widgets/list_tile.dart';
import '../../widgets/news_card.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Map<String, dynamic>> news = [];
  bool loading = false;
  int current_page = 1;
  late final SettingsCubit settings;

  late ScrollController controller;
  loadNewss({int page = 1}) async {
    setState(() {
      loading = true;
    });
    Dio dio = Dio();
    var response = await dio.get(
        'https://newsapi.org/v2/top-headlines?sortBy=publishedAt&category=sports&pageSize=10&language=en&page=$page&apiKey=5502e3169abf4600ae3451b6292c89b2');
    if (response.statusCode == 200) {
      if (page == 1) {
        news = List<Map<String, dynamic>>.from(response.data['articles']);
      } else {
        var newArticles =
            List<Map<String, dynamic>>.from(response.data['articles']);
        news.addAll(newArticles);
      }
      current_page = page;
      loading = false;

      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Hata")));
      setState(() {
        loading = false;
      });
    }
  }

  Widget getNews() {
    if (news != null) {
      return ListView.builder(
        controller: controller,
        itemCount: news.length,
        itemBuilder: (context, index) {
          var haber = news[index];
          var author = haber["author"];
          return InkWell(
            onTap: () {},
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.all(12.0),
              height: 130,
              decoration: BoxDecoration(
                color: appColors.grey,
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
                          image: NetworkImage(haber["urlToImage"].toString()),
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
                            haber["title"],
                            style: TextStyle(
                                color: appColors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(haber["description"],
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
        },
      );
    } else {
      return Text("sa");
    }
  }

  Widget getNews2() {
    if (news != null) {
      return CarouselSlider.builder(
          itemCount: news.length,
          itemBuilder: (context, index, id) => BreakingNewsCard(news[index]),
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
          ));
    } else {
      return Text("sa");
    }
  }

  Widget getNews1() {
    if (news != null) {
      var haberler = news
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: appColors.snackRed,
                      border: Border.all(color: appColors.snackRed),
                      borderRadius: BorderRadius.circular(15)),
                  child: Expanded(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: e["yoast_head_json"]["twitter_image"] != null
                              ? Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 42,
                                      // image: DecorationImage(
                                      //     image: NetworkImage(e["yoast_head_json"]
                                      //         ["twitter_image"]),
                                      //   ),
                                      backgroundImage: NetworkImage(
                                          e["yoast_head_json"]
                                              ["twitter_image"]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  16, // Genişlik ayarını yapabilirsiniz
                                            ),
                                            child: Text(
                                              e["yoast_head_json"]["title"],
                                              overflow: TextOverflow.clip,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              maxLines: 1,
                                              softWrap: false,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  16, // Genişlik ayarını yapabilirsiniz
                                            ),
                                            child: Text(
                                              e["yoast_head_json"]
                                                  ["description"],
                                              overflow: TextOverflow.clip,
                                              maxLines: 4,
                                              style: TextStyle(
                                                color: appColors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ),
                        // Text(
                        //   e["yoast_head_json"]["title"],
                        //   style: TextStyle(
                        //       color: appColors.black,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // Divider(),
                        // Text(
                        //   e["yoast_head_json"]["description"],
                        //   style: TextStyle(color: appColors.black),
                        // ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList();
      return Column(
        children: haberler,
      );
    } else {
      return Text("sa");
    }
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      //sayfanın sonuna geldi
      loadNewss(page: current_page + 1);
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      //sayfanın başına geldi
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    settings = context.read<SettingsCubit>();

    super.initState();
    loadNewss();
    controller = ScrollController();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).getTranslate('news_screen'),
        ),
        actions: [
          Padding(
            padding: MyPadding.horizontal8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 5,
                ),
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
      body: SingleChildScrollView(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).getTranslate('breaking_news'),
                style: GoogleFonts.bebasNeue(fontSize: 36),
              ),
              SizedBox(
                height: 10,
              ),
              getNews2(),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context).getTranslate('recent_news'),
                style: GoogleFonts.bebasNeue(fontSize: 30),
              ),
              Column(
                children: news.map((e) => NewsListTile(e)).toList(),
              ),
              loading ? CircularProgressIndicator() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
