import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:openapi/api/pet_api.dart';
import 'package:openapi/model/pet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final Openapi _openApi = Openapi();
  final PetApi _petApi = _openApi.getPetApi();
  int _id;
  Pet _pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _pet.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: <Widget>[
          Spacer(),
          FloatingActionButton(
            onPressed: () => _petApi
                .addPet((PetBuilder()..status = 'available').build())
                .then((value) => _id = value.data['id']),
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => _petApi
                .getPetById(_id)
                .then((x) => _pet = x.data)
                .then((_) => setState(() {})),
            child: Icon(Icons.cloud_download),
          ),
        ],
      ),
    );
  }
}
