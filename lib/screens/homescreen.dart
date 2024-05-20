import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netflix_1/model/genre_model.dart';
import 'package:netflix_1/model/movie_model.dart';
import 'package:netflix_1/model/tv_series_model.dart';
import 'package:netflix_1/screens/search_screen.dart';
import 'package:netflix_1/services/api_services.dart';
import 'package:netflix_1/signup_in/signin.dart';
import 'package:netflix_1/widgets/custom_carousel.dart';
import 'package:netflix_1/widgets/upcoming_movie_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices apiServices = ApiServices();
  List<GenreModel> genres = [];

  late Future<MovieModel> upcomingFuture;
  late Future<MovieModel> nowPlaying;
  late Future<TvSeriesModel> topRatedShows;
  Future<MovieModel>? genreMoviesFuture;
  String genreHeadline = '';

  @override
  void initState() {
    super.initState();
    fetchGenres();
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlaying = apiServices.getNowPlayingMovies();
    topRatedShows = apiServices.getTopRatedSeries();
  }

  Future<void> fetchGenres() async {
    try {
      List<GenreModel> fetchedGenres = await apiServices.getMovieGenres();
      setState(() {
        genres = fetchedGenres;
      });
    } catch (e) {
      print('Error fetching genres: $e');
    }
  }

  Future<void> fetchMoviesByGenre(int genreId, String genreName) async {
    const apiKey = 'fda0373a16823a6a6fba3a61c6dcb629';
    final String endPoint = 'discover/movie';
    final url = '$baseUrl$endPoint?api_key=$apiKey&with_genres=$genreId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('success');
        final responseBody = response.body;
        print(
            'Response Body: $responseBody'); // Print the response body for debugging

        final Map<String, dynamic> jsonMap = jsonDecode(responseBody);
        if (jsonMap != null) {
          final movieModel = MovieModel.fromJson(jsonMap);
          setState(() {
            genreMoviesFuture = Future.value(movieModel);
            genreHeadline = genreName;
          });
        } else {
          throw Exception('Failed to parse genre movies');
        }
      } else {
        print(
            'Failed to fetch genre movies. Status code: ${response.statusCode}, Response body: ${response.body}');
        throw Exception('Failed to load genre movies');
      }
    } catch (e) {
      print('Error fetching movies by genre: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/logo.png',
          height: 50,
          width: 120,
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  print("sign out success");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                } catch (e) {
                  print("error: $e");
                }
              },
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.logout,
                  weight: 27,
                  color: Colors.amber[700],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<TvSeriesModel>(
              future: topRatedShows,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomCarouselSlider(data: snapshot.data!);
                }
                return const SizedBox();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: UpcomingMovieCard(
                future: nowPlaying,
                headlineText: 'Now Playing',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: UpcomingMovieCard(
                future: upcomingFuture,
                headlineText: 'Upcoming Movies',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: SizedBox(
                height: 70.0,
                child: genres.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              fetchMoviesByGenre(
                                genres[index].id,
                                genres[index].name,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFD45253),
                                    Color(0xFF9E1F28)
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9E1F28),
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  genres[index].name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(height: 20),
            genreMoviesFuture != null
                ? SizedBox(
                    height: 220,
                    child: UpcomingMovieCard(
                      future: genreMoviesFuture!,
                      headlineText: genreHeadline,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
