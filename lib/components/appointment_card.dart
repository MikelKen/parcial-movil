import 'package:flutter/material.dart';
import 'package:parcial_movile/utils/config.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'dart:math';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.color,
    required this.token,
  });

  final Map<String, dynamic> appointment; //doctor
  final Color color;
  final String token;
  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  int? _selectedFichaId;
  @override
  Widget build(BuildContext context) {
    String doctorImage = _getDoctorImage();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,//Config.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
             Row(
               children: [
                 CircleAvatar(
                   backgroundImage:
                   AssetImage(doctorImage),
                 ),
                 const SizedBox(width: 10,),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children:  <Widget>[
                     Text(
                       'Dr. ${widget.appointment['nameDoctor']}',
                       style: const TextStyle(color: Colors.white),
                     ),
                     const SizedBox(
                       height: 2,
                     ),
                     Text(
                       widget.appointment['speciality'],
                       style: const TextStyle(color: Colors.black),
                     ),
                   ],
                 ),
               ],
             ),
              Config.spaceSmall,
              ScheduleCard(
                appointment: widget.appointment,
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          _selectedFichaId = widget.appointment['id'];
                          print(_selectedFichaId);
                          final int fichaId = int.parse(_selectedFichaId.toString());
                          final canceled = await DioProvider().canceledAppointment(fichaId,widget.token!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.error, color: Colors.redAccent),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      canceled,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.black87,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          },
                      ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white38,
                      ),
                      child: const Text(
                        'Completar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Schedule Widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.appointment,
  });
  final Map<String, dynamic> appointment;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            '${appointment['day']}, ${appointment['date']}',//'Lunes, 11/04/2024',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
              child: Text(
                appointment['starTime'],//'2:00 PM',
                style: const TextStyle(color: Colors.white),
              ),
          ),
        ],
      ),
    );
  }
}

String _getDoctorImage() {

  List<String> imageOptions = [
    'assets/doctor_1.jpg',
    'assets/doctor_2.jpg',
    'assets/doctor_3.jpg',
    'assets/doctor_4.png',
    'assets/doctor_5.avif',
    'assets/doctor_6.webp',
    'assets/doctor_7.jpg',
    'assets/doctor_8.jpg',
    'assets/doctor_9.avif',
  ];

  Random random = Random();
  return imageOptions[random.nextInt(imageOptions.length)];
}
