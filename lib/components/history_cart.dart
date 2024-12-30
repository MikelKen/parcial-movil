import 'package:flutter/material.dart';
import 'package:parcial_movile/utils/config.dart';
import 'package:parcial_movile/utils/historial_pdf.dart';


class HistoryCard extends StatefulWidget {
  const HistoryCard({
    super.key,
    required this.route,
    required this.historial,
  });

  final String route;
  final Map<String, dynamic> historial;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 250,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.historial['doctor']['speciality']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Dr. ${widget.historial['doctor']['name']}",//'Dental',
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ScheduleCard(
                          date: widget.historial['date'],
                          day: widget.historial['preConsultation']['day'],
                          time: widget.historial['preConsultation']['hour']
                      ) ,
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Config.primaryColor,
                                ),
                                  onPressed: () async{
                                    await exportHistorialPDF(widget.historial);
                                  },
                                  child: const Text(
                                    'Exportar PDF',
                                    style: TextStyle(color: Colors.white),
                                  ),

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

          Navigator.of(context).pushNamed(widget.route, arguments: widget.historial);

        },  //redirect to doctor detail
      ),
    );
  }
}


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
            size: 10,
          ),
          SizedBox(width: (day == 'Miercoles' || day == 'Domingo') ? 0 : 15),
              // const SizedBox(
              //   width: 15,
              // ),

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