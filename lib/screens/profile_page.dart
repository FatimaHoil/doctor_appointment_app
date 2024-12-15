import "package:doctor_appointment_app/main.dart";
import "package:doctor_appointment_app/models/auth_model.dart";
import "package:doctor_appointment_app/provider/dio_provider.dart";
import "package:doctor_appointment_app/utils/config.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

// Página de perfil que muestra información del usuario y permite cerrar sesión.
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {}; // Mapa que almacena la información del usuario.

  @override
  Widget build(BuildContext context) {
    // Obtiene los datos del usuario desde el modelo de autenticación.
    user = Provider.of<AuthModel>(context, listen: false).getUser;

    return Column(
      children: [
        Expanded(
          flex: 4, // Define la proporción del espacio ocupado por esta sección.
          child: Container(
            width: double.infinity,
            color: Config.primaryColor, // Color de fondo principal.
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 110, // Espaciado superior.
                ),
                const CircleAvatar(
                  radius: 65.0, // Tamaño del avatar.
                  backgroundImage: AssetImage('assets/user.png'), // Imagen del usuario.
                  backgroundColor: Colors.white, // Fondo blanco para el avatar.
                ),
                const SizedBox(
                  height: 10, // Espaciado entre el avatar y el nombre.
                ),
                Text(
                  user['name'], // Nombre del usuario extraído del modelo.
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Tamaño de la fuente para el nombre.
                  ),
                ),
                const SizedBox(
                  height: 10, // Espaciado entre el nombre y la edad.
                ),
                const Text(
                  '23 Years Old', // Información de edad del usuario.
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15, // Tamaño de la fuente para la edad.
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5, // Define la proporción del espacio ocupado por esta sección.
          child: Container(
            color: Colors.grey[200], // Color de fondo gris claro.
            child: Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0), // Margen superior para el Card.
                child: SizedBox(
                  width: 300, // Ancho del Card.
                  height: 115, // Altura del Card.
                  child: Padding(
                    padding: const EdgeInsets.all(10), // Padding interno del Card.
                    child: Column(
                      children: [
                        const Text(
                          'Profile', // Título del Card.
                          style: TextStyle(
                            fontSize: 17, // Tamaño de la fuente del título.
                            fontWeight: FontWeight.w800, // Fuente en negrita.
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300], // Línea divisoria gris claro.
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Alineación de elementos.
                          children: [
                            Icon(
                              Icons.logout_outlined, // Ícono de cerrar sesión.
                              color: Colors.lightGreen[400], // Color verde claro.
                              size: 35, // Tamaño del ícono.
                            ),
                            const SizedBox(
                              width: 20, // Espaciado entre el ícono y el botón.
                            ),
                            TextButton(
                              onPressed: () async {
                                // Obtiene la instancia de SharedPreferences.
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? ''; // Obtiene el token guardado.

                                if (token.isNotEmpty && token != '') {
                                  // Si el token no está vacío, realiza el logout.
                                  final response =
                                      await DioProvider().logout(token);

                                  if (response == 200) {
                                    // Si el logout es exitoso, elimina el token.
                                    await prefs.remove('token');
                                    setState(() {
                                      // Redirige a la página de inicio de sesión.
                                      MyApp.navigatorKey.currentState!
                                          .pushReplacementNamed('/');
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                "Logout", // Texto del botón de cerrar sesión.
                                style: TextStyle(
                                  color: Config.primaryColor, // Color del texto.
                                  fontSize: 15, // Tamaño de la fuente.
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
