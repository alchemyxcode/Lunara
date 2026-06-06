# 🌙 LunaFlow

> A private, open-source menstrual cycle and personal health tracker — built for sovereignty over your own data.

LunaFlow is a Flutter-based Android app that logs cycle data, symptoms, mood, and health metrics — syncing privately to your own Nextcloud/Disroot instance with zero third-party tracking. A self-hosted AI agent (running on your own hardware) analyses your data and provides personalised health insights including nutrition and fitness recommendations.

**Your data. Your hardware. Your terms.**

---

## ✨ Features

- 📅 **Cycle tracking** — log period start/end with predicted next cycle
- 🩸 **Flow logging** — intensity (spotting / light / medium / heavy) and colour
- 🌡️ **Symptom tracking** — multi-select from a full symptom library (cramps, headache, bloating, fatigue, nausea, acne, breast tenderness, back pain, brain fog, appetite changes, insomnia, and more)
- 💭 **Mood & energy** — daily mood check-in and energy level
- 🔥 **Libido tracking** — sex drive logging (low / normal / high)
- 😴 **Sleep logging** — hours and quality
- 🔒 **End-to-end encrypted sync** — to your own Nextcloud/Disroot via WebDAV
- 🤖 **Self-hosted AI health agent** — personalised nutrition and fitness insights, running on hardware you control
- 📊 **History & charts** — visualise patterns across your cycle over time
- 🚫 **Zero tracking** — no analytics, no ads, no cloud accounts required

---

## 🤖 AI Health Agent

LunaFlow is designed to work with a **self-hosted AI agent** running on your own dedicated machine — not on your phone, and not on a third-party cloud server.

```
📱 LunaFlow App
    ↓ encrypted sync
☁️  Your Nextcloud / Disroot
    ↓
🖥️  Your AI Machine (Ollama + Llama 3 or similar)
    ↓
💬  Health insights → back to your dashboard
```

The app sends an anonymised summary of your recent cycle data to a **configurable endpoint** — meaning you point it wherever you want:
- Your own machine running [Ollama](https://ollama.ai) (fully local, recommended)
- Your own Anthropic API key
- Any OpenAI-compatible endpoint

No AI provider is hardcoded. No data goes anywhere you haven't explicitly configured. Other users set up their own agent — nobody shares yours.

> **Current development approach:** LunaFlow is being built and tested against the [Anthropic API](https://anthropic.com) (Claude). Once the AI agent layer is stable, the project will migrate to a fully self-hosted [Ollama](https://ollama.ai) + Llama 3 setup — eliminating any dependency on external APIs entirely. The transition requires changing only a few lines of configuration.

---

## 🏗️ Full Architecture

```
📱 Flutter App (Android)
    ↓ WebDAV + AES-256 encryption
☁️  Your Nextcloud / Disroot
    ↓ Nextcloud desktop sync
🖥️  Your Ubuntu Machine
    ├── Local SQLite database
    └── Local web dashboard
         ↕
🤖  Your AI Machine
    └── Ollama (Llama 3 / Mistral)
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter (Dart) |
| Local storage | SQLite via `sqflite` |
| Sync | WebDAV (`webdav_client`) |
| Encryption | AES-256 (`encrypt` package) |
| AI Agent | Ollama (local) / any OpenAI-compatible API |
| Dashboard | Python + FastAPI |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- Android device or emulator (API 21+)
- A [Disroot](https://disroot.org) or Nextcloud account for sync *(optional — app works fully offline)*

### Installation

```bash
# Clone the repository
git clone https://github.com/alchemyxcode/LunaFlow.git
cd LunaFlow

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

### Sync Setup

1. Open the app and go to **Settings → Sync**
2. Enter your Nextcloud/Disroot WebDAV URL:
   `https://cloud.disroot.org/remote.php/dav/files/YOUR_USERNAME/`
3. Enter your credentials
4. Generate an encryption key — **save this in your password manager**
5. Tap **Connect & Sync**

### AI Agent Setup

1. Set up [Ollama](https://ollama.ai) on your dedicated machine
2. Pull a model: `ollama pull llama3`
3. In the app go to **Settings → AI Agent**
4. Enter your machine's local address: `http://YOUR_MACHINE_IP:11434`
5. Tap **Test Connection**

---

## 🗺️ Roadmap

See the [Project Board](../../projects/1) for live progress.

- [x] Repository setup
- [ ] Core cycle logging UI
- [ ] Symptom & mood tracking
- [ ] Local SQLite storage
- [ ] WebDAV sync to Nextcloud/Disroot
- [ ] AES-256 encryption layer
- [ ] AI health agent integration
- [ ] Charts & history view
- [ ] Reminder notifications
- [ ] Linux desktop companion app
- [ ] F-Droid submission

---

## 🔐 Privacy

LunaFlow is designed from the ground up for privacy:

- All data is stored locally on your device first
- Sync is optional and goes only to infrastructure you control
- Data is AES-256 encrypted before leaving your device
- No telemetry, no crash reporting, no analytics
- No internet permission required except for sync
- AI analysis runs on your own hardware — your health data never touches a third-party AI server unless you explicitly configure it to

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a PR.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org):
   - `feat:` new feature
   - `fix:` bug fix
   - `docs:` documentation only
   - `refactor:` code change that isn't a fix or feature
4. Open a Pull Request

---

## 🙏 Acknowledgements

Built with assistance from [Claude](https://claude.ai) by Anthropic.

---

## 📄 License

Licensed under the **GNU General Public License v3.0** — see [LICENSE](LICENSE) for details.

Any derivative work must also be open source under GPL-3.0.

---

## ⚠️ Disclaimer

LunaFlow is not a medical device and should not be used as a substitute for professional medical advice.

---

*Made with 🌙 by [@alchemyxcode](https://github.com/alchemyxcode)*# LunaFlow
Period tracking app. Privacy focused no data collected unless offered for app improvement. Mostly for personal use to begin with. Built with the help of Claude**
