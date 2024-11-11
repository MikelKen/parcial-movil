import 'package:flutter/material.dart';
import 'package:parcial_movile/utils/config.dart';
import 'dart:math';


class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.route,
    required this.doctor
  });

  final String route;

  final Map<String, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    Map<String, dynamic> randomDetail = _getDoctorDetail();

    Map<String, dynamic> doctorWithDetails = {
      ...doctor,
      ...randomDetail,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.asset(
                  doctorWithDetails['profile'],// doctorImage,//'assets/doctor_2.jpg',
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
                          "${doctorWithDetails['speciality']}",//'Dental',
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const<Widget>[
                            Icon(Icons.star_border, color: Colors.yellow, size: 16),
                            Spacer(flex: 1,),
                            Text('4,5'),
                            Spacer(flex: 1,),
                            Text('Reseñas'),
                            Spacer(flex: 1,),
                            Text('(20)'),
                            Spacer(flex: 7,),
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
          Navigator.of(context).pushNamed(route, arguments: doctorWithDetails);
        },  //redirect to doctor detail
      ),
    );
  }
}

Map<String, dynamic> _getDoctorDetail(){

  List<Map<String, dynamic>> detailDoctor = [
    {
      "profile":'assets/doctor_1.jpg',
      "pacients":76,
      "exp": 10 ,
      "calificacion": '4.5',
      "estudio": 'MD (Universidad Autonoma Gabriel Rene Moreno de Bolivia), FACP (Colegio Americano de Médicos, Estados Unidos)',
      "resumen": 'El Dr. Juan Pérez tiene el título de MD de la Universidad Autónoma Gabriel René Moreno, Bolivia, y es miembro del Colegio Americano de Médicos (FACP), Estados Unidos.'
    },
    {
      "profile":'assets/doctor_2.jpg',
      "pacients": 60,
      "exp": 15 ,
      "calificacion": "4.8",
      "estudio": "MD (Universidad Nacional de San Marcos, Perú), FACS (Colegio Americano de Cirujanos, Estados Unidos)",
      "resumen": "El Dr. Ana María Gómez es especialista en cirugía general, con 15 años de experiencia y formación en cirugía avanzada en los EE.UU."
    },
    {
      "profile":'assets/doctor_3.jpg',
      "pacients": 98,
      "exp": 8,
      "calificacion": "4.3",
      "estudio": "MD (Universidad Nacional Autónoma de México), Msc. en Cardiología (Harvard Medical School)",
      "resumen": "La Dra. Laura Rodríguez tiene una Maestría en Cardiología y más de 8 años ayudando a pacientes con enfermedades del corazón."
    },
    {
      "profile":'assets/doctor_4.png',
      "pacients": 45,
      "exp": 12 ,
      "calificacion": "4.7",
      "estudio": "MD (Universidad de Buenos Aires, Argentina), Especialista en Endocrinología",
      "resumen": "El Dr. Ricardo López es especialista en endocrinología, con una trayectoria de más de 12 años, trabajando en el manejo de enfermedades hormonales."
    },
    {
      "profile":'assets/doctor_5.avif',
      "pacients": 200,
      "exp": 20 ,
      "calificacion": "5.0",
      "estudio": "MD (Universidad de Chile), Ph.D. en Oncología (Johns Hopkins University, EE.UU.)",
      "resumen": "El Dr. Carlos Martínez ha dedicado su carrera a la investigación y tratamiento del cáncer, con más de 20 años de experiencia."
    },
    {
      "profile":'assets/doctor_6.webp',
      "pacients": 150,
      "exp": 17,
      "calificacion": "4.6",
      "estudio": "MD (Universidad de La Paz, Bolivia), Fellow en Neurología (Mayo Clinic, EE.UU.)",
      "resumen": "La Dra. Silvia Fernández es experta en neurología y se especializa en el tratamiento de enfermedades del sistema nervioso central."
    },
    {
      "profile":'assets/doctor_7.jpg',
      "pacients": 60,
      "exp": 9 ,
      "calificacion": "4.4",
      "estudio": "MD (Universidad de Lima, Perú), Especialista en Medicina Interna",
      "resumen": "El Dr. Mario Ruiz es especialista en medicina interna, brindando atención integral a pacientes adultos con enfermedades complejas."
    },
    {
      "profile":'assets/doctor_8.jpg',
      "pacients": 75,
      "exp": 13 ,
      "calificacion": "4.9",
      "estudio": "MD (Universidad Nacional de Colombia), Msc. en Pediatría (Universidad de Barcelona)",
      "resumen": "La Dra. Isabel Torres se dedica a la pediatría y tiene experiencia trabajando con niños en diferentes hospitales y clínicas de prestigio."
    },
    {
      "profile":'assets/doctor_9.avif',
      "pacients": 180,
      "exp": 25 ,
      "calificacion": "5.0",
      "estudio": "MD (Universidad de Buenos Aires, Argentina), Especialista en Cirugía Plástica",
      "resumen": "El Dr. Luis Pérez es experto en cirugía plástica, con más de 25 años de experiencia en procedimientos estéticos y reconstructivos."
    },
    {
      "profile":'assets/doctor_5.avif',
      "pacients": 135,
      "exp": 14 ,
      "calificacion": "4.7",
      "estudio": "MD (Universidad Autónoma de Nuevo León, México), Fellow en Ginecología Oncológica (MD Anderson, EE.UU.)",
      "resumen": "La Dra. Mariana Soto se especializa en ginecología oncológica, con una exitosa carrera tratando cáncer ginecológico en mujeres."
    },
    {
      "profile":'assets/doctor_1.jpg',
      "pacients": 110,
      "exp": 18 ,
      "calificacion": "4.6",
      "estudio": "MD (Universidad de Salamanca, España), Fellow en Cirugía Cardiaca (Cleveland Clinic, EE.UU.)",
      "resumen": "El Dr. Eduardo Hernández tiene una extensa carrera en cirugía cardiovascular y se especializa en intervenciones quirúrgicas de alto riesgo."
    }
  ];


  Random random =Random();
  return detailDoctor[random.nextInt(detailDoctor.length)];
}

