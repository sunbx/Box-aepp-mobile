import 'dart:math';
import 'dart:ui';

import 'package:box/dao/wetrue_comment_list_dao.dart';
import 'package:box/dao/wetrue_config_dao.dart';
import 'package:box/dao/wetrue_topic_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/wetrue_comment_model.dart';
import 'package:box/model/wetrue_config_model.dart';
import 'package:box/page/defi_ranking_page.dart';
import 'package:box/utils/RelativeDateFormat.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/wetrue_comment_input_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../main.dart';
import 'box_footer.dart';
import 'box_header.dart';
import 'chain_loading_widget.dart';
import 'loading_widget.dart';

class WeTrueCommentWidget extends StatefulWidget {
  final String hash;

  const WeTrueCommentWidget({Key key, this.hash}) : super(key: key);

  @override
  _WeTrueCommentWidgetState createState() => _WeTrueCommentWidgetState();
}

class _WeTrueCommentWidgetState extends State<WeTrueCommentWidget> {
  int page;
  WeTrueConfigModel weTrueConfigModel;
  WetrueCommentModel wetrueCommentModel;
  EasyRefreshController controller = EasyRefreshController();
  var loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
    netWeTrueConfig();
  }

  Future<void> _onRefresh() async {
    page = 1;
    var model;
    model = await WetrueCommentDao.fetch(widget.hash, page);
    if (wetrueCommentModel != null) {
      wetrueCommentModel = null;
    }
    if (model != null || model.code == 200) {
      wetrueCommentModel = model;
      loadingType = LoadingType.finish;
      if (wetrueCommentModel.data.data == null ||
          wetrueCommentModel.data.data.length == 0) {
        loadingType = LoadingType.no_data;
      }
    } else {
      loadingType = LoadingType.error;
    }

    if (wetrueCommentModel.data.data.length < 30) {
      controller.finishLoad(success: true, noMore: true);
    }
    controller.finishRefresh();
    page++;
    setState(() {});
  }

  Future<void> _onLoad() async {
    WetrueCommentModel model;
    model = await WetrueCommentDao.fetch(widget.hash, page);
    if (wetrueCommentModel == null) {
      return;
    }
    if (model != null || model.code == 200) {
      wetrueCommentModel.data.data.addAll(model.data.data);
      loadingType = LoadingType.finish;
      if (wetrueCommentModel.data == null ||
          wetrueCommentModel.data.size == 0) {
        loadingType = LoadingType.no_data;
      }
    } else {
      loadingType = LoadingType.error;
    }

    controller.finishRefresh();
    if (wetrueCommentModel.data.data.length < 30) {
      controller.finishLoad(success: true, noMore: true);
    }
    page++;
    setState(() {});
  }

  void netWeTrueConfig() {
    WeTrueConfigDao.fetch().then((WeTrueConfigModel model) {
      weTrueConfigModel = model;
      setState(() {});
    }).catchError((e) {
      //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 3 * 2,
      child: Column(
        children: [
          AppBar(
            primary: false,
            excludeHeaderSemantics: true,
            // toolbarHeight:0,
            // excludeHeaderSemantics:true,
            backgroundColor: Color(0xFFfafbfc),
            elevation: 0,
            // 隐藏阴影
            title: Text(
              "评论",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 17,
              ),
              onPressed: () {
                Navigator.of(context).pop();
//              Navigator.pop(context);
              },
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3 * 2 -
                      50 -
                      kToolbarHeight -
                      MediaQueryData.fromWindow(window).padding.bottom,
                  child: LoadingWidget(
                    type: loadingType,
                    child: AnimationLimiter(
                      child: EasyRefresh(
                        // enableControlFinishRefresh: true,
                        controller: controller,
                        topBouncing: false,
                        behavior: null,
                        header: BoxHeader(),
                        footer: MaterialFooter(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Color(0xFFF22B79)),
                        ),
                        onRefresh: _onRefresh,
                        onLoad: _onLoad,
                        child: ListView(
                          reverse: false,
                          shrinkWrap: true,
                          controller: ModalScrollController.of(context),
                          physics: ClampingScrollPhysics(),
                          children: ListTile.divideTiles(
                              context: context,
                              tiles: List.generate(
                                wetrueCommentModel == null
                                    ? 0
                                    : wetrueCommentModel.data.data.length,
                                (index) => getItem(context, index),
                              )).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                if (weTrueConfigModel != null)
                  InkWell(
                    onTap: () {
                      // EasyLoading.showToast('尽情期待', duration: Duration(seconds: 2));
                      showMaterialModalBottomSheet(
                          expand: false,
                          context: context,
                          enableDrag: true,
                          bounce: true,
                          backgroundColor: Colors.transparent.withAlpha(0),
                          builder: (context) => WeTrueCommentInputWidget(
                              title: Decimal.parse(
                                      (weTrueConfigModel.data.commentAmount /
                                              1000000000000000000)
                                          .toString())
                                  .toString(),
                              passwordCallBackFuture: (String content) async {
                                if (content == null || content == "") {
                                  return;
                                }
                                clickLogin(content);
                                //   EasyLoading.showToast(content,
                                //       duration: Duration(seconds: 2));
                              }));
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(
                          bottom:
                              MediaQueryData.fromWindow(window).padding.bottom),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        height: 11,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFFEEEEEE)),
                        ),
                        child: Text(
                          "有爱评论，说点好听的~",
                          style: TextStyle(
                              color: Colors.black.withAlpha(156),
                              fontSize: 15,
                              fontFamily: BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : "Ubuntu"),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  clickLogin(String conetnt) {
    if (weTrueConfigModel == null) {
      return;
    }
    if (conetnt == null) {
      return;
    }
    if (conetnt == "") {
      EasyLoading.showToast('请输入内容', duration: Duration(seconds: 2));
      return;
    }


    String content = Utils.encodeBase64('{"WeTrue":"' +
        weTrueConfigModel.data.weTrue +
        '","type":"comment","source":"Box æpp","toHash":"' +
        widget.hash +
        '","content":"' +
        conetnt.replaceAll("\n", "\\n") +
        '"}');
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              // ignore: missing_return
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var signingKey = await BoxApp.getSigningKey();
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  var aesDecode = Utils.aesDecode(signingKey, key);

                  if (aesDecode == "") {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content:
                            Text(S.of(context).dialog_hint_check_error_content),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn"
                                    ? "Ubuntu"
                                    : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  // ignore: missing_return
                  BoxApp.spend((tx) {
                    // EasyLoading.show();
                    WeTrueTopicDao.fetch(tx).then((bool model) {
                      EasyLoading.dismiss(animation: true);


                      setState(() {});
                    }).catchError((e) {
                      EasyLoading.dismiss(animation: true);

                      setState(() {});

                    });
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text("发布成功"),
                        content: Text("区块同步中，稍后将展示"),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn"
                                    ? "Ubuntu"
                                    : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    setState(() {});
                    // ignore: missing_return
                  }, (error) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn"
                                    ? "Ubuntu"
                                    : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                      aesDecode,
                      address,
                      weTrueConfigModel.data.receivingAccount,
                      Decimal.parse((weTrueConfigModel.data.commentAmount /
                                  1000000000000000000)
                              .toString())
                          .toString(),
                      content);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }

  Widget getItem(BuildContext context, int index) {
    return Material(
      child: InkWell(
        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: contractRecordModel.data[index])));
        },
        child: Container(
          color: Color(0xFFF5F5F5),
          child: Container(
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              //设置四周圆角 角度
//              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
            margin: index == wetrueCommentModel.data.size - 1
                ? EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0)
                : EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            padding: EdgeInsets.only(left: 18, right: 18, top: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 18 * 2,
                        child: Row(
                          children: [
                            Stack(
                              children: <Widget>[
                                ClipOval(
                                  child: Image.network(
                                      wetrueCommentModel
                                          .data.data[index].users.portrait,
                                      width: 35,
                                      height: 35),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: ClipOval(
                                    child: Container(
                                      width: 14,
                                      color: Colors.amberAccent,
                                      height: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: ClipOval(
                                    child: Container(
                                      width: 12,
                                      color: Colors.red,
                                      height: 12,
                                      child: Center(
                                        child: Text(
                                          "v" +
                                              wetrueCommentModel.data
                                                  .data[index].users.userActive
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      wetrueCommentModel.data.data[index].users
                                                  .nickname ==
                                              ""
                                          ? "匿名用户"
                                          : wetrueCommentModel
                                              .data.data[index].users.nickname,
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(156),
                                          fontSize: 15,
                                          fontFamily: BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu"),
                                    ),
                                  ),
                                  // Container(
                                  //   child: Text(
                                  //     RelativeDateFormat.format(wetrueCommentModel
                                  //         .data.data[index].utcTime) +
                                  //         " 来自:" +
                                  //         wetrueCommentModel
                                  //             .data.data[index].source,
                                  //     style: TextStyle(
                                  //         color: Colors.black.withAlpha(100),
                                  //         fontSize: 13,
                                  //         fontFamily: BoxApp.language == "cn"
                                  //             ? "Ubuntu"
                                  //             : "Ubuntu"),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  // Icon(
                                  //   Icons.visibility_outlined,
                                  //   color: Colors.grey,
                                  //   size: 18,
                                  // ),
                                  // Container(
                                  //   margin: EdgeInsets.only(left: 5),
                                  //   child: Text(
                                  //     (wetrueCommentModel.data.data[index].read /
                                  //         1000)
                                  //         .toStringAsFixed(1) +
                                  //         "k",
                                  //     style: TextStyle(
                                  //         color: Colors.black.withAlpha(100),
                                  //         fontSize: 13,
                                  //         fontFamily: BoxApp.language == "cn"
                                  //             ? "Ubuntu"
                                  //             : "Ubuntu"),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
//                      Container(
//                        child: Text(
//                          "大家早上好，ae果然没让人失望，真的很稳！😂",
//                          style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                        ),
//                      ),
                      Wrap(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width - (18 * 2),
                            child: Text(
                              wetrueCommentModel.data.data[index].payload
                                  .replaceAll("<br>", "\r\n"),
                              strutStyle: StrutStyle(
                                  forceStrutHeight: true,
                                  height: 0.8,
                                  leading: 1.2,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 14, top: 5),
                        child: Text(
                          RelativeDateFormat.format(
                              wetrueCommentModel.data.data[index].utcTime),
                          style: TextStyle(
                              color: Colors.black.withAlpha(100),
                              fontSize: 13,
                              fontFamily: BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : "Ubuntu"),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
