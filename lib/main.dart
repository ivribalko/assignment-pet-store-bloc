import 'package:flutter/material.dart';
import 'package:openapi/model/pet.dart';
import 'package:wakelock/wakelock.dart';

import 'src/pet_data_repository.dart';

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
  final List<Pet> _pets = [];
  final PetDataRepository _petRepository = PetDataRepository();

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
            onPressed: () => _petRepository
                .load(filter: PetFilter(Status.pending))
                .then(_pets.addAll)
                .then((value) => setState(() {})),
            child: Icon(Icons.cloud_download),
          ),
        ],
      ),
    );
  }
}
