class User {
  String firstName, lastName, token, password, email;

  User({this.firstName, this.email, this.lastName, this.token, this.password});

  User.fromMap(Map<String, dynamic> map) {
    firstName = map['firstName'];
    lastName = map['lastName'];
    password = map['password'];
    email = map['token'];
    token = map['email'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}
