import 'package:flutter/material.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/produk_page.dart';
import 'package:toko_kita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================== APPBAR GRADIENT ==================
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD200),
                Colors.black,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // ================== BODY GRADIENT ==================
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFD200),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _inputCard(),
                const SizedBox(height: 25),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================== CARD INPUT ==================
  Widget _inputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _kodeProdukTextField(),
          const SizedBox(height: 15),
          _namaProdukTextField(),
          const SizedBox(height: 15),
          _hargaProdukTextField(),
        ],
      ),
    );
  }

  // ================== TEXTFIELDS ==================
  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: _inputDecoration("Kode Produk"),
      controller: _kodeProdukTextboxController,
      validator: (value) =>
          value!.isEmpty ? "Kode Produk harus diisi" : null,
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: _inputDecoration("Nama Produk"),
      controller: _namaProdukTextboxController,
      validator: (value) =>
          value!.isEmpty ? "Nama Produk harus diisi" : null,
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: _inputDecoration("Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) =>
          value!.isEmpty ? "Harga harus diisi" : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  // ================== BUTTON SUBMIT ==================
  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(fontSize: 16),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!_isLoading) {
              widget.produk != null ? ubah() : simpan();
            }
          }
        },
      ),
    );
  }

  // ================== FUNGSI SIMPAN ==================
  void simpan() {
    setState(() => _isLoading = true);

    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextboxController.text;
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.hargaProduk =
        int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.addProduk(produk: createProduk).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProdukPage()),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() => _isLoading = false);
  }

  // ================== FUNGSI UBAH ==================
  void ubah() {
    setState(() => _isLoading = true);

    Produk updateProduk = Produk(id: widget.produk!.id);
    updateProduk.kodeProduk = _kodeProdukTextboxController.text;
    updateProduk.namaProduk = _namaProdukTextboxController.text;
    updateProduk.hargaProduk =
        int.parse(_hargaProdukTextboxController.text);

    ProdukBloc.updateProduk(produk: updateProduk).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProdukPage()),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() => _isLoading = false);
  }
}
