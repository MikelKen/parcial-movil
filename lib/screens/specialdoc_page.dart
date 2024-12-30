import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial_movile/components/button.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'package:parcial_movile/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';
import 'dart:convert';
import 'dart:math';

class SpecialdocPage extends StatefulWidget {
  const SpecialdocPage({
    super.key,

  });

  @override
  State<SpecialdocPage> createState() => _SpecialdocPageState();
}

class _SpecialdocPageState extends State<SpecialdocPage> {
  bool isFav = false;
  List<dynamic> doctorsSpecial = [];

  Future<void> getDoctorSpecial() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final String speciality = ModalRoute.of(context)!.settings.arguments as String;
    final doctorSpecial = await DioProvider().getDoctorsSpecial(speciality,token);
    if (doctorSpecial != 'Error'){
      setState(() {
        doctorsSpecial = json.decode(doctorSpecial);
        print(doctorsSpecial);
      });
    }
  }

  @override
  void initState() {
    getDoctorSpecial();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Config().init(context);
    String doctorImage = _getDoctorImage();

    final String speciality = ModalRoute.of(context)!.settings.arguments as String;
    bool isEmpty = doctorsSpecial.isEmpty;

    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Lista de medicos: $speciality ',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: isEmpty
        ? Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(20),
            child: Text(
              'No hay doctores medicos en esta especialidad',
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
        padding: const EdgeInsets.all(10),
        itemCount: doctorsSpecial.length,
        itemBuilder: (context, index) {
          final doctorWithDetails = doctorsSpecial[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 180,
            child: GestureDetector(
              child: Card(
                elevation: 15,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: Config.widthSize * 0.30,
                      child: Image.asset(
                        doctorImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Dr. ${doctorWithDetails['nameDoctor']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${doctorWithDetails['speciality']}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 190,
                                  child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Config.primaryColor,
                                        ),
                                      child: const Text(
                                        'Reservar Cita',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: (){
                                        Navigator.of(context).pushNamed(
                                            'booking_page',
                                            arguments: {"doctor_id":doctorWithDetails["id"]}
                                        );
                                      },
                                    ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
              //  Navigator.of(context).pushNamed(route, arguments: doctorWithDetails);
              },
            ),
          );
        },
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