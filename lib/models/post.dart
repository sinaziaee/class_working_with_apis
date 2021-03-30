class Post {
  int postId;
  String title, description, sender;
  DateTime dateTime;

  Post({this.title, this.description, this.dateTime, this.sender,this.postId});

  Post.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    postId = map['post_id'];
    description = map['description'];
    // print('=================');
    String dt = map['dateTime'].toString();
    // print(dt);
    // print('=================');
    List<String> date = dt.substring(0, 10).split('-');
    List<String> time = dt.substring(11, 19).split(':');
    dateTime = DateTime(
      int.parse(date[0]),
      int.parse(date[1]),
      int.parse(date[2]),
      int.parse(time[0]),
      int.parse(time[1]),
      int.parse(time[2]),
    );
    sender = map['sender'].toString();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['post_id'] = this.postId;
    data['description'] = this.description;
    data['dateTime'] = this.dateTime;
    data['sender'] = this.sender;
    return data;
  }
}
