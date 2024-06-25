import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      article['name'] ?? 'No Title',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (article['image'] != null)
                      Container(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          article['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(article['amiiboSeries'] ?? 'No Description'),
                  ],
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
        title: const Text('Profil Saya'),
      ),
      body: Center(
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
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label + ': ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
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
}
