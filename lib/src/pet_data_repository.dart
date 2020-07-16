import 'package:flutter/foundation.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:openapi/api.dart';
import 'package:openapi/api/pet_api.dart';
import 'package:openapi/model/pet.dart';

enum Status {
  available,
  pending,
  sold,
}

class PetFilter {
  final Status status;

  PetFilter(this.status);

  String toQuery() => describeEnum(status);
}

class PetDataRepository implements ListRepository<Pet, PetFilter> {
  static final Openapi _openApi = Openapi();
  final PetApi _petApi = _openApi.getPetApi();

  @override
  Future<List<Pet>> load({PetFilter filter}) {
    return _petApi
        .findPetsByStatus(filter.toQuery())
        .then((value) => value.data);
  }
}
