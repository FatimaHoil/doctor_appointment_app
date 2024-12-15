import 'package:doctor_appointment_app/screens/appointment_page.dart';
import 'package:doctor_appointment_app/screens/fav_page.dart';
import 'package:doctor_appointment_app/screens/home_page.dart';
import 'package:doctor_appointment_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Clase principal que define un diseño base para la aplicación
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

// Estado asociado a la clase MainLayout
class _MainLayoutState extends State<MainLayout> {
  // Declaración de variables
  int currentPage = 0; // Variable que guarda el índice de la página actual
  final PageController _page = PageController(); // Controlador para manejar el PageView

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Contenedor principal que muestra las páginas seleccionadas
      body: PageView(
        controller: _page, // Controlador para manejar el cambio de páginas
        onPageChanged: ((value) {
          // Actualiza el índice de la página cuando el usuario navega entre páginas
          setState(() {
            currentPage = value;
          });
        }),
        // Lista de widgets que representan las páginas de la aplicación
        children: const <Widget>[
          HomePage(),
          FavPage(),
          AppointmentPage(),
          ProfilePage(),
        ],
      ),
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage, // Índice de la página seleccionada
        onTap: (page) {
          // Cambia de página al tocar un elemento de la barra de navegación
          setState(() {
            currentPage = page;
            // Anima el cambio de página con una duración y curva definidas
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        // Elementos de la barra de navegación
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical), // Icono para la página de inicio
            label: 'Home', // Etiqueta para la página de inicio
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart), // Icono para la página de favoritos
            label: 'Favorite', // Etiqueta para la página de favoritos
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck), // Icono para la página de citas
            label: 'Appointments', // Etiqueta para la página de citas
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser), // Icono para la página de perfil
            label: 'Profile', // Etiqueta para la página de perfil
          ),
        ],
      ),
    );
  }
}
