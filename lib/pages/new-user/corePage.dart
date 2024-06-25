import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../new-user/detailAnime.dart';
import 'dart:convert';

class CorePage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;

  CorePage(
      {required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.gender});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.newspaper_outlined)),
                Tab(icon: Icon(Icons.account_circle_rounded)),
              ],
            ),
            title: const Text(
              'Anime Character Encyclopedia',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 32, 35, 38),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 24, 57, 96),
                  Color.fromARGB(255, 38, 32, 36),
                ],
              ),
            ),
            child: TabBarView(
              children: [
                NewsList(),
                Profile(
                  name: name,
                  email: email,
                  phone: phone,
                  address: address,
                  gender: gender,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// NEWS LIST
class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Future<List<dynamic>> _fetchData() async {
    final response =
        await http.get(Uri.parse('https://amiiboapi.com/api/amiibo/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> articles = data['amiibo'] ?? [];
      return articles.where((article) => article['image'] != null).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black54,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<dynamic> articles = snapshot.data ?? [];
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailAnime(
                        amiiboSeries: article['amiiboSeries'],
                        gameSeries: article['gameSeries'],
                        image: article['image'],
                        name: article['name'],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                          child: article['image'] != null
                              ? Image.network(
                                  article['image'],
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image,
                                      size: 50, color: Colors.grey),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['name'] ?? 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article['amiiboSeries'] ?? 'No Description',
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

// MY PROFILE
class Profile extends StatefulWidget {
  @override
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;

  Profile(
      {required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.gender});

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 35, 38),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 24, 57, 96),
              Color.fromARGB(255, 38, 32, 36),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildInfoItem('Nama', widget.name),
                _buildInfoItem('Alamat', widget.address),
                _buildInfoItem('No.Hp', widget.phone),
                _buildInfoItem('Email', widget.email),
                _buildInfoItem('Gender', widget.gender),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoItem(String label, String value) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label + ': ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}
