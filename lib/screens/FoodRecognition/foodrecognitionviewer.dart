import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:food_app/screens/FoodRecognition/foodrecognition.dart';

class FoodRecognitionView extends StatefulWidget {
  final String postUrl;
  FoodRecognitionView({this.postUrl});
  @override
  _FoodRecognitionViewState createState() => _FoodRecognitionViewState();
}

//////////////Making sure that I was able to see the url on next page
// class _RecipeViewState extends State<RecipeView> {
//   String finalUrl;
//   @override
//   void initState() {
//     if (widget.postUrl.contains("http://")) {
//       finalUrl = widget.postUrl.replaceAll("http://", "https://");
//     } else {
//       finalUrl = widget.postUrl;
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(child: Text("${finalUrl.toString()}")),
//     );
//   }
// }

class _FoodRecognitionViewState extends State<FoodRecognitionView> {
  String finalUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.postUrl.contains("http://")) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    } else {
      finalUrl = widget.postUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 106,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
