# GitHub Issues — LunaFlow

Copy each issue into GitHub. Assign labels, milestone, and add to the LunaFlow Development Kanban board under Backlog.

---

## MILESTONE 1: Core App (MVP)

---

### Issue 1 — Flutter project scaffold
**Labels:** `setup` `good first issue`
**Milestone:** Milestone 1 — Core App (MVP)

As a developer, I want a clean Flutter project structure so that the codebase is organised and ready to build on.

**Acceptance criteria:**
- Flutter project initialised with package name `com.alchemyxcode.lunaflow`
- Folder structure in place: `/lib/screens`, `/lib/models`, `/lib/services`, `/lib/widgets`
- Basic bottom navigation shell with placeholder screens
- Runs on Android emulator without errors
- GPL-3.0 licence header added to main.dart

---

### Issue 2 — Cycle & flow logging screen
**Labels:** `feature` `ui`
**Milestone:** Milestone 1 — Core App (MVP)

As a user, I want to log when my period starts and ends, along with flow details, so that I can track my cycle accurately over time.

**Acceptance criteria:**
- Button to mark period start / end
- Flow intensity selector: spotting / light / medium / heavy
- Flow colour selector: bright red / dark red / pink / brown / black / orange (with brief descriptions)
- Date defaults to today but can be changed by the user
- Entry saved to local SQLite database
- Predicted next period displayed on home screen based on average cycle length

---

### Issue 3 — Symptom tracking screen
**Labels:** `feature` `ui`
**Milestone:** Milestone 1 — Core App (MVP)

As a user, I want to log multiple symptoms per day so that I can understand how my cycle affects my body and wellbeing.

**Acceptance criteria:**
- Multi-select symptom options (select all that apply):
  - Physical: cramps, headache, bloating, fatigue, nausea, acne, breast tenderness, back pain, brain fog, insomnia
  - Appetite: increased appetite, decreased appetite, food cravings
  - Libido: low sex drive, normal sex drive, high sex drive
- Mood selector: happy, calm, anxious, irritable, sad, energetic, overwhelmed
- Energy level: 1–5 scale
- Sleep hours input (number field)
- Sleep quality: poor / okay / good
- Notes free text field for anything not covered
- All saved to local SQLite with date stamp

---

### Issue 4 — Local SQLite database
**Labels:** `feature` `data`
**Milestone:** Milestone 1 — Core App (MVP)

As a user, I want all my health data stored locally on my device so that it is private by default and works completely offline.

**Acceptance criteria:**
- SQLite database initialised on first launch using `sqflite`
- Schema includes tables: `cycles`, `flow_logs`, `symptoms`, `moods`, `sleep_logs`, `notes`
- Full CRUD operations for all tables
- Database persists across app restarts
- No data ever leaves the device unless sync is explicitly enabled by the user

---

### Issue 5 — Calendar view
**Labels:** `feature` `ui`
**Milestone:** Milestone 1 — Core App (MVP)

As a user, I want to see my cycle history on a calendar so that I can spot patterns at a glance.

**Acceptance criteria:**
- Monthly calendar view
- Period days highlighted in one colour
- Predicted next period shown in a different colour
- Symptom days marked with a small indicator
- Tap any day to see that day's full log entry
- Swipe left/right to navigate between months

---

## MILESTONE 2: Sync

---

### Issue 6 — WebDAV sync to Disroot/Nextcloud
**Labels:** `feature` `sync`
**Milestone:** Milestone 2 — Sync

As a user, I want my data to sync to my Disroot/Nextcloud account so that it is backed up and accessible from my other devices.

**Acceptance criteria:**
- Settings screen: WebDAV URL, username, password fields
- Default URL pre-filled with Disroot WebDAV format: `https://cloud.disroot.org/remote.php/dav/files/USERNAME/LunaFlow/`
- Manual sync button
- Auto-sync toggle (syncs when on WiFi)
- Sync status indicator (last synced time)
- Graceful offline handling — queues changes and syncs when connection restored
- Uses `webdav_client` Flutter package

---

