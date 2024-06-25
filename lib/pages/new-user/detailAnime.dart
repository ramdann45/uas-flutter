import 'package:flutter/material.dart';

class DetailAnime extends StatelessWidget {
  final String name;
  final String image;
  final String gameSeries;
  final String amiiboSeries;

  DetailAnime(
      {required this.name,
      required this.image,
      required this.gameSeries,
      required this.amiiboSeries});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> article = {
      'image': image,
      'name': name,
      'amiiboSeries': amiiboSeries,
      'gameSeries': gameSeries,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article['name'] ?? 'Detail Profil',
          style: const TextStyle(color: Colors.white),
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
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0, // Shadow for the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: article['image'] != null
                      ? Image.network(
                          article['image'],
                          width: double.infinity,
                          height: 250,
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
                _buildDetailItem('Character', article['name']),
                _buildDetailItem('AmiiboSeries', article['amiiboSeries']),
                _buildDetailItem('GameSeries', article['gameSeries']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label + ': ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Tidak tersedia',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
