import 'dart:convert';
import 'package:doctor_appointment_app/components/button.dart';
import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/provider/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.PrimaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.PrimaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.PrimaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Config.PrimaryColor,
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
                        color: Config.PrimaryColor,
                      ),
              ),
            ),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  try {
                    // Obtener el token
                    final token = await DioProvider().getToken(
                        _emailController.text, _passController.text);
                    print('Token: $token'); // Depuración

                    // Verificar y guardar el token
                    if (token != null && !token.toString().startsWith('DioError')) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('token', token); // Guardar el token
                      final tokenValue = prefs.getString('token');
                      print('Token Value from SharedPreferences: $tokenValue'); // Depuración

                      // Obtener datos del usuario
                      if (tokenValue != null && tokenValue.isNotEmpty) {
                        final response = await DioProvider().getUser(tokenValue);
                        print('User Response: $response'); // Depuración

                        if (response != null && !response.toString().startsWith('DioError')) {
                          setState(() {
                            Map<String, dynamic> appointment = {};
                            final user = json.decode(response);

                            for (var doctorData in user['doctor']) {
                              if (doctorData['appointments'] != null) {
                                appointment = doctorData;
                              }
                            }

                            auth.loginSuccess(user, appointment);
                            MyApp.navigatorKey.currentState!.pushNamed('main');
                          });
                        }
                      }
                    } else {
                      print('Token is null or an error occurred');
                    }
                  } catch (e) {
                    print('Error: $e');
                    // Aquí puedes mostrar un mensaje de error al usuario
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}


