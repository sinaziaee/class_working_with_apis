import 'package:flutter/material.dart';
import 'package:working_with_apis/models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function onTapped;
  PostItem(this.post, this.onTapped);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTapped,
        leading: Text(post.sender),
        title: Text(post.title),
        subtitle: Text(post.description),
        trailing: Text(
          post.dateTime.toString().substring(0, 10),
        ),
      ),
    );
  }
}
