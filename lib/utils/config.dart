
import 'package:flutter/material.dart';

class Config {
  static MediaQueryData? mediaQueryData; // Almacena datos de media query para acceder a las dimensiones de la pantalla.
  static double? screenWidth; // Almacena el ancho de la pantalla.
  static double? screenHeight; // Almacena la altura de la pantalla.

  //width and height initialization
  // Método para inicializar el ancho y alto de la pantalla a través del contexto.
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context); // Obtiene los datos del MediaQuery.
    screenWidth = mediaQueryData!.size.width; // Asigna el ancho de la pantalla.
    screenHeight = mediaQueryData!.size.height; // Asigna la altura de la pantalla.
  }

  // Obtiene el ancho de la pantalla.
  static get widthSize {
    return screenWidth;
  }

  // Obtiene la altura de la pantalla.
  static get heightSize {
    return screenHeight;
  }

  //define spacing height
  // Define un espacio pequeño con altura fija.
  static const spaceSmall = SizedBox(
    height: 25,
  );

  // Define un espacio mediano basado en un porcentaje de la altura de la pantalla.
  static final spaceMedium = SizedBox(
    height: screenHeight! * 0.05, // Altura del 5% de la pantalla.
  );

  // Define un espacio grande basado en un porcentaje de la altura de la pantalla.
  static final spaceBig = SizedBox(
    height: screenHeight! * 0.08, // Altura del 8% de la pantalla.
  );

  //textform field border
  // Define un borde estándar para los TextFormField.
  static const outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)), // Bordes redondeados.
  );

  // Define un borde para cuando el campo está enfocado.
  static const focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)), // Bordes redondeados.
      borderSide: BorderSide(
        color: Colors.greenAccent, // Color del borde cuando está enfocado.
      ));

  // Define un borde para cuando hay un error en el campo.
  static const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)), // Bordes redondeados.
      borderSide: BorderSide(
        color: Colors.red, // Color del borde para errores.
      ));

  // Color primario de la aplicación.
  static const primaryColor = Colors.greenAccent; // Color verde claro usado como color principal.
}
