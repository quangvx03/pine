# ỨNG DỤNG THƯƠNG MẠI ĐIỆN TỬ PINE - TRANG QUẢN TRỊ

## GIỚI THIỆU

Pine Admin Panel là trang quản trị hệ thống thương mại điện tử được phát triển bằng Flutter, Firebase và kiến trúc GetX. Trang quản trị cung cấp các tính năng quản lý sản phẩm, đơn hàng, danh mục và người dùng cho hệ thống mua sắm Pine.

## CÀI ĐẶT MÔI TRƯỜNG

### Yêu cầu hệ thống
- Flutter SDK: phiên bản 3.6.1 trở lên
- IDE: Visual Studio Code hoặc Android Studio
- Trình duyệt web hiện đại (Chrome, Firefox, Edge)

### Các bước cài đặt

1. **Cài đặt Flutter** (nếu chưa cài)
   ```
   # Kiểm tra cài đặt Flutter
   flutter doctor -v
   ```

2. **Tải các thư viện phụ thuộc**
   ```
   # Di chuyển vào thư mục dự án
   cd "<đường_dẫn_đến_thư_mục>/pine_admin_panel"
   
   # Cài đặt các dependencies
   flutter pub get
   ```

3. **Cấu hình Firebase và các dịch vụ**

   Dự án sử dụng Firebase cho các chức năng chính. Để chạy đầy đủ ứng dụng, bạn cần tạo các file cấu hình:
   
   - **Firebase**: 
     - Tạo file `lib/firebase_options.dart` từ Firebase Console
     - Tạo file `android/app/google-services.json` từ Firebase Console

   > **Lưu ý**: Các file chứa thông tin nhạy cảm này đã được thêm vào .gitignore để tránh chia sẻ thông tin lên hệ thống quản lý mã nguồn.

## CHẠY ỨNG DỤNG

1. **Khởi động ứng dụng web**
   ```
   # Chạy ứng dụng trong chế độ debug với Chrome
   flutter run -d chrome
   ```
   
   ```
   # Hoặc chạy với web-server để có thể truy cập từ thiết bị khác trong mạng
   flutter run -d web-server
   ```