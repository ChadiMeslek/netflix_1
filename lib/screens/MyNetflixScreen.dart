import 'package:flutter/material.dart';
import 'package:netflix_1/common/utils.dart';
import 'package:netflix_1/screens/movie_detailed_screen.dart';

class MyNetflixScreen extends StatefulWidget {
  @override
  _MyNetflixHomePageState createState() => _MyNetflixHomePageState();
  static List<Map<String, dynamic>> watchLaterMovies = [];

  static void addToWatchList(Map<String, dynamic> movie) {
    MyNetflixScreen.watchLaterMovies.add(movie);
  }

  static void removeFromWatchList(int movieId) {
    MyNetflixScreen.watchLaterMovies
        .removeWhere((movie) => movie['id'] == movieId);
  }

  static bool isMovieInWatchList(int movieId) {
    return MyNetflixScreen.watchLaterMovies
        .any((movie) => movie['id'] == movieId);
  }
}

class _MyNetflixHomePageState extends State<MyNetflixScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('My Netflix', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 50,
                    child: Image(
                      image: AssetImage('assets/My Netflix.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'العرندس',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'BetterCallUs@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.red),
              title:
                  Text('Notifications', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.download, color: Colors.blue),
              title: Text('Téléchargements',
                  style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {},
            ),
            SizedBox(height: 10),
            Text(
              'Séries et films que vous voulez regarder plus tard',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: MyNetflixScreen.watchLaterMovies.length,
                itemBuilder: (context, index) {
                  final movie = MyNetflixScreen.watchLaterMovies[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieId: movie['id'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Image.network(
                        '$imageUrl${movie['posterPath']}',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
