# QRCodeKeyboardScanner (Swift + Tastaturintegration)

Dieses Repository enthält ein startbares **Xcode-Projekt** für iOS mit:

- nativer QR-/Barcode-Erkennung (AVFoundation)
- Custom-Keyboard-Erweiterung für Eingabefelder
- Übergabe des gescannten Texts aus der App zurück in die Tastatur und Einfügen ins aktive Textfeld

## Projekt öffnen

1. In Xcode öffnen: `QRCodeKeyboardScanner.xcodeproj`
2. Unter *Signing & Capabilities* für **App** und **Keyboard Extension** dein Team wählen.
3. App Group `group.com.predalis.qrkeyboardscanner` in beiden Targets aktiv lassen.

## Verhalten (wie gewünscht)

1. In einer Webseite/App auf ein Texteingabefeld tippen.
2. Als Tastatur die Erweiterung **QR Keyboard** wählen.
3. Auf **QR/Barcode lesen** tippen.
4. Scanner-App öffnet sich, Code wird gelesen, Text wird bestätigt.
5. Beim Zurückkehren ins Eingabefeld wird der bestätigte Text eingefügt (automatisch einmalig), alternativ über den Keyboard-Button "Zuletzt gescannten Text einfügen".

## Wichtige Hinweise

- URL-Scheme für App-Start aus der Tastatur: `qrsamo://scan`
- Kamera-Berechtigung ist in `Info.plist` hinterlegt.
- Das Projekt ist als Basis für Weiterentwicklung gedacht (UI/Flows/Sicherheit/Validierung erweiterbar).
