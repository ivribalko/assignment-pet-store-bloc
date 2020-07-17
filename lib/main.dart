import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:flutter_bloc/src/repository_provider.dart';
import 'package:openapi/api.dart';
import 'package:wakelock/wakelock.dart';

import 'src/pet_data.dart';
import 'ui/pet_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(
    MaterialApp(
      title: 'Pet Store',
      home: MultiRepositoryProvider(
        providers: _repositories,
        child: MultiBlocProvider(
          providers: _blocs,
          child: PetScreen(),
        ),
      ),
    ),
  );
}

List<BlocProviderSingleChildWidget> get _blocs {
  return [
    BlocProvider(
      create: (context) => PetListBloc(
        context.repository<PetDataRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => PetPageBloc(
        context.repository<PetPagedRepository>(),
      ),
    ),
  ];
}

List<RepositoryProviderSingleChildWidget> get _repositories {
  return [
    RepositoryProvider(
      create: (context) => Openapi(),
    ),
    RepositoryProvider(
      create: (context) => PetDataRepository(
        context.repository<Openapi>(),
      ),
    ),
    RepositoryProvider(
      create: (context) => PetPagedRepository(
        context.repository<Openapi>(),
      ),
    ),
  ];
}
