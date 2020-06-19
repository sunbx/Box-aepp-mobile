import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum LoadingType { loading, error, finish }

class LoadingWidget extends StatefulWidget {
  final Widget child;
  final LoadingType type;
  final VoidCallback onPressedError;

  const LoadingWidget({Key key, this.type, this.onPressedError, this.child}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {

  @override
  Widget build(BuildContext context) {

    switch (widget.type) {

      case LoadingType.loading:
        return _loadingView;
        break;
      case LoadingType.error:
        return _error;
        break;
      case LoadingType.finish:

       return widget.child;
    }
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Color(0xFFE71766)),
      ),
    );
  }

  Widget get _error {
    return Center(
        child: Container(
      height: 120,
      child: Column(
        children: <Widget>[
          Text("网络异常,请点击重试"),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: MaterialButton(
              child: Text(
                "重 试",
                style: new TextStyle(fontSize: 17, color: Colors.white),
              ),
              color: Color(0xFFE71766),
              height: 40,
              minWidth: 120,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              onPressed: () {
                widget.onPressedError.call();
              },
            ),
          )
        ],
      ),
    ));
  }
}
