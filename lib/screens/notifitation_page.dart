import 'package:flutter/material.dart';
import 'package:parcial_movile/components/custom_appbar.dart';
import 'package:parcial_movile/components/notification_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> notifications = [];

  Future<void> getNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final notificationPacient = await DioProvider().getNotifications(token);
    if (notificationPacient != 'Error') {
      setState(() {
        notifications = json.decode(notificationPacient);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Notificaciones',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: notifications.isEmpty
          ? Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No tiene notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(
              route: 'notification_detail',
              notification: notification,

          );
        },
      ),
    );
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

    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print(notification);
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
}
