# SafeWeather - Aplicativo Flutter

Aplicativo SafeWeather convertido para Flutter a partir das telas fornecidas.

## 📱 Funcionalidades

- **Tela de Cadastro**: Registro de novos usuários
- **Tela de Login**: Autenticação de usuários existentes
- **Tela de Informações**: Introdução ao aplicativo
- **Chat de Dúvidas**: Interface de chat com IA
- **Mapa Interativo**: Visualização de zonas de perigo com legenda

## 🚀 Como executar

### Pré-requisitos

1. Flutter SDK instalado (versão 3.0.0 ou superior)
2. Android Studio ou VS Code com extensões Flutter
3. Dispositivo físico ou emulador configurado

### Passos

1. Clone ou copie os arquivos para seu diretório

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Entrada do aplicativo
├── screens/
│   ├── cadastro_screen.dart  # Tela de cadastro
│   ├── login_screen.dart     # Tela de login
│   ├── info_screen.dart      # Tela de informações
│   ├── chat_screen.dart      # Chat com IA
│   └── mapa_screen.dart      # Visualização do mapa
└── widgets/
    ├── custom_text_field.dart # Campo de texto personalizado
    └── custom_button.dart     # Botão personalizado
```

## 🎨 Design

O aplicativo utiliza:
- **Cores**: Gradient azul escuro (#1E3A8A → #0F172A)
- **Fonte**: Inter (padrão do sistema se não configurada)
- **Material Design 3**: UI moderna e consistente

## 🗺️ Navegação

As rotas estão configuradas no `main.dart`:
- `/` - Tela de Cadastro (inicial)
- `/login` - Tela de Login
- `/info` - Tela de Informações
- `/chat` - Chat de Dúvidas
- `/mapa` - Visualização do Mapa

## 📝 Próximos Passos

Para produção, considere adicionar:
- Integração com backend real (Firebase, Supabase, etc.)
- Google Maps ou Mapbox para mapas reais
- Autenticação real (Firebase Auth)
- Estado global (Provider, Riverpod, Bloc)
- Testes unitários e de widget
- Localização (i18n)

## 🔧 Customização

Para ajustar cores e estilos, edite:
- `main.dart` - Tema global
- Arquivos individuais de tela - Estilos específicos
