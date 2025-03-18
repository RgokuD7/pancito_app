class UserBreadPrices {
  List<int> basicBreadPrice;
  List<int> lenguaBreadPrice;
  List<int> fricaBreadPrice;
  List<int> moldeBreadPrice;
  List<int> integralBreadPrice;

  UserBreadPrices({
    this.basicBreadPrice = const [0],
    this.lenguaBreadPrice = const [0],
    this.fricaBreadPrice = const [0],
    this.moldeBreadPrice = const [0],
    this.integralBreadPrice = const [0],
  });

  // Convierte un objeto UserBreadPrices a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'basicBreadPrice': basicBreadPrice,
      'lenguaBreadPrice': lenguaBreadPrice,
      'fricaBreadPrice': fricaBreadPrice,
      'moldeBreadPrice': moldeBreadPrice,
      'integralBreadPrice': integralBreadPrice,
    };
  }

  // Convierte un documento de Firebase en un objeto UserBreadPrices
  factory UserBreadPrices.fromMap(Map<String, dynamic> map) {
    return UserBreadPrices(
      basicBreadPrice: List<int>.from(map['basicBreadPrice'] ?? []),
      lenguaBreadPrice: List<int>.from(map['lenguaBreadPrice'] ?? []),
      fricaBreadPrice: List<int>.from(map['fricaBreadPrice'] ?? []),
      moldeBreadPrice: List<int>.from(map['moldeBreadPrice'] ?? []),
      integralBreadPrice: List<int>.from(map['integralBreadPrice'] ?? []),
    );
  }
}
