import '../models/user_bread_prices.dart';

class User {
  String id;
  String name;
  UserBreadPrices? breadPrices;

  User({
    required this.id,
    required this.name,
    this.breadPrices,
  });

  // Convierte un objeto User a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breadPrices': breadPrices?.toMap(),
    };
  }

  // Convierte un documento de Firebase en un objeto User
  factory User.fromMap(String documentId, Map<String, dynamic> map) {
    return User(
      id: documentId,
      name: map['name'] ?? '',
      breadPrices: map['breadPrices'] != null
          ? UserBreadPrices.fromMap(
              map['breadPrices'] as Map<String, dynamic>)
          : null,
    );
  }
}
