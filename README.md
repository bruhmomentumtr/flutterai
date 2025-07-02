# flutterai

Kendi OpenRouter veya OpenAI API anahtarınızı kullanarak çeşitli yapay zeka botlarıyla konuşmanızı sağlayan modern bir sohbet uygulaması.

## 🚀 Projenin Amacı

Bu proje, kullanıcıların [OpenRouter](https://openrouter.ai/) veya (kodlarda değişiklik yaparak) [OpenAI](https://openai.com/) entegrasyonu ile API anahtarlarını girerek diledikleri AI botu ile güvenli ve hızlı şekilde sohbet edebilmelerini amaçlar. Gelişmiş özellikler sayesinde materyal ve mesajlarınızı kolayca yönetir, verimli çalışma imkanı sunar.

## 🎯 Temel Özellikler

- **Çoklu Bot Desteği**  
  OpenRouter veya (kodlarda değişiklik yaparak) OpenAI API anahtarınızı girerek farklı LLM botları arasında geçiş yapabilirsiniz.

- **LaTeX Desteği**  
  Matematiksel formüller yazabilir, çıktıları düzgün şekilde görüntüleyebilirsiniz.

- **Kod ve Cevap Kopyalama**  
  Mesajların ve kod bloklarının (kod blokları tamamen olmasa da tüm mesajı birden) tek tıkla kolayca kopyalayın.

- **Kolay Kurulum & Kullanım**  
  Basit arayüz ile dakikalar içinde sohbet etmeye başlayın.

- **Koyu ve Açık Tema**  
  Göz yormayan kişiselleştirilebilir tema seçenekleri.

## 📸 Ekran Görüntüleri
![ilk giriş ekranı](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(1).jpg)
![mesajlaşma arayüzü](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(2).jpg)
![latex ve markdown desteği](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(3).jpg)
![sohbet listesi](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(4).jpg)
![bot seçim listesi](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(6).jpg)
![ayarlar ekranı](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(5).jpg)

## 🛠️ Kurulum
1) **projeyi zip olarak indirdikten sonra**
```bash
flutter pub get
flutter build apk
```
2) **veya projeyi fork'layarak actions üzerinden**
- keystore oluşturup base kodunu elde edin (NOT: güvenlik için sonradan bu oluşan kodu farklı yere kaydedip, workflow geçmişinden sil)
- ayarlar > secrets and variables > actions > repository secrets'a gelin
- ANDROID_KEYSTORE: base64 kodunu gir
- ANDROID_KEYSTORE_ALIAS: kafana göre değer oluştur :D
- ANDROID_KEYSTORE_PASSWORD: kafana göre değer oluştur :D
- ANDROID_KEY_PASSWORD: kafana göre değer oluştur :D
- bu değerlerin hepsini farklı bir yere not et sonradan başka yerde devam edersen imza çakışmasından uygulamanı güncelleyemezsin

3) **Veya [yayınlanan sürümleri](https://github.com/bruhmomentumtr/flutterai/releases) kullanarak hızlıca başlayabilirsiniz.**

## ⚙️ Kullanım

1. API anahtarınızı ilk kurulumda direkt olarak veya ayarlar kısmında ekleyin.  
2. Sohbet etmek istediğiniz modeli sağ-üst köşeden seçin.  
3. Her türlü soruyu veya kodu yazarak gönderin.
4. ayarlardan ham formatı açarak oluşan markdown hatalarından okunurluğu düzeltin

## 💡 Özelleştirme

- Desteklenen bot veya model sayısını arttırabilirsiniz.

## 🤝 Katkı

Her türlü geliştirme, hata bildirimi veya öneri için eposta gönderebilir veya (Issues) üzerinde tartışma başlatabilirsiniz.
iletişim: fatihkartal64@protonmail.com

## eklenecek veya düzeltilecek özellikler
- botları kolayca aratma
- ilk kurulum sonrası sohbetin listede gözükmeme durumu
- material you renk desteği
