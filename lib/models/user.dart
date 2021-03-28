class User {
  String firstName, lastName, token, password, email;

  User({this.firstName, this.email, this.lastName, this.token, this.password});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    password = json['password'];
    email = json['token'];
    token = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}
