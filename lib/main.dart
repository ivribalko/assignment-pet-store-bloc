import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        providers: [
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
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PetBloc(
                context.repository<PetDataRepository>(),
              ),
            ),
          ],
          child: PetListScreen(),
        ),
      ),
    ),
  );
}
