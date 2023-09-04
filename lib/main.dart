
import 'package:flutter/material.dart';
import 'package:future_builder_widget/beer.dart';
import 'package:future_builder_widget/page_detail.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Beer List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //fetch api (all beers)
  Future<List<Beer>> getAllBeers() async {
    var resp = await http.get(Uri.https('api.punkapi.com', '/v2/beers'));

    if (resp.statusCode == 200) {
      var beers = beerFromJson(resp.body);
      // print(beers.length);
      return beers;
    } else {
      throw Exception('Could not load beer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Beer List"),
      ),
      body: Center(
        child: FutureBuilder(
            future: getAllBeers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              data[index].name!,
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                            subtitle: Text(data[index].tagline!),
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(data[index].imageUrl!),
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BeerDetailsScreen(beerId: data[index].id!), // Replace with the desired beer ID
                                ),
                              );
                            },
                            // trailing: const Icon(Icons.favorite_border),
                          ),
                        ),
                      );
                    });
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ));
}}
