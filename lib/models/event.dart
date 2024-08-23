import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polmitra_admin/models/indian_city.dart';
import 'package:polmitra_admin/models/indian_state.dart';
import 'package:polmitra_admin/models/user.dart';


class Event {
  final String id;
  final String eventName;
  final String description;
  final String date;
  final String time;
  final String address;
  final List<String> images;
  final String karyakartaId;
  final PolmitraUser? karyakarta;
  final String netaId;
  final PolmitraUser? neta;
  final bool isActive;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final IndianState state;
  final IndianCity city;
  final int? endingTime;
  final String? endingImageUrl;
  final Map<String, double>? endingImageLocation; // New field for location

  String get netaDisplayName => neta?.name ?? neta?.email ?? netaId;

  String get karyakartaDisplayName =>
      karyakarta?.name ?? karyakarta?.email ?? karyakartaId;

  Event(
      {required this.id,
      required this.eventName,
      required this.description,
      required this.date,
      required this.time,
      required this.address,
      required this.images,
      required this.karyakartaId,
      required this.netaId,
      required this.isActive,
      this.karyakarta,
      this.neta,
      this.createdAt,
      this.updatedAt,
      required this.state,
      required this.city,
      this.endingImageUrl,
      this.endingTime,
      this.endingImageLocation});

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
      id: doc.id,
      eventName: doc['eventName'] ?? '',
      description: doc['description'] ?? '',
      date: doc['date'] ?? '',
      time: doc['time'] ?? '',
      address: doc['address'] ?? '',
      images: List<String>.from(doc['images'] ?? []),
      karyakartaId: doc['karyakartaId'] ?? '',
      netaId: doc['netaId'] ?? '',
      isActive: doc['isActive'] ?? true,
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
      endingTime: doc["ending_time"] ?? 0,
      karyakarta: doc['karyakarta'] != null
          ? PolmitraUser.fromMap(doc['karyakarta'])
          : null,
      neta: doc['neta'] != null ? PolmitraUser.fromMap(doc['neta']) : null,
      state: doc["state"] != null
          ? IndianState.fromMap(doc['state'])
          : IndianState(stateid: 1, statename: "None", cities: []),
      city: IndianCity.fromMap(doc['city']),

      endingImageUrl:
          doc["endingImageUrl"], // Default to an empty string if not present
      endingImageLocation: doc['endingImageLocation'] != null
          ? Map<String, double>.from(doc['endingImageLocation'])
          : null, // Default to null if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'description': description,
      'date': date,
      'time': time,
      'location': address,
      'images': images,
      'karyakartaId': karyakartaId,
      'netaId': netaId,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'neta': neta?.toMap(),
      'karyakarta': karyakarta?.toMap(),
      'state': state.toMap(),
      'city': city.toMap(),
      "ending_time": endingTime,

      "endingImageUrl": endingImageUrl,
      "endingImageLocation": endingImageLocation, // Added field
    };
  }

  Event copyWith(
      {String? id,
      String? eventName,
      String? description,
      String? date,
      String? time,
      String? address,
      List<String>? images,
      String? karyakartaId,
      String? netaId,
      bool? isActive,
      PolmitraUser? karyakarta,
      PolmitraUser? neta,
      Timestamp? updatedAt,
      IndianState? state,
      IndianCity? city,
      String? endingImageUrl,
      int? endingTime,
      Map<String, double>? endingImageLocation}) {
    return Event(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      address: address ?? this.address,
      images: images ?? this.images,
      karyakartaId: karyakartaId ?? this.karyakartaId,
      netaId: netaId ?? this.netaId,
      isActive: isActive ?? this.isActive,
      karyakarta: karyakarta ?? this.karyakarta,
      neta: neta ?? this.neta,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      state: state ?? this.state,
      city: city ?? this.city,
      endingImageUrl: endingImageUrl ?? this.endingImageUrl,
      endingTime: endingTime ?? this.endingTime,
      endingImageLocation:
          endingImageLocation ?? this.endingImageLocation, // Updated copyWith
    );
  }
}
