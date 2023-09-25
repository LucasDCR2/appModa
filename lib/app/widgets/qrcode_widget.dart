// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ProductQRCodeWidget extends StatelessWidget {
  final int qrCodeData; // Atualize o tipo para int

  ProductQRCodeWidget({required this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: Barcode.qrCode(),
      data: qrCodeData.toString(), 
      width: 200,
      height: 200,
      drawText: false,
    );
  }
}

