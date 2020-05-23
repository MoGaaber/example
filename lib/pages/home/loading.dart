import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'logic.dart';

class Loading extends StatelessWidget {
  int i;
  Loading(this.i);
  @override
  Widget build(BuildContext context) {
    Logic logc = Provider.of(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: <Widget>[
          Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Shimmer.fromColors(
                  enabled: true,
                  baseColor: Color(0xffE9E9E9),
                  highlightColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: 65.w,
                    height: 65.h,
                  )),
              Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Shimmer.fromColors(
                      enabled: true,
                      baseColor: Color(0xffE9E9E9),
                      highlightColor: Colors.white,
                      child: Container(
                        height: 12.h,
                        width: 150.w,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.h)),
                    Shimmer.fromColors(
                      enabled: true,
                      baseColor: Color(0xffE9E9E9),
                      highlightColor: Colors.white,
                      child: Container(
                        height: 10.h,
                        width: 120.w,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
//                  logic.cancelableOperation.cancel().then((x) {
//                    logic.posts.removeAt(i);
//                    logic.notifyListeners();
//                  });
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Material(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    type: MaterialType.circle,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                for (int i = 1; i < 6; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    child: Shimmer.fromColors(
                      enabled: true,
                      baseColor: Color(0xffE9E9E9),
                      highlightColor: Colors.white,
                      child: Container(
                        height: 5.h,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Shimmer.fromColors(
            enabled: false,
            baseColor: Color(0xffE9E9E9),
            highlightColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: 400.h,
              width: 330.w,
            ),
          ),
        ],
      ),
    );
  }
}
