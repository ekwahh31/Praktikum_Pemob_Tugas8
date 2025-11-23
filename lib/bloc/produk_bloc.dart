class ProdukBloc {
  static Future<bool> deleteProduk({required int id}) async {
    // Untuk sementara return true karena belum menggunakan REST API
    // Nanti akan diimplementasikan dengan API call yang sebenarnya
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}