import 'package:flutter/material.dart';
import 'package:parcial_movile/components/button.dart';
import 'package:parcial_movile/main.dart';
import 'package:parcial_movile/models/auth_model.dart';
import 'package:parcial_movile/providers/dio_privider.dart';
import 'package:parcial_movile/utils/config.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _codeController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[
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
           //login button
           Consumer<AuthModel>(
             builder: (context, auth, child) {
               return Button(
                   width: double.infinity,
                   title: 'Sing In',
                   onPressed: () async {
                     final token = await DioProvider().getToken(
                         _codeController.text, _passController.text);
                     if (token.length >= 0) {
                       auth.loginSuccess();
                       MyApp.navigatorKey.currentState!.pushNamed('main');
                     }
                   },
                   disable: false
               );
             },
           )
         ],
        ),
    );
  }
}
