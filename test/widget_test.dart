import 'package:flutter_test/flutter_test.dart';

import 'package:voltavia/main.dart';

void main() {
  testWidgets('Voltavia app boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const VoltaviaApp());

    expect(find.text('Voltavia'), findsOneWidget);
    expect(find.text('Tek uygulama, her şarj istasyonu'), findsOneWidget);

    // Splash ekranı 1600ms sonra Onboarding'e geçiş yapan bir Future.delayed
    // zamanlayıcısı kullanıyor; test bitmeden önce bu zamanlayıcıyı tüketmek
    // için o sürenin ötesine pump ediyoruz.
    await tester.pump(const Duration(milliseconds: 1700));
  });
}
