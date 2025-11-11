import 'dart:async';

import 'package:astrology/app/modules/webview/controllers/webview_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewView extends StatefulWidget {
  final String? url;
  final bool? isLinearProgressBar;
  final Color? statusBarColor;
  final bool? isCredit;

  const WebviewView({
    super.key,
    this.url,
    this.isLinearProgressBar = false,
    this.statusBarColor,
    this.isCredit = false,
  });

  @override
  State<WebviewView> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebviewView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late StreamSubscription _connectivitySubscription;
  PullToRefreshController? pullToRefreshController;
  final cookieManager = CookieManager.instance();
  final String cookieKey = "saved_cookies";

  final webX = Get.put(WebViewController());

  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone; autoplay",
    iframeAllowFullscreen: true,
    geolocationEnabled: true,
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    useShouldOverrideUrlLoading: true,
    useOnLoadResource: true,
    useOnDownloadStart: true,
    allowsBackForwardNavigationGestures: true,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    mixedContentMode:
        MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW, // Android only
    supportZoom: true,
    displayZoomControls: false,
    builtInZoomControls: true,
    cacheEnabled: true,
    clearSessionCache: false,
    domStorageEnabled: true,
    databaseEnabled: true,
    thirdPartyCookiesEnabled: true, // Android only
    transparentBackground: false,
    allowContentAccess: true, // Android only
    allowFileAccess: true, // Android only
    incognito: false, // Set to true for private mode
    useHybridComposition: true, // Recommended for Android
  );

  @override
  void initState() {
    super.initState();
    _initConnectivityCheck();
    _loadCookies();

    pullToRefreshController =
        kIsWeb ||
                ![
                  TargetPlatform.iOS,
                  TargetPlatform.android,
                ].contains(defaultTargetPlatform)
            ? null
            : PullToRefreshController(
              settings: PullToRefreshSettings(color: Colors.blue),
              onRefresh: () async {
                if (defaultTargetPlatform == TargetPlatform.android) {
                  webViewController?.reload();
                } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                  webViewController?.loadUrl(
                    urlRequest: URLRequest(
                      url: await webViewController?.getUrl(),
                    ),
                  );
                }
              },
            );
  }

  void _initConnectivityCheck() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      final hasConnection = result != ConnectivityResult.none;
      webX.updateConnectionStatus(hasConnection);
      if (hasConnection && webX.webNotLoadError.isNotEmpty) {
        webViewController?.reload();
        webX.updateLoadError('');
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cookieStrings = prefs.getStringList(cookieKey);

    if (cookieStrings != null && widget.url != null) {
      Uri uri = Uri.parse(widget.url!);
      for (String cookie in cookieStrings) {
        final parts = cookie.split(';');
        if (parts.isNotEmpty) {
          final nameValue = parts[0].split('=');
          if (nameValue.length == 2) {
            await cookieManager.setCookie(
              url: WebUri(uri.origin),
              name: nameValue[0],
              value: nameValue[1],
              path: "/",
              isSecure: true,
            );
          }
        }
      }
    }
  }

  Future<void> _saveCookies() async {
    if (widget.url == null) return;

    Uri uri = Uri.parse(widget.url!);
    List<Cookie> cookies = await cookieManager.getCookies(
      url: WebUri(uri.origin),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cookieStrings =
        cookies.map((cookie) => "${cookie.name}=${cookie.value}").toList();

    await prefs.setStringList(cookieKey, cookieStrings);
  }

  Future<void> logout() async {
    await cookieManager.deleteAllCookies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(cookieKey);
  }

  // Convert HTTP URL to HTTPS
  String _convertToHttps(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  // Get initial URL with HTTPS if needed
  WebUri _getInitialUrl() {
    if (widget.url == null) return WebUri('about:blank');
    return WebUri(_convertToHttps(widget.url!));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return !webX.hasConnection.value ||
              webX.webNotLoadError.value.isNotEmpty
          ? NoInternetWidget(
            url: widget.url ?? "",
            controller: webViewController,
          )
          : Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: _getInitialUrl()),
                initialSettings: settings,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController?.endRefreshing();
                  webX.updateUrl(url.toString());
                  await _saveCookies();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                  webX.updateProgress(progress / 100);
                },
                onLoadError: (controller, url, code, message) {
                  webX.updateLoadError(message);
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                shouldOverrideUrlLoading: (
                  controller,
                  navigationAction,
                ) async {
                  var uri = navigationAction.request.url!;
    
                  // HTTP to HTTPS redirection
                  if (uri.scheme == "http" &&
                      !uri.host.contains("localhost")) {
                    // Create HTTPS version of the URL
                    var httpsUri = Uri.parse(
                      'https://${uri.host}${uri.path}${uri.query.isNotEmpty ? '?${uri.query}' : ''}',
                    );
                    await controller.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(httpsUri.toString()),
                      ),
                    );
    
                    return NavigationActionPolicy.CANCEL;
                  }
    
                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about",
                  ].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  webX.updateUrl(url.toString());
                },
              ),
              if (widget.isLinearProgressBar == true &&
                  webX.progress.value < 1.0)
                LinearProgressIndicator(
                  value: webX.progress.value,
                  color: Colors.deepPurpleAccent,
                ),
              if (widget.isLinearProgressBar == false &&
                  webX.progress.value < 1.0)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Transform.scale(
                      scale: 0.4,
                      child: const CircularProgressIndicator(
                        color: Colors.purple,
                        strokeWidth: 10,
                      ),
                    ),
                  ),
                ),
            ],
          );
    });
  }
}