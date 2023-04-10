import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/controllers/newsController.dart';
import 'package:newsapp/screens/article_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final NewsController _newsController = Get.put(NewsController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildArticleList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _newsController.reset();
              _newsController.fetchNews(_searchController.text);
            },
          ),
        ),
        onSubmitted: (value) {
          _newsController.reset();
          _newsController.fetchNews(value);
        },
      ),
    );
  }

  Widget _buildArticleList() {
    return Obx(
      () => _newsController.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsController.newsList.length,
              itemBuilder: (context, index) {
                final article = _newsController.newsList[index];
                return ListTile(
                  onTap: () {
                    Get.to(() => ArticleDetailScreen(article: article));
                  },
                  title: Text(article['title']),
                  subtitle: Text(
                    '${article['author']} - ${article['source']['name']} - ${DateFormat.yMMMMd().format(DateTime.parse(article['publishedAt']))}',
                  ),
                  leading: CachedNetworkImage(
                    imageUrl: article['urlToImage'] ?? '',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            ),
    );
  }
}
