import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: Text(
          'Quyền riêng tư',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Chính Sách Quyền Riêng Tư',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .apply(fontWeightDelta: 2),
              ),
              const SizedBox(height: PSizes.spaceBtwItems),
              Text(
                'Cập nhật lần cuối: 21/04/2025',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Nội dung
              _buildSection(
                context: context,
                icon: Iconsax.info_circle,
                title: 'Thông tin chung',
                content:
                    'Ứng dụng Pine cam kết bảo vệ quyền riêng tư của bạn. Chính sách này mô tả cách chúng tôi thu thập, sử dụng và bảo vệ thông tin cá nhân khi bạn sử dụng ứng dụng của chúng tôi.',
              ),

              _buildSection(
                context: context,
                icon: Iconsax.document,
                title: 'Thông tin chúng tôi thu thập',
                content:
                    'Chúng tôi chỉ thu thập thông tin cơ bản cần thiết để cung cấp dịch vụ cho bạn như:\n• Thông tin tài khoản (tên, email)\n• Thông tin thanh toán\n• Thông tin đơn hàng\n• Địa chỉ giao hàng',
              ),

              _buildSection(
                context: context,
                icon: Iconsax.security_user,
                title: 'Bảo mật thông tin',
                content:
                    'Chúng tôi cam kết bảo vệ thông tin của bạn bằng các biện pháp bảo mật hợp lý. Tất cả thông tin thanh toán được mã hóa và chúng tôi không lưu trữ thông tin thẻ tín dụng của bạn.',
              ),

              _buildSection(
                context: context,
                icon: Iconsax.share,
                title: 'Chia sẻ thông tin',
                content:
                    'Chúng tôi không bán hoặc chia sẻ thông tin cá nhân của bạn với bên thứ ba ngoại trừ khi cần thiết để cung cấp dịch vụ (như đối tác vận chuyển để giao hàng).',
              ),

              _buildSection(
                context: context,
                icon: Iconsax.user,
                title: 'Quyền của bạn',
                content:
                    'Bạn có quyền:\n• Truy cập thông tin cá nhân của mình\n• Chỉnh sửa thông tin không chính xác\n• Yêu cầu xóa tài khoản\n• Nhận bản sao dữ liệu của bạn',
              ),

              _buildSection(
                context: context,
                icon: Iconsax.call,
                title: 'Liên hệ',
                content:
                    'Nếu bạn có bất kỳ câu hỏi nào về chính sách quyền riêng tư này, vui lòng liên hệ với chúng tôi qua:\n• Email: support@pine.app\n• Điện thoại: 0123-456-789',
              ),

              const SizedBox(height: PSizes.spaceBtwSections),

              // Nút đồng ý
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Tôi đã hiểu"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Container(
      margin: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: dark ? PColors.dark : PColors.light,
        borderRadius: BorderRadius.circular(PSizes.cardRadiusMd),
        border: Border.all(
            color: dark ? PColors.darkGrey : PColors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: PColors.primary),
                const SizedBox(width: PSizes.sm),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.apply(
                        fontWeightDelta: 2,
                        color: PColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: PSizes.sm),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
