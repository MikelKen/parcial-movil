import 'package:intl/intl.dart';

class DateConvert{
  static String getDate(DateTime date){
    return DateFormat.yMd().format(date);
  }

  static String getDay(int day){
    switch (day) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miercoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sabado';
      case 7:
        return 'Domingo';
      default:
        return 'Domingo';
    }
  }

  static String getTime(int time){
    switch (time){
      case 0:
        return '08:00 AM';
      case 1:
        return '09:00 AM';
      case 2:
        return '10:00 AM';
      case 3:
        return '11:00 AM';
      case 4:
        return '12:00 PM';
      case 5:
        return '13:00 PM';
      case 6:
        return '14:00 PM';
      case 7:
        return '15:00 PM';
      case 8:
        return '16:00 PM';
      default:
        return '08:00 AM';
    }
  }
}