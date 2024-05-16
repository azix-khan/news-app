import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/view_models/news_view_model.dart';
import 'package:news_app/views/categories_screen.dart';
import 'package:news_app/views/news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {
  bbcNews,
  aryNews,
  cnn,
  alJazeera,
  abcNews,
  entertainmentWeekly,
  news24
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMM dd, yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      // backgroundColor: const Color(0xffafdde5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: 30,
              width: 30,
            )),
        title: Text('News',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            )),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }
              if (FilterList.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              if (FilterList.abcNews.name == item.name) {
                name = 'abc-news';
              }
              if (FilterList.entertainmentWeekly.name == item.name) {
                name = 'entertainment-weekly';
              }
              if (FilterList.news24.name == item.name) {
                name = 'news24';
              }

              // NewsViewModel().fetchNewsChannelHeadlinesApi(name);
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text('ARY News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.alJazeera,
                child: Text('Aljazeera News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.entertainmentWeekly,
                child: Text('Entertainment Weekly'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.news24,
                child: Text('News 24'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
                // future: null,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitSpinningLines(
                      size: 50,
                      color: Colors.blue,
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailsScreen(
                                      newsImage: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      newsTitle: snapshot
                                          .data!.articles![index].title
                                          .toString(),
                                      newsDate: snapshot
                                          .data!.articles![index].publishedAt
                                          .toString(),
                                      author: snapshot
                                          .data!.articles![index].author
                                          .toString(),
                                      description: snapshot
                                          .data!.articles![index].description
                                          .toString(),
                                      content: snapshot
                                          .data!.articles![index].content
                                          .toString(),
                                      source: snapshot.data!.articles![index].source!.name.toString()),
                                ),
                              );
                            },
                            child: SizedBox(
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * 0.02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spinkit2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      height: height * .22,
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                      color: Colors.blue),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          );
                        });
                  } else {
                    return const Text('Error: Unable to fetch data');
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriesNewsApi('General'),
                  // future: null,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SpinKitSpinningLines(
                        size: 50,
                        color: Colors.blue,
                      );
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailsScreen(
                                        newsImage: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        newsTitle: snapshot
                                            .data!.articles![index].title
                                            .toString(),
                                        newsDate: snapshot
                                            .data!.articles![index].publishedAt
                                            .toString(),
                                        author: snapshot.data!.articles![index].author
                                            .toString(),
                                        description: snapshot
                                            .data!.articles![index].description
                                            .toString(),
                                        content: snapshot
                                            .data!.articles![index].content
                                            .toString(),
                                        source: snapshot.data!.articles![index].source!.name.toString()),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          height: height * .18,
                                          width: width * .3,
                                          placeholder: (context, url) =>
                                              Container(
                                            child: spinkit2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: height * .18,
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: height * .03,
                                              ),
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              // const Spacer(),
                                              SizedBox(
                                                height: height * .03,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.blue,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    format.format(dateTime),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * .01,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitThreeBounce(
  size: 50,
  color: Colors.blue,
);
