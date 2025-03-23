enum PaymentStatus { paid, partiallyPaid, unpaid }

class DeliveryDay {
  String id; // Fecha en formato 'yyyy-MM-dd'
  List<int> basicBreadQuantity;
  List<int> lenguaBreadQuantity;
  List<int> fricaBreadQuantity;
  List<int> moldeBreadQuantity;
  List<int> integralBreadQuantity;
  List<int> basicBreadPayments;
  List<int> lenguaBreadPayments;
  List<int> fricaBreadPayments;
  List<int> moldeBreadPayments;
  List<int> integralBreadPayments;
  PaymentStatus paymentStatus;

  DeliveryDay({
    this.id = '',
    this.basicBreadQuantity = const [0],
    this.lenguaBreadQuantity = const [0],
    this.fricaBreadQuantity = const [0],
    this.moldeBreadQuantity = const [0],
    this.integralBreadQuantity = const [0],
    this.basicBreadPayments = const [0],
    this.lenguaBreadPayments = const [0],
    this.fricaBreadPayments = const [0],
    this.moldeBreadPayments = const [0],
    this.integralBreadPayments = const [0],
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
      'basicBreadPayments': basicBreadPayments,
      'lenguaBreadPayments': lenguaBreadPayments,
      'fricaBreadPayments': fricaBreadPayments,
      'moldeBreadPayments': moldeBreadPayments,
      'integralBreadPayments': integralBreadPayments,
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
      basicBreadPayments: List<int>.from(map['basicBreadPayments'] ?? [0]),
      lenguaBreadPayments: List<int>.from(map['lenguaBreadPayments'] ?? [0]),
      fricaBreadPayments: List<int>.from(map['fricaBreadPayments'] ?? [0]),
      moldeBreadPayments: List<int>.from(map['moldeBreadPayments'] ?? [0]),
      integralBreadPayments:
          List<int>.from(map['integralBreadPayments'] ?? [0]),
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

  int basicBreadPaymentsTotal() {
    return basicBreadPayments.reduce((a, b) => a + b);
  }

  int lenguaBreadPaymentsTotal() {
    return lenguaBreadPayments.reduce((a, b) => a + b);
  }

  int fricaBreadPaymentsTotal() {
    return fricaBreadPayments.reduce((a, b) => a + b);
  }

  int moldeBreadPaymentsTotal() {
    return moldeBreadPayments.reduce((a, b) => a + b);
  }

  int integralBreadPaymentsTotal() {
    return integralBreadPayments.reduce((a, b) => a + b);
  }

  bool hasOrders() {
    return basicBreadTotal() > 0 ||
        lenguaBreadTotal() > 0 ||
        fricaBreadTotal() > 0 ||
        moldeBreadTotal() > 0 ||
        integralBreadTotal() > 0;
  }

  int totalPayments(){
    return basicBreadPaymentsTotal() +
        lenguaBreadPaymentsTotal() +
        fricaBreadPaymentsTotal() +
        moldeBreadPaymentsTotal() +
        integralBreadPaymentsTotal();
  }
}
