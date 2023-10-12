import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/view_models/news_view_model.dart';
import 'package:news_app/views/news_details_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMM dd, yyyy');
  String categoryName = 'general'; // Default category
  int btnSelected = 0;
  String selectedCategory = 'General';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  Future<void> fetchDataForCategory(String category) async {
    // Use the category parameter to fetch data for the selected category.
    final data = await newsViewModel.fetchCategoriesNewsApi(category);
    setState(() {
      categoryName = category;
      selectedCategory = category; // Update selectedCategory
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            categoriesList[index] == selectedCategory
                                ? Colors.blueAccent
                                : Colors.grey,
                      ),
                      onPressed: () {
                        fetchDataForCategory(categoriesList[index]);
                      },
                      child: Text(
                        categoriesList[index],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.03),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitSpinningLines(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles == null) {
                    return const Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return ListView.builder(
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
                                    newsTitle: snapshot.data!.articles![index].title
                                        .toString(),
                                    newsDate: snapshot
                                        .data!.articles![index].publishedAt
                                        .toString(),
                                    author: snapshot.data!.articles![index].author
                                        .toString(),
                                    description: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    content: snapshot.data!.articles![index].content
                                        .toString(),
                                    source: snapshot.data!.articles![index].source!.name
                                        .toString()),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    placeholder: (context, url) => Container(
                                      child: const SpinKitSpinningLines(
                                        size: 50,
                                        color: Colors.blue,
                                      ),
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
                                    height: height * 0.18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: Colors.blue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
