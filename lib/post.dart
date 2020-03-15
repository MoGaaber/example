class Post {
  String title, downloadUrl, date, hashtags, taskId;
  Owner owner;

  Post(
      {this.title,
      this.downloadUrl,
      this.date,
      this.owner,
      this.hashtags,
      this.taskId});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'downloadUrl': downloadUrl,
      'date': date,
      'hashtags': hashtags,
      'owner': owner.toJson(),
    };
  }
}

class Owner {
  String profilePic, userName, thumbnail;

  Owner({this.profilePic, this.userName, this.thumbnail});

  Map<String, dynamic> toJson() {
    return {
      'profilePic': profilePic,
      'userName': userName,
      'thumbnail': thumbnail
    };
  }
}
