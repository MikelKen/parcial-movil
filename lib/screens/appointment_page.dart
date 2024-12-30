import 'package:flutter/material.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'package:parcial_movile/utils/config.dart';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus {RESERVADO, COMPLETADO, CANCELADO}

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.RESERVADO;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];
  int? _selectedFichaId;
  String? token;

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }
  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointments(token);
    if (appointment != 'Error'){
      setState(() {
        schedules = json.decode(appointment);
        print('------------------------------------------------');
        print(schedules);
      });
    }
  }

  @override
  void initState() {
    getAppointments();
    getToken();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<dynamic> filterSchedules = schedules.where((var schedule) {
      switch (schedule['status']) {
        case 'RESERVADO':
          schedule['status'] = FilterStatus.RESERVADO;//schedule['status'] = FilterStatus.RESERVADO;
          break;
        case 'COMPLETADO':
          schedule['status'] = FilterStatus.COMPLETADO;
          break;
        case 'CANCELADO':
          schedule['status'] = FilterStatus.CANCELADO;
          break;
      }
      return schedule['status'] == status;
    }).toList();
    String doctorImage = _getDoctorImage();
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
             const Text(
                'Calendario de citas',//'''Appointment Schedule',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (FilterStatus filterStatus in FilterStatus.values)
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if(filterStatus == FilterStatus.RESERVADO) {
                                      status = FilterStatus.RESERVADO;
                                      _alignment = Alignment.centerLeft;
                                    }else if(filterStatus == FilterStatus.COMPLETADO) {
                                      status = FilterStatus.COMPLETADO;
                                      _alignment = Alignment.center;
                                    }else if(filterStatus == FilterStatus.CANCELADO) {
                                      status = FilterStatus.CANCELADO;
                                      _alignment = Alignment.centerRight;
                                    }
                                  });
                                },
                                child: Center(
                                  child: Text(filterStatus.name),
                                ),
                              ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    alignment: _alignment,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Config.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Config.spaceSmall,
              Expanded(
                  child: ListView.builder(
                    itemCount: filterSchedules.length,
                    itemBuilder: ((context, index) {
                      var schedule = filterSchedules[index];
                      bool isLastElement = filterSchedules.length + 1 == index;
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: !isLastElement
                              ? const EdgeInsets.only(bottom: 20)
                              : EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(doctorImage),//_schedule['doctor_profile']),
                                  ),
                                  //Config.spaceSmall,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule['nameDoctor'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        schedule['speciality'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ScheduleCard(
                                date: schedule['date'],
                                day: schedule['dayWeek'],
                                time: schedule['startTime'],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          _selectedFichaId = schedule['id'];
                                         print(_selectedFichaId);
                                          final int fichaId = int.parse(_selectedFichaId.toString());
                                          final canceled = await DioProvider().canceledAppointment(fichaId,token!);
                                          print('&&&&&&&&&&&&&&&&&&&&&&&&&7');
                                          print(canceled);
                                          await getAppointments();
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
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Config.primaryColor),
                                        ),
                                      ),
                                  ),
                                  const SizedBox(width: 20,),
                                  Expanded(
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Config.primaryColor,
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          'Reprogramar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
              ),
            ],
          ),
        ),
    );
  }
}

//Schedule Widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.date,
    required this.day,
    required this.time,
  });
  final String date;
  final String day;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,  //---------------
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            '$day, $date',//'Lunes, 11/04/2024',
            style: const TextStyle(color: Config.primaryColor),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              time,//'2:00 PM',
              style: const TextStyle(color: Config.primaryColor),
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
