import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:listview/home/apiPage/NewsCard.dart';
import 'package:listview/model/Getnews.dart';

class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  Future<List<Getnews>> fetchPost() async {
    final response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var getPostsData = json.decode(response.body) as List;
      var listPosts = getPostsData.map((i) => Getnews.fromJson(i)).toList();
      return listPosts;
    } else {
      throw Exception('failed to load posts');
    }
  }

  late Future<List<Getnews>> futurePost;

  @override
  void initState() {
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: FutureBuilder(
              future: futurePost, builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(itemBuilder: ((context, index) {
                var post = (snapshot.data as List<Getnews>)[index];
                return Column(
                  children: [
                    Newscard(getnews: Getnews(
                      id: post.id, title: post.title, body: post.body,),),
                  ],
                );
              }), separatorBuilder: (context, index) {
                return const Divider();
              }, itemCount: (snapshot.data as List<Getnews>).length);
              } else
                  if (snapshot.hasError)
              {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
        ),
      ),
    );
  }
}
