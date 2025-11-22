# Klinisk AI Assistent

En progressiv webbapp (PWA) för svenska läkare som erbjuder kliniskt beslutsstöd med hjälp av AI.

## 🎯 Funktioner

- **Multi-AI Support**: Stöd för Claude (Anthropic), ChatGPT (OpenAI), och Gemini (Google)
- **BYOK (Bring Your Own Key)**: Använd dina egna API-nycklar
- **Ingen backend**: All data lagras lokalt i din webbläsare
- **GDPR-kompatibel**: Ingen datainsamling, 100% privat
- **PWA**: Installera som app på mobil och desktop
- **Offline-stöd**: Visa tidigare konversationer offline
- **Svensk sjukvårdskontext**: Anpassad för svenska läkare och riktlinjer

## 🚀 Kom igång

### Förutsättningar

- Flutter 3.24 eller senare
- En API-nyckel från någon av:
  - Anthropic (https://console.anthropic.com)
  - OpenAI (https://platform.openai.com)
  - Google AI (https://makersuite.google.com)

### Installation

1. Klona repositoryt:
```bash
git clone https://github.com/[username]/klinisk-ai-assistent.git
cd klinisk-ai-assistent
```

2. Installera dependencies:
```bash
flutter pub get
```

3. Kör i webbläsare:
```bash
flutter run -d chrome
```

4. Bygg för produktion:
```bash
flutter build web --release --web-renderer canvaskit
```

## 📦 Deployment till Vercel

### Snabbstart med Vercel Dashboard

1. Gå till [vercel.com/new](https://vercel.com/new)
2. Importera ditt GitHub-repository
3. Konfigurera:
   - **Framework Preset**: Other
   - **Build Command**: `flutter build web --release --web-renderer canvaskit`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`
4. Klicka på "Deploy"

### Med Vercel CLI

```bash
npm i -g vercel
vercel login
vercel --prod
```

## 🏗️ Projektstruktur

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # MaterialApp configuration
├── core/
│   ├── config/
│   │   ├── app_config.dart           # App configuration
│   │   ├── system_prompt.dart        # AI system prompt
│   │   └── api_endpoints.dart        # API URLs
│   ├── services/
│   │   ├── ai_provider_interface.dart
│   │   ├── anthropic_service.dart
│   │   ├── openai_service.dart
│   │   ├── gemini_service.dart
│   │   └── ai_service_factory.dart
│   ├── storage/
│   │   ├── secure_storage_service.dart
│   │   ├── preferences_service.dart
│   │   └── history_storage_service.dart
│   └── models/
│       ├── ai_provider.dart
│       ├── query_request.dart
│       ├── query_response.dart
│       └── search_history_item.dart
├── features/
│   ├── auth/
│   ├── query/
│   ├── results/
│   ├── history/
│   └── settings/
└── shared/
    ├── widgets/
    ├── utils/
    └── theme/
```

## 🔒 Säkerhet & Integritet

- **Lokal lagring**: API-nycklar lagras krypterat i din webbläsare
- **Ingen backend**: Inga servrar mellan dig och AI-leverantören
- **GDPR-kompatibel**: Ingen användardata samlas in
- **Direktkommunikation**: Konversationer går direkt till din valda AI-leverantör
- **Du äger dina data**: Radera allt när som helst

## ⚠️ Medicinsk ansvarsfriskrivning

Detta är ett **beslutsstödsverktyg** och inte en ersättning för professionell medicinsk bedömning.

- Verifiera alltid AI-genererade rekommendationer
- Använd ditt kliniska omdöme
- Följ etablerade riktlinjer och vårdprogram
- Detta verktyg är inte avsett för akuta situationer
- Konsultera alltid med kollegor vid osäkerhet

## 📚 Dokumentation

- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Systemarkitektur
- [API_INTEGRATION.md](docs/API_INTEGRATION.md) - API-integrationsguide
- [DEPLOYMENT.md](docs/DEPLOYMENT.md) - Deployment-instruktioner

## 🤝 Bidra

Bidrag är välkomna! Vänligen:

1. Forka projektet
2. Skapa en feature branch (`git checkout -b feature/amazing-feature`)
3. Commit dina ändringar (`git commit -m 'feat: Add amazing feature'`)
4. Push till branchen (`git push origin feature/amazing-feature`)
5. Öppna en Pull Request

## 📄 Licens

Detta projekt är licensierat under MIT-licensen - se [LICENSE](LICENSE) för detaljer.

## 🙏 Tack till

- Anthropic för Claude API
- OpenAI för ChatGPT API
- Google för Gemini API
- Flutter-teamet för ett fantastiskt ramverk

## 📧 Support

För frågor eller support, öppna ett issue på GitHub.

---

**Byggd med ❤️ för svenska läkare**
