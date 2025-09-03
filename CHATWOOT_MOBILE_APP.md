# 📱 Chatwoot Mobile App - Guia Completo

## 🎯 Opções de App Mobile

### 1. **App Oficial do Chatwoot** ✅ (RECOMENDADO)
- **Repositório:** https://github.com/chatwoot/chatwoot-mobile-app
- **Tecnologia:** React Native + Expo
- **Plataformas:** Android e iOS
- **Status:** Ativamente mantido
- **Versão atual:** 4.0.0+ (2024)

### 2. **Widget React Native** (Para seu próprio app)
- **Pacote:** `@chatwoot/react-native-widget`
- **Use caso:** Adicionar chat ao SEU app existente

## 📲 App Oficial - Como Configurar

### Pré-requisitos:
```bash
# Instalar dependências
npm install -g expo-cli
npm install -g react-native-cli
```

### 1️⃣ Clonar e Configurar
```bash
# Clonar repositório oficial
git clone https://github.com/chatwoot/chatwoot-mobile-app.git
cd chatwoot-mobile-app

# Instalar dependências
yarn install

# Para iOS
cd ios && pod install
```

### 2️⃣ Configurar URL do Servidor
```javascript
// src/constants/url.js
export const API_URL = 'https://seu-chatwoot.com';
// OU para desenvolvimento local:
export const API_URL = 'http://192.168.1.100:3000'; // IP da sua máquina
```

### 3️⃣ Configurar Push Notifications

#### Android (FCM)
```json
// android/app/google-services.json
{
  "project_info": {
    "project_id": "seu-projeto-firebase"
  }
}
```

#### iOS (APNs)
```ruby
# ios/Podfile
pod 'Firebase/Messaging'
```

### 4️⃣ Build e Deploy

#### Desenvolvimento
```bash
# Android
yarn android

# iOS
yarn ios
```

#### Produção
```bash
# Android - Gerar APK
cd android
./gradlew assembleRelease

# iOS - Gerar IPA
expo build:ios
```

## 🔧 Configuração no Chatwoot Backend

### 1. Habilitar Push Notifications
```ruby
# No console Rails
InstallationConfig.create!(
  name: 'ANDROID_PUSH_CERT',
  value: 'seu_fcm_server_key'
)

InstallationConfig.create!(
  name: 'IOS_PUSH_CERT', 
  value: 'seu_apns_cert_base64'
)
```

### 2. Configurar URLs de Deep Linking
```ruby
# config/application.yml
MOBILE_APP_SCHEME: 'chatwoot://'
MOBILE_APP_DOMAIN: 'app.chatwoot.com'
```

## 🎨 Personalização do App

### 1. Cores e Tema
```javascript
// src/theme/colors.js
export default {
  primary: '#1F93FF',
  secondary: '#25C16F',
  background: '#FFFFFF',
  // Suas cores personalizadas
};
```

### 2. Logo e Ícones
```bash
# Substituir arquivos
assets/images/logo.png
android/app/src/main/res/mipmap-*/ic_launcher.png
ios/Chatwoot/Images.xcassets/AppIcon.appiconset/
```

### 3. Nome do App
```xml
<!-- android/app/src/main/res/values/strings.xml -->
<string name="app_name">Seu CRM</string>
```

```plist
<!-- ios/Chatwoot/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Seu CRM</string>
```

## 📊 Features do App Mobile

### ✅ Funcionalidades Disponíveis:
- Login com email/senha
- Lista de conversas
- Chat em tempo real
- Notificações push
- Anexos (imagens, documentos)
- Áudio/vídeo playback
- Pesquisa de conversas
- Filtros e labels
- Status online/offline
- Multi-conta
- Dark mode

### ⚠️ Limitações:
- Sem editor de macros
- Sem configurações de admin
- Sem relatórios complexos
- Sem gerenciamento de webhooks

## 🚀 Deploy nas Lojas

### Google Play Store
```bash
# Gerar bundle assinado
cd android
./gradlew bundleRelease

# Upload para Play Console
# https://play.google.com/console
```

### Apple App Store
```bash
# Build com Expo
expo build:ios

# Upload com Transporter
# https://apps.apple.com/app/transporter
```

## 🔄 Integração com PWA

### Alternativa: Progressive Web App
```javascript
// No Chatwoot, já existe suporte PWA
// manifest.json configurado
// Service Worker ativo

// Para instalar como app:
// Android: Chrome > Menu > "Adicionar à tela inicial"
// iOS: Safari > Compartilhar > "Adicionar à Tela de Início"
```

## 📱 Widget para App Existente

### Instalar no seu React Native app:
```bash
yarn add @chatwoot/react-native-widget
```

### Usar no código:
```javascript
import ChatwootWidget from '@chatwoot/react-native-widget';

function App() {
  return (
    <ChatwootWidget
      websiteToken="SEU_WEBSITE_TOKEN"
      baseUrl="https://seu-chatwoot.com"
      locale="pt_BR"
      user={{
        identifier: 'user@example.com',
        name: 'João Silva',
        email: 'user@example.com'
      }}
    />
  );
}
```

## 🛠️ Scripts Úteis

### Build Automatizado
```json
// package.json
{
  "scripts": {
    "build:android": "cd android && ./gradlew assembleRelease",
    "build:ios": "cd ios && xcodebuild -workspace Chatwoot.xcworkspace -scheme Chatwoot archive",
    "deploy:android": "cd android && ./gradlew publishReleaseBundle",
    "deploy:ios": "fastlane ios release"
  }
}
```

## 📈 Monitoramento

### Crashlytics/Sentry
```javascript
// src/index.js
import * as Sentry from '@sentry/react-native';

Sentry.init({
  dsn: 'SEU_SENTRY_DSN',
  environment: 'production'
});
```

## 🔐 Segurança

### Configurações Importantes:
```javascript
// Ofuscar código
// android/app/build.gradle
buildTypes {
  release {
    minifyEnabled true
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
  }
}
```

## 💡 Dicas

1. **Performance:** Use React Native 0.72+ para melhor performance
2. **Tamanho:** Otimize imagens e use code splitting
3. **Offline:** Implemente cache com AsyncStorage
4. **Updates:** Use CodePush para atualizações OTA

## 🎯 Resumo

**Para usar Chatwoot no mobile você tem 3 opções:**

1. **App oficial** - Clonar e personalizar o app React Native
2. **PWA** - Usar o Chatwoot web como app (mais simples)
3. **Widget** - Integrar chat no seu app existente

A opção mais rápida é usar o **PWA** que já funciona nativamente!