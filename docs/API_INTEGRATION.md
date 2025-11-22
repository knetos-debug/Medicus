# API Integration Guide

## Overview

This document describes how to integrate with different AI provider APIs in Klinisk AI Assistent.

## Supported Providers

### 1. Anthropic (Claude)

#### Setup
1. Create account at https://console.anthropic.com
2. Navigate to API Keys section
3. Create new API key (starts with `sk-ant-`)
4. Store securely

#### API Details
- **Base URL**: `https://api.anthropic.com/v1/messages`
- **Model**: `claude-sonnet-4-20250514`
- **Max Tokens**: 4096
- **Headers**:
  - `x-api-key`: Your API key
  - `anthropic-version`: `2023-06-01`
  - `content-type`: `application/json`

#### Request Format
```json
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 4096,
  "messages": [
    {
      "role": "user",
      "content": "[Full prompt with system prompt + user query]"
    }
  ]
}
```

#### Response Format
```json
{
  "id": "msg_...",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "[AI response]"
    }
  ],
  "usage": {
    "input_tokens": 123,
    "output_tokens": 456
  }
}
```

#### Pricing (as of 2025)
- Input: ~$3 per million tokens
- Output: ~$15 per million tokens

#### Rate Limits
- Tier 1: 50 requests/min, 40,000 tokens/min
- Tier 2: 1,000 requests/min, 80,000 tokens/min
- Higher tiers available

### 2. OpenAI (ChatGPT)

#### Setup
1. Create account at https://platform.openai.com
2. Navigate to API Keys
3. Create new secret key (starts with `sk-`)
4. Store securely

#### API Details
- **Base URL**: `https://api.openai.com/v1/chat/completions`
- **Model**: `gpt-4-turbo-preview`
- **Max Tokens**: 4096
- **Headers**:
  - `Authorization`: `Bearer YOUR_API_KEY`
  - `Content-Type`: `application/json`

#### Request Format
```json
{
  "model": "gpt-4-turbo-preview",
  "messages": [
    {
      "role": "system",
      "content": "[System prompt]"
    },
    {
      "role": "user",
      "content": "[User query]"
    }
  ],
  "max_tokens": 4096,
  "temperature": 0.7
}
```

#### Response Format
```json
{
  "id": "chatcmpl-...",
  "object": "chat.completion",
  "created": 1234567890,
  "model": "gpt-4-turbo-preview",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "[AI response]"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 123,
    "completion_tokens": 456,
    "total_tokens": 579
  }
}
```

#### Pricing (as of 2025)
- GPT-4 Turbo: ~$10 per million input tokens, ~$30 per million output tokens
- GPT-3.5 Turbo: ~$0.50 per million input tokens, ~$1.50 per million output tokens

#### Rate Limits
- Free tier: 3 requests/min
- Paid tier: Based on usage tier (up to 10,000 requests/min)

### 3. Google (Gemini)

#### Setup
1. Go to https://makersuite.google.com
2. Get API key
3. Enable Generative Language API
4. Store securely

#### API Details
- **Base URL**: `https://generativelanguage.googleapis.com/v1beta`
- **Model**: `gemini-pro`
- **Max Tokens**: 4096
- **Authentication**: API key in URL parameter

#### Request Format
```json
POST /v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY

{
  "contents": [
    {
      "parts": [
        {
          "text": "[Full prompt]"
        }
      ]
    }
  ],
  "generationConfig": {
    "maxOutputTokens": 4096,
    "temperature": 0.7
  }
}
```

