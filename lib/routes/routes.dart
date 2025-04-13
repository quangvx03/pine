
class PRoutes {

  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password/';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const staffDashboard = '/staff-dashboard';
  static const media = '/media';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  static const products = '/products';
  static const createProduct = '/createProduct';
  static const editProduct = '/editProduct';

  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';

  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand';

  static const customers = '/customers';
  static const createCustomer = '/createCustomer';
  static const customerDetails = '/customerDetails';

  static const reviews = '/reviews';
  static const reviewDetails = '/reviewDetails';

  static const createStaff = '/createStaff';
  static const editStaff = '/editStaff';

  static const orders = '/orders';
  static const orderDetails = '/orderDetails';

  static const suppliers = '/suppliers';
  static const createSupplier = '/createSupplier';
  static const supplierDetails = '/supplierDetails';

  static const coupons = '/coupons';
  static const createCoupon = '/createCoupon';
  static const editCoupon = '/editCoupon';

  static const profile = '/profile';

  // Sidebar Menu Items List
  static List sidebarMenuItems = [dashboard, media, categories, brands, banners, products, coupons, customers, reviews, orders, suppliers, profile];
}