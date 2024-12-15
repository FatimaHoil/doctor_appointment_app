import 'dart:convert'; // Importa la biblioteca para manejar JSON
import 'package:dio/dio.dart'; // Importa Dio para realizar solicitudes HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenamiento local de datos

// Clase que gestiona las operaciones relacionadas con la API mediante Dio
class DioProvider {
  // Método para obtener el token de autenticación
  Future<dynamic> getToken(String email, String password) async {
    try {
      // Realiza una solicitud POST a la API de inicio de sesión
      var response = await Dio().post('http://10.0.2.2:8000/api/login',
          data: {'email': email, 'password': password});

      // Si la solicitud es exitosa y hay datos en la respuesta
      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data); // Guarda el token en almacenamiento local
        return true; // Devuelve true si el inicio de sesión fue exitoso
      } else {
        return false; // Devuelve false si falló
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para obtener los datos del usuario autenticado
  Future<dynamic> getUser(String token) async {
    try {
      // Realiza una solicitud GET a la API de usuario con el token en los encabezados
      var user = await Dio().get('http://10.0.2.2:8000/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      // Si la solicitud es exitosa y hay datos en la respuesta
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data); // Codifica los datos del usuario en JSON
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para registrar un nuevo usuario
  Future<dynamic> registerUser(
      String username, String email, String password) async {
    try {
      // Realiza una solicitud POST a la API de registro
      var user = await Dio().post('http://10.0.2.2:8000/api/register',
          data: {'name': username, 'email': email, 'password': password});

      // Si la solicitud es exitosa
      if (user.statusCode == 201 && user.data != '') {
        return true; // Retorna true si el registro fue exitoso
      } else {
        return false; // Retorna false si falló
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para almacenar detalles de citas médicas
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      // Realiza una solicitud POST a la API para reservar una cita
      var response = await Dio().post('http://10.0.2.2:8000/api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      // Si la solicitud es exitosa
      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode; // Retorna el código de estado
      } else {
        return 'Error'; // Retorna un mensaje de error si falla
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para obtener detalles de citas médicas
  Future<dynamic> getAppointments(String token) async {
    try {
      // Realiza una solicitud GET a la API de citas
      var response = await Dio().get('http://10.0.2.2:8000/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      // Si la solicitud es exitosa
      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data); // Codifica los datos en JSON
      } else {
        return 'Error'; // Retorna un mensaje de error si falla
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para guardar reseñas y calificaciones
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      // Realiza una solicitud POST a la API de reseñas
      var response = await Dio().post('http://10.0.2.2:8000/api/reviews',
          data: {
            'ratings': ratings, // Calificación
            'reviews': reviews, // Reseña
            'appointment_id': id, // ID de la cita
            'doctor_id': doctor // ID del doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      // Si la solicitud es exitosa
      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode; // Retorna el código de estado
      } else {
        return 'Error'; // Retorna un mensaje de error si falla
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para almacenar doctores favoritos
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      // Realiza una solicitud POST a la API de favoritos
      var response = await Dio().post('http://10.0.2.2:8000/api/fav',
          data: {
            'favList': favList, // Lista de doctores favoritos
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      // Si la solicitud es exitosa
      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode; // Retorna el código de estado
      } else {
        return 'Error'; // Retorna un mensaje de error si falla
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }

  // Método para cerrar sesión
  Future<dynamic> logout(String token) async {
    try {
      // Realiza una solicitud POST a la API de cierre de sesión
      var response = await Dio().post('http://10.0.2.2:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      // Si la solicitud es exitosa
      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode; // Retorna el código de estado
      } else {
        return 'Error'; // Retorna un mensaje de error si falla
      }
    } catch (error) {
      return error; // Retorna el error en caso de excepción
    }
  }
}
