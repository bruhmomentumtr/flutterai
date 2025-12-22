#!/bin/bash

set -e # Hata olursa dur
source secrets.sh
# if you don't have secrets.sh file, you can run this script like that:
# export ANDROID_KEYSTORE_PASSWORD=""
# export ANDROID_KEY_PASSWORD=""
# export ANDROID_KEYSTORE_ALIAS=""
# if you don't have my-release-key.jks file, you need to add this line:
# export ANDROID_KEYSTORE_BASE64=""

echo "🚀 Flutter Build ve İmzalama Süreci Başlatılıyor..."

# ---------------------------------------------------------
# 1. HEDEF DOSYA VE DEĞİŞKEN KONTROLÜ
# ---------------------------------------------------------
KEYSTORE_FILE="android/app/my-release-key.jks"

if [[ -z "$ANDROID_KEYSTORE_PASSWORD" || -z "$ANDROID_KEY_PASSWORD" || -z "$ANDROID_KEYSTORE_ALIAS" ]]; then
    echo "❌ HATA: Şifre değişkenleri yukarıda tanımlanmamış!"
    exit 1
fi

# ---------------------------------------------------------
# 2. KEYSTORE KONTROLÜ VE OLUŞTURMA
# ---------------------------------------------------------
if [ -f "$KEYSTORE_FILE" ]; then
    echo "✅ $KEYSTORE_FILE zaten mevcut."
    echo "⏩ Oluşturma adımı atlanıyor..."
else
    echo "⚠️  $KEYSTORE_FILE bulunamadı."
    
    # Dosya yoksa, Base64 değişkenine ihtiyacımız var
    if [ -z "$ANDROID_KEYSTORE_BASE64" ]; then
        echo "❌ HATA: Dosya yok ve yukarıdaki 'ANDROID_KEYSTORE_BASE64' alanı boş bırakılmış!"
        exit 1
    fi

    echo "🔐 Keystore dosyası Base64 verisinden oluşturuluyor..."
    echo "$ANDROID_KEYSTORE_BASE64" | base64 -d > "$KEYSTORE_FILE"
    echo "✅ Keystore oluşturuldu."
fi

# ---------------------------------------------------------
# 3. KEY.PROPERTIES OLUŞTURMA
# ---------------------------------------------------------
echo "📄 key.properties dosyası güncelleniyor..."

echo "storePassword=$ANDROID_KEYSTORE_PASSWORD" > android/key.properties
echo "keyPassword=$ANDROID_KEY_PASSWORD" >> android/key.properties
echo "keyAlias=$ANDROID_KEYSTORE_ALIAS" >> android/key.properties
# echo "storeFile=my-release-key.jks" >> android/key.properties # Gerekirse yorumu kaldırın

# ---------------------------------------------------------
# 4. APK BUILD
# ---------------------------------------------------------
echo "🔨 APK Release build başlatılıyor..."
flutter build apk --release

# ---------------------------------------------------------
# 5. İMZA KONTROLÜ
# ---------------------------------------------------------
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ -f "$APK_PATH" ]; then
    echo "----------- APK İMZA DETAYLARI -----------"
    if command -v apksigner &> /dev/null; then
        apksigner verify --print-certs "$APK_PATH"
        echo " "
        echo "✅ İŞLEM TAMAMLANDI! APK Yolu: $APK_PATH"
    else
        echo "⚠️  'apksigner' bulunamadı ama APK oluşturuldu: $APK_PATH"
    fi
else
    echo "❌ HATA: Build başarısız, APK oluşmadı."
    exit 1
fi