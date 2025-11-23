# TUGAS 8 PERTEMUAN 10 PRAKTIKUM PEMOGRAMAN MOBILE
Berikut ini merupakan laporan hasil pengerjaan tugas 8 pertemuan 10 praktikum pemograman web. <br>
Nama  : Eka Bintang Wicaksono <br>
NIM   : H1D023054 <br>
Shift : B/A <br>

# Penjelasan Kode

<h1> Model </h1>

<h2>1. Login.dart</h2>
Model data response login dengan properti code, status, token, userID, dan userEmail. Factory method fromJson() melakukan conditional parsing - jika code 200 maka parse semua data termasuk token dan user info dari nested object, jika gagal hanya parse code dan status.

```
class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;
  Login({this.code, this.status, this.token, this.userID, this.userEmail});
  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['code'] == 200) {
      return Login(
        code: obj['code'],
        status: obj['status'],
        token: obj['data']['token'],
        userID: int.parse(obj['data']['user']['id']),

        userEmail: obj['data']['user']['email'],
      );
    } else {
      return Login(code: obj['code'], status: obj['status']);
    }
  }
}
```
<h2>2. Registrasi.dart</h2>
Model data response registrasi dengan properti code, status, dan data. Dilengkapi factory method fromJson() untuk parsing response API registrasi dengan struktur yang lebih sederhana dibanding model Login.

```
class Registrasi {
  int? code;
  bool? status;
  String? data;
  Registrasi({this.code, this.status, this.data});
  factory Registrasi.fromJson(Map<String, dynamic> obj) {
    return Registrasi(
      code: obj['code'],
      status: obj['status'],
      data: obj['data'],
    );
  }
}
```
<h2>3. Produk.dart</h2>
Model data produk dengan properti id, kodeProduk, namaProduk, dan hargaProduk. Dilengkapi dengan factory method fromJson() untuk parsing data dari API.

```
class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  var hargaProduk;
  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});
  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'],
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: obj['harga'],
    );
  }
}
```

<h1> Model </h1>

<h2>1. Login_page.dart</h2>
Halaman login dengan form input email dan password. Dilengkapi validasi bahwa kedua field harus diisi, serta link navigasi ke halaman registrasi di bagian bawah.

<h2>2. Registrasi_page.dart</h2>
Halaman registrasi akun baru dengan form input nama (minimal 3 karakter), email (dengan validasi format regex), password (minimal 6 karakter), dan konfirmasi password yang harus sama dengan password utama.

<h2>3. Produk_page.dart</h2>
Halaman utama yang menampilkan daftar produk dalam ListView. Memiliki AppBar dengan icon tambah untuk menambah produk baru, Drawer menu dengan opsi Logout, dan setiap item produk dapat diklik untuk melihat detail.

<h2>4. Produk_detail.dart</h2>
Halaman detail produk yang menampilkan kode, nama, dan harga produk. Dilengkapi tombol EDIT untuk mengubah data dan tombol DELETE dengan konfirmasi AlertDialog sebelum menghapus produk.

<h2>4. Produk_detail.dart</h2>
Halaman form multifungsi untuk tambah atau edit produk dengan input kode, nama, dan harga. Mode form (tambah/edit) ditentukan otomatis oleh method isUpdate() saat initState, yang mengubah judul dan label tombol sesuai kondisi.

<h2>5. warning_dialog.dart</h2>
Widget reusable AlertDialog untuk menampilkan pesan peringatan atau error. Menerima parameter description untuk pesan dan okClick sebagai callback opsional setelah user klik tombol OK.

<h2>6. produk_bloc.dart</h2>
Business Logic Component untuk operasi produk. Saat ini berisi method static deleteProduk() dengan dummy implementation (delay 1 detik return true), yang nantinya akan diganti dengan actual API call.

<h2>7. main.dart</h2>
Entry point aplikasi yang menjalankan MaterialApp dengan title "Toko Kita", debugShowCheckedModeBanner false, dan home diset ke ProdukPage sebagai halaman awal aplikasi.

# Screenshoot Aplikasi

1. Halaman Registrasi
<img width="499" height="1002" alt="image" src="https://github.com/user-attachments/assets/811844b9-3de7-462b-9047-87147ebcf17e" />

2. Halaman Login
<img width="501" height="1000" alt="image" src="https://github.com/user-attachments/assets/7bffeee6-065a-4702-92ad-b69bcb5770a7" />

3. Halaman List Produk
<img width="503" height="1002" alt="image" src="https://github.com/user-attachments/assets/2ebdf9e6-5501-429c-8b63-ebe843648b86" />

4. Halaman Tambah Produk
<img width="497" height="999" alt="image" src="https://github.com/user-attachments/assets/17cebccf-52d2-4c76-9588-1da31861ca6e" />

5. Halaman Detail Produk
<img width="498" height="999" alt="image" src="https://github.com/user-attachments/assets/654f1972-5490-4e22-96e9-5764a5dc7670" />

6. Halaman Edit Produk
<img width="500" height="997" alt="image" src="https://github.com/user-attachments/assets/89242ab3-d541-403c-99b1-dc69ec221146" />

7. Halaman Delete Produk
<img width="492" height="996" alt="image" src="https://github.com/user-attachments/assets/015ed5b5-413f-447d-b1f5-d4ada496a6b3" />

8. Halaman Logout
<img width="497" height="999" alt="image" src="https://github.com/user-attachments/assets/94d1e2d3-7a26-49a5-9b18-61c3d24ccfce" />
