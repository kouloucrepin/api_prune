import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prune_classifier/generated/l10n.dart';
import 'package:prune_classifier/services/api_predictor.dart';
import 'package:prune_classifier/services/history_manager.dart';
import 'package:share_plus/share_plus.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

final GlobalKey _shareKey = GlobalKey();

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isDetecting = false;
  bool _isFlashOn = false;
  String? _prediction;
  File? _currentImage;
  Map<String, double>? _probabilities;
  bool _cancelRequested = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _isFlashOn = !_isFlashOn;
    await _controller!
        .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  Future<void> _captureAndClassify() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final image = await _controller!.takePicture();
    await _processImage(File(image.path));
  }

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _processImage(File(image.path));
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isDetecting = true;
      _cancelRequested = false;
      _currentImage = imageFile;
      _prediction = null;
      _probabilities = null;
    });

    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        final s = S.of(context);
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      s.processing_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      s.processing_message,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _cancelRequested = true;
                        if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.close),
                      label: Text(s.cancel),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.shade100,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _currentImage != null ? FileImage(_currentImage!) : null,
                  child: _currentImage == null
                      ? const Icon(Icons.image,
                          size: 40, color: Colors.deepPurple)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );

    // Appelle l'API
    final result = await predictFromAPI(_currentImage!,
        cancelled: () => _cancelRequested, context: context);

    if (!_cancelRequested && mounted && dialogContext != null) {
      if (Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop(); // Ferme proprement le dialog
      }

      setState(() {
        _isDetecting = false;
        if (result is Map) {
          _prediction = result["label"];
          _probabilities = result['probabilities'];
        } else {
          _prediction = result.toString();
        }
      });

      // Sauvegarde dans l’historique
      if (result is Map && _prediction != null && _currentImage != null) {
        final savedPath = await HistoryManager.saveImageLocally(_currentImage!);
        await HistoryManager.saveEntry(
          HistoryEntry(
            label: _prediction!,
            imagePath: savedPath,
            date: HistoryManager.formattedDateNow(),
            probabilities: _probabilities ?? {},
          ),
        );
      }
    }
  }

  Widget _buildProbabilityBars() {
    if (_probabilities == null) return const SizedBox();
    return Column(
      children: _probabilities!.entries.map((entry) {
        final percent = (entry.value * 100).toStringAsFixed(1);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              SizedBox(
                  width: 90,
                  child: Text(entry.key,
                      style: const TextStyle(color: Colors.white))),
              Expanded(
                child: LinearProgressIndicator(
                  value: entry.value,
                  minHeight: 8,
                  color: Colors.deepPurple,
                  backgroundColor: Colors.deepPurple.shade100,
                ),
              ),
              const SizedBox(width: 10),
              Text("$percent%", style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    Future<void> _shareAnalysis() async {
      try {
        final boundary = _shareKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/plum_analysis_result.png');
        await file.writeAsBytes(pngBytes);

        await Share.shareXFiles([XFile(file.path)],
            text: "Analyse générée avec PlumAnalyzer – JCIA Hackathon 2025");
      } catch (e) {
        debugPrint("Erreur de partage : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec du partage")),
        );
      }
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final previewSize = _controller!.value.previewSize!;
    return Stack(
      children: [
        // Camera Preview plein écran
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: previewSize.height,
              height: previewSize.width,
              child: CameraPreview(_controller!),
            ),
          ),
        ),

        // Résultat + miniature
        if (_prediction != null && !_isDetecting)
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: RepaintBoundary(
              key: _shareKey,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_currentImage!,
                            width: 64, height: 64, fit: BoxFit.cover),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Résultat : $_prediction",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _buildProbabilityBars(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  if (_currentImage != null) {
                                    _processImage(_currentImage!);
                                  }
                                },
                                icon: const Icon(Icons.refresh,
                                    color: Colors.white),
                                label: const Text("Relancer l'analyse",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              TextButton.icon(
                                onPressed: _shareAnalysis,
                                icon: const Icon(Icons.share,
                                    color: Colors.white),
                                label: const Text("Partager",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Bouton flash
        Positioned(
          top: 30,
          right: 20,
          child: IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
              size: 28,
            ),
            onPressed: _toggleFlash,
          ),
        ),

        // Bouton capture
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _captureAndClassify,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),

        // Galerie
        Positioned(
          bottom: 30,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(Icons.photo, color: Colors.deepPurple),
            onPressed: _pickImageFromGallery,
          ),
        ),
      ],
    );
  }
}
