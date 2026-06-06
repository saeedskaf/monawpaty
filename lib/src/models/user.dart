class User {
  int? id;
  bool? isAdmin;
  String? refresh;
  String? access;
  String? username;
  String? email;
  String? token;
  String? fullname;
  String? rank;

  User(
      {this.id,
      this.isAdmin,
      this.refresh,
      this.access,
      this.username,
      this.email,
      this.token,
      this.fullname,
      this.rank});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAdmin = json['isAdmin'];
    refresh = json['refresh'];
    access = json['access'];
    username = json['username'];
    email = json['email'];
    token = json['token'];
    fullname = json['fullName'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isAdmin'] = isAdmin;
    data['refresh'] = refresh;
    data['access'] = access;
    data['username'] = username;
    data['email'] = email;
    data['token'] = token;
    data['fullName'] = fullname;
    data['rank'] = rank;
    return data;
  }
}
