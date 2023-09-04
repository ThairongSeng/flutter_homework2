import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BeerDetailsScreen extends StatefulWidget {
  final int beerId;

  const BeerDetailsScreen({super.key, required this.beerId});

  @override
  _BeerDetailsScreenState createState() => _BeerDetailsScreenState();
}

class _BeerDetailsScreenState extends State<BeerDetailsScreen> {
  Map<String, dynamic>? beerDetails;

  @override
  void initState() {
    super.initState();
    fetchBeerDetails(widget.beerId).then((details) {
      setState(() {
        beerDetails = details;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future<Map<String, dynamic>> fetchBeerDetails(int beerId) async {
    final url = 'https://api.punkapi.com/v2/beers/$beerId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData[0];
      }
    }
    throw Exception('Failed to load beer details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beerDetails!['name']),
      ),
      body:
      beerDetails != null ?
      Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Image.network(
                  beerDetails!['image_url'], // URL of the beer image
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,

                ),
                Text(
                  'Name: ${beerDetails!['name']}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Text(
                  '${beerDetails!['tagline']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Description: ${beerDetails!['description']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'First Brewed: ${beerDetails!['first_brewed']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Brewers Tips: ${beerDetails!['brewers_tips']}',
                  style: const TextStyle(fontSize: 16),
                ),
                // Add more Text widgets or other UI elements to display additional beer details
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
