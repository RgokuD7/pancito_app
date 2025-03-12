import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client.dart';

class ClientService {
  final CollectionReference _clientCollection = FirebaseFirestore.instance
      .collection('users')
      .doc('1')
      .collection('clients');

  Future<void> addClient(Client client) async {
    DocumentReference docRef = await _clientCollection.add(client.toMap());
    client.id = docRef.id;
  }

  Future<void> updateClient(Client client) async {
    await _clientCollection.doc(client.id).set(client.toMap());
  }

  Stream<List<Client>> getClients() {
    return _clientCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Client.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
