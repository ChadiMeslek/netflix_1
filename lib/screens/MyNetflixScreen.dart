import 'package:flutter/material.dart';
import 'package:netflix_1/common/utils.dart';
import 'package:netflix_1/screens/search_screen.dart';

class MyNetflixScreen extends StatefulWidget {
  @override
  _MyNetflixHomePageState createState() => _MyNetflixHomePageState();
  static List<String> watchLaterMovies = [];
  static void addToWatchList(String movie) {
    MyNetflixScreen.watchLaterMovies.add(movie);
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
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SearchScreen()),
                // );
              }),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                accountName: Text('العرندس'),
                accountEmail: Text('BetterCallUs@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Image(
                    image: AssetImage('assets/My Netflix.jpg'),
                  ),
                ),
              ),
            ),
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
            SizedBox(height: 10),
            Text('Séries et films que vous voulez regarder plus tard',
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: MyNetflixScreen.watchLaterMovies.length,
                itemBuilder: (context, index) {
                  return Card(
                    // child: Image.network(
                    //   MyNetflixScreen
                    //       .watchLaterMovies[index], // Placeholder images
                    //   fit: BoxFit.cover,
                    // ),
                    child: Image.network(
                      '$imageUrl${MyNetflixScreen.watchLaterMovies[index]}',
                      fit: BoxFit.fitHeight,
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