#### Response Format
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "[AI response]"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP"
    }
  ],
  "promptFeedback": {
    "safetyRatings": [...]
  }
}
```

#### Pricing (as of 2025)
- Gemini Pro: Free tier available
- Input: ~$0.125 per million characters
- Output: ~$0.375 per million characters

#### Rate Limits
- 60 requests per minute
- Can be increased with billing

## Implementation Details

### Service Interface

All providers implement this interface:

```dart
abstract class AIProvider {
  Future<QueryResponse> sendQuery(QueryRequest request);
  Future<bool> testConnection();
  String get providerName;
  String get providerId;
}
```

### Error Handling

All services handle these error cases:
- Network errors (timeout, connection failure)
- API errors (invalid key, rate limits)
- Response parsing errors
- Service unavailability

### System Prompt Integration

The system prompt is included in all requests:
- **Anthropic**: Included in user message content
- **OpenAI**: Separate system message
- **Gemini**: Included in text content

### Response Processing

1. Receive raw API response
2. Extract text content
3. Validate response format
4. Create `QueryResponse` object
5. Save to history (if enabled)
6. Display to user

## Testing API Integration

### Test Connection

All services provide a `testConnection()` method:
- Sends minimal query ("Säg bara 'OK' om du fungerar")
- Validates API key
- Checks network connectivity
- Returns boolean success

### Manual Testing

Use these test queries:

**Simple Test:**
```
Säg hej!
```

**Medical Test:**
```
Vad är differentialdiagnoser för akut bröstsmärta?
```

**Complex Test:**
```
65-årig man med diabetes typ 2, hypertoni och hyperlipidemi.
Nyligen insatt på warfarin för förmaksflimmer.
Vilka antibiotika ska undvikas och varför?
```

## Cost Optimization

### Token Usage
- Average query: 500-1000 input tokens
- Average response: 1000-2000 output tokens
- System prompt: ~1500 tokens per query

### Cost Estimates (per 100 queries)
- **Claude Sonnet**: ~$5-10
- **GPT-4 Turbo**: ~$10-20
- **Gemini Pro**: ~$0.50-1 (or free)

### Optimization Tips
1. Keep queries concise
2. Limit max_tokens appropriately
3. Consider cheaper models for simple queries
4. Monitor usage through provider dashboards

## Rate Limit Handling

### Strategies
1. **Retry with exponential backoff**
2. **Queue requests** (future enhancement)
3. **Show user-friendly error messages**
4. **Suggest switching providers**

### Implementation
```dart
Future<QueryResponse> sendQuery(QueryRequest request) async {
  try {
    final response = await http.post(...)
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 429) {
      // Rate limit hit
      throw RateLimitException();
    }

    // Process response
  } catch (e) {
    // Handle error
  }
}
```

## Security Best Practices

### API Key Storage
- ✅ Store encrypted in secure storage
- ✅ Never log API keys
- ✅ Never commit to version control
- ✅ Allow user to delete keys

### Network Security
- ✅ HTTPS only
- ✅ Certificate pinning (future enhancement)
- ✅ Timeout on long requests
- ✅ Validate response format

### Data Privacy
- ✅ No intermediate servers
- ✅ Direct API calls only
- ✅ No data logging
- ✅ User owns all data

## Adding New Providers

To add a new AI provider:

1. **Create Service Class**
```dart
class NewProviderService implements AIProvider {
  final String apiKey;

  @override
  Future<QueryResponse> sendQuery(QueryRequest request) async {
    // Implementation
  }

  @override
  Future<bool> testConnection() async {
    // Implementation
  }

  @override
  String get providerName => 'New Provider';

  @override
  String get providerId => 'newprovider';
}
```

2. **Update Enum**
```dart
enum AIProviderType {
  claude,
  openai,
  gemini,
  newprovider, // Add here
}
```

3. **Update Factory**
```dart
class AIServiceFactory {
  static AIProvider create({
    required AIProviderType provider,
    required String apiKey,
  }) {
    switch (provider) {
      // ...
      case AIProviderType.newprovider:
        return NewProviderService(apiKey: apiKey);
    }
  }
}
```

4. **Update UI**
- Add provider card
- Add setup instructions
- Add icon/branding

## Troubleshooting

### Common Issues

**Invalid API Key**
- Check key format
- Verify key is active
- Check billing status

**Rate Limit Exceeded**
- Wait and retry
- Switch to different provider
- Upgrade tier

**Network Timeout**
- Check internet connection
- Increase timeout duration
- Retry request

**Invalid Response**
- Check API version
- Verify request format
- Check service status

### Debug Mode

Enable debug logging:
```dart
// In service implementation
print('Request: ${jsonEncode(request)}');
print('Response: ${response.body}');
```

---

**Last Updated**: 2025-11-22
**API Integration Version**: 1.0
