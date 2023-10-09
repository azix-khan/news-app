import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _repo = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi() async {
    final response = await _repo.fetchNewsChannelHeadlinesApi();
    return response;
  }
}