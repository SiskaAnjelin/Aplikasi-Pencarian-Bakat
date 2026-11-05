import 'package:flutter_test/flutter_test.dart';
import 'package:niskala/main.dart';

void main() {
  testWidgets('Niskala menampilkan halaman splash',
      (WidgetTester tester) async {

    await tester.pumpWidget(const NiskalaApp());

    // Memastikan halaman splash berhasil ditampilkan
    expect(find.text('Niskala'), findsOneWidget);

    // Memastikan tagline muncul
    expect(
      find.text('Menemukan Potensi yang Belum Terlihat'),
      findsOneWidget,
    );

    // Memastikan petunjuk masuk muncul
    expect(
      find.text('Klik Disini Untuk Masuk'),
      findsOneWidget,
    );
  });
}
