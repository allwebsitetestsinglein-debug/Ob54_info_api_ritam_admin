# HERU AI (v1.0.0)

Native Android assistant: Kotlin, Jetpack Compose (Material 3), MVVM, Coroutines/Flow, DataStore + JSON-file storage.
Brain: Google Gemini (REST API). Persona: friendly Hinglish "best friend".

> **Status: written but NOT compiled or tested by the author.** Expect a few compile errors on the first build.
> Send the exact Gradle error and it can be fixed quickly.

Requirements: Android 8.0+ (minSdk 26). Toolchain assumed: JDK 17, Gradle 8.7, AGP 8.5.2, Kotlin 1.9.24, Compose compiler 1.5.14, compileSdk/targetSdk 34.

## What is implemented

| Area | Status |
|---|---|
| Futuristic home screen (orb, states, chat, quick actions) | Implemented |
| Gemini chat with streaming, context, system prompt, personality/style | Implemented (needs your API key) |
| Settings: key (Keystore-encrypted), test, model list/select, temperature, max tokens, language, voice, appearance, privacy | Implemented |
| Voice input (SpeechRecognizer) + spoken replies (TextToSpeech), stop/interrupt, voice picker, rate/pitch | Implemented |
| App launcher screen + "WhatsApp kholo" style commands, ambiguity choices | Implemented |
| System settings pages (Wi-Fi, Bluetooth, display, sound, ...) | Implemented (opens the page; Android does not allow toggling) |
| YouTube / YouTube Music search + link open, camera app | Implemented (opens search; does NOT start playback) |
| Offline command fallback (apps, settings, YouTube, gestures run without internet/key) | Implemented |
| Coding mode: generate/explain/debug/error, highlighter, copy, editor, snippets, import/export | Implemented (never runs code) |
| Memory (add/review/delete, "yaad rakh ..."), history clear, action log | Implemented |
| Accessibility gestures (Back/Home/Recents/scroll/swipe/tap) + confirmations | Implemented (optional, user enables it) |
| Routines (open a group of apps) | Implemented (Android may block background launches) |

## NOT implemented (deliberately not faked)
Always-on wake word/hands-free listening, notification assistance, clipboard assistant, reminders/alarms, notes/to-do,
calculator/unit conversion, screenshot analysis, camera analysis, file summarisation, web search, Gemini function calling.
No settings or buttons exist for these.

## Build
See `termux-build.sh` (Termux) or `.github/workflows/build.yml` (GitHub Actions).
Output: `app/build/outputs/apk/debug/app-debug.apk`.

## Security and privacy
- API key is stored encrypted with an Android Keystore key. This does not protect against rooted/compromised devices.
  For production use a backend proxy and never ship a key inside the APK.
- The key is sent only in the `x-goog-api-key` header and never logged or stored in chat history. Messages that look like an API key are blocked.
- Sent to Gemini: your message, last ~20 chat messages, saved memories, coding-mode text. Never sent: app list, contacts, files, screen content.
- Accessibility service requests no window-content access; it can only perform gestures you trigger.
- `allowBackup` is off.

## File checklist
build: settings.gradle.kts, build.gradle.kts, gradle.properties, app/build.gradle.kts, AndroidManifest.xml, res/values/{strings,themes}.xml, res/xml/accessibility_service_config.xml
data: Models, SettingsRepository, SecureKeyStore, LocalStore, AppRepository
ai: GeminiClient, Persona
actions: ActionExecutor, CommandRouter, HeruAccessibilityService
voice: VoiceController
ui: HeruApp, SettingsViewModel, theme/Theme, components/{Common,RichText,CodeHighlighter}, home/{HomeScreen,HomeViewModel,HeruOrb},
settings/SettingsScreen, apps/AppsScreen, music/MusicScreen, coding/{CodingScreen,CodingViewModel}, automation/AutomationScreen, misc/MemoryAndLogScreens
