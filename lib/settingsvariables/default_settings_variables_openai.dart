// Default location: lib/settingsvariables/default_settings_variables.dart
// default settings values
// if you want to use openai change file name as default_settings_variables, dont forget to change other one to default_settings_variables_openrouter

import '../models/bot.dart';
import 'package:uuid/uuid.dart';

// Varsayılan bot listesi (bot_provider.dart ile aynı)
final List<Bot> defaultBots = [
  Bot(
    id: const Uuid().v4(),
    name: 'GPT-4.1 nano',
    model: 'gpt-4.1-nano',
    iconName: 'edit',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'O3 Mini',
    model: 'o3-mini',
    iconName: 'smart_toy',
  ),
  Bot(
    id: const Uuid().v4(),
    name: 'GPT 4 Turbo',
    model: 'gpt-4-turbo',
    iconName: 'chat',
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


const String baseUrl = 'https://api.openai.com/v1';
const String defaultControlModel = 'text-embedding-3-small'; //this is for the test connections and for the session title
const String nousablebot = 'gpt-4o-mini'; // If no available models or selected model not in list, use default
String apikey = ''; // dont add your apikey here, leave it empty
