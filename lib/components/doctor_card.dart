import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/screens/doctor_details.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';

// Widget DoctorCard que representa la tarjeta de un doctor
class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor, // Información del doctor (nombre, categoría, perfil, etc.)
    required this.isFav, // Indica si el doctor es favorito
  }) : super(key: key);

  final Map<String, dynamic> doctor; // Mapa que contiene los datos del doctor
  final bool isFav; // Variable para marcar como favorito

  @override
  Widget build(BuildContext context) {
    Config().init(context); // Inicializa las configuraciones de pantalla desde Config
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Margen interno de la tarjeta
      height: 150, // Altura fija del contenedor
      child: GestureDetector(
        onTap: () {
          // Navegar a la página de detalles del doctor
          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => DoctorDetails(
                doctor: doctor, // Pasar los detalles del doctor
                isFav: isFav, // Pasar si el doctor es favorito
              ),
            ),
          );
        },
        child: Card(
          elevation: 5, // Elevación para dar efecto de sombra
          color: Colors.white, // Color de fondo de la tarjeta
          child: Row(
            children: [
              // Imagen del perfil del doctor
              SizedBox(
                width: Config.widthSize * 0.33, // Ancho proporcional a la pantalla
                child: Builder(
                  builder: (context) {
                    // Depuración para verificar la URL de la imagen
                    print("URL de la imagen: ${doctor['doctor_profile']}");

                    return Image.network(
                      doctor['doctor_profile'], // URL de la imagen del doctor
                      fit: BoxFit.fill, // Ajuste de la imagen para llenar el espacio
                      loadingBuilder: (context, child, loadingProgress) {
                        // Muestra un indicador de carga mientras se descarga la imagen
                        if (loadingProgress == null) return child; // Si se cargó completamente, mostrar la imagen
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null, // Calcula el progreso si se conoce el tamaño total
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Manejo de errores al cargar la imagen
                        print('Error al cargar la imagen: $error'); // Imprime el error en la consola
                        return const Icon(Icons.error,
                            size: 50, color: Colors.red); // Muestra un ícono de error
                      },
                    );
                  },
                ),
              ),
              // Contenedor para la información del doctor
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 20), // Margen interno del contenido
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alineación al inicio
                    children: <Widget>[
                      // Nombre del doctor
                      Text(
                        "Dr ${doctor['doctor_name']}", // Nombre del doctor desde el mapa
                        style: const TextStyle(
                          fontSize: 18, // Tamaño de fuente
                          fontWeight: FontWeight.bold, // Estilo negrita
                        ),
                      ),
                      // Categoría del doctor
                      Text(
                        "${doctor['category']}", // Categoría del doctor desde el mapa
                        style: const TextStyle(
                          fontSize: 14, // Tamaño de fuente
                          fontWeight: FontWeight.normal, // Estilo normal
                        ),
                      ),
                      const Spacer(), // Espaciador para separar contenido
                      const Row(
                        // Calificación y reseñas
                        mainAxisAlignment: MainAxisAlignment.start, // Alineación horizontal al inicio
                        children: <Widget>[
                          Icon(
                            Icons.star_border, // Ícono de estrella
                            color: Colors.yellow, // Color amarillo para la estrella
                            size: 16, // Tamaño del ícono
                          ),
                          SizedBox(width: 5), // Espaciado horizontal
                          Text('4.5'), // Calificación
                          SizedBox(width: 5),
                          Text('Reviews'), // Etiqueta de reseñas
                          SizedBox(width: 5),
                          Text('(20)'), // Número de reseñas
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