### Issue 7 — AES-256 encryption layer
**Labels:** `feature` `security` `privacy`
**Milestone:** Milestone 2 — Sync

As a user, I want my data encrypted before it leaves my device so that even if my Disroot account is compromised, my health data cannot be read.

**Acceptance criteria:**
- Encryption key generated on first sync setup
- Key stored in Android Keystore (not plain SharedPreferences)
- All data exported to Nextcloud/Disroot encrypted with AES-256 using the `encrypt` Flutter package
- Decryption works correctly on re-import
- Key backup warning shown to user on setup — instructs them to save key in a password manager
- Data on device (SQLite) remains unencrypted for performance
- Encrypted files stored in `/LunaFlow/data/` on Nextcloud

---

## MILESTONE 3: AI Agent

---

### Issue 8 — Anthropic API health agent (Phase 1)
**Labels:** `feature` `ai`
**Milestone:** Milestone 3 — AI Agent

As a user, I want an AI agent to analyse my cycle and health data so that I can receive personalised nutrition and fitness recommendations during the development phase.

**Acceptance criteria:**
- Settings screen: AI Agent section with endpoint type selector (Anthropic API / Ollama / Custom)
- Phase 1: Anthropic API integration — user enters their own API key
- App sends an anonymised summary of recent cycle data (not raw entries) to the configured endpoint
- AI returns recommendations covering: nutrition, hydration, exercise, rest
- Simple chat interface to ask follow-up health questions
- API key stored securely using Android Keystore, never logged or transmitted elsewhere
- Clear label in UI indicating which AI provider is active

---

### Issue 9 — Ollama self-hosted agent (Phase 2)
**Labels:** `feature` `ai`
**Milestone:** Milestone 3 — AI Agent

As a user, I want to switch my AI agent to a fully self-hosted Ollama instance so that no health data ever touches a third-party server.

**Acceptance criteria:**
- Ollama endpoint option in Settings → AI Agent
- User enters their machine's local or network address: `http://MACHINE_IP:11434`
- Model selector (llama3, mistral, or any model the user has pulled)
- Test connection button with clear success/failure feedback
- Switching from Anthropic to Ollama requires only changing the endpoint in settings — no other changes
- Works on local WiFi and optionally over VPN when away from home

---

### Issue 10 — Health insights dashboard
**Labels:** `feature` `ui` `ai`
**Milestone:** Milestone 3 — AI Agent

As a user, I want to see charts of my health data alongside AI insights so that I can understand patterns in my cycle over time.

**Acceptance criteria:**
- Cycle length chart — last 6 months
- Symptom frequency heatmap — which symptoms appear most and when in cycle
- Average mood by cycle phase (menstrual / follicular / ovulation / luteal)
- Average energy by cycle phase
- Sleep quality trend
- AI insight card: auto-generated weekly summary with nutrition and fitness suggestions
- All charts generated from local data, no external calls required

---

## MILESTONE 4: Polish & Release

---

### Issue 11 — Reminder notifications
**Labels:** `feature`
**Milestone:** Milestone 4 — Polish & Release

As a user, I want reminders so that I don't forget to log daily symptoms and am notified before my predicted period starts.

**Acceptance criteria:**
- Daily logging reminder at a user-configurable time
- Period prediction reminder configurable number of days before predicted start
- All notifications work fully offline
- Easy to enable/disable individually in settings
- Uses local notifications only — no push notification service

---

### Issue 12 — F-Droid submission
**Labels:** `release`
**Milestone:** Milestone 4 — Polish & Release

As a developer, I want to submit LunaFlow to F-Droid so that privacy-conscious users can discover and install it without Google Play.

**Acceptance criteria:**
- Reproducible build confirmed
- Zero proprietary dependencies verified
- Fastlane metadata created at `/fastlane/metadata/android/en-US/`
  - full_description.txt
  - short_description.txt
  - title.txt
  - changelogs/
- App icon and screenshots added to metadata
- F-Droid submission merge request opened on fdroiddata repository
- Build passes F-Droid's automated checker
