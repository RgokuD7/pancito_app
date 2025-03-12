import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/delivery_day.dart';
import 'package:intl/intl.dart';

class DeliveryDayService {
  final DocumentReference _userDocumnet =
      FirebaseFirestore.instance.collection('users').doc('1');

  Future<void> addDeliveryDay(DeliveryDay delyveryDay, String clientId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _userDocumnet
        .collection('clients')
        .doc(clientId)
        .collection('deliveryDays')
        .doc(today)
        .set(delyveryDay.toMap());
  }

  Future<void> updateDeliveryDay(
      DeliveryDay delyveryDay, String clientId, String day) async {
    await _userDocumnet
        .collection('clients')
        .doc(clientId)
        .collection('deliveryDays')
        .doc(day)
        .set(delyveryDay.toMap());
  }

  Future<DeliveryDay> getDeliveryDay(String clientId, String day) async {
    final doc = await _userDocumnet
        .collection('clients')
        .doc(clientId)
        .collection('deliveryDays')
        .doc(day)
        .get();

    return DeliveryDay.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }
}
