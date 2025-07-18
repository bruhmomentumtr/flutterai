// Default location: lib/settingsvariables/default_settings_variables.dart
// default settings values

import '../models/bot.dart';
import 'package:uuid/uuid.dart';

// Varsayılan bot listesi (bot_provider.dart ile aynı)
final List<Bot> defaultBots = [
  Bot(
    id: const Uuid().v4(),
    name: 'openrouter auto',
    model: 'openrouter/auto',
    iconName: 'chat',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'gemini 2.5 flash',
    model: 'google/gemini-2.5-flash',
    iconName: 'chat',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'GPT-4.1 nano',
    model: 'openai/gpt-4.1-nano',
    iconName: 'edit',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'Qwen 3.0 14b',
    model: 'qwen/qwen3-14b',
    iconName: 'chat',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'gemma 3 27b',
    model: 'google/gemma-3-27b-it',
    iconName: 'chat',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'Llama 3.2 11b vision',
    model: 'meta-llama/llama-3.2-11b-vision-instruct',
    iconName: 'smart_toy',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'claude sonnet 4',
    model: 'anthropic/claude-sonnet-4',
    iconName: 'smart_toy',
  ),
];

double defaultTemperature = 0.7;
int defaultMaxTokens = 2048;
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
