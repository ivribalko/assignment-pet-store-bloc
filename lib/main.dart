import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:openapi/api/pet_api.dart';
import 'package:openapi/model/pet.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
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
  final List<Pet> _pets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ..._pets.map((e) => Card(child: Text('$e'))),
        ],
      ),
      floatingActionButton: Row(
        children: <Widget>[
          Spacer(),
          FloatingActionButton(
            onPressed: () =>
                _petApi.addPet((PetBuilder()..status = 'available').build()),
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => _petApi
                .findPetsByStatus('available,pending')
                .then((value) => _pets.addAll(value.data.sublist(0, 10)))
                .then((value) => setState(() {})),
            child: Icon(Icons.cloud_download),
          ),
        ],
      ),
    );
  }
}
