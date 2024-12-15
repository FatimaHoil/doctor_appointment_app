import 'package:doctor_appointment_app/main_layout.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/screens/auth_page.dart';
import 'package:doctor_appointment_app/screens/booking_page.dart';
import 'package:doctor_appointment_app/screens/success_booked.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp()); // Punto de entrada de la aplicación Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Clave global para manejar la navegación push
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Configuración del tema y proveedor principal de la aplicación
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(), // Modelo de autenticación
      child: MaterialApp(
        navigatorKey: navigatorKey, // Clave para navegación global
        title: 'Flutter Doctor App', // Título de la aplicación
        debugShowCheckedModeBanner: false, // Oculta el banner de depuración
        theme: ThemeData(
          // Tema de diseño predefinido para la aplicación
          inputDecorationTheme: const InputDecorationTheme(
            // Configuración de campos de entrada
            focusColor: Config.primaryColor, // Color del foco
            border: Config.outlinedBorder, // Borde predeterminado
            focusedBorder: Config.focusBorder, // Borde al enfocar
            errorBorder: Config.errorBorder, // Borde para errores
            enabledBorder: Config.outlinedBorder, // Borde habilitado
            floatingLabelStyle: TextStyle(color: Config.primaryColor), // Estilo de etiquetas flotantes
            prefixIconColor: Colors.black38, // Color de los íconos de prefijo
          ),
          scaffoldBackgroundColor: Colors.white, // Color de fondo del scaffold
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            // Tema para la barra de navegación inferior
            backgroundColor: Config.primaryColor, // Color de fondo
            selectedItemColor: Colors.white, // Color de ítem seleccionado
            showSelectedLabels: true, // Mostrar etiquetas seleccionadas
            showUnselectedLabels: false, // Ocultar etiquetas no seleccionadas
            unselectedItemColor: Colors.grey.shade700, // Color de ítem no seleccionado
            elevation: 10, // Elevación de la barra
            type: BottomNavigationBarType.fixed, // Tipo fijo de barra
          ),
        ),
        initialRoute: '/', // Ruta inicial de la aplicación
        routes: {
          '/': (context) => const AuthPage(), // Página de autenticación
          'main': (context) => const MainLayout(), // Página principal
          'booking_page': (context) => const BookingPage(), // Página de reserva
          'success_booking': (context) => const AppointmentBooked(), // Página de éxito en la reserva
        },
      ),
    );
  }
}
