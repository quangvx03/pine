import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/features/shop/models/supplier_model.dart';

class PDFInvoiceGenerator {
  static String formatCurrency(double amount) {
    final format = NumberFormat("#,###", "vi_VN");
    return "${format.format(amount)}₫";
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'vi_VN');
    return formatter.format(date);
  }

  /// HÓA ĐƠN NHẬP HÀNG (Supplier)
  static Future<Uint8List> generateSupplierInvoice(SupplierModel supplier) async {
    await initializeDateFormatting('vi_VN');

    final pdf = pw.Document();
    final regularFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Cabin-Regular.ttf'));
    final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Cabin-Bold.ttf'));

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.DefaultTextStyle(
            style: pw.TextStyle(font: regularFont, fontSize: 12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('HÓA ĐƠN NHẬP HÀNG', style: pw.TextStyle(font: boldFont, fontSize: 20)),
                      pw.SizedBox(height: 4),
                      pw.Text('Ngày ${formatDate(supplier.createdAt)}', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text('Đơn vị bán hàng: ${supplier.name}', style: pw.TextStyle(font: boldFont)),
                pw.Text('MST: ................'),
                pw.Text('Địa chỉ: ${supplier.address ?? "Không có"}'),
                pw.Text('Điện thoại: 0123 456 789       Fax: ...............'),
                pw.Text('Số tài khoản: ...................................................'),
                pw.SizedBox(height: 12),
                pw.Text('Họ tên người mua hàng: .............................................................'),
                pw.Text('Tên đơn vị: ................'),
                pw.Text('Mã số thuế: ...................................................'),
                pw.Text('Địa chỉ: ..................'),
                pw.Text('Hình thức thanh toán: ..................................      Số tài khoản: .......................'),
                pw.SizedBox(height: 16),
                pw.Text('Danh sách hàng hóa:', style: pw.TextStyle(font: boldFont)),
                pw.Table.fromTextArray(
                  headers: ['STT', 'Tên hàng hóa', 'Số lượng', 'Đơn giá', 'Thành tiền'],
                  data: List.generate(supplier.products.length, (index) {
                    final item = supplier.products[index];
                    return [
                      '${index + 1}',
                      item.product.title,
                      '${item.quantity}',
                      formatCurrency(item.price),
                      formatCurrency(item.total),
                    ];
                  }),
                  headerStyle: pw.TextStyle(font: boldFont),
                  cellStyle: pw.TextStyle(font: regularFont),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  border: pw.TableBorder.all(),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 12),
                pw.Text('Cộng tiền hàng hóa, dịch vụ: ${formatCurrency(supplier.totalAmount)}'),
                pw.Text(
                  'Số tiền viết bằng chữ: ${convertNumberToWords(supplier.totalAmount.toInt())} đồng',
                ),
                pw.SizedBox(height: 60),
                _buildSignatures(boldFont),
                pw.SizedBox(height: 12),
                _buildNote(regularFont),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// HÓA ĐƠN BÁN HÀNG (Order)
  static Future<Uint8List> generateOrderInvoice(OrderModel order) async {
    await initializeDateFormatting('vi_VN');
    final pdf = pw.Document();
    final regularFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Cabin-Regular.ttf'));
    final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Cabin-Bold.ttf'));

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.DefaultTextStyle(
            style: pw.TextStyle(font: regularFont, fontSize: 12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('HÓA ĐƠN BÁN HÀNG', style: pw.TextStyle(font: boldFont, fontSize: 20)),
                      pw.SizedBox(height: 4),
                      pw.Text('Mã đơn: ${order.id}'),
                      pw.Text('Ngày ${formatDate(order.orderDate)}'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text('Khách hàng: ${order.address?.name ?? "Không có tên"}', style: pw.TextStyle(font: boldFont)),
                pw.Text('Địa chỉ giao hàng: ${order.address?.toString() ?? "Không có địa chỉ"}'),
                pw.Text('SĐT: ${order.address?.phoneNumber ?? "Không có số điện thoại"}'),
                pw.SizedBox(height: 16),
                pw.Text('Chi tiết đơn hàng:', style: pw.TextStyle(font: boldFont)),
                pw.Table.fromTextArray(
                  headers: ['STT', 'Sản phẩm', 'Số lượng', 'Đơn giá', 'Thành tiền'],
                  data: List.generate(order.items.length, (index) {
                    final item = order.items[index];
                    return [
                      '${index + 1}',
                      item.title,
                      '${item.quantity}',
                      formatCurrency(item.price),
                      formatCurrency(item.quantity * item.price),
                    ];
                  }),
                  headerStyle: pw.TextStyle(font: boldFont),
                  cellStyle: pw.TextStyle(font: regularFont),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  border: pw.TableBorder.all(),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 12),
                _buildTotalSection(order, regularFont, boldFont),
                pw.SizedBox(height: 60),
                _buildSignatures(boldFont),
                pw.SizedBox(height: 12),
                _buildNote(regularFont),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildTotalSection(OrderModel order, pw.Font regularFont, pw.Font boldFont) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Tạm tính:'),
            pw.Text(formatCurrency(
              order.items.fold<double>(0, (sum, item) => sum + item.price * item.quantity),
            )),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Giảm giá:'),
            pw.Text('- ${formatCurrency(order.discountAmount)}'),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Phí vận chuyển:'),
            pw.Text(formatCurrency(order.shippingCost)),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Tổng tiền:', style: pw.TextStyle(font: boldFont)),
            pw.Text(formatCurrency(order.totalAmount), style: pw.TextStyle(font: boldFont)),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text('Số tiền bằng chữ: ${convertNumberToWords(order.totalAmount.toInt())} đồng'),
      ],
    );
  }

  static pw.Widget _buildSignatures(pw.Font boldFont) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Container(
          width: 200,
          alignment: pw.Alignment.center,
          child: pw.Column(
            children: [
              pw.Text('Người mua hàng', style: pw.TextStyle(font: boldFont)),
              pw.Text('(Ký, ghi rõ họ tên)', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 135),
              pw.Divider(),
            ],
          ),
        ),
        pw.Container(
          width: 200,
          alignment: pw.Alignment.center,
          child: pw.Column(
            children: [
              pw.Text('Người bán hàng', style: pw.TextStyle(font: boldFont)),
              pw.Text('(Ký, đóng dấu, ghi rõ họ tên)', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 135),
              pw.Divider(),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildNote(pw.Font font) {
    return pw.Center(
      child: pw.Text(
        '(Cần kiểm tra, đối chiếu khi lập, giao, nhận hóa đơn)',
        style: pw.TextStyle(fontSize: 9, font: font, fontStyle: pw.FontStyle.italic),
      ),
    );
  }
}

/// Convert number to Vietnamese words
String convertNumberToWords(int number) {
  final units = ['', 'một', 'hai', 'ba', 'bốn', 'năm', 'sáu', 'bảy', 'tám', 'chín'];

  String readThreeDigits(int n) {
    int hundred = n ~/ 100;
    int ten = (n ~/ 10) % 10;
    int unit = n % 10;
    String result = '';

    if (hundred != 0) {
      result += '${units[hundred]} trăm';
      if (ten == 0 && unit != 0) {
        result += ' linh';
      }
    }

    if (ten != 0) {
      if (ten == 1) {
        result += ' mười';
      } else {
        result += ' ${units[ten]} mươi';
      }
    }

    if (unit != 0) {
      if (ten == 0 && hundred == 0) {
        result += units[unit];
      } else if (unit == 1) {
        result += (ten != 0 && ten != 1) ? ' mốt' : ' một';
      } else if (unit == 5 && ten != 0) {
        result += ' lăm';
      } else {
        result += ' ${units[unit]}';
      }
    }

    return result.trim();
  }

  if (number == 0) return 'không';

  final unitsGroup = ['tỷ', 'triệu', 'nghìn', ''];
  final groups = <int>[];

  for (int i = 0; i < 4; i++) {
    groups.insert(0, number % 1000);
    number ~/= 1000;
  }

  String result = '';
  for (int i = 0; i < groups.length; i++) {
    if (groups[i] != 0) {
      result += '${readThreeDigits(groups[i])} ${unitsGroup[i]} ';
    }
  }

  return result.trim();
}
