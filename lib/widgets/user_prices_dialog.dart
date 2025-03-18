import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/user.dart';
import '../models/user_bread_prices.dart';
import '../utils/currency_formatter.dart';

class UserPricesDialog extends StatefulWidget {
  final String userId;

  UserPricesDialog({required this.userId});

  @override
  _UserPricesDialogState createState() => _UserPricesDialogState();
}

class _UserPricesDialogState extends State<UserPricesDialog> {
  List<TextEditingController> basicBreadPriceControllers = [];
  List<TextEditingController> lenguaBreadPriceControllers = [];
  List<TextEditingController> fricaBreadPriceControllers = [];
  List<TextEditingController> moldeBreadPriceControllers = [];
  List<TextEditingController> integralBreadPriceControllers = [];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final userBreadPrices = appState.currentUser!.breadPrices;

    basicBreadPriceControllers = userBreadPrices?.basicBreadPrice
            .map((price) => TextEditingController(
                text: CurrencyInputFormatter()
                    .formatEditUpdate(TextEditingValue.empty,
                        TextEditingValue(text: price.toString()))
                    .text))
            .toList() ??
        [TextEditingController()];
    lenguaBreadPriceControllers = userBreadPrices?.lenguaBreadPrice
            .map((price) => TextEditingController(
                text: CurrencyInputFormatter()
                    .formatEditUpdate(TextEditingValue.empty,
                        TextEditingValue(text: price.toString()))
                    .text))
            .toList() ??
        [TextEditingController()];
    fricaBreadPriceControllers = userBreadPrices?.fricaBreadPrice
            .map((price) => TextEditingController(
                text: CurrencyInputFormatter()
                    .formatEditUpdate(TextEditingValue.empty,
                        TextEditingValue(text: price.toString()))
                    .text))
            .toList() ??
        [TextEditingController()];
    moldeBreadPriceControllers = userBreadPrices?.moldeBreadPrice
            .map((price) => TextEditingController(
                text: CurrencyInputFormatter()
                    .formatEditUpdate(TextEditingValue.empty,
                        TextEditingValue(text: price.toString()))
                    .text))
            .toList() ??
        [TextEditingController()];
    integralBreadPriceControllers = userBreadPrices?.integralBreadPrice
            .map((price) => TextEditingController(
                text: CurrencyInputFormatter()
                    .formatEditUpdate(TextEditingValue.empty,
                        TextEditingValue(text: price.toString()))
                    .text))
            .toList() ??
        [TextEditingController()];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Precios del Pan",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceList("Pan Corriente", basicBreadPriceControllers),
            const SizedBox(height: 10),
            _buildPriceList("Pan Lengua", lenguaBreadPriceControllers),
            const SizedBox(height: 10),
            _buildPriceList("Pan Frica", fricaBreadPriceControllers),
            const SizedBox(height: 10),
            _buildPriceList("Pan Molde", moldeBreadPriceControllers),
            const SizedBox(height: 10),
            _buildPriceList("Pan Integral", integralBreadPriceControllers),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final appState = Provider.of<AppState>(context, listen: false);
            final breadPrices = UserBreadPrices(
              basicBreadPrice: basicBreadPriceControllers
                  .map((controller) =>
                      int.tryParse(removeCurrencyFormat(controller.text)) ?? 0)
                  .toList(),
              lenguaBreadPrice: lenguaBreadPriceControllers
                  .map((controller) =>
                      int.tryParse(removeCurrencyFormat(controller.text)) ?? 0)
                  .toList(),
              fricaBreadPrice: fricaBreadPriceControllers
                  .map((controller) =>
                      int.tryParse(removeCurrencyFormat(controller.text)) ?? 0)
                  .toList(),
              moldeBreadPrice: moldeBreadPriceControllers
                  .map((controller) =>
                      int.tryParse(removeCurrencyFormat(controller.text)) ?? 0)
                  .toList(),
              integralBreadPrice: integralBreadPriceControllers
                  .map((controller) =>
                      int.tryParse(removeCurrencyFormat(controller.text)) ?? 0)
                  .toList(),
            );

            final updatedUser = User(
              id: widget.userId,
              name: 'Goku', // Obtener el nombre del usuario
              breadPrices: breadPrices,
            );
            appState.updateUser(updatedUser);

            Navigator.of(context).pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  Widget _buildPriceList(
      String label, List<TextEditingController> controllers) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_circle,
                size: 33.0,
              ),
              onPressed: () {
                setState(() {
                  controllers.add(TextEditingController());
                });
              },
            ),
            Expanded(child: Text(label)),
          ],
        ),
        ...controllers.map((controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: 33.0,
                  ),
                  onPressed: () {
                    setState(() {
                      controllers.remove(controller);
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: const InputDecoration(
                      hintText: "Precio",
                      prefixText: "\$",
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
