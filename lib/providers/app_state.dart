import 'package:flutter/material.dart';
import 'package:pancito_app/models/client_bread_prices.dart';
import '../services/client_service.dart';
import '../services/user_service.dart';
import '../services/delivery_day_service.dart';
import '../models/user.dart';
import '../models/client.dart';
import '../models/delivery_day.dart';

import 'package:intl/intl.dart';

class AppState extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  final UserService _userService = UserService();
  final DeliveryDayService _deliveryDayService = DeliveryDayService();

  List<Client> _clients = [];
  List<DeliveryDay> _deliveryDays = [];
  User? _currentUser;

  List<Client> get clients => _clients;
  List<DeliveryDay> get deliveryDays => _deliveryDays;
  User? get currentUser => _currentUser;

  AppState() {
    _fetchClients();
    _fetchCurrentUser();
  }

  void _fetchClients() {
    _clientService.getClients().listen((clients) {
      _clients = clients;
      _checkAndCreateTodayDeliveryDay();
      notifyListeners();
    });
  }

  Future<void> addClient(String name) async {
    final newClient = Client(
      id: '', // El ID será generado automáticamente por Firebase
      name: name,
      breadPrices: ClientBreadPrices(),
    );
    await _clientService.addClient(newClient);
    _fetchClients(); // Asegúrate de actualizar la lista de clientes después de agregar uno nuevo
  }

  void _fetchCurrentUser() async {
    _currentUser = await _userService.getUser("1");
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await _userService.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> updateClient(Client client) async {
    await _clientService.updateClient(client);
    _fetchClients();
  }

  Future<DeliveryDay?> getDeliveryDay(String clientId, String day) async {
    return await _deliveryDayService.getDeliveryDay(clientId, day);
  }

  Future<void> updateDeliveryDay(
      DeliveryDay deliveryDay, String clientId, String day) async {
    await _deliveryDayService.updateDeliveryDay(deliveryDay, clientId, day);
    notifyListeners();
  }

  void _checkAndCreateTodayDeliveryDay() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    for (var client in _clients) {
      final deliveryDay =
          await _deliveryDayService.getDeliveryDay(client.id, today);
      if (deliveryDay == null) {
        final newDeliveryDay = DeliveryDay();
        await _deliveryDayService.addDeliveryDay(newDeliveryDay, client.id);
      }
    }
  }
}
