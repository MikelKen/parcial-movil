import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial_movile/components/button.dart';
import 'package:parcial_movile/components/custom_appbar.dart';
import 'package:parcial_movile/main.dart';
import 'package:parcial_movile/models/king_datetime_convert.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'package:parcial_movile/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';


class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  int? _selectedFichaId;
  String? token;

  Map<String,dynamic> hoursDoctor = {};

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }
  Future <void> getHoursDoctor() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    print(doctor);
    final hourDoctor = await DioProvider().getHoursDoctor(doctor['doctor_id'], token);
    if (hourDoctor != 'Error'){
      setState(() {
        hoursDoctor = json.decode(hourDoctor);
        print(hoursDoctor);

      });
    }
  }

  @override
  void initState() {
    getHoursDoctor();
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Programar Cita',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                //table calendar
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Seleccione un Horario',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 30),
                  alignment: Alignment.center,
                  child: const Text(
                    'El fin de semana no está disponible, seleccione otra fecha.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
          )
          : hoursDoctor['fichas'] != null && hoursDoctor['fichas'].isNotEmpty
         ? SliverGrid(
              delegate:SliverChildBuilderDelegate((context, index) {
                final ficha = hoursDoctor['fichas'][index];
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _timeSelected = true;
                      _selectedFichaId = ficha['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                                ? Colors.white
                                : Colors.black
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                            ? Config.primaryColor
                            : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                     // '${ficha['startTime']}',//'${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                          () {
                        if (ficha['turn'] == 'mañana') {
                          return '${index + 8}:00 ${index + 8 > 11 ? "PM" : "AM"}';
                        } else if (ficha['turn'] == 'tarde') {
                          return '${index + 13}:00 ${index + 12 > 11 ? "PM" : "AM"}';
                        } else {
                          return 'Turno no especificado';
                        }
                      }(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: hoursDoctor['fichas'].length,//8,
              ) ,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1.5
              ),
          )
          : SliverToBoxAdapter(
            child: Center(
              child: Text(
                'No hay horarios disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Button(
                  width: double.infinity,
                  title: 'Make appointment', //hacer cita
                  onPressed: () async{
                    final getDate = DateConvert.getDate(_currentDay);
                    final getDay = DateConvert.getDay(_currentDay.weekday);
                    final getTime = DateConvert.getTime(_currentIndex ?? 0);
                    final int fichaId = int.parse(_selectedFichaId.toString());
                    final booking = await DioProvider().reserverAppointment(
                        fichaId, token!);
                    print('----------------');
                    print(booking);
                    if(booking == 200){
                    MyApp.navigatorKey.currentState!.pushNamed('success_booking');
                    }else if(booking is String){
                      print('llelgoo');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.error, color: Colors.redAccent),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  booking,
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
                    }
                  },
                  disable: _timeSelected && _dateSelected ? false : true,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //table calendar
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2025, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      daysOfWeekHeight: 55,
      //--------------------------
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),

      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      //---------------------------
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },

      onFormatChanged: (format) {
        setState(() {
          _format= format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;

          if(selectedDay.weekday == 6 || selectedDay.weekday == 7){
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          }else {
            _isWeekend = false;
          }
        });
      }),
    );
  }
}


