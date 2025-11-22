# Architecture Documentation

## Overview

Klinisk AI Assistent is a Progressive Web App (PWA) built with Flutter Web. The architecture follows clean architecture principles with clear separation of concerns.

## Architecture Layers

### 1. Core Layer

The core layer contains business logic and data models that are independent of any framework.

**Components:**
- **Models**: Data structures (`AIProvider`, `QueryRequest`, `QueryResponse`, `SearchHistoryItem`)
- **Services**: Business logic for AI provider integration
- **Config**: Application configuration and system prompts
- **Storage**: Data persistence services

### 2. Features Layer

Feature-based organization for better maintainability and scalability.

**Features:**
- **Auth**: Authentication and provider selection
- **Query**: Query input and management
- **Results**: Response display
- **History**: Search history management
- **Settings**: Application settings

### 3. Shared Layer

Reusable components across features.

**Components:**
- **Theme**: Application theming and styling
- **Widgets**: Reusable UI components
- **Utils**: Utilities, validators, formatters, extensions

## State Management

### Riverpod

We use Riverpod 2.4+ for state management due to:
- Type safety
- Compile-time safety
- Easy testing
- No BuildContext required
- Built-in dependency injection

**Key Providers:**
- `authStateProvider`: Authentication state
- `selectedProviderProvider`: Current AI provider
- `apiKeyProvider`: API key state
- `queryActionsProvider`: Query actions
- `searchHistoryProvider`: Search history

## Data Flow

```
User Input → Provider → Service → API → Response → Storage → UI Update
```

1. User inputs query in UI
2. Riverpod provider receives input
3. AI service processes request
4. API call to external AI provider
5. Response received and validated
6. Response saved to local storage
7. UI updated with new state

## Storage Strategy

### Secure Storage
- **Purpose**: Store sensitive data (API keys)
- **Technology**: flutter_secure_storage
- **Encryption**: Yes (platform-specific)
- **Web**: Uses Web Crypto API

### Shared Preferences
- **Purpose**: Store user preferences and history
- **Technology**: shared_preferences
- **Encryption**: No (non-sensitive data)
- **Web**: Uses localStorage

## Security Considerations

### API Key Security
- Stored encrypted using platform secure storage
- Never transmitted to intermediate servers
- Only sent directly to AI provider
- Can be deleted at any time

### GDPR Compliance
- No user data collection
- No analytics tracking
- No external data transmission except to AI provider
- User can delete all data

### Content Security
- No inline scripts in HTML
- Strict CSP headers in Vercel config
- HTTPS only
- XSS protection headers

## AI Provider Integration

### Provider Interface
All AI providers implement the `AIProvider` interface:

```dart
abstract class AIProvider {
  Future<QueryResponse> sendQuery(QueryRequest request);
  Future<bool> testConnection();
  String get providerName;
  String get providerId;
}
```

### Supported Providers
1. **Anthropic (Claude)**
   - Model: claude-sonnet-4-20250514
   - Endpoint: https://api.anthropic.com/v1/messages

2. **OpenAI (ChatGPT)**
   - Model: gpt-4-turbo-preview
   - Endpoint: https://api.openai.com/v1/chat/completions

3. **Google (Gemini)**
   - Model: gemini-pro
   - Endpoint: https://generativelanguage.googleapis.com/v1beta

### Adding New Providers

To add a new AI provider:
1. Implement `AIProvider` interface
2. Add to `AIProviderType` enum
3. Update `AIServiceFactory`
4. Add UI elements in provider selection

## PWA Features

### Service Worker
- Caches static assets
- Enables offline viewing of history
- Fast subsequent loads

### Manifest
- Installable as app
- Custom icons and splash screen
- Shortcuts to common actions

### Offline Support
- View previous searches
- Access settings
- Cannot send new queries (requires network)

## Testing Strategy

### Unit Tests
- Service layer logic
- Data model validation
- Utility functions

### Widget Tests
- Individual widgets
- Screen layouts
- User interactions

### Integration Tests
- End-to-end user flows
- API integration
- State management

## Performance Optimization

### Code Splitting
- Lazy loading of features
- Tree shaking in production
- Minimal initial bundle

### Caching
- Service worker caching
- API response caching
- Image optimization

### Rendering
- Flutter Web using CanvasKit renderer
- Optimized for modern browsers
- Responsive design for all screen sizes

## Deployment Architecture

### Vercel Platform
- Edge network for global CDN
- Automatic HTTPS
- Zero-config deployment
- Automatic scaling

### Build Process
1. Flutter web build
2. CanvasKit rendering
3. Asset optimization
4. Service worker generation
5. Deploy to Vercel edge network

## Scalability Considerations

### Client-Side Scaling
- All processing client-side
- No backend servers to scale
- User pays for AI usage
- Unlimited concurrent users

### Storage Limits
- Browser storage quotas apply
- Automatic cleanup of old history
- User can manage storage

## Future Architecture Improvements

### Potential Enhancements
1. **Voice Input**: Speech-to-text integration
2. **Multi-language**: Support for English medical terms
3. **Offline AI**: Local ML models for basic queries
4. **Collaboration**: Share queries between colleagues (requires backend)
5. **Advanced Features**: Image analysis for radiology

### Migration Path
- Current: Fully client-side
- Future: Optional backend for collaboration features
- Maintain BYOK and privacy-first approach

## Monitoring & Logging

### Client-Side Logging
- Error tracking (can be added)
- Performance metrics (can be added)
- User analytics (optional, requires consent)

### No Server-Side Logging
- Maintains privacy
- GDPR compliant
- No user tracking

---

**Last Updated**: 2025-11-22
**Architecture Version**: 1.0
