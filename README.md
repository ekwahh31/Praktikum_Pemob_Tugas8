# TUGAS 7 PERTEMUAN 9 PRAKTIKUM PEMOGRAMAN MOBILE
Berikut ini merupakan laporan hasil pengerjaan tugas 7 pertemuan 9 praktikum pemograman web. <br>
Nama  : Eka Bintang Wicaksono <br>
NIM   : H1D023054 <br>
Shift : B/A <br>

# Screenshoot Aplikasi
https://github.com/user-attachments/assets/1296cc2e-5036-46b9-b77b-71ad6e141429

# Penjelasan Kode

## 1. Proses Registrasi
Dari halaman login, klik "Registrasi" untuk membuka halaman registrasi.
1. Membuka Halaman Registrasi
```
TextButton(
  child: const Text("Registrasi"),
  onPressed: () {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegistrasiPage()));
  },
)
```
Dari halaman login, user dapat mengakses halaman registrasi dengan mengklik link "Belum punya akun? Registrasi" yang berada di bagian bawah form login. Ketika link diklik, aplikasi menggunakan Navigator.push() untuk membuka halaman RegistrasiPage tanpa menghapus halaman login dari stack navigasi, sehingga user bisa kembali ke halaman login dengan tombol back.

2. Validasi Registrasi
```
// Validasi Nama
validator: (value) {
  if (value!.length < 3) {
    return "Nama harus diisi minimal 3 karakter";
  }
  return null;
}

// Validasi Email
validator: (value) {
  if (value!.isEmpty) {
    return 'Email harus diisi';
  }
  Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  RegExp regex = RegExp(pattern.toString());
  if (!regex.hasMatch(value)) {
    return "Email tidak valid";
  }
  return null;
}

// Validasi Password
validator: (value) {
  if (value!.length < 6) {
    return "Password harus diisi minimal 6 karakter";
  }
  return null;
}

// Validasi Konfirmasi Password
validator: (value) {
  if (value != _passwordTextboxController.text) {
    return "Konfirmasi Password tidak sama";
  }
  return null;
}
```
Halaman registrasi menampilkan form dengan empat field input yang harus diisi user. Field Nama divalidasi minimal 3 karakter menggunakan value!.length < 3. Field Email memiliki dua validasi yaitu mengecek apakah kosong dengan value!.isEmpty dan memvalidasi format email menggunakan Regex pattern yang memastikan struktur email benar dengan adanya @ dan domain. Field Password menggunakan obscureText: true untuk menyembunyikan input dan divalidasi minimal 6 karakter. Field Konfirmasi Password juga menggunakan obscureText: true dan membandingkan input dengan password menggunakan value != _passwordTextboxController.text untuk memastikan user tidak salah ketik.

3. Submit Registrasi
`registrasi_page.dart`
```
void _submit() {
  _formKey.currentState!.save();
  setState(() {
    _isLoading = true;
  });
  RegistrasiBloc.registrasi(
    nama: _namaTextboxController.text,
    email: _emailTextboxController.text,
    password: _passwordTextboxController.text
  ).then((value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SuccessDialog(
        description: "Registrasi berhasil, silahkan login",
        okClick: () {
          Navigator.pop(context);
        },
      )
    );
  }, onError: (error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const WarningDialog(
        description: "Registrasi gagal, silahkan coba lagi",
      )
    );
  });
  setState(() {
    _isLoading = false;
  });
}
```
`registrasi_bloc.dart`
```
static Future<Registrasi> registrasi(
    {String? nama, String? email, String? password}) async {
  String apiUrl = ApiUrl.registrasi;
  
  var body = {"nama": nama, "email": email, "password": password};
  
  var response = await Api().post(apiUrl, body);
  var jsonObj = json.decode(response.body);
  return Registrasi.fromJson(jsonObj);
}
```
Setelah user mengklik tombol "Registrasi", aplikasi menjalankan _formKey.currentState!.validate() untuk mengecek semua validasi field. Jika semua validator mengembalikan null (validasi berhasil), method _submit() akan dijalankan yang mengubah state _isLoading menjadi true, lalu mengirim data nama, email, dan password ke server melalui RegistrasiBloc.registrasi(). RegistrasiBloc membuat body JSON berisi data user dan mengirimnya ke API endpoint registrasi menggunakan method POST dari class Api. Jika registrasi berhasil, aplikasi menampilkan SuccessDialog dengan pesan "Registrasi berhasil, silahkan login" dan tombol OK yang menutup dialog kembali ke halaman login. Jika gagal, aplikasi menampilkan WarningDialog dengan pesan "Registrasi gagal, silahkan coba lagi" menggunakan onError callback.

