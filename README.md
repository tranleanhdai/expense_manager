#  Ứng dụng Quản Lý Chi Tiêu (Expense Manager)

##  Giới thiệu

Expense Manager là một ứng dụng di động đa nền tảng được xây dựng bằng **Flutter**, giúp người dùng theo dõi chi tiêu hằng ngày, quản lý ngân sách và kiểm soát tài chính cá nhân một cách hiệu quả. Ứng dụng tích hợp **Firebase** và lưu trữ cục bộ để đảm bảo hoạt động ổn định.

---

##  Chức năng chính

###  Xác thực người dùng

* Đăng ký tài khoản
* Đăng nhập
* Tích hợp Firebase Authentication

###  Quản lý giao dịch

* Thêm giao dịch chi tiêu
* Xem danh sách giao dịch
* Xem chi tiết giao dịch
* Theo dõi lịch sử giao dịch

###  Quản lý ngân sách

* Tạo ngân sách
* Xem chi tiết ngân sách
* Theo dõi chi tiêu so với ngân sách

###  Trang chủ

* Hiển thị tổng quan tài chính
* Điều hướng giữa các chức năng

###  Hồ sơ người dùng

* Xem và chỉnh sửa thông tin cá nhân
* Hỗ trợ avatar

###  Quản lý số dư

* Cập nhật số dư tài khoản

###  Thông báo

* Nhắc nhở chi tiêu
* Thông báo cục bộ

###  Lưu trữ dữ liệu

* SQLite (sqflite)
* Shared Preferences
* Firebase Firestore

###  Tích hợp Firebase

* Firebase Core
* Firebase Authentication
* Cloud Firestore
* Firebase Storage

###  Quản lý trạng thái

* Sử dụng Provider

---

##  Cấu trúc project

```
lib/
 ├── models/              # Model dữ liệu
 ├── screens/             # Giao diện
 ├── providers/           # State management
 ├── services/            # Logic xử lý
 ├── database/            # Database local
 ├── utils/               # Helper (notification,...)
 └── main.dart            # Entry point
```

---

## 🛠️ Công nghệ sử dụng

* Flutter (Dart)
* Firebase
* SQLite (sqflite)
* Provider
* Shared Preferences

---

##  Cài đặt và chạy

### 1. Clone project

```
git clone https://github.com/your-username/expense_manager.git
cd expense_manager
```

### 2. Cài thư viện

```
flutter pub get
```

### 3. Cấu hình Firebase

* Tạo project Firebase
* Thêm app Android/iOS
* Thêm file:

  * `google-services.json`
  * `GoogleService-Info.plist`

### 4. Chạy app

```
flutter run
```

---

##  Nền tảng hỗ trợ

* Android
* iOS
* Web
* Windows

---

## Hướng phát triển

* Thêm chức năng đổi tiền
* Thêm biểu đồ thống kê
* Dark mode
* Tối ưu đồng bộ dữ liệu

---

##  Ảnh demo



###  Trang chủ
![Trang chủ](assets/images/trangchu.jpg)

###  Giao dịch mới
![Giao dịch mới](assets/images/giaodichmoi.jpg)

###  Danh sách giao dịch
![Danh sách](assets/images/danhsachgiaodich.jpg)

###  Ngân sách
![Ngân sách](assets/images/ngansachdangapdung.jpg)

###  Hồ sơ
![Hồ sơ](assets/images/hoso.jpg)

###  Danh sách tiền
![List tiền](assets/images/listtien.jpg)

##  Đóng góp

1. Fork project
2. Tạo branch mới
3. Commit code
4. Push lên GitHub
5. Tạo Pull Request

---

##  License

MIT License

---

## Tác giả

* Đại Trần

---

##  Ghi chú

Đây là project phục vụ học tập và thực hành Flutter.
