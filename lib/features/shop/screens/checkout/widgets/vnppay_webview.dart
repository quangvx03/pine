import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Thêm import này
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // Thêm import này

class VnpayWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const VnpayWebViewScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State<VnpayWebViewScreen> createState() => _VnpayWebViewScreenState();
}

class _VnpayWebViewScreenState extends State<VnpayWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Khởi tạo WebView platform trước
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    // Tạo controller
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // Cấu hình controller
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
            setState(() {
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');

            // Kiểm tra nếu URL chứa thông tin trả về từ VNPAY
            if (url.contains('vnp_ResponseCode=')) {
              // Xử lý URL trả về và đưa kết quả về màn hình trước đó
              _handleVnpayResponse(url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'ReturnURL',
        onMessageReceived: (JavaScriptMessage message) {
          print('JavaScript message from VNPAY: ${message.message}');
        },
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    // Set controller instance
    _controller = controller;
  }

  void _handleVnpayResponse(String url) {
    try {
      final uri = Uri.parse(url);
      final params = uri.queryParameters;

      // Nếu có thông tin trả về
      if (params.isNotEmpty && params.containsKey('vnp_ResponseCode')) {
        // Trả về kết quả cho màn hình trước đó
        Get.back(result: params);
      }
    } catch (e) {
      print('Lỗi xử lý URL trả về từ VNPAY: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán VNPAY'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(), // Trở về màn hình trước (kết quả null)
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
