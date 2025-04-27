# ỨNG DỤNG THƯƠNG MẠI ĐIỆN TỬ PINE

## GIỚI THIỆU

Pine là ứng dụng thương mại điện tử được phát triển bằng Flutter, Firebase và kiến trúc GetX. Ứng dụng cung cấp trải nghiệm mua sắm toàn diện với các tính năng như duyệt sản phẩm, tìm kiếm, giỏ hàng, thanh toán và theo dõi đơn hàng.

## CÀI ĐẶT MÔI TRƯỜNG

### Yêu cầu hệ thống
- Flutter SDK: phiên bản 3.6.1 trở lên
- Android SDK: tối thiểu API level 23 (Android 6.0 Marshmallow)
- IDE: Visual Studio Code hoặc Android Studio
- Thiết bị Android: thiết bị thật hoặc máy ảo có Android 6.0 trở lên

### Các bước cài đặt

1. **Cài đặt Flutter** (nếu chưa cài)
   ```
   # Kiểm tra cài đặt Flutter
   flutter doctor -v
   ```

2. **Tải các thư viện phụ thuộc**
   ```
   # Di chuyển vào thư mục dự án
   cd "<đường_dẫn_đến_thư_mục>/pine"
   
   # Cài đặt các dependencies
   flutter pub get
   ```

3. **Cấu hình Firebase và các dịch vụ**

   Dự án sử dụng Firebase và VNPay cho các chức năng chính. Để chạy đầy đủ ứng dụng, bạn cần tạo các file cấu hình từ các file mẫu:
   
   - **Firebase**: 
     - Tạo file `lib/firebase_options.dart` từ file mẫu `firebase_options.dart.example`
     - Tạo file `android/app/google-services.json` từ file mẫu `google-services.json.example`
   
   - **VNPay**: 
     - Tạo file `lib/utils/constants/vnpay_config.dart` từ file mẫu `vnpay_config.dart.example`

   > **Lưu ý**: Các file mẫu đã được cung cấp với cấu trúc giống hệt file thực, chỉ cần thay thế các giá trị ví dụ bằng giá trị thực từ Firebase Console và VNPay.

## CHẠY ỨNG DỤNG

1. **Kết nối thiết bị Android**
   - Kết nối thiết bị Android thật qua cáp USB và bật chế độ "USB Debugging"
   - Hoặc khởi động máy ảo Android từ Android Studio/VS Code

2. **Chạy ứng dụng**
   ```
   # Chạy ứng dụng trong chế độ debug
   flutter run
   ```
   
   ```
   # Hoặc chạy phiên bản release
   flutter run --release
   