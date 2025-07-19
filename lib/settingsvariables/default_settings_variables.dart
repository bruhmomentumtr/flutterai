// Default location: lib/settingsvariables/default_settings_variables.dart
// default settings values

import '../models/bot.dart';
import 'package:uuid/uuid.dart';

// Varsayılan bot listesi (bot_provider.dart ile aynı)
final List<Bot> defaultBots = [
  Bot(
    id: const Uuid().v4(),
    name: 'OpenRouter Auto',
    model: 'openrouter/auto',
    iconName: 'flutter',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'Openrouter Auto',
    model: 'openrouter/auto',
    iconName: 'chat',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'Gemini 2.5 Flash',
    model: 'google/gemini-2.5-flash',
    iconName: 'smart_toy',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'GPT-4.1 Nano',
    model: 'openai/gpt-4.1-nano',
    iconName: 'edit',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'Gemma 3 27b',
    model: 'google/gemma-3-27b-it',
    iconName: 'chat',
  ),
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


const String baseUrl = 'https://openrouter.ai/api/v1';
const String defaultControlModel = 'mistralai/ministral-3b'; //this is for the test connections and for the session title
const String nousablebot = 'openai/gpt-4o-mini'; // If no available models or selected model not in list, use default
String apikey = ''; // dont add your apikey here, leave it empty
