import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/user.dart';
import '../models/bread_prices.dart';
import '../models/client.dart';

class PricesDialog extends StatelessWidget {
  final String userId;
  final String? clientId;

  PricesDialog({required this.userId, this.clientId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController basicBreadPriceController =
        TextEditingController();
    final TextEditingController lenguaBreadPriceController =
        TextEditingController();
    final TextEditingController fricaBreadPriceController =
        TextEditingController();
    final TextEditingController moldeBreadPriceController =
        TextEditingController();
    final TextEditingController integralBreadPriceController =
        TextEditingController();

    return AlertDialog(
      title: const Text("Precios del Pan"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(child: Text("Pan Básico")),
              Expanded(
                child: TextField(
                  controller: basicBreadPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Precio"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Pan Lengua")),
              Expanded(
                child: TextField(
                  controller: lenguaBreadPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Precio"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Pan Frica")),
              Expanded(
                child: TextField(
                  controller: fricaBreadPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Precio"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Pan Molde")),
              Expanded(
                child: TextField(
                  controller: moldeBreadPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Precio"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Pan Integral")),
              Expanded(
                child: TextField(
                  controller: integralBreadPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Precio"),
                ),
              ),
            ],
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
            final appState = Provider.of<AppState>(context, listen: false);
            final breadPrices = BreadPrices(
              basicBreadPrice: int.tryParse(basicBreadPriceController.text),
              lenguaBreadPrice: int.tryParse(lenguaBreadPriceController.text),
              fricaBreadPrice: int.tryParse(fricaBreadPriceController.text),
              moldeBreadPrice: int.tryParse(moldeBreadPriceController.text),
              integralBreadPrice:
                  int.tryParse(integralBreadPriceController.text),
            );

            if (clientId != null) {
              // Guardar en el cliente
              final client = Client(
                id: clientId!,
                name: "", // Aquí deberías obtener el nombre del cliente
                breadPrices: breadPrices,
              );
              appState.updateClient(client);
            } else {
              // Guardar en el usuario
              final updatedUser = User(
                id: userId,
                name: "Goku", // Aquí deberías obtener el nombre del usuario
                breadPrices: breadPrices,
              );
              appState.updateUser(updatedUser);
            }

            Navigator.of(context).pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
