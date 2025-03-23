import 'package:flutter/material.dart';
import 'package:pancito_app/models/user_bread_prices.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/client.dart';
import '../models/delivery_day.dart';
import '../utils/currency_formatter.dart';

class PaymentDetailDialog extends StatefulWidget {
  final String clientId;
  final String date;

  PaymentDetailDialog({required this.clientId, required this.date});

  @override
  _PaymentDetailDialogState createState() => _PaymentDetailDialogState();
}

class _PaymentDetailDialogState extends State<PaymentDetailDialog> {
  late TextEditingController basicBreadPaymentController;
  late Map<String, TextEditingController> specialBreadPaymentControllers;
  late Client client;
  late UserBreadPrices? userBreadPrices;
  DeliveryDay? deliveryDay;
  bool showSpecialBreadDetails = false;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    client =
        appState.clients.firstWhere((client) => client.id == widget.clientId);
    userBreadPrices = appState.currentUser!.breadPrices;
    _loadDeliveryDay();
  }

  Future<void> _loadDeliveryDay() async {
    final appState = Provider.of<AppState>(context, listen: false);
    deliveryDay = await appState.getDeliveryDay(client.id, widget.date);
    setState(() {
      basicBreadPaymentController = TextEditingController(text: '0');
      specialBreadPaymentControllers = {
        'lengua': TextEditingController(),
        'frica': TextEditingController(),
        'molde': TextEditingController(),
        'integral': TextEditingController(),
      };
    });
  }

  void _updatePaymentDetails() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateDeliveryDay(deliveryDay!, client.id, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    if (deliveryDay == null) {
      return Center(child: CircularProgressIndicator());
    }

    final colorScheme = Theme.of(context).colorScheme;

    final bool hasBasicBread = client.breadPrices?.basicBreadPrice[2] ?? false;
    final bool hasSpecialBread =
        client.breadPrices?.isSpecialBreadActive ?? false;

    return AlertDialog(
      title: Text("Detalle de pagos ${client.name}"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasBasicBread && hasSpecialBread)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showSpecialBreadDetails = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showSpecialBreadDetails
                          ? colorScheme.primary
                          : colorScheme.secondary,
                      foregroundColor: !showSpecialBreadDetails
                          ? colorScheme.onPrimary
                          : colorScheme.onSecondary,
                    ),
                    child: const Text("Pan Corriente"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showSpecialBreadDetails = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showSpecialBreadDetails
                          ? colorScheme.primary
                          : colorScheme.secondary,
                      foregroundColor: showSpecialBreadDetails
                          ? colorScheme.onPrimary
                          : colorScheme.onSecondary,
                    ),
                    child: const Text("Pan Especial"),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            if (!showSpecialBreadDetails && hasBasicBread)
              _buildPaymentDetail(
                  "Pan Corriente",
                  basicBreadPaymentController,
                  deliveryDay!.basicBreadTotal(),
                  deliveryDay!.basicBreadPaymentsTotal(),
                  client.breadPrices!.basicBreadPrice[0] != 0
                      ? client.breadPrices!.basicBreadPrice[0]
                      : userBreadPrices?.basicBreadPrice[
                              client.breadPrices!.basicBreadPrice[1]] ??
                          0, (value) {
                setState(() {
                  deliveryDay!.basicBreadPayments
                      .add(int.tryParse(removeCurrencyFormat(value)) ?? 0);
                  basicBreadPaymentController.text = '0';
                });
              }),
            if (showSpecialBreadDetails && hasSpecialBread ||
                hasSpecialBread && !hasBasicBread) ...[
              if (client.breadPrices?.lenguaBreadPrice[2] ?? false)
                _buildPaymentDetail(
                    "Pan Lengua",
                    specialBreadPaymentControllers['lengua']!,
                    deliveryDay!.lenguaBreadTotal(),
                    deliveryDay!.lenguaBreadPaymentsTotal(),
                    client.breadPrices!.lenguaBreadPrice[0] != 0
                        ? client.breadPrices!.lenguaBreadPrice[0]
                        : userBreadPrices?.basicBreadPrice[
                                client.breadPrices!.lenguaBreadPrice[1]] ??
                            0, (value) {
                  setState(() {
                    deliveryDay!.lenguaBreadPayments
                        .add(int.tryParse(removeCurrencyFormat(value)) ?? 0);
                    specialBreadPaymentControllers['lengua']!.text = '0';
                  });
                }),
              if (client.breadPrices?.fricaBreadPrice[2] ?? false)
                _buildPaymentDetail(
                    "Pan Frica",
                    specialBreadPaymentControllers['frica']!,
                    deliveryDay!.fricaBreadTotal(),
                    deliveryDay!.fricaBreadPaymentsTotal(),
                    client.breadPrices!.fricaBreadPrice[0] != 0
                        ? client.breadPrices!.fricaBreadPrice[0]
                        : userBreadPrices?.basicBreadPrice[
                                client.breadPrices!.fricaBreadPrice[1]] ??
                            0, (value) {
                  setState(() {
                    deliveryDay!.fricaBreadPayments
                        .add(int.tryParse(removeCurrencyFormat(value)) ?? 0);
                    specialBreadPaymentControllers['frica']!.text = '0';
                  });
                }),
              if (client.breadPrices?.moldeBreadPrice[2] ?? false)
                _buildPaymentDetail(
                    "Pan Molde",
                    specialBreadPaymentControllers['molde']!,
                    deliveryDay!.moldeBreadTotal(),
                    deliveryDay!.moldeBreadPaymentsTotal(),
                    client.breadPrices!.moldeBreadPrice[0] != 0
                        ? client.breadPrices!.moldeBreadPrice[0]
                        : userBreadPrices?.basicBreadPrice[
                                client.breadPrices!.moldeBreadPrice[1]] ??
                            0, (value) {
                  setState(() {
                    deliveryDay!.moldeBreadPayments
                        .add(int.tryParse(removeCurrencyFormat(value)) ?? 0);
                    specialBreadPaymentControllers['molde']!.text = '0';
                  });
                }),
              if (client.breadPrices?.integralBreadPrice[2] ?? false)
                _buildPaymentDetail(
                    "Pan Integral",
                    specialBreadPaymentControllers['integral']!,
                    deliveryDay!.integralBreadTotal(),
                    deliveryDay!.integralBreadPaymentsTotal(),
                    client.breadPrices!.integralBreadPrice[0] != 0
                        ? client.breadPrices!.integralBreadPrice[0]
                        : userBreadPrices?.basicBreadPrice[
                                client.breadPrices!.integralBreadPrice[1]] ??
                            0, (value) {
                  setState(() {
                    deliveryDay!.integralBreadPayments
                        .add(int.tryParse(removeCurrencyFormat(value)) ?? 0);
                    specialBreadPaymentControllers['integral']!.text = '0';
                  });
                }),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // Agregar los valores actuales de los TextField a las listas correspondientes
            deliveryDay!.basicBreadPayments.add(int.tryParse(
                    removeCurrencyFormat(basicBreadPaymentController.text)) ??
                0);
            deliveryDay!.lenguaBreadPayments.add(int.tryParse(
                    removeCurrencyFormat(
                        specialBreadPaymentControllers['lengua']!.text)) ??
                0);
            deliveryDay!.fricaBreadPayments.add(int.tryParse(
                    removeCurrencyFormat(
                        specialBreadPaymentControllers['frica']!.text)) ??
                0);
            deliveryDay!.moldeBreadPayments.add(int.tryParse(
                    removeCurrencyFormat(
                        specialBreadPaymentControllers['molde']!.text)) ??
                0);
            deliveryDay!.integralBreadPayments.add(int.tryParse(
                    removeCurrencyFormat(
                        specialBreadPaymentControllers['integral']!.text)) ??
                0);

            // Guardar en Firebase
            _updatePaymentDetails();
            Navigator.of(context).pop();
          },
          child: const Text("Listo"),
        ),
      ],
    );
  }

  Widget _buildPaymentDetail(
      String label,
      TextEditingController controller,
      int totalQuantity,
      int totalPayments,
      int pricePerUnit,
      ValueChanged<String> onChanged) {
    final totalDebt = totalQuantity * pricePerUnit;

    final formattedTotalDebt = CurrencyInputFormatter()
        .formatEditUpdate(TextEditingValue.empty,
            TextEditingValue(text: totalDebt.toString()))
        .text;

    final formattedTotalPayments = CurrencyInputFormatter()
        .formatEditUpdate(TextEditingValue.empty,
            TextEditingValue(text: totalPayments.toString()))
        .text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          "Deuda total: \$$formattedTotalDebt",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        Text(
          "Deuda pagada: \$$formattedTotalPayments",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatter()],
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: "0"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => onChanged(removeCurrencyFormat(controller.text)),
            ),
          ],
        ),
      ],
    );
  }
}
