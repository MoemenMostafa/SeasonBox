import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/storage_location.dart';

class LabelService {
  static Future<void> printLabels(List<StorageLocation> locations) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Wrap(
              spacing: 20,
              runSpacing: 20,
              children: locations.map((location) {
                return _buildLabel(location);
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Storage_Labels.pdf',
    );
  }

  static pw.Widget _buildLabel(StorageLocation location) {
    return pw.Container(
      width: 150,
      height: 200,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            location.name,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
            textAlign: pw.TextAlign.center,
            maxLines: 2,
            overflow: pw.TextOverflow.clip,
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            location.type,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 10),
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: location.id,
            width: 100,
            height: 100,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'UID: ${location.id}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }
}
