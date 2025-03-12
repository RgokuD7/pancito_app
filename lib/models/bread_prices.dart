class BreadPrices {
  
  int? basicBreadPrice;
  int? lenguaBreadPrice;
  int? fricaBreadPrice;
  int? moldeBreadPrice;
  int? integralBreadPrice;

  BreadPrices({
    this.basicBreadPrice,
    this.lenguaBreadPrice,
    this.fricaBreadPrice,
    this.moldeBreadPrice,
    this.integralBreadPrice,
  });

  // Convierte un objeto DistributionCategories a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'basicBreadPrice': basicBreadPrice,
      'lenguaBreadPrice': lenguaBreadPrice, 
      'fricaBreadPrice': fricaBreadPrice,
      'moldeBreadPrice': moldeBreadPrice,
      'integralBreadPrice': integralBreadPrice,
    };
  }

  // Convierte un documento de Firebase en un objeto DistributionCategories
  factory BreadPrices.fromMap(Map<String, dynamic> map, String documentId) {
    return BreadPrices(
      basicBreadPrice: map['basicBreadPrice'],
      lenguaBreadPrice: map['lenguaBreadPrice'],
      fricaBreadPrice: map['fricaBreadPrice'],
      moldeBreadPrice: map['moldeBreadPrice'],
      integralBreadPrice: map['integralBreadPrice'],
    );
  }
}