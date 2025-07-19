// Default location: lib/settingsvariables/default_settings_variables.dart
// default settings values

import '../models/bot.dart';
import 'package:uuid/uuid.dart';

// Her endpoint için baseUrl, defaultControlModel, nousablebot, name ve bots'u birlikte tutan model
class ApiEndpoint {
  final String baseUrl;
  final String defaultControlModel;
  final String name; // Kullanıcıya gösterilecek isim
  final String nousablebot; // fallback bot modeli
  final List<Bot> bots; // endpoint'e özel bot listesi

  const ApiEndpoint({
    required this.baseUrl,
    required this.defaultControlModel,
    required this.name,
    required this.nousablebot,
    required this.bots,
  });
}

// Kullanılabilir endpointlerin listesi
const List<ApiEndpoint> apiEndpoints = [
  ApiEndpoint(
    name: 'OpenRouter',
    baseUrl: 'https://openrouter.ai/api/v1',
    defaultControlModel: 'mistralai/ministral-3b',
    nousablebot: 'openai/gpt-4o-mini',
    bots: [
      Bot(
        id: 'openrouter-auto',
        name: 'Openrouter Auto',
        model: 'openrouter/auto',
        iconName: 'chat',
      ),
      Bot(
        id: 'gemini-2-5-flash',
        name: 'Gemini 2.5 Flash',
        model: 'google/gemini-2.5-flash',
        iconName: 'smart_toy',
      ),
      Bot(
        id: 'gpt-4-1-nano',
        name: 'GPT-4.1 Nano',
        model: 'openai/gpt-4.1-nano',
        iconName: 'edit',
      ),
      Bot(
        id: 'gemma-3-27b',
        name: 'Gemma 3 27b',
        model: 'google/gemma-3-27b-it',
        iconName: 'chat',
      ),
    ],
  ),
  ApiEndpoint(
    name: 'OpenAI',
    baseUrl: 'https://api.openai.com/v1',
    defaultControlModel: 'text-embedding-3-small',
    nousablebot: 'gpt-4o-mini',
    bots: [
      Bot(
        id: 'gpt-4-1-nano',
        name: 'GPT-4.1 nano',
        model: 'gpt-4.1-nano',
        iconName: 'edit',
      ),
      Bot(
        id: 'o3-mini',
        name: 'O3 Mini',
        model: 'o3-mini',
        iconName: 'smart_toy',
      ),
      Bot(
        id: 'gpt-4-turbo',
        name: 'GPT 4 Turbo',
        model: 'gpt-4-turbo',
        iconName: 'chat',
      ),
    ],
  ),
  // Buraya yeni endpointler eklenebilir
];

double defaultTemperature = 0.7;
int defaultMaxTokens = 3072;
String defaultSystemPrompt = """You are a helpful assistant that formats responses clearly. 

When writing mathematical expressions or equations, you MUST use LaTeX syntax in your responses.

For inline equations, use: \$\$equation here\$\$
For block equations, use: [equation here]

When writing code, always use code blocks with language specification:
```python
print("Hello World")
```

Format all your responses with proper markdown.""";


String apikey = ''; // dont add your apikey here, leave it empty
