import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial_movile/utils/config.dart';

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({super.key});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  @override
  Widget build(BuildContext context) {
    final notification = ModalRoute.of(context)!.settings.arguments as Map;
    return  SafeArea(
       child: Text(
         'Notificaion'
       ),
    );
  }
}
