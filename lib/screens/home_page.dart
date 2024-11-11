import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial_movile/components/appointment_card.dart';
import 'package:parcial_movile/components/doctor_card.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'package:parcial_movile/utils/config.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String,dynamic> user = {};
  Map<String,dynamic> appointments = {};

  List<Map<String, dynamic>> medCat = [
    {
      "icon":FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon":FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon":FontAwesomeIcons.lungs,
      "category": "Respirations",
    },
    {
      "icon":FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon":FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon":FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if(token.isNotEmpty && token != ''){
      final response = await DioProvider().getUser(token);
      if(response != null){
        setState(() {
         user = json.decode(response);
         //appointments = ;//user['appointment'];
         for(var appointmentData in user['appointment']){
           if(appointmentData != null){
             appointments = appointmentData;
             print('############################334');
             print(appointments);
           }
         }
         //print(appointments);
          print(user);
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: user.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )

          : Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  <Widget>[
                        Text(
                          user['name'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/profile.jpg'),
                          ),
                        ),
                      ],
                    ),
                    Config.spaceMedium,
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.spaceSmall,
                    SizedBox(
                      height: Config.heightSize * 0.06,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List<Widget>.generate(medCat.length, (index) {
                          return Card(
                            margin: const EdgeInsets.only(right: 20),
                            color: Config.primaryColor,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FaIcon(
                                      medCat[index]['icon'],
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      medCat[index]['category'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Config.spaceSmall,
                    const Text(
                      'Cita de Hoy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.spaceSmall,
                    appointments.isNotEmpty
                    ? AppointmentCard(
                        appointment: appointments,
                        color: Config.primaryColor,
                    )
                   : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No tiene citas para hoy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Config.spaceSmall,
                    const Text(
                      'Lista de Doctores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.spaceSmall,
                    Column(
                      children: List.generate(user['doctor'].length, (index) {
                        return DoctorCard(
                          route: 'doc_details',
                          doctor: user['doctor'][index]
                        );
                      }),
                    ),
                  ],
                ),
              ),
          ),
      ),
    );
  }
}
