// ignore_for_file: file_names

class _MyException extends Error {
  String message;
  String wrongData;

  _MyException({this.message = "There is no data found in database: ", required this.wrongData});

  getMessage() => message + " -> " + wrongData;
}

class NoUserInDatabaseException extends _MyException {
  NoUserInDatabaseException({message = "There is no data found in database: ", required wrongData})
      : super(message: message, wrongData: wrongData);
}

class InValidDataException extends _MyException {
  InValidDataException({message = "InValid data : ", required wrongData})
      : super(message: message, wrongData: wrongData);
}

class InValidUserNameException extends InValidDataException {
  InValidUserNameException({message = "InValid username : ", required wrongData})
      : super(message: message, wrongData: wrongData);
}

class InValidPasswordException extends InValidDataException {
  InValidPasswordException({message = "InValid Password : ", required wrongData})
      : super(message: message, wrongData: wrongData);
}

class InValidEmailException extends InValidDataException {
  InValidEmailException({message = "InValid Email : ", required wrongData})
      : super(message: message, wrongData: wrongData);
}
