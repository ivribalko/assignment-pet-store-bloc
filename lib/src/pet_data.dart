import 'package:flutter/foundation.dart';
import 'package:list_bloc/list_bloc.dart';
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
  final PetApi _petApi;

  PetDataRepository(openApi) : _petApi = openApi.getPetApi();

  @override
  Future<List<Pet>> load({PetStatus filter}) => _petApi
      .findPetsByStatus(describeEnum(filter))
      .then((value) => value.data);
}

class PetPagedRepository implements PaginatedRepository<Pet, PetStatus> {
  final PetApi _petApi;

  PetPagedRepository(openApi) : _petApi = openApi.getPetApi();

  @override
  Future<ListPage<Pet>> load({PetStatus filter}) => _petApi
      .findPetsByStatus(describeEnum(filter))
      .then((value) => value.data)
      .then((value) => ListPage(
            data: value,
            count: value.length,
          ));
}
