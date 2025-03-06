import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class DistributionPage extends StatelessWidget {
  const DistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Reparto")),
      body: ListView.builder(
        itemCount: appState.clients.length,
        itemBuilder: (context, index) {
          final client = appState.clients[index];
          return ListTile(
            title: Text(client.name),
            subtitle: client.address != null ? Text(client.address!) : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDistributionTypeSelecion(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDistributionTypeSelecion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text("Seleccione Tipo")),
          titlePadding: const EdgeInsets.all(20),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAcomulableDialog(context); 
              },
              child: const Text("Acomulable"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSectionDialog(context); 
              },
              child: const Text("Por sección"),
            ),
          ],
        );
      },
    );
  }

  void _showAcomulableDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text("Nombre de la sección")),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Ej: Pan Soft",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar el valor ingresado
                String name = _nameController.text;
                Navigator.of(context).pop();
              },
              child: const Text("Aceptar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _showSectionDialog(BuildContext context) {
    final TextEditingController _sectionNameController =
        TextEditingController();
    final List<TextEditingController> _subsectionControllers = [
      TextEditingController()
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Ingrese los detalles de la sección"),
                  automaticallyImplyLeading: false,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _sectionNameController,
                        decoration: const InputDecoration(
                          hintText: "Mañana",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _subsectionControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextField(
                                controller: _subsectionControllers[index],
                                decoration: InputDecoration(
                                  hintText: "Vuelta ${index + 1}",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _subsectionControllers.add(TextEditingController());
                          });
                        },
                        child: const Text("Agregar subsección"),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Aquí puedes manejar los valores ingresados
                          String sectionName = _sectionNameController.text;
                          List<String> subsectionNames = _subsectionControllers
                              .map((controller) => controller.text)
                              .toList();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Aceptar"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
