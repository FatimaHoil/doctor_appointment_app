import 'package:doctor_appointment_app/main.dart'; // Importa el archivo principal de la aplicación
import 'package:doctor_appointment_app/provider/dio_provider.dart'; // Importa el proveedor para interactuar con la API
import 'package:doctor_appointment_app/utils/config.dart'; // Importa configuraciones y utilidades
import 'package:flutter/material.dart'; // Biblioteca principal de Flutter
import 'package:rating_dialog/rating_dialog.dart'; // Biblioteca para la funcionalidad de diálogo de calificación
import 'package:shared_preferences/shared_preferences.dart'; // Para manejo de almacenamiento local

// Widget para representar la tarjeta de cita médica
class AppointmentCard extends StatefulWidget {
  const AppointmentCard({Key? key, required this.doctor, required this.color})
      : super(key: key);

  final Map<String, dynamic> doctor; // Mapa que contiene los detalles del doctor
  final Color color; // Color de fondo de la tarjeta

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

// Estado del widget AppointmentCard
class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      decoration: BoxDecoration(
        color: widget.color, // Aplica el color recibido como parámetro
        borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20), // Padding interno
          child: Column(
            children: <Widget>[
              // Sección con información del doctor
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage("${widget.doctor['doctor_profile']}"), // Foto del doctor
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr ${widget.doctor['doctor_name']}', // Nombre del doctor
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.doctor['category'], // Categoría del doctor
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ],
              ),
              Config.spaceSmall, // Espacio entre secciones
              // Información de la cita
              ScheduleCard(
                appointment: widget.doctor['appointments'], // Detalles de la cita
              ),
              Config.spaceSmall,
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Botón para cancelar
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {}, // Acción de cancelar (vacía)
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Botón de completar
                      ),
                      onPressed: () {
                        // Muestra el diálogo de calificación
                        showDialog(
                            context: context,
                            builder: (context) {
                              return RatingDialog(
                                  initialRating: 1.0, // Calificación inicial
                                  title: const Text(
                                    'Rate the Doctor', // Título del diálogo
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  message: const Text(
                                    'Please help us to rate our Doctor', // Mensaje del diálogo
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  image: const FlutterLogo(
                                    size: 100, // Imagen del diálogo
                                  ),
                                  submitButtonText: 'Submit', // Botón de envío
                                  commentHint: 'Your Reviews', // Placeholder de comentario
                                  onSubmitted: (response) async {
                                    // Acción al enviar la calificación
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    final token =
                                        prefs.getString('token') ?? ''; // Obtiene el token almacenado

                                    // Llama al método para guardar la reseña
                                    final rating = await DioProvider()
                                        .storeReviews(
                                            response.comment, // Comentario del usuario
                                            response.rating, // Calificación del usuario
                                            widget.doctor['appointments']
                                                ['id'], // ID de la cita
                                            widget.doctor[
                                                'doc_id'], // ID del doctor
                                            token);

                                    // Si la calificación es exitosa, navega a la pantalla principal
                                    if (rating == 200 && rating != '') {
                                      MyApp.navigatorKey.currentState!
                                          .pushNamed('main');
                                    }
                                  });
                            });
                      },
                      child: const Text(
                        'Completed', // Texto del botón
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para mostrar la información del horario de la cita
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment; // Detalles de la cita

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey, // Fondo gris
        borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
      ),
      width: double.infinity, // Ocupa todo el ancho disponible
      padding: const EdgeInsets.all(20), // Padding interno
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today, // Icono de calendario
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${appointment['day']}, ${appointment['date']}', // Día y fecha de la cita
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm, // Icono de reloj
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            appointment['time'], // Hora de la cita
            style: const TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}
