import 'package:flutter/material.dart';
import '../widgets/user_prices_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajustes")),
      body: ListView(children: <Widget>[
        Card(
          child: ListTile(
            leading: const Icon(Icons.payments),
            title: const Text('Precios'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showDialog(
              context: context,
              builder: (context) => UserPricesDialog(userId: "1"),
            ),
          ),
        ),
      ]),
    );
  }
}
