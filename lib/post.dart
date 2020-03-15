class Post {
  String title, downloadUrl, date, hashtags, taskId,thumbnail;
  Owner owner;

  Post(
      {this.title,
      this.downloadUrl,
      this.date,
      this.owner,
      this.hashtags,this.thumbnail,
      this.taskId});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'downloadUrl': downloadUrl,
      'date': date,
      'hashtags': hashtags,
      'owner': owner.toJson(),
      'thumbnail': thumbnail

    };
  }
}

class Owner {
  String profilePic, userName ;

  Owner({this.profilePic, this.userName, });

  Map<String, dynamic> toJson() {
    return {
      'profilePic': profilePic,
      'userName': userName,
    };
  }
}
