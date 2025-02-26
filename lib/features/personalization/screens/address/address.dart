import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/features/personalization/screens/address/add_new_address.dart';
import 'package:pine/features/personalization/screens/address/widgets/single_address.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PColors.primary,
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        child: Icon(Iconsax.add, color: PColors.white),
      ),
      appBar: PAppBar(
        showBackArrow: true,
        title: Text(
          'Địa chỉ',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(PSizes.defaultSpace),
        child: Column(
          children: [
            PSingleAddress(selectedAddress: false),
            PSingleAddress(selectedAddress: true),
          ],
        ),),
      ),
    );
  }
}
