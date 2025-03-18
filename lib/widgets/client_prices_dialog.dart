import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/client_bread_prices.dart';
import '../utils/currency_formatter.dart';

class ClientPricesDialog extends StatefulWidget {
  final String clientId;

  ClientPricesDialog({required this.clientId});

  @override
  _ClientPricesDialogState createState() => _ClientPricesDialogState();
}

class _ClientPricesDialogState extends State<ClientPricesDialog> {
  late TextEditingController basicBreadPriceController;
  late TextEditingController lenguaBreadPriceController;
  late TextEditingController fricaBreadPriceController;
  late TextEditingController moldeBreadPriceController;
  late TextEditingController integralBreadPriceController;

  late bool isBasicBreadActive;
  late bool isLenguaBreadActive;
  late bool isFricaBreadActive;
  late bool isMoldeBreadActive;
  late bool isIntegralBreadActive;

  late bool isBasicBreadSameAsUser;
  late bool isLenguaBreadSameAsUser;
  late bool isFricaBreadSameAsUser;
  late bool isMoldeBreadSameAsUser;
  late bool isIntegralBreadSameAsUser;

  late bool isSpecialBreadActive;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final client =
        appState.clients.firstWhere((client) => client.id == widget.clientId);
    final breadPrices = client.breadPrices!;
    final userBreadPrices = appState.currentUser!.breadPrices;

