import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_bloc/list_bloc.dart';
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
  final bloc = ListBloc<Pet, PetFilter>(PetDataRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, state) {},
      ),
    );
  }

  Widget _buildLoaded(List<Pet> pets) {
    return ListView(
      children: <Widget>[
        ...pets.map((e) => Card(child: Text('$e'))),
      ],
    );
  }
}
