class LoginWithEmailAndPasswordFailure {
  final String message;

  LoginWithEmailAndPasswordFailure(
      [this.message = 'An unknown error occured.']);

  factory LoginWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return LoginWithEmailAndPasswordFailure(
            'Please enter a stronger password.');
      case 'invalid-email':
        return LoginWithEmailAndPasswordFailure('Email is not valid.');
      default:
        return LoginWithEmailAndPasswordFailure();
    }
  }
}