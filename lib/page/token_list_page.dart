import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/token_list_model.dart';
import 'package:box/page/token_add_page.dart';
import 'package:box/page/token_record_page.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import 'home_page_v2.dart';

class TokenListPage extends StatefulWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<TokenListPage> {
  var loadingType = LoadingType.loading;
  TokenListModel tokenListModel;
  PriceModel priceModel;

  Future<void> _onRefresh() async {
    TokenListDao.fetch(HomePageV2.address, "easy").then((TokenListModel model) {
      if (model != null || model.code == 200) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
        setState(() {});
      } else {
        tokenListModel = null;
        loadingType = LoadingType.error;
        setState(() {});
      }
      for (int i = 0; i < tokenListModel.data.length; i++) {
        netContractBalance(i);
      }
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netBaseData();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
  }

  void netBaseData() {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    PriceDao.fetch(type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice(int index) {
    if (tokenListModel.data[index].countStr == null ||
        tokenListModel.data[index].countStr == "") {
      return "";
    }
    if (priceModel == null) {
      return "";
    }
    if (BoxApp.language == "cn" && priceModel.aeternity != null) {
      if (priceModel.aeternity.cny == null) {
        return "";
      }
      if (double.parse(tokenListModel.data[index].countStr) < 1000) {
        return "≈ " +
            (priceModel.aeternity.cny *
                    double.parse(tokenListModel.data[index].countStr) *
                    double.parse(tokenListModel.data[index].rate))
                .toStringAsFixed(2) +
            " (CNY)";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "≈ " +
            (priceModel.aeternity.cny *
                    double.parse(tokenListModel.data[index].countStr) *
                    double.parse(tokenListModel.data[index].rate))
                .toStringAsFixed(2) +
            " (CNY)";
      }
    } else {
      if (priceModel.aeternity.usd == null) {
        return "";
      }
      return "≈ " +
          (priceModel.aeternity.usd *
                  double.parse(tokenListModel.data[index].countStr) *
                  double.parse(tokenListModel.data[index].rate))
              .toStringAsFixed(2) +
          " (USD)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).home_token,
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
        actions: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (context, anim1, anim2) {},
                    barrierColor: Colors.grey.withOpacity(.4),
                    barrierDismissible: true,
                    barrierLabel: "",
                    transitionDuration: Duration(milliseconds: 0),
                    transitionBuilder: (context, anim1, anim2, child) {
                      final curvedValue =
                          Curves.easeInOutBack.transform(anim1.value) - 1.0;
                      return Transform(
                          transform: Matrix4.translationValues(0.0, 0, 0.0),
                          child: Opacity(
                              opacity: anim1.value,
                              // ignore: missing_return
                              child: Material(
                                type: MaterialType.transparency, //透明类型
                                child: Center(
                                  child: Container(
                                    height: 470,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    decoration: ShapeDecoration(
                                      color: Color(0xffffffff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(60)),
                                              onTap: () {
                                                Navigator.pop(context); //关闭对话框
                                                // ignore: unnecessary_statements
//                                  widget.dismissCallBackFuture("");
                                              },
                                              child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Icon(Icons.clear,
                                                      color: Colors.black
                                                          .withAlpha(80))),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            S.of(context).tokens_dialog_title,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily:
                                                  BoxApp.language == "cn"
                                                      ? "Ubuntu"
                                                      : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 270,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: SingleChildScrollView(
                                            child: Container(
                                              child: Text(
                                                S
                                                    .of(context)
                                                    .tokens_dialog_content,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        BoxApp.language == "cn"
                                                            ? "Ubuntu"
                                                            : "Ubuntu",
                                                    letterSpacing: 2,
                                                    height: 2),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 30, bottom: 20),
                                          child: ArgonButton(
                                            height: 40,
                                            roundLoadingShape: true,
                                            width: 120,
                                            onTap: (startLoading, stopLoading,
                                                btnState) async {
                                              Navigator.pop(context); //关闭对话框
                                            },
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .dialog_statement_btn,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily:
                                                    BoxApp.language == "cn"
                                                        ? "Ubuntu"
                                                        : "Ubuntu",
                                              ),
                                            ),
                                            loader: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SpinKitRing(
                                                lineWidth: 4,
                                                color: Colors.white,
                                                // size: loaderWidth ,
                                              ),
                                            ),
                                            borderRadius: 30.0,
                                            color: Color(0xFFFC2365),
                                          ),
                                        ),

//          Text(text),
                                      ],
                                    ),
                                  ),
                                ),
                              )));
                    });
              },
              child: Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(15),
                child: Image(
                  width: 36,
                  height: 36,
                  color: Colors.black,
                  image: AssetImage('images/token_add.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: EasyRefresh(
          header: BoxHeader(),
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: tokenListModel == null ? 0 : tokenListModel.data.length,
            itemBuilder: (BuildContext context, int index) {
              return itemListView(context, index);
            },
          ),
        ),
      ),
    );
  }

  void netContractBalance(int index) {
    ContractBalanceDao.fetch(tokenListModel.data[index].ctAddress)
        .then((ContractBalanceModel model) {
      if (model.code == 200) {
        tokenListModel.data[index].countStr = model.data.balance;
        tokenListModel.data[index].rate = model.data.rate;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Material itemListView(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TokenRecordPage(
                        ctId: tokenListModel.data[index].ctAddress,
                        coinCount: tokenListModel.data[index].count,
                        coinImage: tokenListModel.data[index].image,
                        coinName: tokenListModel.data[index].name,
                      )));
        },
        child: Container(
          child: Row(
            children: [
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 15),
                      child: Row(
                        children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFEEEEEE), width: 1.0),
                                  top: BorderSide(
                                      color: Color(0xFFEEEEEE), width: 1.0),
                                  left: BorderSide(
                                      color: Color(0xFFEEEEEE), width: 1.0),
                                  right: BorderSide(
                                      color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                tokenListModel.data[index].image,
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  if (wasSynchronouslyLoaded) return child;

                                  return AnimatedOpacity(
                                    child: child,
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.easeOut,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Text(
                              tokenListModel.data[index].name,
                              style: new TextStyle(
                                fontSize: 20,
                                color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn"
                                    ? "Ubuntu"
                                    : "Ubuntu",
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          tokenListModel.data[index].countStr == null
                              ? Container(
                                  width: 50,
                                  height: 50,
                                  child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
                                    'images/loading.json',
//              'images/animation_khzuiqgg.json',
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      double.parse(tokenListModel
                                              .data[index].countStr)
                                          .toStringAsFixed(2),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Color(0xff333333),
                                          letterSpacing: 1.3,
                                          fontFamily: BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu"),
                                    ),
                                    if (getAePrice(index) != "")
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          getAePrice(index),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xff999999),
                                              letterSpacing: 1.3,
                                              fontFamily:
                                                  BoxApp.language == "cn"
                                                      ? "Ubuntu"
                                                      : "Ubuntu"),
                                        ),
                                      ),
                                  ],
                                ),

                          Container(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