## 2. Proses Login
Halaman login adalah halaman awal jika user belum login (token tidak ditemukan).
1. Membuka Halaman Login
Kode pengecekan login `main.dart`
```
void isLogin() async {
  var token = await UserInfo().getToken();
  if (token != null) {
    setState(() {
      page = const ProdukPage();
    });
  } else {
    setState(() {
      page = const LoginPage();
    });
  }
}
```
Ketika aplikasi pertama kali dibuka, method isLogin() pada main.dart akan otomatis dijalankan saat initState(). Method ini menggunakan UserInfo().getToken() untuk mengecek apakah ada token tersimpan di SharedPreferences. Jika token ditemukan (user pernah login sebelumnya), aplikasi langsung mengarahkan ke ProdukPage menggunakan setState() dengan mengubah widget page. Jika token tidak ada atau null, aplikasi akan menampilkan LoginPage sebagai halaman awal, memaksa user untuk login terlebih dahulu sebelum mengakses fitur aplikasi.

2. Mengisi Form Login
Kode validasi `login_page.dart`
```
// Validasi Email
validator: (value) {
  if (value!.isEmpty) {
    return 'Email harus diisi';
  }
  return null;
}

// Validasi Password
validator: (value) {
  if (value!.isEmpty) {
    return 'Password harus diisi';
  }
  return null;
}
```
Halaman login menampilkan form sederhana dengan dua field input yaitu Email dan Password. Field Email menggunakan keyboardType: TextInputType.emailAddress untuk menampilkan keyboard khusus email dan divalidasi hanya mengecek apakah kosong dengan value!.isEmpty. Field Password menggunakan obscureText: true untuk menyembunyikan karakter input dan juga divalidasi hanya mengecek apakah kosong. Kedua validasi ini lebih sederhana dibanding registrasi karena validasi detail sudah dilakukan saat registrasi, dan pada login hanya memastikan user mengisi kedua field sebelum data dikirim ke server untuk autentikasi.

3. Submit Login
Setelah validasi berhasil, kredensial dikirim ke API. Jika berhasil, token disimpan dan user diarahkan ke halaman produk.
Kode proses login `login_page.dart`
```
void _submit() {
  _formKey.currentState!.save();
  setState(() {
    _isLoading = true;
  });
  LoginBloc.login(
    email: _emailTextboxController.text,
    password: _passwordTextboxController.text
  ).then((value) async {
    if (value.code == 200) {
      await UserInfo().setToken(value.token.toString());
      await UserInfo().setUserID(value.userID!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProdukPage())
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Login gagal, silahkan coba lagi",
        )
      );
    }
  }, onError: (error) {
    print(error);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const WarningDialog(
        description: "Login gagal, silahkan coba lagi",
      )
    );
  });
  setState(() {
    _isLoading = false;
  });
}
```
Kode LoginBloc `login_bloc.dart`
```
static Future<Login> login({String? email, String? password}) async {
  String apiUrl = ApiUrl.login;
  
  var body = {"email": email, "password": password};
  
  var response = await Api().post(apiUrl, body);
  var jsonObj = json.decode(response.body);
  return Login.fromJson(jsonObj);
}
```
Kode menyimpan token `user_info.dart`
```
uture setToken(String value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setString("token", value);
}

Future setUserID(int value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setInt("userID", value);
}
```
Setelah user mengklik tombol "Login", aplikasi menjalankan _formKey.currentState!.validate() untuk memvalidasi kedua field. Jika valid, method _submit() dijalankan yang mengubah _isLoading menjadi true, lalu memanggil LoginBloc.login() dengan parameter email dan password dari controller. LoginBloc membuat body JSON dan mengirimnya ke API endpoint login menggunakan POST request, kemudian response diubah menjadi object Login menggunakan Login.fromJson(). Jika response code adalah 200 (berhasil), aplikasi menyimpan token dan userID ke SharedPreferences menggunakan UserInfo().setToken() dan UserInfo().setUserID(), lalu menggunakan Navigator.pushReplacement() untuk mengganti halaman login dengan ProdukPage (tidak bisa back ke login). Jika login gagal atau terjadi error, aplikasi menampilkan WarningDialog dengan pesan "Login gagal, silahkan coba lagi" menggunakan callback onError.

