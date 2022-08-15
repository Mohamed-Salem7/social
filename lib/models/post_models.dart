class PostModels
{
  late String name;
  late String image;
  late String uId;
  String? resivierId;
  late String postImage;
  late String text;
  late String dateTime;
  String? comments;

  PostModels({
    required this.name,
    required this.image,
    required this.postImage,
    required this.text,
    required this.dateTime,
    required this.uId,
    this.resivierId,
    this.comments,
  });


  PostModels.fromJason(Map<String,dynamic> json)
  {
    name = json['name'];
    postImage = json['postImage'];
    text = json['text'];
    image = json['image'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    resivierId = json['resivierId'];
    comments = json['comments'];
  }


  Map<String,dynamic> toMap()
  {
    return
      {
        'name' : name,
        'postImage' : postImage,
        'text' : text,
        'image' : image,
        'dateTime' : dateTime,
        'uId' : uId,
        'resivierId' : resivierId,
        'comments' : comments,
      };
  }
}