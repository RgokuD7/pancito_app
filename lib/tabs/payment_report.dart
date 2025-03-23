import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/delivery_detail_dialog.dart';
import '../widgets/payment_detail_dialog.dart';
import '../widgets/client_prices_dialog.dart';
import '../models/delivery_day.dart';
import '../utils/date_utils.dart';
import 'package:intl/intl.dart';

class PaymentReportPage extends StatefulWidget {
  const PaymentReportPage({super.key});

  @override
  _PaymentReportPageState createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
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
              SizedBox(width: 40),
          ],
        ),
      ),
      body: FutureBuilder<List<DeliveryDay?>>(
        future: Future.wait(appState.clients.map((client) {
          final day = DateFormat('yyyy-MM-dd').format(selectedDate);
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
          return Card(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Reporte de Pago'),
              trailing: Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
