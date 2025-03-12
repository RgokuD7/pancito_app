enum PaymentStatus { paid, partiallyPaid, unpaid }

class DeliveryDay {
  String id; // Fecha en formato 'yyyy-MM-dd'
  List<int> basicBreadQuantity;
  List<int> lenguaBreadQuantity;
  List<int> fricaBreadQuantity;
  List<int> moldeBreadQuantity;
  List<int> integralBreadQuantity;
  PaymentStatus paymentStatus;

  DeliveryDay({
    required this.id,
    this.basicBreadQuantity = const [0],
    this.lenguaBreadQuantity = const [0],
    this.fricaBreadQuantity = const [0],
    this.moldeBreadQuantity = const [0],
    this.integralBreadQuantity = const [0],
    this.paymentStatus = PaymentStatus.unpaid,
  });

  // Convierte un objeto DeliveryDay a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'basicBreadQuantity': basicBreadQuantity,
      'lenguaBreadQuantity': lenguaBreadQuantity,
      'fricaBreadQuantity': fricaBreadQuantity,
      'moldeBreadQuantity': moldeBreadQuantity,
      'integralBreadQuantity': integralBreadQuantity,
      'paymentStatus': paymentStatus.index,
    };
  }

  // Convierte un documento de Firebase en un objeto DeliveryDay
  factory DeliveryDay.fromMap(String documentId, Map<String, dynamic> map) {
    return DeliveryDay(
      id: documentId,
      basicBreadQuantity: List<int>.from(map['basicBreadQuantity'] ?? [0]),
      lenguaBreadQuantity: List<int>.from(map['lenguaBreadQuantity'] ?? [0]),
      fricaBreadQuantity: List<int>.from(map['fricaBreadQuantity'] ?? [0]),
      moldeBreadQuantity: List<int>.from(map['moldeBreadQuantity'] ?? [0]),
      integralBreadQuantity:
          List<int>.from(map['integralBreadQuantity'] ?? [0]),
      paymentStatus: PaymentStatus.values[map['paymentStatus'] ?? 2],
    );
  }

  int basicBreadTotal() {
    return basicBreadQuantity.reduce((a, b) => a + b);
  }

  int lenguaBreadTotal() {
    return lenguaBreadQuantity.reduce((a, b) => a + b);
  }

  int fricaBreadTotal() {
    return fricaBreadQuantity.reduce((a, b) => a + b);
  }

  int moldeBreadTotal() {
    return moldeBreadQuantity.reduce((a, b) => a + b);
  }

  int integralBreadTotal() {
    return integralBreadQuantity.reduce((a, b) => a + b);
  }

  bool hasOrders() {
    return basicBreadTotal() > 0 ||
        lenguaBreadTotal() > 0 ||
        fricaBreadTotal() > 0 ||
        moldeBreadTotal() > 0 ||
        integralBreadTotal() > 0;
  }
}