## 3. Proses CRUD
Setelah login berhasil, user melihat daftar semua produk dalam bentuk list.
1. Proses Halaman List Produk (READ)
a. Halaman List Produk
Kode halaman produk `produk_page.dart`
```
class ListProduk extends StatelessWidget {
  final List? list;
  const ListProduk({Key? key, this.list}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemProduk(
          produk: list![i],
        );
      }
    );
  }
}
```
Kode mengambil data produk `produk_bloc.dart`
```
static Future<List<Produk>> getProduks() async {
  String apiUrl = ApiUrl.listProduk;
  var response = await Api().get(apiUrl);
  var jsonObj = json.decode(response.body);
  List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
  List<Produk> produks = [];
  for (int i = 0; i < listProduk.length; i++) {
    produks.add(Produk.fromJson(listProduk[i]));
  }
  return produks;
}
```
Setelah login berhasil, aplikasi otomatis menampilkan ProdukPage yang berisi daftar semua produk menggunakan widget ListProduk. Widget ini menggunakan ListView.builder untuk menampilkan item secara dinamis berdasarkan jumlah data dari list produk. Method ProdukBloc.getProduks() mengirim GET request ke API endpoint ApiUrl.listProduk, kemudian response JSON di-decode dan array data produk diambil dari key 'data'. Setiap item JSON dalam array dikonversi menjadi object Produk menggunakan Produk.fromJson() dalam looping, lalu semua object Produk dikumpulkan ke dalam List<Produk> yang dikembalikan sebagai Future. ListView.builder menggunakan itemCount untuk menentukan jumlah item (0 jika list null) dan itemBuilder untuk membuat widget ItemProduk untuk setiap index.

b. Klik Item untuk Melihat Detail
User dapat mengklik salah satu item untuk melihat detail produk.
Kode navigasi ke detail `produk_page.dart`
```
lass ItemProduk extends StatelessWidget {
  final Produk produk;
  const ItemProduk({Key? key, required this.produk}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              produk: produk,
            )
          )
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk!),
          subtitle: Text(produk.hargaProduk.toString()),
        ),
      ),
    );
  }
}
```
Kode halaman detail `produk_detail.dart`
```
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Detail Produk'),
    ),
    body: Center(
      child: Column(
        children: [
          Text("Kode : ${widget.produk!.kodeProduk}"),
          Text("Nama : ${widget.produk!.namaProduk}"),
          Text("Harga : Rp. ${widget.produk!.hargaProduk.toString()}"),
          _tombolHapusEdit()
        ],
      ),
    ),
  );
}
```
Setiap item produk dibungkus dengan GestureDetector yang mendeteksi event onTap ketika user menyentuh Card. Widget ItemProduk menampilkan nama produk sebagai title dan harga sebagai subtitle dalam ListTile yang dibungkus Card. Ketika item diklik, aplikasi menggunakan Navigator.push() untuk membuka halaman ProdukDetail sambil mengirimkan object produk melalui constructor parameter. Halaman ProdukDetail menerima object produk melalui widget.produk dan menampilkan informasi lengkap produk menggunakan widget Text untuk kode produk, nama produk, dan harga produk yang diformat dengan prefix "Rp." untuk harga. Di bagian bawah informasi terdapat widget _tombolHapusEdit() yang berisi tombol EDIT dan DELETE.

