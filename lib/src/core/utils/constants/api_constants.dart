import 'package:flutter_dotenv/flutter_dotenv.dart';

///This is the main api route
// ignore: comment_references
///Here the [API_BASE_URL] is the base url that is defined in the .env file
String baseApiRoute = dotenv.env['API_BASE_URL'] ?? '';

///This is the api routes
class ApiRoutes {
  ///This is the Route for the auth module
  static String auth = '$baseApiRoute/auth';
}
