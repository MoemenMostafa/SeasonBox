import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:seasonbox/app/theme/theme.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleQRCode(String? code) {
    if (code == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Haptic feedback
    // HapticFeedback.mediumImpact(); // Optional: Add if services are available

    // Validate and Navigate
    // Assuming storage location IDs might have a prefix or just be the ID
    // For now, we assume the code IS the storage location ID

    debugPrint('Scanned QR Code: $code');

    // Navigate to storage details
    // Using simple ID check - in production you might want to validate format
    if (code.isNotEmpty) {
      // Stop camera
      _controller.stop();

      // Check if we are in "picker" mode (result expected)
      // We check if the current route has extra indicating request for result?
      // Or we can just check if we can pop? No, we might be root.
      // Better to check specific extra param passed when pushing.
      final extra = GoRouterState.of(context).extra;
      bool returnResult = false;
      if (extra is Map && extra['returnResult'] == true) {
        returnResult = true;
      }

      if (context.mounted) {
        if (returnResult) {
          context.pop(code);
        } else {
          // Default behavior: Navigate to items screen filtered by this storage location
          context.push('/items', extra: {'initialStorageLocationId': code});
        }
      }
    } else {
      setState(() {
        _isProcessing = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR Code')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                _handleQRCode(barcode.rawValue);
                break; // Process first code only
              }
            },
          ),

          // Overlay
          Container(
            decoration: const ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: AppTheme.primaryColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),

          // Controls
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close Button
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 30),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black45,
                        ),
                      ),

                      // Flash Toggle
                      IconButton(
                        onPressed: () async {
                          await _controller.toggleTorch();
                          setState(() {
                            // Helper to toggle icon, assuming toggleTorch() works
                            // Ideally we'd read the state, but if API is missing, we toggle local state
                            _isTorchOn = !_isTorchOn;
                          });
                        },
                        icon: Icon(
                          _isTorchOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 30,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Hint Text
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Align QR code within the frame to scan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Overlay Shape (Simple implementation/placeholder if package doesn't provide one directly usable this way or custom needed)
// NOTE: mobile_scanner doesn't provide QrScannerOverlayShape out of the box in all versions.
// We will implement a custom painter or use a container with a hole punch if needed.
// For now, let's assume we want a custom overlay or use a simplified one.
// Actually, let's implement a simple CustomPainter for the overlay to be safe and dependency-light.

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;
  final double cutOutBottomOffset;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
    this.cutOutBottomOffset = 0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    // final borderWidthSize = width / 2; // Unused
    final height = rect.height;
    // final borderOffset = borderWidth / 2; // Unused
    final actualCutOutSize =
        cutOutSize != 0.0 ? cutOutSize : width - 40.0; // Default padding

    final cutOutWidth =
        actualCutOutSize < width ? actualCutOutSize : width - 40.0;
    final cutOutHeight =
        actualCutOutSize < height ? actualCutOutSize : height - 40.0;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromCenter(
      center: rect.center.translate(0, -cutOutBottomOffset),
      width: cutOutWidth,
      height: cutOutHeight,
    );

    canvas.saveLayer(rect, backgroundPaint);
    canvas.drawRect(rect, backgroundPaint);

    // Draw hole
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      boxPaint..blendMode = BlendMode.clear,
    );
    canvas.restore();

    // Draw corners
    // Top left
    final path = Path();
    path.moveTo(cutOutRect.left, cutOutRect.top + borderLength);
    path.lineTo(cutOutRect.left, cutOutRect.top + borderRadius);
    if (borderRadius > 0) {
      path.quadraticBezierTo(cutOutRect.left, cutOutRect.top,
          cutOutRect.left + borderRadius, cutOutRect.top);
    } else {
      path.lineTo(cutOutRect.left, cutOutRect.top);
    }
    path.lineTo(cutOutRect.left + borderLength, cutOutRect.top);

    // Top right
    path.moveTo(cutOutRect.right - borderLength, cutOutRect.top);
    path.lineTo(cutOutRect.right - borderRadius, cutOutRect.top);
    if (borderRadius > 0) {
      path.quadraticBezierTo(cutOutRect.right, cutOutRect.top, cutOutRect.right,
          cutOutRect.top + borderRadius);
    } else {
      path.lineTo(cutOutRect.right, cutOutRect.top);
    }
    path.lineTo(cutOutRect.right, cutOutRect.top + borderLength);

    // Bottom right
    path.moveTo(cutOutRect.right, cutOutRect.bottom - borderLength);
    path.lineTo(cutOutRect.right, cutOutRect.bottom - borderRadius);
    if (borderRadius > 0) {
      path.quadraticBezierTo(cutOutRect.right, cutOutRect.bottom,
          cutOutRect.right - borderRadius, cutOutRect.bottom);
    } else {
      path.lineTo(cutOutRect.right, cutOutRect.bottom);
    }
    path.lineTo(cutOutRect.right - borderLength, cutOutRect.bottom);

    // Bottom left
    path.moveTo(cutOutRect.left + borderLength, cutOutRect.bottom);
    path.lineTo(cutOutRect.left + borderRadius, cutOutRect.bottom);
    if (borderRadius > 0) {
      path.quadraticBezierTo(cutOutRect.left, cutOutRect.bottom,
          cutOutRect.left, cutOutRect.bottom - borderRadius);
    } else {
      path.lineTo(cutOutRect.left, cutOutRect.bottom);
    }
    path.lineTo(cutOutRect.left, cutOutRect.bottom - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      overlayColor: overlayColor,
    );
  }
}
