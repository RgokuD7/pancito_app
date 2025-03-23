import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/currency_formatter.dart';
import '../widgets/delivery_detail_dialog.dart';
import '../widgets/payment_detail_dialog.dart';
import '../widgets/client_prices_dialog.dart';
import '../models/delivery_day.dart';
import '../utils/date_utils.dart';
import 'package:intl/intl.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.subtract(Duration(days: 1));
                });
              },
            ),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(
                formatDate(selectedDate),
                style: TextStyle(fontSize: 20),
              ),
            ),
            if (selectedDate
                .isBefore(DateTime.now().subtract(Duration(days: 1))))
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.add(Duration(days: 1));
                  });
                },
              )
            else
              SizedBox(width: 40), // Ancho fijo para mantener el espacio
          ],
        ),
      ),
      body: FutureBuilder<int>(
        future: _totalDebt(DateFormat('yyyy-MM-dd').format(selectedDate)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error cargando dia de reparto',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Sin Registros para este dia',
                textAlign: TextAlign.center,
              ),
            );
          }

          final totalDebt = snapshot.data!;
          final day = DateFormat('yyyy-MM-dd').format(selectedDate);

          return FutureBuilder<List<DeliveryDay?>>(
            future: Future.wait(appState.clients.map((client) {
              return appState.getDeliveryDay(client.id, day);
            }).toList()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error cargando dia de reparto',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Sin Registros para este dia',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final deliveryDays = snapshot.data!;
              bool hasData = deliveryDays.any((day) => day != null);

              if (!hasData) {
                return Center(
                  child: Text(
                    'Sin Registros para este dia',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              int totalReceived = deliveryDays.fold(
                  0, (sum, day) => sum + (day?.totalPayments() ?? 0));
              int difference = totalDebt - totalReceived;

              String formattedTotalDebt = CurrencyInputFormatter()
                  .formatEditUpdate(TextEditingValue.empty,
                      TextEditingValue(text: totalDebt.toString()))
                  .text;

              String formattedTotalReceived = CurrencyInputFormatter()
                  .formatEditUpdate(TextEditingValue.empty,
                      TextEditingValue(text: totalReceived.toString()))
                  .text;

              String formattedDifference = CurrencyInputFormatter()
                  .formatEditUpdate(TextEditingValue.empty,
                      TextEditingValue(text: difference.toString()))
                  .text;

              return Column(
                children: [
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Resumen de Pagos",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total esperado:",
                                  style: TextStyle(fontSize: 16)),
                              Text("\$$formattedTotalDebt",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total recibido:",
                                  style: TextStyle(fontSize: 16)),
                              Text("\$$formattedTotalReceived",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Diferencia:",
                                  style: TextStyle(fontSize: 16)),
                              Text("\$$formattedDifference",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: appState.clients.length,
                      itemBuilder: (context, index) {
                        final client = appState.clients[index];
                        final todayDeliveryDay = deliveryDays[index];

                        if (todayDeliveryDay == null) {
                          return SizedBox.shrink();
                        }

                        Color paymentColor;

                        if (!todayDeliveryDay.hasOrders()) {
                          paymentColor = Colors.grey;
                        } else {
                          switch (todayDeliveryDay.paymentStatus) {
                            case PaymentStatus.paid:
                              paymentColor = Colors.green;
                              break;
                            case PaymentStatus.partiallyPaid:
                              paymentColor = Colors.orange;
                              break;
                            case PaymentStatus.unpaid:
                              paymentColor = Colors.red;
                              break;
                          }
                        }

                        return Card(
                          child: ListTile(
                            leading: InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ClientPricesDialog(
                                  clientId: client.id,
                                ),
                              ),
                              child: const Icon(Icons.settings),
                            ),
                            title: Text(
                              client.name,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${todayDeliveryDay.basicBreadTotal().toStringAsFixed(1)} Kg',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                                SizedBox(width: 8),
                                InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => PaymentDetailDialog(
                                      clientId: client.id,
                                      date: DateFormat('yyyy-MM-dd')
                                          .format(selectedDate),
                                    ),
                                  ),
                                  child:
                                      Icon(Icons.payments, color: paymentColor),
                                ),
                              ],
                            ),
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => DeliveryDetailDialog(
                                clientId: client.id,
                                date: DateFormat('yyyy-MM-dd')
                                    .format(selectedDate),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<int> _totalDebt(String day) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBreadPrices = appState.currentUser?.breadPrices;

    int totalDebt = 0;

    for (var client in appState.clients) {
      final deliveryDay = await appState.getDeliveryDay(client.id, day);
      if (deliveryDay == null) continue;

      final breadPrices = client.breadPrices;
      if (breadPrices == null) continue;

      int getBreadDebt(int clientPrice, int userPrice, List<int> quantities) {
        final price = clientPrice != 0
            ? clientPrice
            : (userBreadPrices?.basicBreadPrice[userPrice] ?? 0);
        return price * quantities.fold(0, (sum, quantity) => sum + quantity);
      }

      int basicBreadDebt = getBreadDebt(breadPrices.basicBreadPrice[0],
          breadPrices.basicBreadPrice[1], deliveryDay.basicBreadQuantity);
      int lenguaBreadDebt = getBreadDebt(breadPrices.lenguaBreadPrice[0],
          breadPrices.lenguaBreadPrice[1], deliveryDay.lenguaBreadQuantity);
      int fricaBreadDebt = getBreadDebt(breadPrices.fricaBreadPrice[0],
          breadPrices.fricaBreadPrice[1], deliveryDay.fricaBreadQuantity);
      int moldeBreadDebt = getBreadDebt(breadPrices.moldeBreadPrice[0],
          breadPrices.moldeBreadPrice[1], deliveryDay.moldeBreadQuantity);
      int integralBreadDebt = getBreadDebt(breadPrices.integralBreadPrice[0],
          breadPrices.integralBreadPrice[1], deliveryDay.integralBreadQuantity);

      totalDebt += basicBreadDebt +
          lenguaBreadDebt +
          fricaBreadDebt +
          moldeBreadDebt +
          integralBreadDebt;
    }

    return totalDebt;
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
