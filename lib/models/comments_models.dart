class CommentsModels
{
  late String name;
  late String image;
  late String text;
  late String uId;


  CommentsModels({
    required this.name,
    required this.image,
    required this.text,
    required this.uId,
  });


  CommentsModels.fromJason(Map<String,dynamic> json)
  {
    image = json['image'];
    name = json['name'];
    text = json['text'];
    uId = json['uId'];
  }


  Map<String,dynamic> toMap()
  {
    return
      {
        'image' : image,
        'name' : name,
        'text' : text,
        'uId' : uId,
      };
  }
}