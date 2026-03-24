import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print("Bypass SSL for host: $host");
        return true; // Bỏ qua tất cả certificate & hostname mismatch
      };
  }
}
