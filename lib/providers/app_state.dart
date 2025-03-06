import 'package:flutter/material.dart';
import '../services/client_service.dart';
import '../models/client.dart';

class AppState extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];

  List<Client> get clients => _clients;

  AppState() {
    _fetchClients();
  }

  void _fetchClients() {
    _clientService.getClients().listen((clients) {
      _clients = clients;
      notifyListeners();
    });
  }

  Future<void> addClient(String name, String? address) async {
    final newClient = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: address,
    );
    await _clientService.addClient(newClient);
  }
}
