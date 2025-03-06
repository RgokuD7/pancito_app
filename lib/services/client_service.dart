import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client.dart';

class ClientService {
  final CollectionReference _clientsCollection =
      FirebaseFirestore.instance.collection('clients');

  Future<void> addClient(Client client) async {
    await _clientsCollection.doc(client.id).set(client.toMap());
  }

  Stream<List<Client>> getClients() {
    return _clientsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Client.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
