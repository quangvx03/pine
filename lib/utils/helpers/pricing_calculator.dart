class PPricingCalculator {
  /// calculate price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {
    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + shippingCost;
    return totalPrice;
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
