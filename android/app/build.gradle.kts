import java.util.Properties // Properties sınıfını kullanmak için import edin
import java.io.FileInputStream // Dosya okumak için import edin

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.openrouterapp"
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
        applicationId = "com.bmtr.openrouterapp" // TODO: Kendi benzersiz değerinizle değiştirin!
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // BURADAN İTİBAREN EKLEYİN VEYA DÜZENLEYİN

    // key.properties dosyasını oku
    val keyPropertiesFile = file("../key.properties") // android/app/build.gradle.kts'den android/key.properties'e göreceli yol
    val keyProperties = Properties()

    if (keyPropertiesFile.exists()) {
        println("Reading signing properties from ${keyPropertiesFile.absolutePath}")
        keyPropertiesFile.inputStream().use { keyProperties.load(it) }
    } else {
        println("Warning: key.properties not found at ${keyPropertiesFile.absolutePath}. Release build might fail if signingConfig is required.")
        // GitHub Actions ortamında bu dosya oluşturulacağı için burada hata vermeyecek.
        // Lokal debug build'lerde dosya olmayabilir, bu durumda debug signing kullanılır.
    }

    signingConfigs {
        create("release") {
            // key.properties dosyasından okunan değerleri kullan
            // Güvenlik nedeniyle, bu değerlerin key.properties dosyasında olduğundan emin olun
            // ve bu dosyayı .gitignore'a ekleyin (GitHub Actions'ta runtime'da oluşturuluyor).

            // storeFile path'i key.properties içinde proje kök dizinine göre verilmiş olmalı
            // (Sizin Actions adımınızda "storeFile=android/app/my-release-key.jks" olarak ayarlanıyor)
            // Bu path'i proje kök dizinine göre çözümlememiz gerekiyor.
            storeFile = file("${project.rootDir}/${keyProperties["storeFile"]}")
            storePassword = keyProperties["storePassword"] as String
            keyAlias = keyProperties["keyAlias"] as String
            keyPassword = keyProperties["keyPassword"] as String
        }
    }

    buildTypes {
        release {
            // Kendi release imzalama yapılandırmanızı kullanın
            // key.properties dosyası varsa "release" signingConfig'i kullanır.
            // Yoksa (lokal debug gibi), signingConfig varsayılan olarak null kalır veya debug kullanılır.
            // Flutter'ın varsayılan şablonu debug'ı kullandığı için, key.properties yoksa debug signing devreye girer.
            // Eğer key.properties yoksa build'in hata vermesini isterseniz, burada bir kontrol ekleyebilirsiniz.
            signingConfig = signingConfigs.getByName("release")

            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug") // <-- Bu satırı silebilirsiniz veya yorum satırı yapabilirsiniz
        }
    }
    // BURAYA KADAR EKLEYİN VEYA DÜZENLEYİN
}

flutter {
    source = "../.."
}
