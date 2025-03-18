import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../models/client.dart';
import '../models/delivery_day.dart';

class DeliveryDetailDialog extends StatefulWidget {
  final String clientId;
  final String date;

  DeliveryDetailDialog({required this.clientId, required this.date});

  @override
  _DeliveryDetailDialogState createState() => _DeliveryDetailDialogState();
}

class _DeliveryDetailDialogState extends State<DeliveryDetailDialog> {
  late TextEditingController basicBreadController;
  late Map<String, TextEditingController> specialBreadControllers;
  late Client client;
  DeliveryDay? deliveryDay;
  bool showSpecialBreadDetails = false;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    client =
        appState.clients.firstWhere((client) => client.id == widget.clientId);
    _loadDeliveryDay();
  }

  Future<void> _loadDeliveryDay() async {
    final appState = Provider.of<AppState>(context, listen: false);
    deliveryDay = await appState.getDeliveryDay(client.id, widget.date);
    setState(() {
      basicBreadController = TextEditingController();
      specialBreadControllers = {
        'lengua': TextEditingController(),
        'frica': TextEditingController(),
        'molde': TextEditingController(),
        'integral': TextEditingController(),
      };
    });
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
      title: Text(
        "Detalle reparto ${client.name}",
        textAlign: TextAlign.center,
      ),
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
                          : colorScheme.surfaceContainer,
                      foregroundColor: !showSpecialBreadDetails
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                    child: const Text("Pan Corriente"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showSpecialBreadDetails = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showSpecialBreadDetails
                          ? colorScheme.primary
                          : colorScheme.surfaceContainer,
                      foregroundColor: showSpecialBreadDetails
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                    child: const Text("Pan Especial"),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            if (!showSpecialBreadDetails && hasBasicBread)
              _buildBreadDetail("Pan Corriente", basicBreadController,
                  deliveryDay!.basicBreadTotal(), (value) {
                setState(() {
                  deliveryDay!.basicBreadQuantity.add(int.tryParse(value) ?? 0);
                  basicBreadController.text = '0';
                });
              }),
            if (showSpecialBreadDetails && hasSpecialBread ||
                hasSpecialBread && !hasBasicBread) ...[
              if (client.breadPrices?.lenguaBreadPrice[2] ?? false)
                _buildBreadDetail(
                    "Pan Lengua",
                    specialBreadControllers['lengua']!,
                    deliveryDay!.lenguaBreadTotal(), (value) {
                  setState(() {
                    deliveryDay!.lenguaBreadQuantity
                        .add(int.tryParse(value) ?? 0);
                    specialBreadControllers['lengua']!.text = '0';
                  });
                }),
              if (client.breadPrices?.fricaBreadPrice[2] ?? false)
                _buildBreadDetail(
                    "Pan Frica",
                    specialBreadControllers['frica']!,
                    deliveryDay!.fricaBreadTotal(), (value) {
                  setState(() {
                    deliveryDay!.fricaBreadQuantity
                        .add(int.tryParse(value) ?? 0);
                    specialBreadControllers['frica']!.text = '0';
                  });
                }),
              if (client.breadPrices?.moldeBreadPrice[2] ?? false)
                _buildBreadDetail(
                    "Pan Molde",
                    specialBreadControllers['molde']!,
                    deliveryDay!.moldeBreadTotal(), (value) {
                  setState(() {
                    deliveryDay!.moldeBreadQuantity
                        .add(int.tryParse(value) ?? 0);
                    specialBreadControllers['molde']!.text = '0';
                  });
                }),
              if (client.breadPrices?.integralBreadPrice[2] ?? false)
                _buildBreadDetail(
                    "Pan Integral",
                    specialBreadControllers['integral']!,
                    deliveryDay!.integralBreadTotal(), (value) {
                  setState(() {
                    deliveryDay!.integralBreadQuantity
                        .add(int.tryParse(value) ?? 0);
                    specialBreadControllers['integral']!.text = '0';
                  });
                }),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Agregar los valores actuales de los TextField a las listas correspondientes
            deliveryDay!.basicBreadQuantity
                .add(int.tryParse(basicBreadController.text) ?? 0);
            deliveryDay!.lenguaBreadQuantity.add(
                int.tryParse(specialBreadControllers['lengua']!.text) ?? 0);
            deliveryDay!.fricaBreadQuantity
                .add(int.tryParse(specialBreadControllers['frica']!.text) ?? 0);
            deliveryDay!.moldeBreadQuantity
                .add(int.tryParse(specialBreadControllers['molde']!.text) ?? 0);
            deliveryDay!.integralBreadQuantity.add(
                int.tryParse(specialBreadControllers['integral']!.text) ?? 0);

            // Guardar en Firebase
            final appState = Provider.of<AppState>(context, listen: false);
            appState.updateDeliveryDay(deliveryDay!, client.id, widget.date);
            Navigator.of(context).pop();
          },
          child: const Text("Listo"),
        ),
      ],
    );
  }

  Widget _buildBreadDetail(String label, TextEditingController controller,
      int total, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          "$total ${label == 'Pan Corriente' ? 'Kg' : 'Bolsas'}",
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: "0"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => onChanged(controller.text),
            ),
          ],
        ),
      ],
    );
  }
}
