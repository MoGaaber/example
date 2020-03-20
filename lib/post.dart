import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';

enum InfoStatus { loading, connectionError, success }

class Post {

  String title, downloadUrl, hashtags, taskId, thumbnail, url;

  int timeStamp;
  bool fullTitle = false;
  bool downloadIsLocked = false;
bool isVideo ;
  Owner owner;
  InfoStatus infoStatus;
  DownloadCallbackModel downloadCallbackModel;
  Post({
    this.url,
    this.isVideo,
    this.infoStatus,
    this.title,
    this.downloadUrl,
    this.timeStamp,
    this.owner,
    this.hashtags,
    this.thumbnail,
  });

  String get date => DateFormat('d/m/y - hh:mm ')
      .format(DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000));
  String get firstPart => title.substring(0, (title.length - 1) ~/ 2);
  String get getTitle {
    if (title.length <= 40) {
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
