# flutterai

A modern chat application that lets you converse with various AI bots using your own OpenRouter or OpenAI API keys.

## 🚀 Project Purpose

I created this project after searching for alternatives to avoid paying around $20 for existing solutions. I discovered the "pay-as-you-go" API system but found that—apart from Open WebUI—there weren't many all-in-one apps available. This project allows users to securely and efficiently converse with any AI bot of their choice by entering their [OpenRouter model list](https://openrouter.ai/models) or, with minor code changes, [OpenAI pricing](https://platform.openai.com/docs/pricing) API keys. The app also supports image uploads and makes it easy to copy code or messages, streamlining the coding/chat experience. You can extend it to other operating systems if you wish.

## 🎯 Key Features

- **Multi-Bot Support**  
  Easily switch between different LLM bots via your OpenRouter or (with small changes) OpenAI API key.

- **LaTeX Support**  
  Write mathematical formulas and display outputs correctly.

- **Copy Code and Answers**  
  Copy entire messages or code blocks with a single click (code block-only copy is partial; full-message copy is implemented).

- **Easy Setup & Use**  
  Start chatting in minutes with a simple user interface.

- **Dark and Light Themes**  
  Personalize your experience with eye-friendly theme options.

## 📸 Screenshots (app not supports full english UI for now)
![First login screen](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(1).jpg)
![Chat interface](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(2).jpg)
![LaTeX and markdown support](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(3).jpg)
![Chat list](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(4).jpg)
![Bot selection list](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(6).jpg)
![Settings screen](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(5).jpg)

## 🛠️ Installation

1. **After downloading the project as a ZIP:**
   ```bash
   flutter pub get
   flutter build apk
   ```

2. **Or, fork the project and use GitHub Actions:**
   - Generate a keystore and get its base64 code (**Important:** For security, store this code somewhere safe and delete it from your workflow history).
   - Go to repository settings > secrets and variables > actions > repository secrets, then add:
     ```
     ANDROID_KEYSTORE: Enter your base64 code
     ANDROID_KEYSTORE_ALIAS: Create a value of your choice
     ANDROID_KEYSTORE_PASSWORD: Create a value of your choice
     ANDROID_KEY_PASSWORD: Create a value of your choice
     ```
   - Save these values somewhere; if you change location later, you’ll need them. Otherwise, you won't be able to update the app due to signature conflicts.

3. **Or [download a release](https://github.com/bruhmomentumtr/flutterai/releases) to get started quickly.**

## ⚙️ Usage

1. Enter your API key during the initial setup or later in the settings.
2. Select the model you want to chat with from the top right corner.
3. Ask any question or send any code as a message.
4. Enable raw format from settings to fix markdown readability issues.

## 💡 Customization

- You can increase the number of supported bots or models as needed.

## 🤝 Contributing

Feel free to send an email or open an issue to report bugs, request features, or make suggestions.
Contact: fatihkartal64@protonmail.com

## Upcoming Features & Fixes

- Easier bot search functionality
- Fix conversation not appearing in the list after initial setup
- Material You color support
- Pre-built OpenAI integration files for convenience (just copy-paste the endpoint, set bot list, and you’re done! :D)

## VirusTotal Scan

https://www.virustotal.com/gui/file-analysis/NGZjZGFhYzI3ODVmNGZkODFmZTg2Y2M0YjE0OTg4ZGU6MTc1MTQ1ODMzMg==
