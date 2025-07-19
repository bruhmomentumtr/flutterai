# flutterai

Kendi OpenRouter veya OpenAI API anahtarlarınızı kullanarak çeşitli yapay zeka botlarıyla sohbet etmenizi sağlayan modern bir sohbet uygulaması.

## 🚀 Projenin Amacı

Bu projeyi, mevcuttaki platformlar için yaklaşık 20$ ödeme yapmak yerine bir alternatif ararken oluşturdum. "Kullandıkça öde" API sistemini keşfettim fakat Open WebUI dışında hepsi bir arada uygulamaların sayısı çok azdı. Bu proje, kullanıcıların [OpenRouter (model listesi linki)](https://openrouter.ai/models) (veya küçük kod değişiklikleriyle [OpenAI (fiyatlandırma linki)](https://platform.openai.com/docs/pricing)) API anahtarlarını girerek istedikleri herhangi bir yapay zeka botu ile güvenli ve verimli bir şekilde sohbet etmelerini sağlıyor. Uygulama ayrıca resim yüklemeyi, kod veya mesaj kopyalamayı kolaylaştırıyor ve kodlama/sohbet deneyiminizi hızlandırıyor. İsterseniz uygulamayı başka işletim sistemlerine de genişletebilirsiniz.

## 🎯 Ana Özellikler

- **Çoklu Bot Desteği**  
  OpenRouter veya (küçük değişiklikler ile) OpenAI API anahtarınız ile farklı LLM botları arasında kolayca geçiş yapabilirsiniz.

- **LaTeX Desteği**  
  Matematiksel formülleri yazabilir ve çıktıları düzgün görüntüleyebilirsiniz. (genellikle :D)

- **Kod ve Yanıt Kopyalama**  
  Tek tıkla tüm mesajları veya kod bloklarını (kod bloğu kopyalama kısmi; tüm mesaj kopyalama tam olarak uygulanmıştır) kopyalayabilirsiniz.

- **Kolay Kurulum ve Kullanım**  
  Basit kullanıcı arayüzü ile dakikalar içinde sohbete başlayın.

- **Koyu ve Açık Tema**  
  Göz dostu tema seçenekleri ile deneyiminizi kişiselleştirin.

## 📸 Ekran Görüntüleri (languages.dart üzerinden dili değiştirebilirsiniz)
![İlk giriş ekranı](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(1).jpg)
![Sohbet arayüzü](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(2).jpg)
![LaTeX ve markdown desteği](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(3).jpg)
![Sohbet listesi](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(4).jpg)
![Bot seçme listesi](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(6).jpg)
![Ayarlar ekranı](https://github.com/bruhmomentumtr/flutterai/blob/main/ss%20(5).jpg)

## 🛠️ Kurulum

1. **Projeyi ZIP olarak indirdikten sonra:**
   ```bash
   flutter pub get
   flutter build apk
   ```

2. **Veya projeyi fork'layıp GitHub Actions kullanarak:**
   - Bir keystore oluşturun ve base64 kodunu alın (**Önemli:** Bu kodu güvenli bir yerde saklayın, workflow geçmişinizden silmeyi unutmayın).
   - Depo ayarlarından > secrets and variables > actions > repository secrets bölümüne girin ve şunları ekleyin:
     ```
     ANDROID_KEYSTORE: Base64 kodunuzu girin
     ANDROID_KEYSTORE_ALIAS: İstediğiniz bir değer oluşturun
     ANDROID_KEYSTORE_PASSWORD: İstediğiniz bir değer oluşturun
     ANDROID_KEY_PASSWORD: İstediğiniz bir değer oluşturun
     ```
   - Bu değerleri bir yere kaydedin; ileride local olarak bir cihazda build ederken yeniden lazım olacak. Aksi takdirde imza çakışmalarından dolayı uygulamayı güncelleyemezsiniz.

  > **Not:**  
  > Projeyi fork'ladıktan sonra aşağıdaki dosyaları kendi ihtiyaçlarınıza göre gözden geçirip özelleştirmeniz önerilir:
  > - `lib/languages/languages.dart`: Uygulamadaki tüm kullanıcıya gösterilen metinler burada merkezi olarak tutulur. Uygulamayı çevirmek veya kullanıcıya gösterilen mesajları değiştirmek için bu dosyayı düzenleyin.
  > - `lib/settingsvariables/default_settings_variables.dart`: Varsayılan bot listesi, sistem mesajı ve API anahtarı yönetimi bu dosyada bulunur. Kendi varsayılan botlarınızı, sistem mesajınızı veya API anahtarı yönetimini ayarlamak için bu dosyayı güncelleyin.
  > - eğer kodlamadan uğraşmak istemiyorsanız [OpenRouter Integrations](https://openrouter.ai/settings/integrations) üzerinden openAI api anahtarınızı ekleyerek devam edebilirsiniz.

3. **Veya [bir release üzerinden sürüm indirerek](https://github.com/bruhmomentumtr/flutterai/releases) hızlıca başlayın.**

## ⚙️ Kullanım

1. API anahtarınızı ilk kurulumda veya sonradan ayarlar bölümünden girin.
2. Sağ üst köşeden sohbet etmek istediğiniz modeli seçin.
3. Herhangi bir soru sorabilir veya kodu mesaj olarak gönderebilirsiniz.
4. Ayarlardan raw formatı etkinleştirerek (olursa) markdown okuma sorunlarını çözebilirsiniz.

## 💡 Özelleştirme

- Desteklenen bot veya model sayısını istediğiniz gibi artırabilirsiniz.

## 🤝 Katkıda Bulunma

Hata bildirmek, özellik talep etmek ya da öneride bulunmak için e-posta gönderebilir veya issue açabilirsiniz.  
İletişim: fatihkartal64@protonmail.com

## Yakında Gelecek Özellikler & Düzeltmeler

- Bot arama fonksiyonunun kolaylaştırılması
- İlk kurulumdan sonra sohbetlerin listede görünmeme sorununun çözümü
- Material You renk desteği
- Açıkça kodlanmış OpenAI entegrasyon dosyaları (endpoint’i kopyala-yapıştır, bot listesi ayarla ve hazır! :D)

## VirusTotal Taraması

https://www.virustotal.com/gui/file/44479ce7741c3f865f4bc9d3894677c17f4944d616224de3ac173fd693e57dfa/details