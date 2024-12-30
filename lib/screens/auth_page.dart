import 'package:flutter/material.dart';
import 'package:parcial_movile/components/login_form.dart';
import 'package:parcial_movile/components/sign_up_form.dart';
import 'package:parcial_movile/components/social_button.dart';
import 'package:parcial_movile/utils/text.dart';
import 'package:parcial_movile/utils/config.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key}); // const AuthPage({Key? key}) : super{key:key})

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 1,
          ),
        child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
              Center(
                child: Text(
                  'Bienvenido\nClinica SSVS',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Config.spaceSmall,
              ),

                Text(
                  isSignIn
                  ? 'Inicia sesión en tu cuenta'!//AppText.enText['signIn_text']!
                  : 'Puede registrarse fácilmente y conectarse con los médicos cercanos a usted'!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Config.spaceSmall,
                isSignIn ? LoginForm() : SignUpForm(),
                // Config.spaceSmall,
                isSignIn
                ? Center(
                  child: TextButton(
                      onPressed: (){},
                      child: Text(
                        'Olvidaste tu contraseña',//AppText.enText['forgot-password']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                  ),
                ) : Container(

                ),

                const Spacer(),
                // Center(
                //   child: Text(
                //     'O continuar con la cuenta social',//AppText.enText['social-login']!,
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.normal,
                //       color: Colors.grey.shade500,
                //     ),
                //   ),
                // ),
                // Config.spaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    SocialButton(social: 'google'),
                    SocialButton(social: 'facebook'),
                  ],
                ),
                // Config.spaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isSignIn
                      ? AppText.enText['signUp_text']!
                      : AppText.enText['registered_text']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignIn = !isSignIn;
                        });
                      },
                      child:  Text(
                        isSignIn ? 'Sign Up' : 'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

        ),
      ),

    );
  }




}
