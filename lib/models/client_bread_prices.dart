class ClientBreadPrices {
  List<dynamic> basicBreadPrice;
  List<dynamic> lenguaBreadPrice;
  List<dynamic> fricaBreadPrice;
  List<dynamic> moldeBreadPrice;
  List<dynamic> integralBreadPrice;

  bool isSpecialBreadActive;

  ClientBreadPrices({
    this.basicBreadPrice = const [0, 0, true],
    this.lenguaBreadPrice = const [0, 0, true],
    this.fricaBreadPrice = const [0, 0, true],
    this.moldeBreadPrice = const [0, 0, true],
    this.integralBreadPrice = const [0, 0, true],
    this.isSpecialBreadActive = true,
  }) {
    if (!isSpecialBreadActive) {
      lenguaBreadPrice[2] = false;
      fricaBreadPrice[2] = false;
      moldeBreadPrice[2] = false;
      integralBreadPrice[2] = false;
    }
  }

  // Convierte un objeto ClientBreadPrices a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'basicBreadPrice': basicBreadPrice,
      'lenguaBreadPrice': lenguaBreadPrice,
      'fricaBreadPrice': fricaBreadPrice,
      'moldeBreadPrice': moldeBreadPrice,
      'integralBreadPrice': integralBreadPrice,
      'isSpecialBreadActive': isSpecialBreadActive,
    };
  }

  // Convierte un documento de Firebase en un objeto ClientBreadPrices
  factory ClientBreadPrices.fromMap(Map<String, dynamic> map) {
    return ClientBreadPrices(
      basicBreadPrice: List<dynamic>.from(map['basicBreadPrice']),
      lenguaBreadPrice: List<dynamic>.from(map['lenguaBreadPrice']),
      fricaBreadPrice: List<dynamic>.from(map['fricaBreadPrice']),
      moldeBreadPrice: List<dynamic>.from(map['moldeBreadPrice']),
      integralBreadPrice: List<dynamic>.from(map['integralBreadPrice']),
      isSpecialBreadActive: map['isSpecialBreadActive'] ?? true,
    );
  }
}
