// ignore_for_file: file_names

class Entities {
  static const String users = "users";
  static const String vehicles = "vehicles";
}

class UserOrdersFields {
  static const String orders = "orders";
  static const String orderId = "orderId";
  static const String anotherUserID = "username";
  static const String status = "status";
  static const String dateTime = "dateTime";
  static const String vehicleKey = "vehicleKey";
  static const String username = "username";

}

class UserFields {
  static const String _personalData = "personalData";
  static const String userID = "$_personalData/userID";
  static const String username = "$_personalData/username";

  static const String _location = "location";
  static const String latitude = "$_location/latitude";
  static const String longitude = "$_location/longitude";
  static const String accuracy = "$_location/accuracy";
}

class VehicleFields {
  static const String isAvailable = "isAvailable";
  static const String orderID = "orderID";
  static const String path = "path";

  static const String _location = "location";
  static const String latitude = "$_location/latitude";
  static const String longitude = "$_location/longitude";
  static const String accuracy = "$_location/accuracy";

  static const String _destination = "destination";
  static const String destinationLatitude = "$_destination/latitude";
  static const String destinationLongitude = "$_destination/longitude";
  static const String destinationAccuracy = "$_destination/accuracy";
}