2. Proses Tambah Produk (CREATE)
a. Membuka Form Tambah Produk
Dari halaman list produk, klik icon (+) di AppBar untuk membuka form tambah produk.
Kode navigasi `produk_page.dart`
```
floatingActionButton: FloatingActionButton(
  child: const Icon(Icons.add),
  onPressed: () async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdukForm())
    );
  },
)
```
Dari halaman ProdukPage, user dapat menambah produk baru dengan menekan FloatingActionButton yang berada di pojok kanan bawah dengan icon tambah (+). Ketika tombol diklik, aplikasi menggunakan Navigator.push() untuk membuka halaman ProdukForm tanpa mengirimkan parameter produk, sehingga widget.produk akan bernilai null yang menandakan mode tambah produk baru.

b. Mengisi Form Produk
User mengisi 3 field:
- **Kode Produk**
- **Nama Produk**
- **Harga Produk** (harus angka)

Kode form (`produk_form.dart`)
```
Widget _kodeProdukTextField() {
  return TextField(
    decoration: const InputDecoration(labelText: "Kode Produk"),
    keyboardType: TextInputType.text,
    controller: _kodeProdukTextboxController,
  );
}

Widget _namaProdukTextField() {
  return TextField(
    decoration: const InputDecoration(labelText: "Nama Produk"),
    keyboardType: TextInputType.text,
    controller: _namaProdukTextboxController,
  );
}

Widget _hargaProdukTextField() {
  return TextField(
    decoration: const InputDecoration(labelText: "Harga"),
    keyboardType: TextInputType.number,
    controller: _hargaProdukTextboxController,
  );
}
```
Halaman ProdukForm menampilkan tiga field input menggunakan widget TextField (bukan TextFormField karena tidak ada validasi kompleks). Field Kode Produk menggunakan keyboardType: TextInputType.text untuk keyboard standar, field Nama Produk juga menggunakan keyboard text, sedangkan field Harga menggunakan keyboardType: TextInputType.number agar keyboard yang muncul adalah numeric untuk memudahkan input angka. Setiap field dikontrol oleh TextEditingController masing-masing untuk mengambil nilai input user. Method isUpdate() yang dipanggil saat initState() mengecek widget.produk, jika null maka set judul menjadi "TAMBAH PRODUK EKA" dan tombol menjadi "SIMPAN", serta semua field dibiarkan kosong.

c. Submit Form Tambah
Setelah semua field terisi, klik tombol "SIMPAN" untuk menyimpan produk baru.
Kode proses simpan `produk_form.dart`
```
simpan() {
  setState(() {
    _isLoading = true;
  });
  Produk createProduk = Produk(id: null);
  createProduk.kodeProduk = _kodeProdukTextboxController.text;
  createProduk.namaProduk = _namaProdukTextboxController.text;
  createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  
  ProdukBloc.addProduk(produk: createProduk).then((value) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => const ProdukPage()
    ));
  }, onError: (error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "Simpan gagal, silahkan coba lagi",
      )
    );
  });
  setState(() {
    _isLoading = false;
  });
}
```
Kode ProdukBloc.addProduk `produk_bloc.dart`
```
static Future addProduk({Produk? produk}) async {
  String apiUrl = ApiUrl.createProduk;
  
  var body = {
    "kode_produk": produk!.kodeProduk,
    "nama_produk": produk.namaProduk,
    "harga": produk.hargaProduk.toString()
  };
  
  var response = await Api().post(apiUrl, body);
  var jsonObj = json.decode(response.body);
  return jsonObj['status'];
}
```
Ketika user menekan tombol "SIMPAN", method simpan() dijalankan yang mengubah _isLoading menjadi true. Aplikasi membuat object Produk baru dengan id null, lalu mengisi kodeProduk, namaProduk, dan hargaProduk dari nilai controller masing-masing field, dimana harga di-parse menjadi integer menggunakan int.parse(). Object produk ini dikirim ke ProdukBloc.addProduk() yang membuat body JSON dengan key sesuai format API (kode_produk, nama_produk, harga yang dikonversi ke string). Data dikirim ke server menggunakan POST request melalui Api().post(), response di-decode dan status dikembalikan. Jika berhasil, aplikasi menggunakan Navigator.push() untuk membuka ProdukPage yang menampilkan list produk terbaru termasuk produk yang baru ditambahkan. Jika gagal, aplikasi menampilkan WarningDialog dengan pesan "Simpan gagal, silahkan coba lagi" menggunakan callback onError.

