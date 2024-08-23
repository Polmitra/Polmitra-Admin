import 'package:polmitra_admin/models/indian_city.dart';

class IndianState {
  int stateid;
  String statename;
  List<IndianCity> cities;

  IndianState(
      {required this.stateid, required this.statename, required this.cities});

  factory IndianState.fromJson(Map<String, dynamic> json) {
    var list = json['cities'];

    List<IndianCity> citiesList =
        List<IndianCity>.from(list.map((i) => IndianCity.fromJson(i)));

    return IndianState(
      stateid: json['stateid'],
      statename: json['statename'],
      cities: citiesList ?? [],
    );
  }

  // fromMap
  factory IndianState.fromMap(Map<String, dynamic> map) {
    // var list = map['cities'] ?? [];
    // List<IndianCity> citiesList =
    //     list.map((i) => IndianCity.fromMap(i)).toList();

    return IndianState(
      stateid: map['stateid'],
      statename: map['statename'],
      cities: map['cities'] != null
          ? map["cities"].map((i) => IndianCity.fromMap(i)).toList()
          : [],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'stateid': stateid,
      'statename': statename,
      'cities': cities.map((x) => x.toMap()).toList(),
    };
  }
}
