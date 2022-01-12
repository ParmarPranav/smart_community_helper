class Validators {
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp phoneNumber = RegExp(
    r'^(\+[9][1])([0-9]{10})$',
  );

  static final RegExp website = RegExp(
    r'^((https?:www\.|https?:\/\/|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?)$',
  );

  static isValidEmail(String email) {
    return emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return passwordRegExp.hasMatch(password);
  }

  static isValidPhoneNumber(String password) {
    return phoneNumber.hasMatch(password);
  }

  static isWebsite(String url) {
    return website.hasMatch(url);
  }
}
