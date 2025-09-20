// Importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importa o nosso arquivo principal
import 'package:lumina_app/main.dart'; // Certifique-se de que 'lumina_app' é o nome do seu projeto

void main() {
  // Define um novo teste
  testWidgets('Login screen builds correctly', (WidgetTester tester) async {
    // Constrói o nosso app e dispara um frame.
    await tester.pumpWidget(const LuminaApp());

    // Verifica se o título 'Lumina' e o botão 'Entrar' aparecem na tela.
    expect(find.text('Lumina'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
  });
}
