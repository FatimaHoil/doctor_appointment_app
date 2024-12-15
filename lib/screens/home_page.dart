import 'package:doctor_appointment_app/components/appointment_card.dart';
import 'package:doctor_appointment_app/components/doctor_card.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Clase que representa la página principal de la aplicación.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {}; // Datos del usuario.
  Map<String, dynamic> doctor = {}; // Datos de la cita del doctor.
  List<dynamic> favList = []; // Lista de doctores favoritos.
  String selectedCategory = ""; // Categoría seleccionada.

  // Lista de categorías médicas.
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "All Doctors", // Categoría que muestra todos los doctores.
    },
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Respirations",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Inicializa la configuración de la pantalla.
    Config().init(context);

    // Obtiene datos del usuario, citas y favoritos desde el modelo de autenticación.
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    // Filtra la lista de doctores según la categoría seleccionada.
    List<dynamic> filteredDoctors = selectedCategory == "All Doctors"
        ? (user['doctor'] ?? []) // Muestra todos los doctores si no hay filtro.
        : selectedCategory.isEmpty
            ? (user['doctor'] ?? []) // Muestra todos si no se seleccionó categoría.
            : (user['doctor'] ?? [])
                .where((doc) => doc['category'] == selectedCategory) // Filtra por categoría.
                .toList();

    return Scaffold(
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Muestra un indicador de carga si los datos están vacíos.
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  // Permite desplazarse verticalmente por la página.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Encabezado con el nombre del usuario y su avatar.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user['name'], // Muestra el nombre del usuario.
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/user.png'), // Imagen de perfil.
                            ),
                          ),
                        ],
                      ),
                      Config.spaceMedium,
                      const Text(
                        'Category', // Título de la sección de categorías.
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      // Lista horizontal de categorías.
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal, // Desplazamiento horizontal.
                          children:
                              List<Widget>.generate(medCat.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = medCat[index]['category'];
                                  // Actualiza la categoría seleccionada.
                                });
                              },
                              child: Card(
                                margin: const EdgeInsets.only(right: 20),
                                color: selectedCategory ==
                                        medCat[index]['category']
                                    ? Colors.blueAccent // Color de categoría seleccionada.
                                    : Config.primaryColor, // Color de categoría no seleccionada.
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FaIcon(
                                        medCat[index]['icon'], // Icono de la categoría.
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        medCat[index]['category'], // Nombre de la categoría.
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Config.spaceSmall,
                      const Text(
                        'Appointment Today', // Título de la sección de citas.
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      doctor.isNotEmpty
                          ? AppointmentCard(
                              doctor: doctor, // Información de la cita.
                              color: Config.primaryColor,
                            )
                          : Container(
                              // Muestra un mensaje si no hay citas programadas.
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'No Appointment Today',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Config.spaceSmall,
                      const Text(
                        'Top Doctors', // Título de la sección de doctores destacados.
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      Column(
                        // Lista de doctores filtrados según la categoría seleccionada.
                        children:
                            List.generate(filteredDoctors.length, (index) {
                          return DoctorCard(
                            doctor: filteredDoctors[index], // Información del doctor.
                            isFav: favList.contains(
                                    filteredDoctors[index]['doc_id']) // Verifica si es favorito.
                                ? true
                                : false,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