    basicBreadPriceController = TextEditingController(
        text: CurrencyInputFormatter()
            .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue(
                    text: breadPrices.basicBreadPrice[0] == 0
                        ? userBreadPrices?.basicBreadPrice[
                                    breadPrices.basicBreadPrice[1]]
                                .toString() ??
                            '0'
                        : breadPrices.basicBreadPrice[0].toString()))
            .text);
    lenguaBreadPriceController = TextEditingController(
        text: CurrencyInputFormatter()
            .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue(
                    text: breadPrices.lenguaBreadPrice[0] == 0
                        ? userBreadPrices?.lenguaBreadPrice[
                                    breadPrices.lenguaBreadPrice[1]]
                                .toString() ??
                            '0'
                        : breadPrices.lenguaBreadPrice[0].toString()))
            .text);
    fricaBreadPriceController = TextEditingController(
        text: CurrencyInputFormatter()
            .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue(
                    text: breadPrices.fricaBreadPrice[0] == 0
                        ? userBreadPrices?.fricaBreadPrice[
                                    breadPrices.fricaBreadPrice[1]]
                                .toString() ??
                            '0'
                        : breadPrices.fricaBreadPrice[0].toString()))
            .text);
    moldeBreadPriceController = TextEditingController(
        text: CurrencyInputFormatter()
            .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue(
                    text: breadPrices.moldeBreadPrice[0] == 0
                        ? userBreadPrices?.moldeBreadPrice[
                                    breadPrices.moldeBreadPrice[1]]
                                .toString() ??
                            '0'
                        : breadPrices.moldeBreadPrice[0].toString()))
            .text);
    integralBreadPriceController = TextEditingController(
        text: CurrencyInputFormatter()
            .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue(
                    text: breadPrices.integralBreadPrice[0] == 0
                        ? userBreadPrices?.integralBreadPrice[
                                    breadPrices.integralBreadPrice[1]]
                                .toString() ??
                            '0'
                        : breadPrices.integralBreadPrice[0].toString()))
            .text);

    isBasicBreadActive = breadPrices.basicBreadPrice[2];
    isLenguaBreadActive = breadPrices.lenguaBreadPrice[2];
    isFricaBreadActive = breadPrices.fricaBreadPrice[2];
    isMoldeBreadActive = breadPrices.moldeBreadPrice[2];
    isIntegralBreadActive = breadPrices.integralBreadPrice[2];

    isBasicBreadSameAsUser = breadPrices.basicBreadPrice[0] == 0;
    isLenguaBreadSameAsUser = breadPrices.lenguaBreadPrice[0] == 0;
    isFricaBreadSameAsUser = breadPrices.fricaBreadPrice[0] == 0;
    isMoldeBreadSameAsUser = breadPrices.moldeBreadPrice[0] == 0;
    isIntegralBreadSameAsUser = breadPrices.integralBreadPrice[0] == 0;

    isSpecialBreadActive = breadPrices.isSpecialBreadActive;

    // Add listeners to detect changes in the text fields
    basicBreadPriceController.addListener(() {
      if (isBasicBreadSameAsUser && basicBreadPriceController.text.isNotEmpty) {
        setState(() {
          isBasicBreadSameAsUser = false;
        });
      }
    });
    lenguaBreadPriceController.addListener(() {
      if (isLenguaBreadSameAsUser &&
          lenguaBreadPriceController.text.isNotEmpty) {
        setState(() {
          isLenguaBreadSameAsUser = false;
        });
      }
    });
    fricaBreadPriceController.addListener(() {
      if (isFricaBreadSameAsUser && fricaBreadPriceController.text.isNotEmpty) {
        setState(() {
          isFricaBreadSameAsUser = false;
        });
      }
    });
    moldeBreadPriceController.addListener(() {
      if (isMoldeBreadSameAsUser && moldeBreadPriceController.text.isNotEmpty) {
        setState(() {
          isMoldeBreadSameAsUser = false;
        });
      }
    });
    integralBreadPriceController.addListener(() {
      if (isIntegralBreadSameAsUser &&
          integralBreadPriceController.text.isNotEmpty) {
        setState(() {
          isIntegralBreadSameAsUser = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userBreadPrices = appState.currentUser!.breadPrices;
    final client =
        appState.clients.firstWhere((client) => client.id == widget.clientId);

    return AlertDialog(
      title: Text(
        "Precios del Pan para ${client.name}",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceRow(
              "Pan Corriente",
              basicBreadPriceController,
              isBasicBreadActive,
              isBasicBreadSameAsUser,
              (value) => setState(() => isBasicBreadActive = value),
              (value) => setState(() => isBasicBreadSameAsUser = value),
              userBreadPrices?.basicBreadPrice ?? [],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pan Especial"),
                SizedBox(width: 22),
                Switch(
                  value: isSpecialBreadActive,
                  onChanged: (value) {
                    setState(() {
                      isSpecialBreadActive = value;
                      isLenguaBreadActive = value;
                      isFricaBreadActive = value;
                      isMoldeBreadActive = value;
                      isIntegralBreadActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildPriceRow(
              "Pan Lengua",
              lenguaBreadPriceController,
              isLenguaBreadActive,
              isLenguaBreadSameAsUser,
              (value) {
                setState(() {
                  isLenguaBreadActive = value;
                });
              },
              (value) => setState(() => isLenguaBreadSameAsUser = value),
              userBreadPrices?.lenguaBreadPrice ?? [],
            ),
            const SizedBox(height: 10),
            _buildPriceRow(
              "Pan Frica",
              fricaBreadPriceController,
              isFricaBreadActive,
              isFricaBreadSameAsUser,
              (value) {
                setState(() {
                  isFricaBreadActive = value;
                });
              },
              (value) => setState(() => isFricaBreadSameAsUser = value),
              userBreadPrices?.fricaBreadPrice ?? [],
            ),
            const SizedBox(height: 10),
            _buildPriceRow(
              "Pan Molde",
              moldeBreadPriceController,
              isMoldeBreadActive,
              isMoldeBreadSameAsUser,
              (value) {
                setState(() {
                  isMoldeBreadActive = value;
                });
              },
              (value) => setState(() => isMoldeBreadSameAsUser = value),
              userBreadPrices?.moldeBreadPrice ?? [],
            ),
            const SizedBox(height: 10),
            _buildPriceRow(
              "Pan Integral",
              integralBreadPriceController,
              isIntegralBreadActive,
              isIntegralBreadSameAsUser,
              (value) {
                setState(() {
                  isIntegralBreadActive = value;
                });
              },
              (value) => setState(() => isIntegralBreadSameAsUser = value),
              userBreadPrices?.integralBreadPrice ?? [],
            ),
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
            final breadPrices = ClientBreadPrices(
              basicBreadPrice: [
                isBasicBreadSameAsUser
                    ? 0
                    : int.tryParse(removeCurrencyFormat(
                            basicBreadPriceController.text)) ??
                        0,
                isBasicBreadSameAsUser
                    ? userBreadPrices?.basicBreadPrice.indexOf(int.tryParse(
                                removeCurrencyFormat(
                                    basicBreadPriceController.text)) ??
                            0) ??
                        0
                    : 0,
                isBasicBreadActive
              ],
              lenguaBreadPrice: [
                isLenguaBreadSameAsUser
                    ? 0
                    : int.tryParse(removeCurrencyFormat(
                            lenguaBreadPriceController.text)) ??
                        0,
                isLenguaBreadSameAsUser
                    ? userBreadPrices?.lenguaBreadPrice.indexOf(int.tryParse(
                                removeCurrencyFormat(
                                    lenguaBreadPriceController.text)) ??
                            0) ??
                        0
                    : 0,
                isLenguaBreadActive
              ],
              fricaBreadPrice: [
                isFricaBreadSameAsUser
                    ? 0
                    : int.tryParse(removeCurrencyFormat(
                            fricaBreadPriceController.text)) ??
                        0,
                isFricaBreadSameAsUser
                    ? userBreadPrices?.fricaBreadPrice.indexOf(int.tryParse(
                                removeCurrencyFormat(
                                    fricaBreadPriceController.text)) ??
                            0) ??
                        0
                    : 0,
                isFricaBreadActive
              ],
              moldeBreadPrice: [
                isMoldeBreadSameAsUser
                    ? 0
                    : int.tryParse(removeCurrencyFormat(
                            moldeBreadPriceController.text)) ??
                        0,
                isMoldeBreadSameAsUser
                    ? userBreadPrices?.moldeBreadPrice.indexOf(int.tryParse(
                                removeCurrencyFormat(
                                    moldeBreadPriceController.text)) ??
                            0) ??
                        0
                    : 0,
                isMoldeBreadActive
              ],
              integralBreadPrice: [
                isIntegralBreadSameAsUser
                    ? 0
                    : int.tryParse(removeCurrencyFormat(
                            integralBreadPriceController.text)) ??
                        0,
                isIntegralBreadSameAsUser
                    ? userBreadPrices?.integralBreadPrice.indexOf(int.tryParse(
                                removeCurrencyFormat(
                                    integralBreadPriceController.text)) ??
                            0) ??
                        0
                    : 0,
                isIntegralBreadActive
              ],
              isSpecialBreadActive:
                  isSpecialBreadActive, // Guardar el estado de isSpecialBreadActive
            );

            final client = appState.clients
                .firstWhere((client) => client.id == widget.clientId);
            client.breadPrices = breadPrices;
            appState.updateClient(client);

            Navigator.of(context).pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    TextEditingController controller,
    bool isActive,
    bool isSameAsUser,
    ValueChanged<bool> onActiveChanged,
    ValueChanged<bool> onSameAsUserChanged,
    List<int> userPrices,
  ) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
            decoration: const InputDecoration(
              hintText: "Precio",
              prefixText: "\$",
            ),
            enabled: isActive,
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () {
            if (isActive) {
              _showUserPricesDialog(
                  userPrices, controller, onSameAsUserChanged);
            }
          },
        ),
        Switch(
          value: isActive,
          onChanged: (value) {
            setState(() {
              onActiveChanged(value);
              if (value) {
                if (isLenguaBreadActive ||
                    isFricaBreadActive ||
                    isMoldeBreadActive ||
                    isIntegralBreadActive) {
                  isSpecialBreadActive = true;
                }
              } else {
                if (!isLenguaBreadActive &&
                    !isFricaBreadActive &&
                    !isMoldeBreadActive &&
                    !isIntegralBreadActive) {
                  isSpecialBreadActive = false;
                }
              }
            });
          },
        ),
      ],
    );
  }

  void _showUserPricesDialog(
      List<int> userPrices,
      TextEditingController controller,
      ValueChanged<bool> onSameAsUserChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Precios preestablecidos"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: userPrices.asMap().entries.map((entry) {
                int index = entry.key;
                int price = entry.value;
                String formattedPrice = CurrencyInputFormatter()
                    .formatEditUpdate(TextEditingValue.empty,
                        TextEditingValue(text: price.toString()))
                    .text;
                return ListTile(
                  title: Text('Pan corriente ${index + 1}:  \$$formattedPrice'),
                  onTap: () {
                    setState(() {
                      controller.text = price.toString();
                      onSameAsUserChanged(true);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
