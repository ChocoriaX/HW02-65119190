import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'models/product.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Product> products;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var url = Uri.https('fakestoreapi.com','products');
    var response = await http.get(url);
    //print(response.body);
    setState(() {
      products = productFromJson(response.body);
    });
    return;
  }
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('IT@WU Shop', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          var imgUrl = product.image;
          imgUrl ??= 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg';
          return ListTile(
            title: Text('${product.title}'),
            subtitle: Text('\$${product.price}'),
            leading: AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(imgUrl)
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Details(),
                    settings: RouteSettings(
                      arguments: product
                    )
                  )
                );
              }
          );
        }
      ));
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Details();
  }
}

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    var imgUrl = product.image;
    imgUrl ??= 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details '),
      ),
      body: ListView(
        children: [
          
          // Image
          AspectRatio(aspectRatio: 16.0 / 9.0, child: Image.network(imgUrl)),
          
          // Title
          ListTile(
            title: Text(
              '${product.title}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              )),
              subtitle: Text(
                '\$ ${product.price}',
                style: const TextStyle(fontSize: 20.0),
              )
          ),

          //Category
          ListTile(
            title: const Text(
              'Category',
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(
              '${product.category}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),

          //Descript
          ListTile(
            title: Text('${product.description}'),
          ),

          //Rating
          ListTile(
            title: Text(
              'Rating : ${product.rating!.rate}/5 of ${product.rating!.count}'
            ),
          ),

          //RatingBar
          RatingBar.builder(
            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
            // ignore: avoid_print
            onRatingUpdate: (value) => print(value),
            minRating: 0,
            itemCount: 5,
            allowHalfRating: true,
            direction: Axis.horizontal,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            initialRating: product.rating!.rate ?? 0,
          )
        ],
      ),
    );
  }
}