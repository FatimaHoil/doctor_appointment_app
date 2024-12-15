// Importaciones necesarias para el funcionamiento de la página de citas
import 'package:doctor_appointment_app/provider/dio_provider.dart'; // Proveedor para llamadas a la API
import 'package:doctor_appointment_app/utils/config.dart'; // Configuración global
import 'package:flutter/material.dart'; // Widgets de Flutter
import 'dart:convert'; // Para trabajar con datos JSON
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenamiento local de datos

// Declaración del widget principal para la página de citas
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

// Enum para representar los estados de las citas
enum FilterStatus { upcoming, complete, cancel } // Estados: próximas, completadas, canceladas

// Clase que contiene el estado del widget AppointmentPage
class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming; // Estado inicial: próximas
  Alignment _alignment = Alignment.centerLeft; // Alineación inicial del indicador de filtro
  List<dynamic> schedules = []; // Lista para almacenar las citas obtenidas de la API

  // Método para obtener las citas desde la API
  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Acceso al almacenamiento local
    final token = prefs.getString('token') ?? ''; // Recupera el token almacenado
    final appointment = await DioProvider().getAppointments(token); // Llama a la API para obtener las citas
    if (appointment != 'Error' && mounted) {
      // Si no hay error y el widget está montado
      setState(() {
        schedules = json.decode(appointment); // Decodifica las citas y las guarda en la lista
      });
    }
  }

  @override
  void initState() {
    getAppointments(); // Llama a getAppointments al iniciar el estado
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Filtra las citas según el estado seleccionado
    List<dynamic> filteredSchedules = schedules.where((schedule) {
      return schedule['status'] == status.name; // Filtra por el nombre del estado
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20), // Espaciado de los bordes
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alinea los elementos a lo largo del eje principal
          children: <Widget>[
            // Título de la página
            const Text(
              'Appointment Schedule', // Título principal
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall, // Espaciado pequeño

            // Barra de filtro con tabs
            Stack(
              children: [
                // Contenedor de fondo para los filtros
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco
                    borderRadius: BorderRadius.circular(20), // Bordes redondeados
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                status = filterStatus; // Cambia el estado seleccionado
                                _alignment =
                                    filterStatus == FilterStatus.upcoming
                                        ? Alignment.centerLeft
                                        : filterStatus == FilterStatus.complete
                                            ? Alignment.center
                                            : Alignment.centerRight; // Ajusta la alineación
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name), // Nombre del estado
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Indicador animado del estado seleccionado
                AnimatedAlign(
                  alignment: _alignment, // Alineación según el estado
                  duration: const Duration(milliseconds: 200), // Duración de la animación
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor, // Color primario
                      borderRadius: BorderRadius.circular(20), // Bordes redondeados
                    ),
                    child: Center(
                      child: Text(
                        status.name, // Muestra el estado seleccionado
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall, // Espaciado pequeño

            // Lista de citas filtradas
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length, // Número de elementos en la lista
                itemBuilder: ((context, index) {
                  var schedule = filteredSchedules[index]; // Cita actual
                  bool isLastElement = filteredSchedules.length + 1 == index; // Comprueba si es el último elemento
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey, // Borde gris
                      ),
                      borderRadius: BorderRadius.circular(20), // Bordes redondeados
                    ),
                    margin: !isLastElement
                        ? const EdgeInsets.only(bottom: 20) // Margen entre tarjetas
                        : EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(15), // Espaciado interno
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Detalles del doctor
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "${schedule['doctor_profile']}", // Imagen del doctor
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    schedule['doctor_name'], // Nombre del doctor
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    schedule['category'], // Categoría del doctor
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Detalles de la cita
                          ScheduleCard(
                            date: schedule['date'], // Fecha de la cita
                            day: schedule['day'], // Día de la cita
                            time: schedule['time'], // Hora de la cita
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Opciones según el estado de la cita
                          schedule['status'] == 'cancel'
                              ? Center(
                                  child: Text(
                                    'Canceled', // Texto de cancelación
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Botón para cancelar la cita
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            schedule['status'] = 'cancel'; // Cambia el estado a cancelado
                                          });
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Config.primaryColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    // Botón para reprogramar la cita
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Config.primaryColor, // Color del botón
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            'booking_page', // Navega a la página de reprogramación
                                            arguments: schedule,
                                          );
                                        },
                                        child: const Text(
                                          'Reschedule',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para mostrar los detalles de la cita
class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {Key? key, required this.date, required this.day, required this.time})
      : super(key: key);

  final String date; // Fecha de la cita
  final String day; // Día de la cita
  final String time; // Hora de la cita

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Fondo gris claro
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20), // Espaciado interno
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today, // Icono de calendario
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$day, $date', // Día y fecha
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm, // Icono de reloj
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            time, // Hora
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ))
        ],
      ),
    );
  }
}
