import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Clientes")),
      body: ListView.builder(
        itemCount: appState.clients.length,
        itemBuilder: (context, index) {
          final client = appState.clients[index];
          return ListTile(
            title: Text(client.name),
            subtitle: client.address != null ? Text(client.address!) : null,
            onTap: () => _showClienInfotDialog(context),
          );
        },
      ),
    );
  }

  void _showClienInfotDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

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
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration:
                    const InputDecoration(labelText: "Dirección (opcional)"),
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
                  appState.addClient(
                      nameController.text, addressController.text);
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