3. Proses Ubah Produk (UPDATE)
a. Membuka Form Edit
Dari halaman detail produk, klik tombol "EDIT" untuk membuka form edit dengan data produk yang sudah terisi.
Kode navigasi `produk_detail.dart`
```
OutlinedButton(
  child: const Text("EDIT"),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukForm(
          produk: widget.produk!,
        )
      )
    );
  }
)
```
Kode mengisi form dengan data lama `produk_form.dart`
```
oid isUpdate() {
  if (widget.produk != null) {
    setState(() {
      judul = "UBAH PRODUK EKA";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextboxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk.toString();
    });
  } else {
    setState(() {
      judul = "TAMBAH PRODUK EKA";
      tombolSubmit = "SIMPAN";
    });
  }
}
```
Dari halaman ProdukDetail, user dapat mengedit produk dengan menekan tombol "EDIT" yang dibuat menggunakan OutlinedButton. Ketika tombol diklik, aplikasi menggunakan Navigator.push() untuk membuka ProdukForm sambil mengirimkan object produk saat ini melalui parameter constructor produk: widget.produk!, sehingga widget.produk pada ProdukForm tidak null yang menandakan mode edit.

b. Mengubah Data
User dapat mengubah data kode produk, nama produk, atau harga produk.
Method isUpdate() pada ProdukForm mendeteksi bahwa widget.produk tidak null, maka mengubah judul menjadi "UBAH PRODUK EKA" dan label tombol menjadi "UBAH" menggunakan setState(). Aplikasi juga mengisi nilai awal ketiga field dengan data produk yang akan diedit: _kodeProdukTextboxController.text diisi dengan widget.produk!.kodeProduk!, _namaProdukTextboxController.text diisi dengan nama produk, dan _hargaProdukTextboxController.text diisi dengan harga yang dikonversi ke string menggunakan toString(). User kemudian dapat mengubah nilai field sesuai kebutuhan.

c. Submit Form Edit
Setelah data diubah, klik tombol "UBAH" untuk menyimpan perubahan.
Kode proses ubah `produk_form.dart`
```
ubah() {
  setState(() {
    _isLoading = true;
  });
  Produk updateProduk = Produk(id: widget.produk!.id!);
  updateProduk.kodeProduk = _kodeProdukTextboxController.text;
  updateProduk.namaProduk = _namaProdukTextboxController.text;
  updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  
  ProdukBloc.updateProduk(produk: updateProduk).then((value) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ProdukDetail(
        produk: updateProduk,
      )
    ));
  }, onError: (error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "Permintaan ubah data gagal, silahkan coba lagi",
      )
    );
  });
  setState(() {
    _isLoading = false;
  });
}
```
Kode ProdukBloc.updateProduk `produk_bloc.dart`
```
static Future updateProduk({required Produk produk}) async {
  String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
  print(apiUrl);
  
  var body = {
    "kode_produk": produk.kodeProduk,
    "nama_produk": produk.namaProduk,
    "harga": produk.hargaProduk.toString()
  };
  print("Body : $body");
  
  var response = await Api().put(apiUrl, jsonEncode(body));
  var jsonObj = json.decode(response.body);
  return jsonObj['status'];
}
```
Ketika user menekan tombol "UBAH", method ubah() dijalankan yang mengubah _isLoading menjadi true. Aplikasi membuat object Produk baru dengan id dari produk yang sedang diedit (widget.produk!.id!), lalu mengisi kodeProduk, namaProduk, dan hargaProduk dari nilai controller yang sudah diubah user. Object ini dikirim ke ProdukBloc.updateProduk() yang membuat URL dinamis menggunakan ApiUrl.updateProduk(int.parse(produk.id!)) untuk menyertakan ID produk di URL. Body JSON dibuat dengan format sama seperti addProduk, lalu di-encode menggunakan jsonEncode(body) sebelum dikirim karena PUT request memerlukan JSON string. Data dikirim menggunakan Api().put(), response di-decode dan status dikembalikan. Jika berhasil, aplikasi menggunakan Navigator.push() untuk membuka halaman ProdukDetail dengan object produk yang sudah diupdate untuk menampilkan data terbaru. Jika gagal, aplikasi menampilkan WarningDialog dengan pesan "Permintaan ubah data gagal, silahkan coba lagi".

