import 'package:flutter/material.dart';
import 'package:parcial_movile/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parcial_movile/providers/dio_privider.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    super.key,
    required this.route,
    required this.notification,
  });

  final String route;
  final Map<String, dynamic> notification;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    // Extraemos los datos necesarios de la notificación
    final String message = widget.notification['message'] ?? 'Sin mensaje';
    final String detail = widget.notification['detail'] ?? 'Sin detalles';
    final bool state = widget.notification['state'] ?? false;

    final Map<String, dynamic> pacient = widget.notification['pacient'] ?? {};
    final String pacientCI = pacient['ci']?.toString() ?? 'Desconocido';
    final int pacientAge = pacient['age'] ?? 0;
    final String pacientSexo = pacient['sexo'] ?? 'N/A';

    // Fecha
    final List<int> dateList = List<int>.from(widget.notification['date'] ?? []);
    final String formattedDate =
    dateList.isNotEmpty ? '${dateList[2]}-${dateList[1]}-${dateList[0]}' : 'Fecha desconocida';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 130,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white70,

          child:  Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.notifications, // Icono de notificación
                  size: 30,
                  color: state ? Colors.blueAccent : Colors.red, // Cambia el color según prefieras
                ),
              ),
              Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            //color: state ? Colors.black : Colors.red,
                          ),
                        ),
                        Text(
                          ' $formattedDate',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
        onTap: () async{
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';
          final putNoti = await DioProvider().putNotification(widget.notification['id'],token);
          _showNotificationDetails(context, widget.notification);
        },
      ),
    );

  }
}

void _showNotificationDetails(BuildContext context, Map<String, dynamic> notification) {
  final String message = notification['message'] ?? 'Sin mensaje';
  final String detail = notification['detail'] ?? 'Sin detalles';
  final List<int> dateList = List<int>.from(notification['date'] ?? []);
  final String formattedDate =
  dateList.isNotEmpty ? '${dateList[2]}-${dateList[1]}-${dateList[0]}' : 'Fecha desconocida';

  final pacient = notification['pacient'] ?? {};
  final String pacientCI = pacient['ci']?.toString() ?? 'Desconocido';
  final int pacientAge = pacient['age'] ?? 0;
  final String pacientSexo = pacient['sexo'] == 'M' ? 'Masculino' : 'Femenino';
  final user = pacient['user'] ?? {};
  final String pacientName = user['name'] ?? 'Sin nombre';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detalles de la Notificación'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mensaje: $message',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Fecha: $formattedDate'),
              const SizedBox(height: 10),
              Text('Detalles: $detail'),
              const SizedBox(height: 10),
              if (pacient.isNotEmpty) ...[
                Text('Paciente: $pacientName'),
                Text('CI: $pacientCI'),
                Text('Edad: $pacientAge años'),
                Text('Sexo: $pacientSexo'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
