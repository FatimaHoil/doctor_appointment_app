import 'package:doctor_appointment_app/components/button.dart'; // Importación del componente de botón
import 'package:doctor_appointment_app/components/custom_appbar.dart'; // Importación de la barra de aplicación personalizada
import 'package:doctor_appointment_app/main.dart'; // Importación del archivo principal de la aplicación
import 'package:doctor_appointment_app/models/booking_datetime_converted.dart'; // Importación de utilidades para convertir fecha y hora
import 'package:doctor_appointment_app/provider/dio_provider.dart'; // Importación del proveedor para manejar solicitudes de red
import 'package:doctor_appointment_app/utils/config.dart'; // Importación de la configuración de la aplicación
import 'package:flutter/material.dart'; // Importación de Flutter para diseño de UI
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importación de íconos de FontAwesome
import 'package:shared_preferences/shared_preferences.dart'; // Importación para manejar preferencias compartidas
import 'package:table_calendar/table_calendar.dart'; // Importación del calendario interactivo

// Clase principal para la página de reservas
class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

// Estado de la página de reservas
class _BookingPageState extends State<BookingPage> {
  // Declaraciones
  CalendarFormat _format = CalendarFormat.month; // Formato del calendario
  DateTime _focusDay = DateTime.now(); // Día enfocado en el calendario
  DateTime _currentDay = DateTime.now(); // Día actualmente seleccionado
  int? _currentIndex; // Índice actual del horario seleccionado
  bool _isWeekend = false; // Indica si el día seleccionado es fin de semana
  bool _dateSelected = false; // Indica si se ha seleccionado una fecha
  bool _timeSelected = false; // Indica si se ha seleccionado un horario
  String? token; // Token para insertar la reserva en la base de datos

  // Método para obtener el token desde las preferencias compartidas
  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? ''; // Obtiene el token o un string vacío
  }

  @override
  void initState() {
    getToken(); // Llama al método para obtener el token al iniciar el estado
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context); // Inicializa la configuración de la aplicación
    final doctor = ModalRoute.of(context)!.settings.arguments as Map; // Obtiene los argumentos pasados a la página
    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: 'Appointment', // Título de la barra de navegación
        icon: FaIcon(Icons.arrow_back_ios), // Ícono de retroceso
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(), // Muestra el calendario
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time', // Texto para seleccionar horario
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Texto en negrita
                        fontSize: 20, // Tamaño de la fuente
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Muestra mensaje si el día seleccionado es fin de semana
          _isWeekend
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    alignment: Alignment.center, // Alinea el contenido al centro
                    child: const Text(
                      'Weekend is not available, please select another date', // Mensaje para fines de semana
                      style: TextStyle(
                        fontSize: 18, // Tamaño del texto
                        fontWeight: FontWeight.bold, // Texto en negrita
                        color: Colors.grey, // Color gris
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent, // Sin efecto de splash
                        onTap: () {
                          setState(() {
                            _currentIndex = index; // Actualiza el índice seleccionado
                            _timeSelected = true; // Indica que un horario ha sido seleccionado
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5), // Margen alrededor del contenedor
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white // Color blanco si está seleccionado
                                  : Colors.black, // Color negro si no está seleccionado
                            ),
                            borderRadius: BorderRadius.circular(15), // Bordes redondeados
                            color: _currentIndex == index
                                ? Config.primaryColor // Color primario si está seleccionado
                                : null,
                          ),
                          alignment: Alignment.center, // Centra el texto
                          child: Text(
                            '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}', // Texto del horario
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Texto en negrita
                              color: _currentIndex == index ? Colors.white : null, // Cambia el color si está seleccionado
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 8, // Número de horarios disponibles
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.5), // Configuración del grid
                ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Button(
                width: double.infinity, // Ancho completo
                title: 'Make Appointment', // Título del botón
                onPressed: () async {
                  // Convierte la fecha, el día y el horario en strings
                  final getDate = DateConverted.getDate(_currentDay);
                  final getDay = DateConverted.getDay(_currentDay.weekday);
                  final getTime = DateConverted.getTime(_currentIndex!);

                  // Envía la reserva al servidor
                  final booking = await DioProvider().bookAppointment(
                      getDate, getDay, getTime, doctor['doctor_id'], token!);

                  // Si la reserva es exitosa, redirige a la página de éxito
                  if (booking == 200) {
                    MyApp.navigatorKey.currentState!
                        .pushNamed('success_booking');
                  }
                },
                disable: _timeSelected && _dateSelected ? false : true, // Deshabilita el botón si no hay selección
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para el calendario
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay, // Día enfocado actualmente
      firstDay: DateTime.now(), // Primer día disponible
      lastDay: DateTime(2024, 12, 31), // Último día disponible
      calendarFormat: _format, // Formato del calendario
      currentDay: _currentDay, // Día actual seleccionado
      rowHeight: 48, // Altura de las filas
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle), // Estilo para el día actual
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month', // Solo formato mensual
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format; // Cambia el formato del calendario
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay; // Actualiza el día seleccionado
          _focusDay = focusedDay; // Actualiza el día enfocado
          _dateSelected = true; // Indica que una fecha ha sido seleccionada

          // Verifica si el día seleccionado es fin de semana
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null; // Reinicia el índice de horarios
          } else {
            _isWeekend = false; // Indica que no es fin de semana
          }
        });
      }),
    );
  }
}
