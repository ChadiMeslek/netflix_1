import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:netflix_1/common/utils.dart';
import 'package:netflix_1/model/genre_model.dart';
import 'package:netflix_1/model/movie_detail_model.dart';
import 'package:netflix_1/model/movie_model.dart';
import 'package:netflix_1/model/movie_recommendation_model.dart';
import 'package:netflix_1/model/search_model.dart';
import 'package:netflix_1/model/tv_series_model.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
var key = '?api_key=$apiKey';
late String endPoint;

class ApiServices {
  Future<MovieModel> getUpcomingMovies() async {
    endPoint = 'movie/upcoming';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<MovieModel> getMovie(int Id) async {
    endPoint = 'movie/' + Id.toString();
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      print(response.body);
      return MovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<MovieModel> getNowPlayingMovies() async {
    endPoint = 'movie/now_playing';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<MovieRecommendationsModel> getPopularMovies() async {
    endPoint = 'movie/popular';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url), headers: {});
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = 'tv/1396/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load top rated series');
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    endPoint = 'movie/$movieId';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
    endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    print(url);
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZGEwMzczYTE2ODIzYTZhNmZiYTNhNjFjNmRjYjYyOSIsInN1YiI6IjY2NDczNmI2MzlhNjgxNDQ2Yjc4NzcxYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.a5xz4DI-mTKX3Fw3YUZ4kerHpkbTOTFb0SeK0Mho57o'
    });
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  search movie ');
  }

  Future<List<GenreModel>> getMovieGenres() async {
    final url = '$baseUrl/genre/movie/list?api_key=$apiKey&language=en';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<GenreModel> genres = [];

        for (var item in jsonData['genres']) {
          genres.add(GenreModel.fromJson(item));
        }

        return genres;
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<MovieModel> getGenreMovies(int genreId) async {
    final String endPoint = 'discover/movie';
    final url = '$baseUrl$endPoint?api_key=$apiKey&with_genres=$genreId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('success');
      return MovieModel.fromJson(jsonDecode(response.body));
    } else {
      print(
          'Failed to fetch genre movies. Status code: ${response.statusCode}, Response body: ${response.body}');
      throw Exception('Failed to load genre movies');
    }
  }
}
