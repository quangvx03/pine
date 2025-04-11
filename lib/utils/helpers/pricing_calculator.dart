class PPricingCalculator {
  static double calculateTotalPrice(double productPrice, String location,
      {double discount = 0}) {
    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + shippingCost - discount;

    return totalPrice > 0 ? totalPrice : 0;
  }

  /// calculate shipping cost
  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
  }

  static double getShippingCost(String location) {
    return 15000;
  }
}
