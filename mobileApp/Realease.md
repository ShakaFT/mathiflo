# Realease

Automate deployments with Fastlane : <https://docs.fastlane.tools/>

## Android

### Build and release

Documentation : <https://docs.flutter.dev/deployment/android#reference-the-keystore-from-the-app>

If we lose /android/keystore.jks : <https://docs.flutter.dev/deployment/android#create-an-upload-keystore>
We use keystore.jsk to sign our aab/apf files. If we create new keystore.jsk file, we need to send a request to update keystore.jsk upload on Play Store : Mathiflo/Configuration/Intégrité de l'appli/Signature d'application/Certificat de la clé de signature d'application/Demander la mise à jour de votre clé/Importer une nouvelle clé de signature d'application depuis un keystore Java

To setup /android/key.properties : <https://docs.flutter.dev/deployment/android#reference-the-keystore-from-the-app>

### Fastlane

Setup Fastlane : <https://docs.fastlane.tools/getting-started/android/setup>

Release : <https://docs.fastlane.tools/getting-started/android/release-deployment/>

We use supply : <http://docs.fastlane.tools/actions/supply/>
