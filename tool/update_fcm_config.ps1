# PowerShell script to update Firebase Messaging Service Worker with correct configuration
# This reads from lib/firebase_options.dart and updates web/firebase-messaging-sw.js

Write-Host "🔧 Updating Firebase Messaging Service Worker..." -ForegroundColor Cyan

$firebaseOptionsPath = "lib\firebase_options.dart"
$serviceWorkerPath = "web\firebase-messaging-sw.js"

if (!(Test-Path $firebaseOptionsPath)) {
    Write-Host "❌ Error: $firebaseOptionsPath not found!" -ForegroundColor Red
    Write-Host "   Run: flutterfire configure" -ForegroundColor Yellow
    exit 1
}

if (!(Test-Path $serviceWorkerPath)) {
    Write-Host "❌ Error: $serviceWorkerPath not found!" -ForegroundColor Red
    exit 1
}

# Read firebase_options.dart
$content = Get-Content $firebaseOptionsPath -Raw

# Extract web configuration values using simple string matching
$webSection = $content -split 'static const FirebaseOptions web'
if ($webSection.Length -lt 2) {
    Write-Host "❌ Error: Could not find web configuration!" -ForegroundColor Red
    exit 1
}

$configSection = $webSection[1]

# Extract values using regex
$apiKey = if ($configSection -match "apiKey: '([^']+)'") { $matches[1] } else { "" }
$authDomain = if ($configSection -match "authDomain: '([^']+)'") { $matches[1] } else { "" }
$projectId = if ($configSection -match "projectId: '([^']+)'") { $matches[1] } else { "" }
$storageBucket = if ($configSection -match "storageBucket: '([^']+)'") { $matches[1] } else { "" }
$messagingSenderId = if ($configSection -match "messagingSenderId: '([^']+)'") { $matches[1] } else { "" }
$appId = if ($configSection -match "appId: '([^']+)'") { $matches[1] } else { "" }
$measurementId = if ($configSection -match "measurementId: '([^']+)'") { $matches[1] } else { "" }

if (!$apiKey -or !$projectId) {
    Write-Host "❌ Error: Could not extract Firebase configuration!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Extracted Firebase Configuration:" -ForegroundColor Green
Write-Host "   Project ID: $projectId" -ForegroundColor Gray
Write-Host "   Auth Domain: $authDomain" -ForegroundColor Gray

# Read service worker file
$swContent = Get-Content $serviceWorkerPath -Raw

# Replace the firebase.initializeApp section
$newConfig = @"
firebase.initializeApp({
  apiKey: "$apiKey",
  authDomain: "$authDomain",
  projectId: "$projectId",
  storageBucket: "$storageBucket",
  messagingSenderId: "$messagingSenderId",
  appId: "$appId",
  measurementId: "$measurementId"
});
"@

# Replace the configuration
$pattern = "firebase\.initializeApp\(\{[^}]+\}\);"
$updatedContent = $swContent -replace $pattern, $newConfig

# Write back to file
$updatedContent | Set-Content $serviceWorkerPath -NoNewline

Write-Host "`n✅ Service Worker updated successfully!" -ForegroundColor Green
Write-Host "`n📝 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Run: flutter run -d chrome" -ForegroundColor White
Write-Host "   2. Check console for successful FCM initialization" -ForegroundColor White
Write-Host "`n🎉 Done!" -ForegroundColor Green
