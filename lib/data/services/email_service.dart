import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/personalization/models/user_model.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();

  factory EmailService() => _instance;

  EmailService._internal();

  // Thông tin tài khoản gửi email
  // Lưu ý: Trong môi trường thực tế, không nên lưu trữ thông tin đăng nhập trực tiếp trong code
  final String _senderEmail =
      'quang011103@gmail.com'; // Thay thế bằng email thực tế
  final String _appPassword = 'amjkamfoqcfjacce'; // Thay thế bằng App Password
  final String _senderName = 'Pine';

  /// Gửi email xác nhận đơn hàng
  Future<bool> sendOrderConfirmationEmail({
    required OrderModel order,
    required UserModel user,
  }) async {
    try {
      // Tạo SMTP server cho Gmail
      final smtpServer = gmail(_senderEmail, _appPassword);

      // Tạo nội dung email
      final message = Message()
        ..from = Address(_senderEmail, _senderName)
        ..recipients.add(user.email)
        ..subject =
            'Cảm ơn bạn đã đặt hàng! Đơn hàng  ${order.id} đang được xử lý'
        ..html = _buildOrderConfirmationEmailTemplate(order, user);

      // Gửi email
      final sendReport = await send(message, smtpServer);
      debugPrint(
          'Email xác nhận đơn hàng đã được gửi: ${sendReport.toString()}');
      return true;
    } catch (e) {
      debugPrint('Lỗi khi gửi email: $e');
      return false;
    }
  }

  String _buildOrderConfirmationEmailTemplate(
      OrderModel order, UserModel user) {
    String productsHtml = '';

    for (var item in order.items) {
      productsHtml += '''
        <tr>
          <td style="padding: 8px; border: 1px solid #ddd;">${item.title}</td>
          <td style="padding: 8px; text-align: center; border: 1px solid #ddd;">${item.quantity}</td>
          <td style="padding: 8px; text-align: right; border: 1px solid #ddd;">${item.price.toStringAsFixed(0)}đ</td>
          <td style="padding: 8px; text-align: right; border: 1px solid #ddd;">${(item.price * item.quantity).toStringAsFixed(0)}đ</td>
        </tr>
      ''';
    }

    // Format địa chỉ giao hàng
    String addressHtml = '<p>Không có thông tin địa chỉ</p>';
    if (order.address != null) {
      addressHtml = '''
        <p><strong>Tên người nhận:</strong> ${order.address!.name}</p>
        <p><strong>Số điện thoại:</strong> ${order.address!.phoneNumber}</p>
        <p><strong>Địa chỉ:</strong> ${order.address!.street}, ${order.address!.ward}, ${order.address!.city}, ${order.address!.province}</p>
      ''';
    }

    return '''
      <!DOCTYPE html>
      <html lang="vi">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #333;">
        <div style="background-color: #2AAD7B; padding: 20px; text-align: center;">
          <h1 style="color: white; margin: 0;">Pine</h1>
        </div>
        
        <div style="padding: 20px; border: 1px solid #ddd; border-top: none;">
          <h2>Xin chào ${user.lastName} ${user.firstName},</h2>
          <p>Cảm ơn bạn đã đặt hàng tại Pine. Đơn hàng của bạn đã được tiếp nhận và đang được xử lý.</p>
          
          <div style="background-color: #f9f9f9; padding: 15px; margin: 20px 0; border-radius: 5px;">
            <h3 style="margin-top: 0; color: #2AAD7B;">Thông tin đơn hàng ${order.id}</h3>
            <p><strong>Ngày đặt:</strong> ${order.formattedOrderDate}</p>
            <p><strong>Trạng thái:</strong> ${order.orderStatusText}</p>
            <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
            <p><strong>Tổng tiền:</strong> ${order.totalAmount.toStringAsFixed(0)}đ</p>
          </div>
          
          <h3 style="color: #2AAD7B;">Sản phẩm đã đặt</h3>
          <div style="overflow-x: auto;">
          <table style="width: 100%; border-collapse: collapse;">
            <tr style="background-color: #f2f2f2;">
              <th style="padding: 8px; text-align: left; border: 1px solid #ddd;">Sản phẩm</th>
              <th style="padding: 8px; text-align: center; border: 1px solid #ddd;">Số lượng</th>
              <th style="padding: 8px; text-align: right; border: 1px solid #ddd;">Đơn giá</th>
              <th style="padding: 8px; text-align: right; border: 1px solid #ddd;">Thành tiền</th>
            </tr>
            ${productsHtml}
          </table>
          </div>
          
          <div style="margin-top: 20px;">
            <h3 style="color: #2AAD7B;">Địa chỉ giao hàng</h3>
            ${addressHtml}
          </div>
          
          <div style="margin-top: 30px; text-align: center; color: #666; font-size: 14px;">
            <p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ chúng tôi qua email support@pine.com</p>
          </div>
        </div>
        
        <div style="background-color: #f2f2f2; padding: 15px; text-align: center; font-size: 12px; color: #666;">
          <p>© ${DateTime.now().year} Pine.</p>
          <p>Đây là email tự động, vui lòng không trả lời.</p>
        </div>
      </body>
      </html>
    ''';
  }
}
