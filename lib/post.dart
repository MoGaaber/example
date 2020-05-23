import 'dart:typed_data';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';

enum InfoStatus { loading, connectionError, success }

class History {
  String title, hashtags, url, thumbnail, fileName;
  bool isVideo;
  String downloadUrl;
  Owner owner;
  int key;
  Uint8List uint8ListThumbnail;

  int timeStamp;
  String path;
  Future<Uint8List> bytesOfImage() async =>
      await networkImageToByte(this.thumbnail);
  String get date => DateFormat('d/m/y - hh:mm ')
      .format(DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000));

  History(
      {this.title,
      this.hashtags,
      this.thumbnail,
      this.timeStamp,
      this.key,
      this.url,
      this.isVideo,
      this.owner,
      this.fileName,
      this.downloadUrl});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'hashtags': hashtags,
      'thumbnail': thumbnail,
      'isVideo': this.isVideo,
      'fileName': this.fileName,
      'owner': owner.toJson(),
      'thumbnail': this.thumbnail,
      'url': this.url,
      'timeStamp': this.timeStamp,
    };
  }

  History fromJson(Map myJson, int key) {
    return History(
        key: key,
        fileName: fileName,
        isVideo: myJson['isVideo'],
        thumbnail: myJson['thumbnail'],
        title: myJson['title'],
        owner: Owner().fromJson(myJson['owner']),
        url: myJson['url'],
        hashtags: myJson['hashtags'],
        timeStamp: myJson['timeStamp']);
  }
}

class Post {
  History history;

  bool fullTitle = false;

  String taskId, buttonTextt;

  InfoStatus infoStatus;
  bool isGoingToCancel = false;
  DownloadCallbackModel downloadCallbackModel;
  bool downloadIsLocked = false;
  bool isClicked = false;

  Post({
    this.infoStatus,
    this.history,
    this.taskId,
  });

  String get firstPart =>
      history.title.substring(0, (history.title.length - 1) ~/ 2);
  String get getTitle {
    if (history.title.length <= 40) {
      return history.title;
    } else {
      return fullTitle ? history.title : firstPart;
    }
  }

  Map<String, dynamic> toJson() {
    return {'history': history.toJson()};
  }

  String get buttonText {
    var downloadStatus = downloadCallbackModel?.status;
    if (downloadStatus == DownloadTaskStatus.complete) {
      return 'اكتمل التحميل افتح الآن';
    } else if (downloadStatus == null && !downloadIsLocked) {
      return 'ابدأ التحميل';
    } else if (downloadStatus == DownloadTaskStatus.canceled) {
      return 'تم الغاء التحميل اعده مره اخري';
    } else if (downloadStatus == DownloadTaskStatus.running) {
      return 'بدأ التحميل انتظر';
    } else {
      return 'فشل التحميل اعده مره اخري';
    }
  }
}

class Owner {
  String profilePic, userName, profilePicHd;

  Owner({
    this.profilePic,
    this.profilePicHd,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'profilePic': profilePic,
      'userName': userName,
      'profilePicHd': profilePicHd
    };
  }

  Owner fromJson(Map json) {
    return Owner(
        profilePic: json['profilePic'],
        userName: json['userName'],
        profilePicHd: json['profilePicHd']);
  }
}

class DownloadCallbackModel {
  int progress;
  DownloadTaskStatus status;
  String taskId;
  DownloadCallbackModel(this.progress, this.status, this.taskId);
}
