import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  static const String _baseUrl = 'http://192.168.100.50:8080';

  Future<dynamic> getToken (String code, String password) async {
    try{
      var response = await Dio().post('http://192.168.100.50:8080/auth/login',
      data: {'ci': code, 'password': password});
      if (response.statusCode == 200 && response.data != ''){
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setString('token', response.data['data']);
        return response.data;
      }
    }catch (error) {
      return error;
    }
  }

  Future<dynamic> getUser(String token) async {
    try{
      var user = await Dio().get('http://192.168.100.50:8080/api/pacient/get-pacientMovil',
        options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (user.statusCode == 200 && user.data != ''){
        return json.encode(user.data['data']);
      }
    }catch(error) {
     return error;
    }
  }

  Future<dynamic> registerUser(String name, String code,String email, String password) async {
    try{
      var user = await Dio().post('http://192.168.100.50:8080/api/pacient/create',
          data: {'name': name, 'ci': code, 'email': email,'password': password});
      if (user.statusCode == 201 && user.data != ''){
        return true;
      }else {
        return false;
      }
    }catch(error) {
      return error;
    }
  }

  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
   try{
     var response = await Dio().post('http://192.168.100.50:8080/api/time-block/prueba',
         data: {'date1': date, 'day1': day, 'time1': time, 'doctorCi':doctor},
         options: Options(headers: {'Authorization': 'Bearer $token'}));
     if(response.statusCode == 200 && response.data != ''){
       return response.statusCode;
     }else {
       return 'Error';
     }
   }catch (error){
     return error;
   }
  }

  Future<dynamic> getAppointments(String token) async {
    try{
      var response = await Dio().get('$_baseUrl/api/time-block/get-citaPacient',
      options: Options(headers: {'Authorization':'Bearer $token'}));
      if(response.statusCode == 200 && response.data != ''){
        return json.encode(response.data['data']);
      }else {
        return 'Error';
      }

    }catch(error){
      return error;
    }
  }
}

