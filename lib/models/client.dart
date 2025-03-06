class Client {
  String id;
  String name;
  String? address;

  Client({
    required this.id,
    required this.name,
    this.address,
  });

  // Convierte un objeto Client a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  // Convierte un documento de Firebase en un objeto Client
  factory Client.fromMap(Map<String, dynamic> map, String documentId) {
    return Client(
      id: documentId,
      name: map['name'] ?? '',
      address: map['address'],
    );
  }
}
