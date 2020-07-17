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

class PetListBloc extends ListBloc<Pet, PetStatus> {
  PetListBloc(PetDataRepository repository) : super(repository);
}

class PetDataRepository implements ListRepository<Pet, PetStatus> {
  final PetApi _petApi;

  PetDataRepository(Openapi openApi) : _petApi = openApi.getPetApi();

  @override
  Future<List<Pet>> load({PetStatus filter}) => _petApi
      .findPetsByStatus(describeEnum(filter))
      .then((value) => value.data);
}

class PetPageBloc extends PaginatedBloc<Pet, int> {
  PetPageBloc(PetPagedRepository repository) : super(repository);
}

class PetPagedRepository implements PaginatedRepository<Pet, int> {
  final int _size = ListPage.kPageSize;

  final PetApi _petApi;
  final String _all = PetStatus.values.map(describeEnum).join(',');

  PetPagedRepository(Openapi openApi) : _petApi = openApi.getPetApi();

  @override
  Future<ListPage<Pet>> load({int filter}) => _petApi
      .findPetsByStatus(_all)
      .then((value) => value.data)
      .then((value) => ListPage<Pet>(
            number: filter,
            count: value.length,
          ).withData(
            data: value.sublist(_size * filter, _size * (filter + 1)),
            count: value.length,
          ));
}
