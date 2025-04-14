import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/state_city_model.dart';

class ProfileFieldBloc extends Bloc<ProfileFieldEvent, ProfileFieldState> {
  List<String>? switcherConfigValue;
  List<String>? selectedBrand;
  bool isWhatsappNumber = false;
  bool isMarried = false;
  List<StateCityModel>? stateCityList;

  List<String> cityList = [];

  ProfileFieldBloc() : super(ProfileFieldState.init) {
    on<UpdateField>(_updateField);
    on<LoadStates>(_loadStateCityData);
    on<LoadCityData>(_loadCityData);
  }

  Future<void> _updateField(
      UpdateField event, Emitter<ProfileFieldState> emit) async {
    emit(event.state);
    emit(ProfileFieldState.init);
  }

  Future<void> _loadCityData(
      LoadCityData event, Emitter<ProfileFieldState> emit) async {
    cityList.clear();
    cityList.addAll(stateCityList?.getCitiesByState(
        event.stateLoaded) ??
        []);
    emit(ProfileFieldState.cityLoaded);
  }

  Future<void> _loadStateCityData (
      LoadStates event, Emitter<ProfileFieldState> emit) async {
    final String jsonString =
    await rootBundle.loadString('assets/data/state_city_list.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    stateCityList = jsonMap.entries.map((entry) {
      return StateCityModel(
        state: entry.key,
        cities: List<String>.from(entry.value),
      );
    }).toList();

    emit(ProfileFieldState.stateLoaded);
  }
}

abstract class ProfileFieldEvent {}

class UpdateField extends ProfileFieldEvent {
  final ProfileFieldState state;

  UpdateField(this.state);
}

class LoadStates extends ProfileFieldEvent {
  LoadStates();
}

class LoadCityData extends ProfileFieldEvent {
  String stateLoaded;
  LoadCityData(this.stateLoaded);
}

//!states'
enum ProfileFieldState {
  init,
  titleState,
  whatsAppNumberState,
  maritalStatusState,
  genderState,
  occupationState,
  stateState,
  stateLoaded,
  cityState,
  cityLoaded,
}
