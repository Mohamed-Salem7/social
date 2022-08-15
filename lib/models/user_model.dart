class UserModel
{
  late String name;
  late String email;
  late String cover;
  late String image;
  late String bio;
  late String phone;
  late bool isEmailVerified;
  late String uId;
  late String text;


  UserModel({
    required this.name,
    required this.email,
    required this.cover,
    required this.image,
    required this.bio,
    required this.phone,
    required this.uId,
    required this.isEmailVerified,
    required this.text,
});


  UserModel.fromJason(Map<String,dynamic>? json)
  {
    name = json!['name'];
    email = json['email'];
    cover = json['cover'];
    image = json['image'];
    bio = json['bio'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    text = json['text'];
  }


  Map<String,dynamic> toMap()
  {
    return
      {
        'name' : name,
        'email' : email,
        'cover' : cover,
        'image' : image,
        'bio' : bio,
        'phone' : phone,
        'uId' : uId,
        'isEmailVerified' : isEmailVerified,
        'text' : text,
      };
  }
}