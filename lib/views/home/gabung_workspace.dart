import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:diversitree_mobile/views/workspace/workspace_master.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class GabungWorkspace extends StatefulWidget {
  @override
  _GabungWorkspaceState createState() => _GabungWorkspaceState();
}

class _GabungWorkspaceState extends State<GabungWorkspace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: QRViewExample(),
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
  
  bool isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Expanded(flex: 1, child: _buildQrView(context)),
            const SizedBox(height: 8),
            const Text(
              'Pindai QR Code',
              style: TextStyle(fontSize: 20, color: AppColors.info),
            ),
            const Text(
              'Workspace Bersama',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
        ),
        if (isLoading) // Show loading indicator when processing QR code
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
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

    controller.scannedDataStream.listen((scanData) async {
      if (!isLoading) { // Prevent multiple scans while loading
        setState(() {
          isLoading = true;
          result = scanData;
        });

        await _onIdentified(workspaceId: scanData.code ?? '');
      }
    });
  }

  Future<void> _onIdentified({required String workspaceId}) async {
    try {
      Map<String, dynamic> workspaceData = await WorkspaceTimService.addToTim(workspaceId);


      controller?.pauseCamera();
      await Future.delayed(Duration(seconds: 3));
      
      LocalDbService.insert('workspaces', workspaceData);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkspaceMaster(
            urutanSaatIni: workspaceData["urutan_status_workspace"],
            workspaceData: workspaceData,
          ),
        ),
      );
    } catch (e) {
      print("Error processing QR code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses QR Code')),
      );

      controller?.pauseCamera();
      await Future.delayed(Duration(seconds: 1));
    } finally {
      controller?.resumeCamera();
      setState(() {
        isLoading = false; // Reset loading state after processing
      });
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada izin akses kamera')),
      );
    }
  }
}
