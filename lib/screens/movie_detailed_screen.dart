import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:netflix_1/common/utils.dart';
import 'package:netflix_1/model/movie_detail_model.dart';
import 'package:netflix_1/model/movie_recommendation_model.dart';
import 'package:netflix_1/services/api_services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationsModel> movieRecommendationModel;
  bool isRated = false; // State to track if the movie is rated

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetail(widget.movieId);
    movieRecommendationModel =
        apiServices.getMovieRecommendations(widget.movieId);
    setState(() {});
  }

  void shareMovie(String movieTitle) {
    String netflixSearchUrl =
        'https://www.netflix.com/search?q=${Uri.encodeComponent(movieTitle)}';

    Share.share(
      'Seen $movieTitle on Netflix yet? Watch here: $netflixSearchUrl',
    );
  }

  void playTrailer(String movieTitle) async {
    // Construct the YouTube search URL for the movie trailer
    String searchQuery = '${movieTitle} official trailer';
    String url =
        'https://www.youtube.com/results?search_query=${Uri.encodeComponent(searchQuery)}';

    // Launch the URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<MovieDetailModel>(
          future: movieDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data!;
              String genresText =
                  movie.genres.map((genre) => genre.name).join(', ');

              // Format runtime in hours and minutes
              final runtime = movie.runtime;
              final hours = runtime ~/ 60;
              final minutes = runtime % 60;
              final runtimeText = '${hours}h ${minutes}min';

              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("$imageUrl${movie.posterPath}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '13+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              runtimeText,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            RatingBarIndicator(
                              rating: movie.voteAverage /
                                  2, // Convert to 5-star scale
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${movie.voteAverage}/10',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => playTrailer(movie.title),
                                icon: const Icon(Icons.play_arrow,
                                    color: Colors.black),
                                label: const Text(
                                  'Play',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(size.width * 0.9,
                                      50), // Full width button
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Add Watch List functionality here
                                },
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  'Add to Watch List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  minimumSize: Size(size.width * 0.9,
                                      50), // Full width button
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          movie.overview,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isRated
                                        ? Icons.thumb_up_alt
                                        : Icons.thumb_up_alt_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isRated = !isRated;
                                    });
                                  },
                                ),
                                const Text('Rate',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.share,
                                      color: Colors.white),
                                  onPressed: () {
                                    shareMovie(movie.title);
                                  },
                                ),
                                const Text('Share',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  FutureBuilder<MovieRecommendationsModel>(
                    future: movieRecommendationModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final movie = snapshot.data!;
                        return movie.results.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "More like this",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount: movie.results.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1.5 / 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                movieId:
                                                    movie.results[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "$imageUrl${movie.results[index].posterPath}",
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                      }
                      return const Text("");
                    },
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
