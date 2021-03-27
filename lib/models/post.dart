class Post{
  String title, description, sender, dateTime;

  Post({this.title, this.description, this.dateTime, this.sender});

  Post.fromJson(Map<String, dynamic> json){
    title =json['title'];
    description =json['description'];
    dateTime =json['dateTime'];
    sender =json['sender'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['dateTime'] = this.dateTime;
    data['sender'] = this.sender;
    return data;
  }

}