import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportHistorialPDF(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  // Define colores y estilos
  const PdfColor primaryColor = PdfColor(0, 0.6, 0.9); // Azul hospital
  const PdfColor secondaryColor = PdfColor(0.9, 0.9, 0.9); // Gris claro
  const PdfColor blackColor = PdfColor(0, 0, 0);

  final titleStyle = pw.TextStyle(
    color: primaryColor,
    fontSize: 22,
    fontWeight: pw.FontWeight.bold,
  );

  final sectionTitleStyle = pw.TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontWeight: pw.FontWeight.bold,
  );

  final contentStyle = pw.TextStyle(
    fontSize: 12,
    color: blackColor,
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
          color: secondaryColor,
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabecera
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: primaryColor,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Text(
                  'Historial Clínico del Paciente',
                  style: titleStyle.copyWith(color: PdfColors.white),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 20),

              // Datos del paciente
              pw.Text('Datos del Paciente', style: sectionTitleStyle),
              pw.Divider(color: primaryColor),
              pw.Text('Nombre: ${data["medicalRecord"]["pacient"]["name"]}', style: contentStyle),
              pw.Text('CI: ${data["medicalRecord"]["pacient"]["ci"]}', style: contentStyle),
              pw.Text(
                  'Fecha de nacimiento: ${data["medicalRecord"]["pacient"]["dateOfBirth"]}', style: contentStyle),
              pw.Text('Edad: ${data["medicalRecord"]["pacient"]["age"]} años', style: contentStyle),
              pw.Text('Sexo: ${data["medicalRecord"]["pacient"]["sexo"]}', style: contentStyle),
              pw.SizedBox(height: 20),

              // Consulta
              pw.Text('Consulta', style: sectionTitleStyle),
              pw.Divider(color: primaryColor),
              pw.Text('Fecha: ${data["date"]}', style: contentStyle),
              pw.Text('Estado: ${data["state"]}', style: contentStyle),
              pw.Text('Diagnóstico: ${data["diagnosis"]}', style: contentStyle),
              pw.Text('Observaciones: ${data["observation"]}', style: contentStyle),
              pw.SizedBox(height: 20),

              // Exámenes Médicos
              pw.Text('Exámenes Médicos', style: sectionTitleStyle),
              pw.Divider(color: primaryColor),
              if (data["examMedico"] == null || data["examMedico"].isEmpty)
                pw.Text('No tiene exámenes médicos.', style: contentStyle)
              else
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: data["examMedico"].map<pw.Widget>((exam) {
                    return pw.Text(
                        '${exam["type"]}: ${exam["result"] ?? "Sin resultado"}', style: contentStyle);
                  }).toList(),
                ),
              pw.SizedBox(height: 20),

              // Prescripciones
              pw.Text('Prescripciones', style: sectionTitleStyle),
              pw.Divider(color: primaryColor),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: data["prescriptions"].map<pw.Widget>((prescription) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.symmetric(vertical: 5),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      border: pw.Border.all(color: primaryColor, width: 1),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Medicamento: ${prescription["medicine"]}', style: contentStyle),
                        pw.Text('Dosis: ${prescription["dosis"]}', style: contentStyle),
                        pw.Text('Frecuencia: ${prescription["frecuency"]}', style: contentStyle),
                        pw.Text('Duración: ${prescription["duration"]}', style: contentStyle),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    ),
  );

  // Mostrar opciones para guardar o imprimir el PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
