import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BookSharer {
  /// Downloads the book cover and opens the native system share sheet
  /// presenting the physical image file with your promotional app landing link.
  static Future<void> shareBookWithImage({
    required String title,
    required String imageUrl,
  }) async {
    try {
      // 1. Download the book cover bytes from the remote storage network URL
      final http.Response response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode != 200) {
        throw HttpException('Failed to download image: Status ${response.statusCode}');
      }

      // 2. Locate the safe local sandboxed temporary system cache directory
      final Directory tempDir = await getTemporaryDirectory();
      
      // 3. Generate a clean unique filename using the current timestamp to avoid cache conflicts
      final String uniqueFileName = 'book_cover_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File file = File('${tempDir.path}/$uniqueFileName');
      
      // 4. Save the downloaded bytes directly into the local file layout
      await file.writeAsBytes(response.bodyBytes);

      // 5. Construct the clean promotional message payload
      final String message = '📚 I\'m reading "$title" on Booksly!\n'
                             '📱 Get the app here: https://booksly.online';

      // 6. Fire the native share tray sheet passing the localized image file reference
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: 'Great read on Booksly: $title',
          files: [XFile(file.path)], // Attaches the actual physical image asset file natively
        ),
      );
    } catch (e) {
      print("❌ Error processing book layout share: $e");
    }
  }
}