plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Adicione esta linha:
    id("com.google.gms.google-services")
}

android {
    namespace = "com.breno.securemsg"
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
        applicationId = "com.breno.securemsg"
        // O Firebase geralmente exige minSdk 21 ou superior
        minSdk = 21 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode()
        versionName = flutter.versionName()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Adicione esta linha para importar o BoM do Firebase
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
}

flutter {
    source = "../.."
}
