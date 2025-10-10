/// Utility function to check registration input validity

String checkRegistration(String email, String username, String password){
  String registrationResult; /// -1 is error, 0 is success

  if (email.isEmpty || username.isEmpty || password.isEmpty) {
      // Show error if any field is empty
      registrationResult = 'All fields are required.';

    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) { 
      // Show error if email format is invalid
      registrationResult = 'Invalid email format.';

    } else if (password.length < 6) {
      // Show error if password is too short
      registrationResult = 'Password must be at least 6 characters long.';
      
    } else {
      registrationResult = 'OK';
  }
  
  return registrationResult;
}
