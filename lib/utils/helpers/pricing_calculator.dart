
class PPricingCalculator {

  /// -- Calculate Price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {

  double shippingCost = getShippingCost(location);

  double totalPrice = productPrice + shippingCost;
  return totalPrice;
  }

  /// -- Calculate shipping cost
  static String calculateShippingCost(double productPrice, String location) {
  double shippingCost = getShippingCost(location);
  return shippingCost.toStringAsFixed(0);
  }

  static double getShippingCost(String location) {
  // Lookup the shipping cost for the given location using a shipping rate API.
  // Calculate the shipping cost based on various factors like distance, weight, etc.
  return 15000; // Example shipping cost of $5
  }

  /// -- Sum all cart values and return total amount
  // static double calculateCartTotal(CartModel cart) {
  //   return cart.items.map((e) => e.price).fold(0, (previousPrice, currentPrice) => previousPrice + (currentPrice ?? 0));
  // }
}
