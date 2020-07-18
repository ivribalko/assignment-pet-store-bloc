import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:openapi/model/pet.dart';
import 'package:pet_store_bloc/src/pet_data.dart';

/// General container screen for all tab views.
class PetScreen extends StatefulWidget {
  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final _tabs = [
    _Tab(
        name: 'list',
        body: BlocBody<PetListBloc>((data) => data),
        side: StatusDropdown()),
    _Tab(
        name: 'page',
        body: BlocBody<PetPageBloc>((data) => data.data),
        side: PagingSwitcher()),
  ];

  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Screen'),
      ),
      body: _tabs[_tab].body,
      floatingActionButton: _tabs[_tab].side,
      bottomNavigationBar: BottomNavigationBar(
        items: _buildNavigationItems(),
        onTap: _setTab,
        currentIndex: _tab,
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return _tabs
        .map((e) => e.name)
        .map((e) => BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            title: Text(e),
            activeIcon: Icon(Icons.star)))
        .toList();
  }

  void _setTab(int index) {
    setState(() {
      _tab = index;
    });
  }
}

class StatusDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      iconSize: 60,
      hint: Text('Click here'),
      items: [
        ...PetStatus.values.map(
          (status) => DropdownMenuItem(
            value: status,
            child: Text(describeEnum(status)),
          ),
        ),
      ],
      onChanged: (value) => context.bloc<PetListBloc>().load(value),
    );
  }
}

class PagingSwitcher extends StatefulWidget {
  @override
  _PagingSwitcherState createState() => _PagingSwitcherState();
}

class _PagingSwitcherState extends State<PagingSwitcher> {
  @override
  void initState() {
    super.initState();
    _load(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetPageBloc, DataState<ListPage<Pet>, int>>(
      bloc: context.bloc<PetPageBloc>(),
      builder: (_, state) {
        if (state is DataLoaded) {
          return _buildPaging(state.data.number, state.data.pages);
        } else {
          return _buildPaging(0, 0);
        }
      },
    );
  }

  Row _buildPaging(int index, int count) {
    return Row(
      children: <Widget>[
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: index > 0 ? () => _load(--index) : null,
        ),
        Text('Click here'),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: index < count - 2 ? () => _load(++index) : null,
        )
      ],
    );
  }

  void _load(int page) => context.bloc<PetPageBloc>().load(page);
}

class _Tab {
  final String name;
  final Widget body;
  final Widget side;

  _Tab({this.name, this.body, this.side});
}

class BlocBody<B extends Bloc<dynamic, dynamic>> extends StatelessWidget {
  final Function(dynamic) _extractor;

  const BlocBody(this._extractor);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: context.bloc<B>(),
      listener: (context, state) {
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
          return _buildLoaded(_extractor(state.data));
        } else if (state is DataError) {
          return _buildEmpty();
        } else {
          throw UnimplementedError();
        }
      },
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
      children: [
        ...pets.map((e) => Card(child: Text('$e'))),
      ],
    );
  }
}
