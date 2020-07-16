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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListBloc<Pet, PetFilter>>(
            create: (BuildContext context) {
              return ListBloc<Pet, PetFilter>(
                PetDataRepository(),
              );
            },
          ),
        ],
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocConsumer(
        bloc: context.bloc<ListBloc<Pet, PetFilter>>(),
        listener: (BuildContext context, state) {
          if (state is DataError) {
            _showError(context, state);
          }
        },
        builder: (_, state) {
          if (state is DataEmpty) {
            return _buildEmpty();
          } else if (state is DataLoading) {
            return _buildLoading();
          } else if (state is DataLoaded) {
            return _buildLoaded(state.data);
          } else if (state is DataError) {
            return _buildEmpty();
          } else {
            throw UnimplementedError();
          }
        },
      ),
    );
  }

  void _showError(BuildContext context, DataError state) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(state.error),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'No pets matching filter',
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
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
