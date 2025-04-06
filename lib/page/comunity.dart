import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> tweets = [
    {
      'username': 'CoffeeLover98',
      'tweet':
          'Baru coba kafe Kopi Hitam Jember, vibesnya cozy banget dan kopinya mantap!',
      'likes': 12,
      'isLiked': false,
      'comments': 4
    },
    {
      'username': 'CafeExplorer',
      'tweet':
          'Ngopi di Kedai Senja Jember, tempatnya aesthetic dan cocok buat nugas.',
      'likes': 8,
      'isLiked': false,
      'comments': 2
    }
  ];

  void toggleLike(int index) {
    setState(() {
      tweets[index]['isLiked'] = !tweets[index]['isLiked'];
      tweets[index]['isLiked']
          ? tweets[index]['likes']++
          : tweets[index]['likes']--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community"),
        backgroundColor: Color(0xFFB13841),
      ),
      body: ListView.builder(
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tweets[index]['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(tweets[index]['tweet']),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: tweets[index]['isLiked']
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () => toggleLike(index),
                      ),
                      Text(tweets[index]['likes'].toString()),
                      SizedBox(width: 20),
                      Icon(Icons.comment, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(tweets[index]['comments'].toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
