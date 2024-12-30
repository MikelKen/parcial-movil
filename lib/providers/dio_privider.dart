import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
 //static const String _baseUrl = 'http://192.168.100.121:8080';
  static const String _baseUrl = 'https://imports-bacteria-lebanon-limited.trycloudflare.com';

  Future<dynamic> getToken (String code, String password) async {
    try{
      var response = await Dio().post('$_baseUrl/auth/login',
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
      var user = await Dio().get('$_baseUrl/api/pacient/get-pacientMovil',
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
      var user = await Dio().post('$_baseUrl/api/pacient/create',
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
     var response = await Dio().post('$_baseUrl/api/time-block/prueba',
         data: {'date1': date, 'day1': day, 'time1': time, 'doctorCi':doctor},
         options: Options(headers: {'Authorization': 'Bearer $token'}));
     print('estoson: ');
     print(response.data);
     // if(response.statusCode == 200 && response.data != ''){
     //   return response.statusCode;
     // }else {
     //   return 'Error';
     // }
     if(response.statusCode == 200 && response.data['success'] == true){
       print('entro111');
       return response.statusCode;
     }else{
       print('entro');
       return response.data['message'];
     }
   }catch (error){
     print('entro33');
     return error;
   }
  }
  Future<dynamic> reserverAppointment(int fichId, String token) async {
    try{
      var response = await Dio().post('$_baseUrl/api/time-block/prueba',
          data: {'fichaId':fichId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      print(response);
      if(response.statusCode == 200 && response.data['success'] == true){
        print('entro111');
        return response.statusCode;
      }else{
        print('entro');
        return response.data['message'];
      }
    }catch (error){
      return error;
    }
  }

  Future<dynamic> canceledAppointment(int fichId, String token) async {
    try{
      var response = await Dio().post('$_baseUrl/api/time-block/cancelarFich',
          data: {'fichaId':fichId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      print(response);
      if(response.statusCode == 200 && response.data['success'] == true){
        print('entro111');
        return response.data['message'];
      }else{
        print('entro');
        return response.data['message'];
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
  
  Future<dynamic> getDoctorsSpecial(String speciality, String token) async{
    try{
      var response = await Dio().get('$_baseUrl/api/doctor/get-doctorSpecial',
          data: {'speciality': speciality},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if(response.statusCode == 200 && response.data !=''){
        return json.encode(response.data['data']);
      }else{
        return 'Error';
    }
    }catch(error){
      return error;
    }
  }

  Future<dynamic> getHoursDoctor(int doctor, String token) async{

    try{

      var response = await Dio().get('$_baseUrl/api/time-block/get-allDispon/$doctor',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if(response.statusCode == 200 && response.data !=''){
        return json.encode(response.data['data']);
      }else{
        return 'Error';
      }
    }catch(error){
      return error;
    }
  }

  Future<dynamic> getHistorialPacient(String token) async{

    try{

      var response = await Dio().get('$_baseUrl/api/consult/get-consultHistori',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if(response.statusCode == 200 && response.data !=''){
        return json.encode(response.data['data']);
      }else{
        return 'Error';
      }
    }catch(error){
      return error;
    }
  }

  Future<dynamic> getNotifications(String token) async{
    try{
      var response = await Dio().get('$_baseUrl/api/notification/get-notifPacient',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if(response.statusCode == 200 && response.data !=''){
        return json.encode(response.data['data']);
      }else{
        return 'Error';
      }
    }catch(error){
      return error;
    }
  }

  Future<dynamic> putNotification(int id, String token) async {
    try{
      var response = await Dio().put('$_baseUrl/api/notification/put-notifPacient/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      print(response);
      if(response.statusCode == 200 && response.data['success'] == true){
        print('entro111');
        return response.data['message'];
      }else{
        print('entro');
        return response.data['message'];
      }
    }catch (error){
      return error;
    }
  }

}

