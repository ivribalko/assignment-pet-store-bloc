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
  static final _side = {
    'list': StatusDropdown(),
    'page': PagingSwitcher(),
  };

  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Screen'),
      ),
      body: _tabs[_keys[_tab]],
      floatingActionButton: _side[_keys[_tab]],
      bottomNavigationBar: BottomNavigationBar(
        items: _buildNavigationItems(),
        onTap: _setTab,
        currentIndex: _tab,
      ),
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
    return _buildBlocConsumer<PetListBloc>(context, (data) => data);
  }
}

/// View for PaginatedRepository.
class PetPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildBlocConsumer<PetPageBloc>(context, (data) => data.data);
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

  Row _buildPaging(int number, int pages) {
    return Row(
      children: <Widget>[
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: number > 0 ? () => _load(--number) : null,
        ),
        Text('Click here'),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: number < pages - 2 ? () => _load(++number) : null,
        )
      ],
    );
  }

  void _load(int page) => context.bloc<PetPageBloc>().load(page);
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

Widget _buildBlocConsumer<B extends Bloc<dynamic, dynamic>>(
  BuildContext context,
  Function(dynamic) extractor,
) {
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
        return _buildLoaded(extractor(state.data));
      } else if (state is DataError) {
        return _buildEmpty();
      } else {
        throw UnimplementedError();
      }
    },
  );
}
