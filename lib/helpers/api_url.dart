class ApiUrl {
  static const String baseUrl = 'http://172.16.187.51/toko-api/public';

  // Auth
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Produk
  static const String listProduk = '$baseUrl/produk';
  static const String createProduk = '$baseUrl/produk';

  static String updateProduk(int id) {
    return '$baseUrl/produk/$id/update';
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }
}
