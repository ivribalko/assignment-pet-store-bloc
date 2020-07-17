import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:openapi/model/pet.dart';
import 'package:pet_store_bloc/src/pet_data.dart';

class PetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Store'),
      ),
      body: BlocConsumer(
        bloc: context.bloc<PetBloc>(),
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
      ),
      floatingActionButton: _buildStatusDropdown(context),
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
      onChanged: (value) => context.bloc<PetBloc>().load(value),
    );
  }
}
