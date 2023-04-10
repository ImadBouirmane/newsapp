import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late WebViewController _webViewController;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Detail'),
      ),
      body: Column(
        children: [
          _buildArticleHeader(),
          Expanded(child: _buildArticleContent()),
        ],
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.article['title'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '${widget.article['author']} - ${widget.article['source']['name']} - ${DateFormat.yMMMMd().format(DateTime.parse(widget.article['publishedAt']))}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return WebView(
      initialUrl: widget.article['url'],
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _controllerCompleter.complete(webViewController);
      },
    );
  }
}
