import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class GabungWorkspace extends StatefulWidget {
  @override
  _GabungWorkspaceState createState() => _GabungWorkspaceState();
}

class _GabungWorkspaceState extends State<GabungWorkspace> {
  // You can add any variables you want to manage here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DiversitreeAppBar(titleText: '',),
      backgroundColor: Colors.white,
      body: QRViewExample()
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String? workspaceId;

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _buildQrView(context)),
        const SizedBox(height: 8,),
        const Text('Pindai QR Code', style: TextStyle(fontSize: 20, color: AppColors.info),),
        const Text('Workspace Bersama', style: TextStyle(fontSize: 12),),
        const SizedBox(height: 16,),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: AppColors.primary,
        overlayColor: Colors.black.withOpacity(0.52),
        borderRadius: 8,
        borderLength: 40,
        borderWidth: 8,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        workspaceId = result?.code;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}