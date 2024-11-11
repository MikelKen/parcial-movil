import 'package:flutter/material.dart';
import 'package:parcial_movile/components/button.dart';
import 'package:parcial_movile/main.dart';
import 'package:parcial_movile/models/auth_model.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'package:provider/provider.dart';

import '../utils/config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  //final _ciController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexoController = TextEditingController();
  final _passController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Nombre',
                  labelText: 'Nombre',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.person_2_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Código de Usuario',
                  labelText: 'Código',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.verified_user_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _passController,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Config.primaryColor,
                obscureText: obsecurePass,
                decoration:  InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    prefixIconColor: Config.primaryColor,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecurePass = !obsecurePass;
                          });
                        },
                        icon: obsecurePass
                            ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black38,
                        )
                            : const Icon(
                          Icons.visibility_outlined,
                          color: Config.primaryColor,
                        ))),
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  labelText: 'Email',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.email_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _dateOfBirthController,
                keyboardType: TextInputType.datetime,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Fecha de Nacimiento (dd/mm/yyyy)',
                  labelText: 'Fecha de Nacimiento',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Edad',
                  labelText: 'Edad',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.calendar_view_day_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
              ),
              Config.spaceSmall,
              TextFormField(
                controller: _sexoController,
                keyboardType: TextInputType.text,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Sexo',
                  labelText: 'Sexo',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.wc_outlined),
                  prefixIconColor: Config.primaryColor,
                ),
              ),
              Config.spaceSmall,
              //login button
              Consumer<AuthModel>(
                builder: (context, auth, child) {
                  return Button(
                      width: double.infinity,
                      title: 'Sing Up',
                      onPressed: () async {
                        final userResgister = await DioProvider().registerUser(
                            _nameController.text,
                            _codeController.text,
                            _emailController.text,
                            _passController.text);
                        if(userResgister){
                          final token = await DioProvider().getToken(_codeController.text, _passController.text);
                          if (token.length >= 0) {
                            auth.loginSuccess();
                            MyApp.navigatorKey.currentState!.pushNamed('main');
                          }
                        } else {
                          print('register not successfull');
                        }
                      },
                      disable: false
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
