#!/data/data/com.termux/files/usr/bin/bash
# Usage: bash termux-build.sh
# Needs: openjdk-17, Android SDK in ~/android-sdk, Gradle 8.7 in ~/gradle-8.7 (see README).
set -e
cd "$(dirname "$0")"

export JAVA_HOME="${JAVA_HOME:-$PREFIX/lib/jvm/java-17-openjdk}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"

GRADLE="$HOME/gradle-8.7/bin/gradle"
[ -x "$GRADLE" ] || GRADLE=gradle

if [ ! -d "$ANDROID_HOME" ]; then
  echo "Android SDK nahi mila: $ANDROID_HOME (README ka step 2 dekh)"; exit 1
fi

echo "sdk.dir=$ANDROID_HOME" > local.properties

BT=$(ls "$ANDROID_HOME/build-tools" 2>/dev/null | sort -V | tail -1)
if [ -n "$BT" ] && [ -x "$ANDROID_HOME/build-tools/$BT/aapt2" ] && ! grep -q '^android.aapt2FromMavenOverride' gradle.properties; then
  echo "android.aapt2FromMavenOverride=$ANDROID_HOME/build-tools/$BT/aapt2" >> gradle.properties
  echo "aapt2 override set: build-tools/$BT"
fi

echo "Platforms mile: $(ls "$ANDROID_HOME/platforms" 2>/dev/null | tr '\n' ' ')"
echo "(Agar android-34 nahi hai to app/build.gradle.kts me compileSdk/targetSdk us version pe badal.)"

"$GRADLE" assembleDebug --no-daemon "$@"

APK=app/build/outputs/apk/debug/app-debug.apk
if [ -f "$APK" ]; then
  echo "APK ready: $PWD/$APK"
  if [ -d "$HOME/storage/downloads" ]; then
    cp "$APK" "$HOME/storage/downloads/heru-ai-debug.apk"
    echo "Copy ho gaya: Download/heru-ai-debug.apk (file manager se install kar)"
  fi
else
  echo "APK nahi bana. Upar ka error dekh."; exit 1
fi
