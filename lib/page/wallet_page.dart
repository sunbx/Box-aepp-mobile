import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // 隐藏阴影

          title: Text(
            '钱包',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: EasyRefresh(
          onRefresh: _onRefresh,
          header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 378,
                  height: 160,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 18, left: 18, right: 18,bottom: 30),
                  decoration: new BoxDecoration(
                      color: Color(0xFFE71766),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                      //设置四周边框
                      ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 28, left: 18),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "我的资产 (AE)",
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12, left: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "603.2134",
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Text(
                              "",
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                        child: Text(
                          "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF",
                          style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                buildItem(context, "发送代", "images/profile_info.png", () {
                  print("123");
                }),
                buildItem(context, "接受代", "images/profile_info.png", () {
                  print("123");
                }),
                buildItem(context, "转账记录", "images/profile_info.png", () {
                  print("123");
                }),
                buildItem(context, "扫一扫", "images/profile_info.png", () {
                  print("123");
                }),
              ],
            ),
          ),
        ));
  }

  Material buildItem(BuildContext context, String content, String assetImage, GestureTapCallback tab, {bool isLine = true}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 13),
                child: Row(
                  children: <Widget>[
                    Image(
                      width: 40,
                      height: 40,
                      image: AssetImage(assetImage),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 28,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              if (isLine)
                Positioned(
                  bottom: 0,
                  left: 30,
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {});
  }
}
