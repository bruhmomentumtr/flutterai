import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.GradleException // Hata fırlatmak için import edin

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.openrouterapp" // TODO: Kendi benzersiz değerinizle değiştirin!
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.openrouterapp" // TODO: Kendi benzersiz değerinizle değiştirin!
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // key.properties dosyasını oku
    // build.gradle.kts (android/app) dosyasından bir üst dizindeki (android) key.properties dosyasına göreceli yol
    val keyPropertiesFile = file("../key.properties") // <-- Burayı düzelttik!
    val keyProperties = Properties()

    // Sadece dosya varsa oku
    if (keyPropertiesFile.exists()) {
        println("Reading signing properties from ${keyPropertiesFile.absolutePath}")
        keyPropertiesFile.inputStream().use { keyProperties.load(it) }
    } else {
        // GitHub Actions ortamında bu dosya oluşturulacağı için burada bu uyarıyı görmemelisiniz.
        // Lokal debug build'lerde dosya olmayabilir.
        println("Warning: key.properties not found at ${keyPropertiesFile.absolutePath}. Release build might fail if signingConfig is required.")
    }

    signingConfigs {
        create("release") {
            // Keystore dosyasının yolunu, build.gradle.kts dosyasının bulunduğu dizine (android/app) göre göreceli olarak belirtin.
            // Workflow'da dosya android/app/my-release-key.jks olarak decode ediliyor.
            storeFile = file("my-release-key.jks") // <-- Burayı düzelttik!

            // Şifre ve alias'ı key.properties'ten okuyun
            val storePass = keyProperties.getProperty("storePassword")
            val keyPass = keyProperties.getProperty("keyPassword")
            val keyAliasVal = keyProperties.getProperty("keyAlias")

            // Check if properties were read successfully
            // Eğer key.properties dosyası varsa (GitHub Actions'ta olduğu gibi)
            // ve içindeki değerler eksikse, build'i durdur.
            if (keyPropertiesFile.exists()) {
                if (storePass != null && keyPass != null && keyAliasVal != null) {
                    storePassword = storePass
                    keyPassword = keyPass
                    keyAlias = keyAliasVal
                } else {
                     throw GradleException("Error: Missing signing properties (password, alias) in key.properties! Check your GitHub Secrets and workflow step creating key.properties.")
                }
            } else {
                // Eğer key.properties dosyası yoksa (lokal build gibi),
                // signingConfig eksik kalır. Release build için bu hata verir.
                // Debug build için sorun olmaz.
                println("Info: key.properties not found, release signing config might be incomplete.")
            }
        }
    }

    buildTypes {
        release {
            // Kendi release imzalama yapılandırmanızı kullanın
            // key.properties dosyası varsa "release" signingConfig'i kullanır.
            // Yoksa (lokal debug gibi), signingConfig eksik kalır ve Gradle hata verir.
            signingConfig = signingConfigs.getByName("release")

            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug") // <-- Bu satırı silebilirsiniz veya yorum satırı yapabilirsiniz
        }
    }
    // ... (diğer ayarlarınız) ...
}

flutter {
    source = "../.."
}
