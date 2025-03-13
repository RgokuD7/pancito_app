import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/prices_dialog.dart';
import '../models/client.dart';
import '../models/delivery_day.dart';
import 'package:intl/intl.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Clientes")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: appState.clients.length,
              itemBuilder: (context, index) {
                final client = appState.clients[index];
                final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                final todayDeliveryDayFuture =
                    appState.getDeliveryDay(client.id, today);

                return FutureBuilder<DeliveryDay?>(
                  future: todayDeliveryDayFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(); // Devolver un contenedor vacío mientras se carga
                    } else if (snapshot.hasError) {
                      return const Text('Error cargando dia de reparto');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('Reparto no encontrado');
                    }

                    final todayDeliveryDay = snapshot.data!;

                    IconData paymentIcon;
                    Color paymentColor;

                    if (!todayDeliveryDay.hasOrders()) {
                      paymentIcon = Icons.payments;
                      paymentColor = Colors.grey;
                    } else {
                      switch (todayDeliveryDay.paymentStatus) {
                        case PaymentStatus.paid:
                          paymentIcon = Icons.payments;
                          paymentColor = Colors.green;
                          break;
                        case PaymentStatus.partiallyPaid:
                          paymentIcon = Icons.payments;
                          paymentColor = Colors.orange;
                          break;
                        case PaymentStatus.unpaid:
                          paymentIcon = Icons.payments;
                          paymentColor = Colors.red;
                          break;
                      }
                    }

                    return Card(
                      child: ListTile(
                        leading: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                PricesDialog(userId: "1", clientId: client.id),
                          ),
                          child: const Icon(Icons.more_vert),
                        ),
                        title: Text(
                          client.name,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${todayDeliveryDay.basicBreadTotal().toStringAsFixed(2)} Kg',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              paymentIcon,
                              color: paymentColor,
                            ),
                          ],
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              PricesDialog(userId: "1", clientId: client.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (appState.clients.isEmpty)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Agregar Cliente"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  appState.addClient(nameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
