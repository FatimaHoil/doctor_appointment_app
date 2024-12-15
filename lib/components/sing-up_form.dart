// Importaciones necesarias para el funcionamiento de la aplicación
import 'package:doctor_appointment_app/components/button.dart';
import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/provider/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/config.dart';

// Definición del widget de formulario de registro
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

// Estado del widget SignUpForm
class _SignUpFormState extends State<SignUpForm> {
  // Clave global para manejar el estado del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Variable para manejar la visibilidad de la contraseña
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    // Construcción del formulario
    return Form(
      key: _formKey, // Asigna la clave del formulario
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Alineación de los elementos al inicio
        children: <Widget>[
          // Campo de texto para el nombre de usuario
          TextFormField(
            controller: _nameController, // Controlador asignado
            keyboardType: TextInputType.text, // Tipo de entrada: texto
            cursorColor: Config.primaryColor, // Color del cursor
            decoration: const InputDecoration(
              hintText: 'Username', // Texto de sugerencia
              labelText: 'Username', // Etiqueta del campo
              alignLabelWithHint: true, // Alineación de la etiqueta con el texto
              prefixIcon: Icon(Icons.person_outlined), // Icono al inicio
              prefixIconColor: Config.primaryColor, // Color del icono
            ),
          ),
          Config.spaceSmall, // Espaciado entre los elementos

          // Campo de texto para el correo electrónico
          TextFormField(
            controller: _emailController, // Controlador asignado
            keyboardType: TextInputType.emailAddress, // Tipo de entrada: correo electrónico
            cursorColor: Config.primaryColor, // Color del cursor
            decoration: const InputDecoration(
              hintText: 'Email Address', // Texto de sugerencia
              labelText: 'Email', // Etiqueta del campo
              alignLabelWithHint: true, // Alineación de la etiqueta con el texto
              prefixIcon: Icon(Icons.email_outlined), // Icono al inicio
              prefixIconColor: Config.primaryColor, // Color del icono
            ),
          ),
          Config.spaceSmall, // Espaciado entre los elementos

          // Campo de texto para la contraseña
          TextFormField(
            controller: _passController, // Controlador asignado
            keyboardType: TextInputType.visiblePassword, // Tipo de entrada: contraseña
            cursorColor: Config.primaryColor, // Color del cursor
            obscureText: obsecurePass, // Visibilidad de la contraseña
            decoration: InputDecoration(
                hintText: 'Password', // Texto de sugerencia
                labelText: 'Password', // Etiqueta del campo
                alignLabelWithHint: true, // Alineación de la etiqueta con el texto
                prefixIcon: const Icon(Icons.lock_outline), // Icono al inicio
                prefixIconColor: Config.primaryColor, // Color del icono
                suffixIcon: IconButton(
                    // Botón para mostrar/ocultar la contraseña
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass; // Cambia el estado de visibilidad
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined, // Icono de ocultar
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined, // Icono de mostrar
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall, // Espaciado entre los elementos

          // Botón para registrarse
          Consumer<AuthModel>(
            // Escucha cambios en el modelo de autenticación
            builder: (context, auth, child) {
              return Button(
                width: double.infinity, // Botón de ancho completo
                title: 'Sign Up', // Texto del botón
                onPressed: () async {
                  // Llama al método de registro
                  final userRegistration = await DioProvider().registerUser(
                      _nameController.text,
                      _emailController.text,
                      _passController.text);

                  // Si el registro es exitoso, procede al inicio de sesión
                  if (userRegistration) {
                    final token = await DioProvider()
                        .getToken(_emailController.text, _passController.text);

                    if (token) {
                      auth.loginSuccess({}, {}); // Actualiza el estado de inicio de sesión
                      // Redirige a la página principal
                      MyApp.navigatorKey.currentState!.pushNamed('main');
                    }
                  } else {
                    print('register not successful'); // Mensaje de error en caso de fallo
                  }
                },
                disable: false, // Habilita el botón
              );
            },
          )
        ],
      ),
    );
  }
}
