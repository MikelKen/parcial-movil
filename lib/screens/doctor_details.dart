import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial_movile/components/button.dart';
import 'package:parcial_movile/utils/config.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
  final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Detalles del Medico',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isFav = !isFav;
                });
              },
              icon: FaIcon(
                isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                color: Colors.red,
              ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              AboutDoctor(doctor: doctor,),
              DetailBody(doctor: doctor,),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(20),
                child: Button(
                    width: double.infinity,
                    title: 'Reservar Cita', //book appointment
                    onPressed: () {
                      //navigator
                      Navigator.of(context).pushNamed(
                          'booking_page',
                          arguments: {"doctor_id": doctor["ci"]}
                      );
                    },
                    disable: false,
                ),
              ),
            ],
          ),
      ),
    );
  }
}


class AboutDoctor extends StatelessWidget {
  const AboutDoctor({
    super.key,
    required this.doctor,
  });
final Map<dynamic,dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
           CircleAvatar(
            radius: 65.0,
            backgroundImage: AssetImage( doctor['profile']),//('assets/doctor_2.jpg'),
            backgroundColor: Colors.white,
          ),
          //Config.spaceSmall,
          SizedBox(width: 5,),
          Text(
            'Dr. ${doctor['nameDoctor']}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
         //Config.spaceSmall,
          SizedBox(width: 10,),
          SizedBox(
            width: Config.widthSize * 0.90,
            child: const Text(
              'MD (Universidad Autonoma Gabriel Rene Moreno de Bolivia), FACP (Colegio Americano de Médicos, Estados Unidos)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          //Config.spaceSmall,
          SizedBox(width: 5,),
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Hospital General',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({
    super.key,
    required this.doctor,
  });

  final Map<dynamic,dynamic> doctor;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
     // margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Config.spaceSmall,
          SizedBox(width: 5,),
          DoctorInfo(
            pacients: doctor['pacients'],
            exp: doctor['exp'],
          ),
          Config.spaceSmall,
          const Text(
            'Acerca de Medico',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          //Config.spaceSmall,
          SizedBox(width: 5,),
          Text(
            'El Dr. ${doctor['nameDoctor']} tiene experiencia en ${doctor['speciality']}, el título de MD de la Universidad Autónoma Gabriel René Moreno, Bolivia, y es miembro del Colegio Americano de Médicos (FACP), Estados Unidos.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}


class DoctorInfo extends StatelessWidget {
  const DoctorInfo({
    super.key,
    required this.pacients,
    required this.exp,
  });

  final int pacients;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
     children: <Widget>[
       InfoCart(
           label:'Pacientes' ,
           value: '$pacients'
       ),
       SizedBox(width: 15,),
       InfoCart(
           label:'Experiencia' ,
           value: '$exp años'
       ),
       SizedBox(width: 15,),
       InfoCart(
           label:'Calificacion' ,
           value: '4.6'
       ),
       SizedBox(width: 15,),
     ],
    );
  }
}


class InfoCart extends StatelessWidget {
  const InfoCart({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children:  <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
