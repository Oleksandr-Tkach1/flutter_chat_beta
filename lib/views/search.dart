import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchTextEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Adding a chat',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,))),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search username...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x36ffffff),
                          const Color(0x0fffffff),
                        ]
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Image.asset(
                      "assets/image/search_icon.png",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
