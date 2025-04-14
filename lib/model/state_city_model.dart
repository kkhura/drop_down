

class StateCityModel{
  final String state;
  final List<String> cities;

  StateCityModel({required this.state, required this.cities});

  factory StateCityModel.fromJson(Map<String, dynamic> json) {
    return StateCityModel(
      state: json['state'],
      cities: List<String>.from(json['cities']),
    );
  }

}

extension StateCityExtension on List<StateCityModel> {
  // Get all unique states
  List<String> getStates() {
    return map((e) => e.state).toList();
  }

  // Get cities for a specific state
  List<String> getCitiesByState(String stateName) {
    if(stateName.isEmpty){
      return [];
    }
    final matchedState = firstWhere(
          (e) => e.state.toLowerCase() == stateName.toLowerCase(),
      orElse: () => StateCityModel(state: '', cities: []),
    );
    return matchedState.cities;
  }
}