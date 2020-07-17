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
      title: 'Flutter Demo',
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<Openapi>(
            create: (context) => Openapi(),
          ),
          RepositoryProvider<PetDataRepository>(
            create: (context) => PetDataRepository(
              context.repository<Openapi>(),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PetBloc>(
              create: (context) => PetBloc(
                context.repository<PetDataRepository>(),
              ),
            ),
          ],
          child: PetScreen(),
        ),
      ),
    ),
  );
}
