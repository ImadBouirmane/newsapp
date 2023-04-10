import 'package:get/get.dart';
import 'package:newsapp/services/newsServices';

class NewsController extends GetxController {
  final NewsService _NewsService = NewsService();
  var newsList = [].obs;
  var isLoading = false.obs;
  var page = 1.obs;

  Future<void> fetchNews(String query) async {
    try {
      isLoading(true);
      List<dynamic> news = await _NewsService.fetchNews(query, page.value);
      if (news.isNotEmpty) {
        newsList.addAll(news);
        page.value++;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void reset() {
    newsList.clear();
    page.value = 1;
  }
}
