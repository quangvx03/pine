import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:printing/printing.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/pdf_invoice_generator.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrderDetailDesktopScreen extends StatelessWidget {
  const OrderDetailDesktopScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with breadcrumb and export button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PBreadcrumbsWithHeading(
                      returnToPreviousScreen: true,
                      heading: order.id,
                      breadcrumbItems: [
                        {'label': 'Danh sách đơn hàng', 'path': PRoutes.orders},
                        'Chi tiết'
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // TODO: Thêm logic xuất hóa đơn cho đơn hàng
                      final pdfData = await PDFInvoiceGenerator.generateOrderInvoice(order);
                      await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdfData);
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text('Xuất hóa đơn'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: PSizes.spaceBtwSections),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        OrderInfo(order: order),
                        const SizedBox(height: PSizes.spaceBtwSections),
                        OrderItems(order: order),
                        const SizedBox(height: PSizes.spaceBtwSections),
                        OrderTransaction(order: order),
                      ],
                    ),
                  ),
                  const SizedBox(width: PSizes.spaceBtwSections),
                  // Right Side Customer Info
                  Expanded(
                    child: Column(
                      children: [
                        OrderCustomer(order: order),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

