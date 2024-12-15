import 'package:doctor_appointment_app/components/login_form.dart'; // Importación del formulario de inicio de sesión
import 'package:doctor_appointment_app/components/sing-up_form.dart'; // Importación del formulario de registro
import 'package:doctor_appointment_app/components/social_button.dart'; // Importación de botones sociales
import 'package:doctor_appointment_app/utils/text.dart'; // Importación de textos de la aplicación
import 'package:flutter/material.dart'; // Importación de Flutter para diseño de UI
import '../utils/config.dart'; // Importación de la configuración de la aplicación

// Clase principal para la página de autenticación
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

// Estado de la página de autenticación
class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true; // Controla si la vista actual es de inicio de sesión o registro

  @override
  Widget build(BuildContext context) {
    Config().init(context); // Inicializa la configuración de la aplicación
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15, // Espaciado horizontal
        vertical: 15, // Espaciado vertical
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alineación en la parte superior
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
          children: <Widget>[
            // Texto de bienvenida
            Text(
              AppText.enText['welcome_text']!,
              style: const TextStyle(
                fontSize: 36, // Tamaño de la fuente
                fontWeight: FontWeight.bold, // Negrita
              ),
            ),
            Config.spaceSmall, // Espacio pequeño
            // Texto de inicio de sesión o registro dependiendo del estado
            Text(
              isSignIn
                  ? AppText.enText['signIn_text']!
                  : AppText.enText['register_text']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            // Muestra el formulario de inicio de sesión o registro según el estado
            isSignIn ? const LoginForm() : const SignUpForm(),
            Config.spaceSmall,
            // Botón para recuperar contraseña si está en la vista de inicio de sesión
            isSignIn
                ? Center(
                    child: TextButton(
                      onPressed: () {}, // Acción al presionar
                      child: Text(
                        AppText.enText['forgot-password']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color del texto
                        ),
                      ),
                    ),
                  )
                : Container(), // Contenedor vacío para la vista de registro
            const Spacer(), // Espaciador para empujar el contenido hacia arriba
            // Texto de inicio de sesión social
            Center(
              child: Text(
                AppText.enText['social-login']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade500, // Color gris claro
                ),
              ),
            ),
            Config.spaceSmall,
            // Botones sociales para Google y Facebook
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SocialButton(social: 'google'),
                SocialButton(social: 'facebook'),
              ],
            ),
            Config.spaceSmall,
            // Texto para alternar entre inicio de sesión y registro
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
                      isSignIn = !isSignIn; // Cambia entre inicio de sesión y registro
                    });
                  },
                  child: Text(
                    isSignIn ? 'Sign Up' : 'Sign In', // Texto del botón según el estado
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
