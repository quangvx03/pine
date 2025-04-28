import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/features/shop/controllers/supplier/supplier_detail_controller.dart';
import 'package:pine_admin_panel/features/shop/models/supplier_model.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../utils/helpers/pdf_invoice_generator.dart';
import '../widgets/supplier_info.dart';
import '../widgets/supplier_orders.dart';

class SupplierDetailDesktopScreen extends StatefulWidget {
  const SupplierDetailDesktopScreen({super.key, required this.supplier});
  final SupplierModel supplier;

  @override
  _SupplierDetailDesktopScreenState createState() =>
      _SupplierDetailDesktopScreenState();
}

class _SupplierDetailDesktopScreenState
    extends State<SupplierDetailDesktopScreen> {
  late SupplierDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SupplierDetailController());
    controller.setSupplier(widget.supplier);
  }

  Future<void> _reloadSupplierData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Suppliers')
        .doc(widget.supplier.id)
        .get();

    if (snapshot.exists) {
      final updatedSupplier = SupplierModel.fromSnapshot(snapshot);
      controller.setSupplier(updatedSupplier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Obx(() {
            final supplier = controller.supplier.value;
            if (supplier == null) return const CircularProgressIndicator();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PBreadcrumbsWithHeading(
                        returnToPreviousScreen: true,
                        heading: supplier.name,
                        breadcrumbItems: [
                          {
                            'label': 'Danh sách đơn nhập hàng',
                            'path': PRoutes.suppliers
                          },
                          'Chi tiết'
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _reloadSupplierData(); // load lại
                        final updatedSupplier = controller.supplier.value;

                        final pdfData = await PDFInvoiceGenerator
                            .generateSupplierInvoice(updatedSupplier!);
                        await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async => pdfData);
                      },
                      icon:
                      const Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: const Text('Xuất hóa đơn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: PSizes.spaceBtwSections),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SupplierInfo(supplier: supplier),
                          const SizedBox(height: PSizes.spaceBtwSections),
                        ],
                      ),
                    ),
                    const SizedBox(width: PSizes.spaceBtwSections),
                    const Expanded(flex: 2, child: SupplierProducts()),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