4. Proses Hapus Produk (DELETE)
a. Klik Tombol Delete
Dari halaman detail produk, klik tombol "DELETE" untuk menghapus produk. Akan muncul konfirmasi terlebih dahulu.
Kode tombol delete `produk_detail.dart`
```
OutlinedButton(
  child: const Text("DELETE"),
  onPressed: () => confirmHapus(),
)
```
Dari halaman ProdukDetail, user dapat menghapus produk dengan menekan tombol "DELETE" yang dibuat menggunakan OutlinedButton dengan warna merah untuk indikasi aksi berbahaya. Ketika tombol diklik, aplikasi tidak langsung menghapus tetapi memanggil method confirmHapus() untuk menampilkan dialog konfirmasi terlebih dahulu agar user tidak menghapus data secara tidak sengaja.

b. Konfirmasi Hapus
Dialog konfirmasi muncul dengan pilihan "Ya" atau "Batal".
Kode dialog konfirmasi `produk_detail.dart`
```
void confirmHapus() {
  AlertDialog alertDialog = AlertDialog(
    content: const Text("Yakin ingin menghapus data ini?"),
    actions: [
      OutlinedButton(
        child: const Text("Ya"),
        onPressed: () {
          ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
            (value) => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProdukPage()
              ))
            }, onError: (error) {
              showDialog(
                context: context,
                builder: (BuildContext context) => const WarningDialog(
                  description: "Hapus gagal, silahkan coba lagi",
                )
              );
            }
          );
        },
      ),
      OutlinedButton(
        child: const Text("Batal"),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );
  showDialog(builder: (context) => alertDialog, context: context);
}
```
Method confirmHapus() membuat dan menampilkan AlertDialog dengan konten teks "Yakin ingin menghapus data ini?" dan dua tombol aksi. Tombol "Ya" ketika diklik akan menjalankan ProdukBloc.deleteProduk() dengan parameter id produk yang di-parse menjadi integer. Method deleteProduk membuat URL dinamis menggunakan ApiUrl.deleteProduk(id!) yang menyertakan ID di URL, lalu mengirim DELETE request ke server menggunakan Api().delete(). Response di-decode dan nilai boolean dari key 'data' dikembalikan sebagai hasil. Jika berhasil (callback then), dialog konfirmasi ditutup dan aplikasi navigasi ke ProdukPage untuk menampilkan list produk terbaru tanpa produk yang dihapus. Jika gagal (callback onError), aplikasi menampilkan WarningDialog dengan pesan "Hapus gagal, silahkan coba lagi". Tombol "Batal" hanya menutup dialog konfirmasi dengan Navigator.pop(context) tanpa melakukan penghapusan.

c. Produk Terhapus
Setelah klik "Ya", produk dihapus dari database dan user kembali ke halaman list produk.
Kode ProdukBloc.deleteProduk `produk_bloc.dart`
```
static Future<bool> deleteProduk({int? id}) async {
  String apiUrl = ApiUrl.deleteProduk(id!);
  
  var response = await Api().delete(apiUrl);
  var jsonObj = json.decode(response.body);
  return (jsonObj as Map<String, dynamic>)['data'];
}
```
Setelah user menekan "Ya" dan proses penghapusan berhasil, data produk dihapus dari database server melalui API. Aplikasi kemudian kembali ke halaman ProdukPage yang akan memanggil ulang ProdukBloc.getProduks() untuk mengambil data terbaru dari server, sehingga list produk yang ditampilkan sudah tidak termasuk produk yang baru saja dihapus.
