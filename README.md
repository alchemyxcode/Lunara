# 🌙 Lunara

Lunara is a privacy-first personal health tracker for women, built around the menstrual cycle. Log your period, mood, symptoms, food, and movement — and let AI help you understand the patterns in your own body.

Built by a woman, for women. Local-first, encrypted, open source.

---

## Features

**Currently available:**
- 🌙 Cycle tracking — log period start, flow intensity, and colour
- 📋 Daily health log — mood, energy, sleep, libido, symptoms, and notes
- 📅 Calendar view — visualise logged days and period days
- 🌕 Lunar phase tracking — moon phase displayed on home screen and calendar
- ☁️ WebDAV sync — AES-256 encrypted backup to Disroot or any Nextcloud instance
- 🔔 Daily reminders — customisable log reminders with timezone support

**Coming soon:**
- 🥗 Food tracking — log what you eat without weighing or counting calories
- 🏃 Workout and movement logging
- 🤖 AI health agent — pattern insights across your whole cycle
- 📊 Insights screen — understand your monthly rhythms over time

---

## Privacy

Your data belongs to you. Lunara is designed with privacy at its core:

- All data is stored **locally** on your device using SQLite
- Cloud sync is **optional** and uses **AES-256 encryption** before anything leaves your device
- Sync is self-hosted — your data goes to **your** Nextcloud or Disroot, not our servers
- No analytics, no tracking, no ads
- Fully open source under the GNU GPL v3.0 license

---

## Tech Stack

- **Flutter** (Dart) — Android app
- **SQLite** (sqflite) — local database
- **WebDAV** (webdav_client) — encrypted cloud sync
- **AES-256** (encrypt) — end-to-end encryption
- **Anthropic API / Ollama** — AI health agent (coming soon)

---

## Getting Started

### Requirements
- Flutter 3.44.1 or later
- Android SDK
- Java 17

### Run locally
```bash
git clone https://github.com/alchemyxcode/Lunara.git
cd Lunara
flutter pub get
flutter run
```

---

## Roadmap

| Milestone | Status |
|-----------|--------|
| Core cycle & symptom logging | ✅ Complete |
| Calendar view | ✅ Complete |
| WebDAV sync with AES-256 encryption | ✅ Complete |
| Lunar phase tracking | ✅ Complete |
| Daily reminder notifications | ✅ Complete |
| Food tracking | 🔧 In progress |
| Workout logging | 🔧 In progress |
| AI health agent | 📋 Planned |
| Insights screen | 📋 Planned |
| F-Droid submission | 📋 Planned |

---

## License

Lunara is licensed under the [GNU General Public License v3.0](LICENSE).

---

## Credits

Built by [@alchemyxcode](https://github.com/alchemyxcode) with assistance from Claude by Anthropic.
