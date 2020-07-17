import 'package:flutter/foundation.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:openapi/api.dart';
import 'package:openapi/api/pet_api.dart';
import 'package:openapi/model/pet.dart';

enum PetStatus {
  available,
  pending,
  sold,
}

class PetBloc extends ListBloc<Pet, PetStatus> {
  PetBloc(PetDataRepository repository) : super(repository);
}

class PetDataRepository implements ListRepository<Pet, PetStatus> {
  static final Openapi _openApi = Openapi();
  final PetApi _petApi = _openApi.getPetApi();

  @override
  Future<List<Pet>> load({PetStatus filter}) {
    return _petApi
        .findPetsByStatus(describeEnum(filter))
        .then((value) => value.data);
  }
}
