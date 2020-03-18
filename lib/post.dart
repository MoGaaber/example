import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/logic.dart';

enum InfoStatus { loading, connectionError, success, notFound }

class Post {
  String title, downloadUrl, hashtags, taskId, thumbnail;
  int timeStamp;
  bool fullTitle = false;
  bool downloadIsLocked = false;

  Owner owner;
  InfoStatus infoStatus;
  DownloadCallbackModel downloadCallbackModel;
  Post({
    this.infoStatus,
    this.title,
    this.downloadUrl,
    this.timeStamp,
    this.owner,
    this.hashtags,
    this.thumbnail,
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  String get firstPart => title.substring(0, (title.length - 1) ~/ 2);
  String get getTitle {
    if (title.length == 0) {
      return '';
    } else if (title.length <= 40) {
      return title;
    } else {
      return fullTitle ? title : firstPart;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'downloadUrl': downloadUrl,
      'date': timeStamp,
      'hashtags': hashtags,
      'owner': owner.toJson(),
      'thumbnail': thumbnail
    };
  }
}

class Owner {
  String profilePic, userName;

  Owner({
    this.profilePic,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'profilePic': profilePic,
      'userName': userName,
    };
  }
}

class DownloadCallbackModel {
  int progress;
  DownloadTaskStatus status;
  String id;

  DownloadCallbackModel(this.progress, this.status, this.id);
}
