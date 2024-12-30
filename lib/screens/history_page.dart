import 'package:flutter/material.dart';
import 'package:parcial_movile/components/history_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'dart:convert';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isFav = false;
  List<dynamic> historialPacient = [];

  Future<void> getHistorialPacient() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final history = await DioProvider().getHistorialPacient(token);
    print ('----------------------------------------------');
    print (history);
    if (history != 'Error'){
      setState(() {
        historialPacient = json.decode(history);
      });
    }
  }



  @override
  void initState() {
    getHistorialPacient();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            children: [
              const Text(
                'Historia Clinica',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
          // Verifica si la lista historialPacient tiene datos
              Expanded(
                child: historialPacient.isEmpty
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
                            'No tiene datos en su historial clínico',
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
                    itemCount: historialPacient.length,
                    itemBuilder: (context, index) {
                      return HistoryCard(
                          route: 'history_detail',
                          historial: historialPacient[index]
                      );
                     },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
