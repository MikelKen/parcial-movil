import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial_movile/utils/config.dart';

class HistorialDetail extends StatefulWidget {
  const HistorialDetail({super.key});

  @override
  State<HistorialDetail> createState() => _HistorialDetailState();
}

class _HistorialDetailState extends State<HistorialDetail> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    final history = ModalRoute.of(context)!.settings.arguments as Map;
    final pacient = history["medicalRecord"]["pacient"];
    final doctor = history["doctor"];
    final preConsultation = history["preConsultation"];
    final prescriptions =  history["prescriptions"] as List;

    print(preConsultation);
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Detalles del Historial',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Historial Clínico del Paciente'),
            const Divider(),
            _buildSubHeader('Datos del Paciente'),
            _buildRow('Nombre completo:', pacient["name"]),
            _buildRow('CI:', pacient["ci"].toString()),
            _buildRow('Fecha de nacimiento:', pacient["dateOfBirth"]),
            _buildRow('Edad:', '${pacient["age"]} años'),
            _buildRow('Sexo:', pacient["sexo"]),
            const Divider(),
            _buildSubHeader('Datos de la Consulta'),
            _buildRow('Fecha de consulta:', history["date"]),
            _buildRow('Estado:', history["state"]),
            _buildRow('Diagnóstico:', history["diagnosis"]),
            _buildRow('Observaciones:', history["observation"]),
            const Divider(),
            _buildSubHeader('Médico Responsable'),
            _buildRow('Nombre:', doctor["name"]),
            _buildRow('Especialidad:', doctor["speciality"]),
            const Divider(),
            _buildSubHeader('Signos Vitales'),
            _buildRow('Día:', preConsultation["day"]),
            _buildRow('Hora:', preConsultation["hour"]),
            _buildRow('Frecuencia cardíaca:', '${preConsultation["heartRate"]} BPM'),
            _buildRow('Presión arterial:', preConsultation["arterialPressure"]),
            _buildRow('Temperatura:', '${preConsultation["temperature"]} °C'),
            _buildRow('Peso:', '${preConsultation["weight"]} kg'),
            _buildRow('Enfermera:', preConsultation["enfermera"]["name"]),
            const Divider(),
            _buildSubHeader('Exámenes Médicos'),
            _buildExamMedico(history["examMedico"]),
            const Divider(),
            _buildSubHeader('Recetas Medicas'),
            ...prescriptions.map((prescription) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPrescription(prescription),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}


Widget _buildHeader(String text){
  return Center(
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildSubHeader(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Config.primaryColor,
      ),
    ),
  );
}

Widget _buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

Widget _buildExamMedico(List? exams) {
  if (exams == null || exams.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'No tiene exámenes médicos.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
  return Column(
    children: exams.map((exam) {
      return _buildRow(
        'Tipo de examen',
        '${exam["type"]} - Resultado: ${exam["result"]}',
      );
    }).toList(),
  );
}

Widget _buildPrescription(Map<String, dynamic> prescription) {
  if (prescription == null || prescription.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'No tiene recetas médicas.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
  return Card(
    color: Colors.grey[100],
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medicamento: ${prescription["medicine"]}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Dosis: ${prescription["dosis"]}'),
          Text('Frecuencia: ${prescription["frecuency"]}'),
          Text('Duración: ${prescription["duration"]}'),
          Text('Observaciones: ${prescription["observation"]}'),
        ],
      ),
    ),
  );
}


