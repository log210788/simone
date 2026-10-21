# 🍂 Master Blueprint & Instructions for Future AI Models and Student Folders

This document explains how to replicate the **Peaceful Interactive Transcript & Vocabulary Sanctuary** style (originally created for Marinela's Lesson 01) for any future Preply student folder.

---

## 🚀 Quick-Start: How to Use This for a New Student

### Option A: Copy the Starter Template Folder
1. Copy the [`template/`](./template/) folder contents (`GEMINI.md` and `index_template.html`) into your new student's folder (e.g., `D:\Documents\<StudentName>\`).
2. Place the raw lesson transcript inside `D:\Documents\<StudentName>\Transcript\lesson01.txt`.
3. Ask the AI model:
   > *"Read `GEMINI.md` and `Transcript/lesson01.txt`. Build `index.html` using `index_template.html` as the structural base, sorting out all note-taker spelling mistakes, flagging 45–60 vocabulary words inline with timestamps, and pushing to GitHub Pages."*

### Option B: Copy-Paste Prompt for Any Future AI Model
If starting an empty student folder with only `Transcript/lesson01.txt`, paste this prompt directly to the model:

```text
Please read the raw transcript in Transcript/lesson01.txt and build a single-file interactive GitHub Pages web app (index.html, plus .nojekyll and README.md) modeled after D:\Documents\Marinela B\index.html and D:\Documents\Marinela B\TEMPLATE_INSTRUCTIONS_FOR_AI.md.

Specifically, make sure you include:
1. FULL CLEANED TRANSCRIPT TAB (00:00 to end): Include every speaking turn organized into 5–6 chapters with exact timestamps, search bar, speaker filter, and per-turn audio button.
2. SORT OUT NOTE-TAKER / ASR SPELLING MISTAKES: Forensically fix all automated speech-to-text mishearings (proper nouns, place names, idioms, foreign words) and wrap each correction with the toggleable fixBadge("Actual Phrase", "Raw Note-Taker Error") pill.
3. INLINE VOCABULARY + STICKY SPOTLIGHT + TIPPY TOOLTIPS: Flag 45–60 B2–C2 vocabulary words, phrasal verbs, and idioms right where they appear in the transcript using v("key", "word"). Hovering shows a Tippy.js card; clicking updates a sticky right-hand Vocabulary Spotlight panel with IPA, CEFR level, timestamp, meaning, exact quote, the student's native-language equivalent, and UK/US speech synthesis.
4. VOCABULARY DICTIONARY TAB: Searchable/filterable grid of all flagged words where clicking the timestamp badge (🕒 MM:SS ↗) switches back to the Transcript tab, scrolls to that exact turn, and pulses the line with a golden glow.
5. NOTE-TAKER FIXES & GENTLE PHRASING TAB: Start by celebrating 6 natural expressions the student used well (to build confidence), followed by 6 gentle, encouraging grammar/phrasing polishes and a visual log of all note-taker spelling fixes.
6. CULTURAL PLACES / TOPICS TAB & PEACEFUL PRACTICE TAB: 4 editorial cards on the cultural/visual topics discussed, plus an interactive flashcard deck, a 6-question context quiz with confetti, and 3 reflection prompts for next lesson.
7. CALMING ATMOSPHERE: Include a soft 3-palette theme switcher, an adjustable HTML5 Canvas ambient particle animation (e.g., falling autumn leaves) with a toggle button, and a built-in Web Audio API ambient soundscape generator (breeze/rain/study) in the header.
```

---

## 🏛️ Core Architecture & Stylisation Standards (For AI Models)

When generating `index.html` for a student, follow these 7 design and engineering pillars strictly:

### 1. Tone & Student Psychology (Warm, Reassuring, Non-Intimidating)
- Many language learners feel shy or self-conscious seeing their spoken words in writing.
- **Never** use harsh red "Error / Mistake / Wrong" badges for the student's speech.
- Frame grammar upgrades as **"Gentle Phrasing Polishes"** (*"In the moment"* → *"Natural Polish"*), and always precede them with a **"Your Natural Strengths"** banner celebrating 6 idioms, phrasal verbs, or thoughtful ideas the student expressed well.
- Reserve "Mistake / Fix" labels strictly for the **AI Note-Taker's speech-to-text mishearings** (which students find funny and relieving!).

### 2. Forensic Transcript Cleaning & Note-Taker Fix Badges (`fixBadge`)
Automated note-takers frequently mishear place names, architects/authors, homophones, and non-English words (e.g. hearing *"Ibiza"* as *"a visa"*, *"Bath"* as *"a bar"*, *"bathes Bath"* as *"Babe's bath"*, *"Winchester"* as *"Leicester"*, *"Tadao Ando"* as *"Tano Ando"*, *"boon"* as *"boom"*, or *"like a never-ending"* as *"not a clever ending"*).
- **Rule 1**: Read the entire raw transcript in context before writing code so you spot every ASR hallucination.
- **Rule 2**: Smooth out fragmented backchannel splits (where a listener says *"Yeah"* mid-sentence) while keeping timestamps accurate.
- **Rule 3**: Use `fixBadge(actualSpokenText, rawNoteTakerText)` inline right next to the corrected phrase in the transcript AND list the top 10–15 fixes in Tab 3 (`ASR_FIXES` array).
- **Rule 4**: Provide a header toggle button (`toggleAsrBadges()`) that toggles `body.hide-asr-fixes` so the student can view or hide the fix pills anytime.

### 3. Inline Vocabulary Tagging (`v(key, displayWord)`) & Dual Inspection
Every flagged word (`45–60` items across `B2`, `C1`, `C2`, idioms, and phrasal verbs) lives in the central `VOCAB_DB` dictionary object:
```js
"vantage-point": {
  word: "vantage point",
  ipa: "/ˈvɑːn.tɪdʒ pɔɪnt/",
  pos: "noun",
  level: "C1",
  time: "06:54",
  turnId: "turn-20",
  cat: "architecture", // category key for filtering
  def: "A high or peaceful position that gives you a clear, wide view of everything below.",
  quote: "Louie (06:54): \"...you have a good vantage point where the city still belongs to you.\"",
  l1: "mirador privilegiado / perspectiva" // Student's native language connection
}
```
Inside `TRANSCRIPT_TURNS`, wrap occurrences with `${v("vantage-point", "vantage point")}`. This provides **three** connected ways to learn:
1. **Hovering** in the transcript opens a **Tippy.js** popover (`theme: 'autumn-sanctuary'`) with IPA, level, timestamp, definition, native-language equivalent, and a `🔊 Listen` button.
2. **Clicking** in the transcript updates the sticky right-hand **Vocabulary Spotlight** panel (`inspectVocab(key)`) with the full lesson quote and details.
3. **Clicking the timestamp (`🕒 06:54 ↗`) in Tab 2 (Vocabulary Dictionary)** calls `jumpToTranscriptTurn(turnId, vocabKey)`, which switches to Tab 1, scrolls smoothly to `#turn-20`, updates the Spotlight panel, and triggers a 2.8-second golden highlight pulse (`.turn-highlight-flash`).

### 4. Typography & Restful Colour System
- **Fonts**:
  - Headings & Literary Quotes: `'Cormorant Garamond'` (serif)
  - Transcript Body & UI Controls: `'Plus Jakarta Sans'` (clean, high-legibility sans-serif)
  - Timestamps, CEFR Badges & IPA Phonetics: `'JetBrains Mono'` (monospace)
- **CSS Variables with 3 Peaceful Moods (`data-theme`)**:
  - Default (`kensington` / Bath Stone): Warm parchment cream (`#f9f6f0`), soft sage (`#5b826f`), and autumn leaf amber (`#be6f38`).
  - Secondary (`winchester` / Mist): Soft dove-sage and Cotswold mist (`#f3f6f5`).
  - Evening (`twilight` / Warm Study): Cosy parchment-amber (`#f5efe6`) for low-eye-strain evening study.
- **Speaker Differentiation in Transcript**:
  - Student turns: Warm ivory card (`#fffdf9`) with a 4px left border in autumn amber (`border-l-autumn-500`).
  - Teacher (Louie) turns: Soft sage-tinted card (`#f8faf8`) with a 4px left border in sage green (`border-l-sage-600`).

### 5. Sensory & Calming Plugins (Zero Broken External Media)
- **Web Audio API Soundscape Generator**: Never rely on external `.mp3` URLs that might 404 or get blocked by CORS on GitHub Pages. Use the built-in procedural pink/brown noise + BiquadFilter + LFO wind-swell synthesizer (`toggleSoundscape()`) which creates soothing *Autumn Breeze*, *Soft Rain*, and *Warm Study Hearth* audio natively in any browser.
- **HTML5 Canvas Breeze / Particle Overlay**: Use `#autumn-breeze-canvas` (`pointer-events-none fixed inset-0 z-20`) with `cycleLeafBreeze()` in the top navbar so the student can switch between *Gentle*, *Breeze*, or *Still (Off)*.
- **Web Speech API Pronunciation**: Provide `0.85×` (slow) and `1.0×` (natural) speed buttons in the header, plus speaker buttons on every vocabulary item, phrase polish, flashcard, and transcript turn.

### 6. GitHub Pages Deployment Files
Always include at the repository root:
- `index.html` (self-contained single-file app using CDN links for Tailwind, Lucide, GSAP, Popper/Tippy.js, and Canvas-Confetti)
- `.nojekyll` (prevents GitHub Pages from ignoring files or running Jekyll build steps)
- `README.md` (clean summary of the lesson, tabs, and note-taker fixes)
