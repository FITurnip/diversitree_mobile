import 'package:camera/camera.dart';
import 'package:diversitree_mobile/components/camera_screen.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IdentifikasiPohon extends StatefulWidget {
  final Map<String, dynamic> pohonData;
  final String workspaceId;
  final Map<String, dynamic> workspaceData;
  
  IdentifikasiPohon({required this.pohonData, required this.workspaceId, required this.workspaceData});

  @override
  _IdentifikasiPohonState createState() => _IdentifikasiPohonState();
}

class _IdentifikasiPohonState extends State<IdentifikasiPohon> {
  final TextEditingController _spesiesController = TextEditingController();
  final TextEditingController _dbhController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _spesiesController.dispose();
    _dbhController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _spesiesController.text = widget.pohonData["nama_spesies"] ?? "";
    _dbhController.text = widget.pohonData["dbh"].toString();
  }

  XFile? capturedImage;
  
  void saveCapturedImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("capturedImage, ${capturedImage}");
      await CameraService.saveCapturedImage(
        widget.workspaceData, 
        capturedImage!, 
        widget.workspaceId, 
        widget.pohonData["path_foto"]
      );

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print("Error saving image: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  ApiService.urlStorage + widget.pohonData["path_foto"], 
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTextColors.onPrimary.withOpacity(0.8),
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Icon(Icons.arrow_back, color: AppColors.primary),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: ElevatedButton(
                  onPressed: () {
                    final backCamera = CameraService.getBackCamera();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          camera: backCamera,
                          workspaceId: widget.workspaceId,
                          syncCaptureImage: (newCapturedImage) {
                            capturedImage = newCapturedImage;
                          },
                          saveImage: saveCapturedImage,
                          mode: 'single',
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.camera_alt, color: AppTextColors.onPrimary),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.08,
                maxChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Container(
                            height: 4,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Identifikasi ulang",
                                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 32),
                                    backgroundColor: Colors.white.withOpacity(0.75),
                                    side: BorderSide(color: AppColors.primary),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: saveCapturedImage,
                                  child: Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 32),
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          _buildTextField("Spesies", _spesiesController),
                          _buildTextField("DBH", _dbhController, isNumeric: true),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        inputFormatters: isNumeric ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))] : [],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14, color: AppColors.primary),
          floatingLabelStyle: TextStyle(color: AppColors.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          suffixText: isNumeric ? 'm²' : null,
        ),
      ),
    );
  }
}
