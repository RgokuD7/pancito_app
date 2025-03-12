import 'package:pancito_app/models/bread_prices.dart';

class Client {
  String id;
  String name;
  BreadPrices? breadPrices;

  Client({
    this.id = '',
    required this.name,
    this.breadPrices,
  });

  // Convierte un objeto Client a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breadPrices': breadPrices?.toMap(),
    };
  }

  // Convierte un documento de Firebase en un objeto Client
  factory Client.fromMap( String documentId, Map<String, dynamic> map) {
    return Client(
      id: documentId,
      name: map['name'] ?? '',
      breadPrices: map['breadPrices'] != null
          ? BreadPrices.fromMap(map['breadPrices'] as Map<String, dynamic>, documentId)
          : null,
    );
  }
}
