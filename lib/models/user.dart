class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? regdate;
  String? otp;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.regdate,
      required this.otp});
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    otp = json['otp'];
  }

  get userid => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['regdate'] = regdate;
    data['address'] = address;
    data['otp'] = otp;

    return data;
  }
}
