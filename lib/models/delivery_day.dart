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
    this.basicBreadQuantity = const[0],
    this.lenguaBreadQuantity = const[0],
    this.fricaBreadQuantity = const[0],
    this.moldeBreadQuantity = const[0],
    this.integralBreadQuantity = const[0],
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
      basicBreadQuantity: map['basicBreadQuantity'] ?? [0],
      lenguaBreadQuantity: map['lenguaBreadQuantity'] ?? [0],
      fricaBreadQuantity: map['fricaBreadQuantity'] ?? [0],
      moldeBreadQuantity: map['moldeBreadQuantity'] ?? [0],
      integralBreadQuantity: map['integralBreadQuantity'] ?? [0],
      paymentStatus: PaymentStatus.values[map['paymentStatus'] ?? 2],
    );
  }

  List total() {
    return basicBreadQuantity;
  }
}
