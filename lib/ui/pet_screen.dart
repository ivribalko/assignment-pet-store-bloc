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
  static final _keys = _tabs.keys.toList();
  static final _tabs = {
    'list': PetListView(),
    'page': PetPageView(),
  };

  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Screen'),
      ),
      body: _tabs[_keys[_tab]],
      floatingActionButton: _buildStatusDropdown(context),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildNavigationItems(),
        onTap: _setTab,
        currentIndex: _tab,
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
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

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return _keys
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

/// View for ListRepository.
class PetListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: context.bloc<PetListBloc>(),
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
          return _buildLoaded(state.data);
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

/// View for PaginatedRepository.
class PetPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TODO'),
    );
  }
}
