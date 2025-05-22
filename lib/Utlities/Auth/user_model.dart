class User {
  final String uid;
  final String email;
  final String firstname;
  final String lastname;
  final String dob;

  User(
      {required this.uid,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.dob,});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'first name': firstname,
      'Last name': lastname,
      'email': email,
      'Date of Birth': dob,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'],
        firstname: map['first name'],
        lastname: map['Last name'],
        email: map['email'],
        dob: map['Date of Birth'],);
  }
}
