import "package:doctor_appointment_app/components/doctor_card.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/auth_model.dart";

// Clase que representa la página de favoritos.
class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Utiliza SafeArea para evitar superposiciones con barras del sistema.
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        // Padding para dar espacio alrededor del contenido.
        child: Column(
          children: [
            // Título de la página.
            const Text(
              'My Favorite Doctors', // Texto del título.
              textAlign: TextAlign.center, // Centra el texto.
              style: TextStyle(
                fontSize: 18, // Tamaño de fuente del texto.
                fontWeight: FontWeight.bold, // Texto en negrita.
              ),
            ),
            const SizedBox(
              height: 20, // Espaciado entre el título y la lista.
            ),
            Expanded(
              // Expande la lista para ocupar el espacio disponible.
              child: Consumer<AuthModel>(
                // Consumer para escuchar cambios en AuthModel.
                builder: (context, auth, child) {
                  // Construye la lista de doctores favoritos.
                  return ListView.builder(
                    itemCount: auth.getFavDoc.length, // Número de doctores favoritos.
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: auth.getFavDoc[index], // Información del doctor.
                        isFav: true, // Indica que es un doctor favorito.
                      );
                    },
                  );
                },
                //child: (Opcional) Se puede usar para evitar reconstrucción de widgets estáticos.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
