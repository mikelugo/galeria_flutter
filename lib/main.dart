import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("gallery"),),
        body: Gallery(),
      ),
    );
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool loading;
  List<String>ids ;

  @override
  void initState(){
    loading = true;
    ids = [];
    _loadImageIds();
    super.initState();
    }

    void  _loadImageIds() async {
    final response = await http.get(Uri.parse('https://picsum.photos/v2/list'));
    final json = jsonDecode(response.body);
    List<String> _ids =[];
    for (var imagen in json){
      _ids.add(imagen['id']);
    }
    setState(() {
      loading= false;
      ids = _ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      itemBuilder: (context,index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Zoom(ids[index]),
            ),
          );
        },
        child: Image.network('https://picsum.photos/id/${ids[index]}/250/250',
        ),
      ),
      itemCount: ids.length,
    );
  }
}

class Zoom extends StatelessWidget {
  final String id;
  Zoom(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network('https://picsum.photos/id/$id/600/1000',
        ),
      ),
    );
  }
}
