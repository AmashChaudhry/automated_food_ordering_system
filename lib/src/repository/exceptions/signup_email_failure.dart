class SignupWithEmailAndPasswordFailure {
  final String message;

  SignupWithEmailAndPasswordFailure(
      [this.message = 'An unknown error occured.']);

  factory SignupWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignupWithEmailAndPasswordFailure(
            'Please enter a stronger password.');
      case 'invalid-email':
        return SignupWithEmailAndPasswordFailure('Email is not valid.');
      default:
        return SignupWithEmailAndPasswordFailure();
    }
  }
}
