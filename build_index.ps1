# PowerShell script to compile clean index.html for Simone's Lesson 01
$ErrorActionPreference = "Stop"

$vocabJson = Get-Content "d:\Documents\Simone\data_vocab.json" -Raw -Encoding UTF8
$transcriptJson = Get-Content "d:\Documents\Simone\data_transcript.json" -Raw -Encoding UTF8
$extrasJson = Get-Content "d:\Documents\Simone\data_extras.json" -Raw -Encoding UTF8

$template = @'
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Simone's Peaceful English Sanctuary | Lesson 01 Transcript &amp; Vocabulary</title>

  <!-- Google Fonts: Cormorant Garamond, Plus Jakarta Sans, JetBrains Mono -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,400;1,600&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            serif: ['"Cormorant Garamond"', 'Georgia', 'serif'],
            sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'],
            mono: ['"JetBrains Mono"', 'monospace'],
          },
          colors: {
            parchment: {
              50: '#fbf9f5',
              100: '#f6f1e7',
              200: '#ede3d1',
              300: '#dfd0b5',
              400: '#cbb38e',
              500: '#b6966b',
            },
            autumn: {
              50: '#fcf6f0',
              100: '#f7e9db',
              200: '#eed0b5',
              300: '#e2b086',
              400: '#d38c57',
              500: '#be6f38',
              600: '#a3582b',
              700: '#854524',
              800: '#6c3921',
            },
            sage: {
              50: '#f4f7f5',
              100: '#e4ece7',
              200: '#cadad1',
              300: '#a5bfb1',
              400: '#7b9f8d',
              500: '#5b826f',
              600: '#476858',
              700: '#3a5448',
              800: '#30443b',
            },
            slatewarm: {
              700: '#3d4441',
              800: '#2b312e',
              900: '#1e2321',
            }
          }
        }
      }
    }
  </script>

  <!-- Lucide Icons -->
  <script src="https://unpkg.com/lucide@latest"></script>

  <!-- GSAP for Gentle Animations -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>

  <!-- Popper & Tippy.js for Interactive Vocabulary Explanations -->
  <script src="https://unpkg.com/@popperjs/core@2"></script>
  <script src="https://unpkg.com/tippy.js@6"></script>
  <link rel="stylesheet" href="https://unpkg.com/tippy.js@6/animations/shift-away.css" />

  <!-- Canvas Confetti for Gentle Practice Encouragement -->
  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js"></script>

  <style>
    :root {
      --bg-base: #f9f6f0;
      --bg-card: rgba(255, 253, 249, 0.90);
      --bg-subcard: rgba(255, 255, 255, 0.94);
      --border-soft: #e6decb;
      --border-accent: #d9c8b0;
      --text-main: #2b312e;
      --text-muted: #5c6660;
      --grad-1: rgba(238, 208, 181, 0.42);
      --grad-2: rgba(202, 218, 209, 0.48);
      --grad-3: rgba(246, 241, 231, 0.70);
    }

    body[data-theme="winchester"] {
      --bg-base: #f3f6f5;
      --bg-card: rgba(252, 254, 253, 0.91);
      --bg-subcard: rgba(255, 255, 255, 0.95);
      --border-soft: #d7e2dc;
      --border-accent: #b8ccc2;
      --text-main: #26312d;
      --text-muted: #52635c;
      --grad-1: rgba(202, 218, 209, 0.50);
      --grad-2: rgba(219, 228, 238, 0.48);
      --grad-3: rgba(244, 240, 230, 0.55);
    }

    body[data-theme="twilight"] {
      --bg-base: #f5efe6;
      --bg-card: rgba(253, 249, 242, 0.92);
      --bg-subcard: rgba(255, 252, 247, 0.96);
      --border-soft: #e2d2be;
      --border-accent: #cfaea0;
      --text-main: #2d2622;
      --text-muted: #665850;
      --grad-1: rgba(226, 176, 134, 0.36);
      --grad-2: rgba(214, 196, 176, 0.42);
      --grad-3: rgba(235, 220, 202, 0.55);
    }

    body {
      background-color: var(--bg-base);
      background-image:
        radial-gradient(at 8% 5%, var(--grad-1) 0px, transparent 52%),
        radial-gradient(at 92% 18%, var(--grad-2) 0px, transparent 52%),
        radial-gradient(at 50% 88%, var(--grad-3) 0px, transparent 58%);
      background-attachment: fixed;
      color: var(--text-main);
      transition: background-color 0.5s ease, color 0.4s ease;
      overflow-x: hidden;
    }

    .sanctuary-card {
      background: var(--bg-card);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid var(--border-soft);
      box-shadow: 0 12px 36px -10px rgba(91, 130, 111, 0.08), 0 4px 14px -3px rgba(43, 49, 46, 0.04);
      transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .sanctuary-subcard {
      background: var(--bg-subcard);
      border: 1px solid var(--border-soft);
      box-shadow: 0 4px 14px -4px rgba(43, 49, 46, 0.04);
      transition: all 0.25s ease;
    }

    /* Inline Vocabulary Highlight in Transcript */
    .vocab-mark {
      display: inline-block;
      background: linear-gradient(120deg, rgba(226, 176, 134, 0.25) 0%, rgba(165, 191, 177, 0.28) 100%);
      border-bottom: 2px dashed #a3582b;
      color: #5b3216;
      font-weight: 600;
      padding: 0px 5px;
      margin: 0 1px;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s ease;
      position: relative;
    }

    .vocab-mark:hover, .vocab-mark.active-vocab {
      background: linear-gradient(120deg, rgba(190, 111, 56, 0.25) 0%, rgba(91, 130, 111, 0.32) 100%);
      border-bottom-style: solid;
      border-bottom-color: #476858;
      transform: translateY(-1px);
      box-shadow: 0 3px 10px rgba(163, 88, 43, 0.14);
    }

    body.hide-vocab-highlights .vocab-mark {
      background: transparent !important;
      border-bottom: none !important;
      color: inherit !important;
      font-weight: inherit !important;
      padding: 0 !important;
      box-shadow: none !important;
    }

    /* Note-taker fix badge */
    .asr-fix-pill {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-size: 0.72rem;
      font-family: 'Plus Jakarta Sans', sans-serif;
      background-color: #f4f7f5;
      color: #476858;
      border: 1px solid #cadad1;
      padding: 1px 7px;
      border-radius: 999px;
      margin-left: 4px;
      vertical-align: middle;
    }

    body.hide-asr-fixes .asr-fix-pill {
      display: none !important;
    }

    /* Custom Tippy Tooltip Theme: Peaceful Autumn */
    .tippy-box[data-theme~='autumn-sanctuary'] {
      background-color: #fffdf9;
      color: #2b312e;
      border: 1px solid #dfd0b5;
      border-radius: 1rem;
      box-shadow: 0 20px 38px -8px rgba(61, 68, 65, 0.16), 0 6px 16px -4px rgba(163, 88, 43, 0.08);
      padding: 0.35rem;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .tippy-box[data-theme~='autumn-sanctuary'][data-placement^='top'] > .tippy-arrow::before {
      border-top-color: #dfd0b5;
    }
    .tippy-box[data-theme~='autumn-sanctuary'][data-placement^='bottom'] > .tippy-arrow::before {
      border-bottom-color: #dfd0b5;
    }

    @keyframes gentleGlow {
      0% { background-color: rgba(226, 176, 134, 0.45); transform: scale(1.005); }
      50% { background-color: rgba(165, 191, 177, 0.38); }
      100% { background-color: transparent; transform: scale(1); }
    }
    .turn-highlight-flash {
      animation: gentleGlow 2.8s ease-out;
    }

    @media print {
      .no-print, #autumn-breeze-canvas { display: none !important; }
      body { background: #fff !important; }
      .sanctuary-card, .sanctuary-subcard { box-shadow: none !important; border: 1px solid #ccc !important; }
    }
  </style>
</head>
<body data-theme="kensington" class="font-sans antialiased min-h-screen selection:bg-autumn-200 selection:text-slatewarm-900 relative">

  <!-- CALMING LONDON AUTUMN BREEZE CANVAS OVERLAY -->
  <canvas id="autumn-breeze-canvas" class="fixed inset-0 pointer-events-none z-20 opacity-80"></canvas>

  <!-- STICKY PEACEFUL NAVIGATION & ATMOSPHERE BAR -->
  <header class="sticky top-0 z-40 border-b border-[#e6decb]/90 bg-[#fbf9f5]/85 backdrop-blur-md no-print">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-2.5 flex flex-wrap items-center justify-between gap-3">
      
      <!-- Brand Identity -->
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-sage-600 via-sage-500 to-autumn-500 flex items-center justify-center text-white font-serif text-xl font-bold shadow-sm">
          S
        </div>
        <div>
          <div class="flex items-center gap-2">
            <span class="font-serif font-bold text-lg sm:text-xl tracking-tight text-slatewarm-900">Simone's English Sanctuary</span>
            <span class="hidden sm:inline-flex items-center gap-1 px-2.5 py-0.5 text-[11px] font-medium rounded-full bg-sage-100 text-sage-800 border border-sage-200">
              <i data-lucide="sparkles" class="w-3 h-3 text-autumn-600"></i>
              Lesson 01 Notes
            </span>
          </div>
          <p class="text-[11px] text-stone-500 hidden md:block">Bologna &amp; Hanoi &bull; Technical Support, Board Games, Lord of the Rings &amp; Family</p>
        </div>
      </div>

      <!-- Calming Atmosphere Controls -->
      <div class="flex flex-wrap items-center gap-2">
        
        <!-- Ambient Sound Player -->
        <div class="flex items-center gap-1.5 bg-white/90 border border-[#dfd0b5] rounded-xl px-2.5 py-1 shadow-sm">
          <button id="soundscape-btn" onclick="toggleSoundscape()" class="flex items-center gap-1.5 text-xs font-semibold text-sage-700 hover:text-sage-900 transition px-1.5 py-0.5 rounded-lg" title="Play soothing ambient soundscape">
            <i data-lucide="wind" id="soundscape-icon" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span id="soundscape-label">Ambient Sound: Off</span>
          </button>
          <select id="soundscape-preset" onchange="changeSoundscapePreset(this.value)" class="text-[11px] bg-parchment-50 border border-parchment-200 rounded-lg px-1.5 py-0.5 text-stone-700 focus:outline-none">
            <option value="breeze">Kensington Breeze</option>
            <option value="rain">Soft London Rain</option>
            <option value="study">Warm Study Hearth</option>
          </select>
          <input id="soundscape-volume" type="range" min="0.05" max="0.6" step="0.05" value="0.22" oninput="updateSoundscapeVolume(this.value)" class="w-14 accent-sage-600 cursor-pointer hidden sm:block" />
        </div>

        <!-- Falling Leaves Toggle -->
        <button id="leaves-toggle-btn" onclick="cycleLeafBreeze()" class="px-2.5 py-1.5 rounded-xl bg-white/90 hover:bg-autumn-50 border border-[#dfd0b5] text-xs font-medium text-stone-700 flex items-center gap-1.5 shadow-sm transition">
          <i data-lucide="leaf" class="w-3.5 h-3.5 text-autumn-600"></i>
          <span id="leaves-label" class="hidden sm:inline">Leaves: Gentle</span>
        </button>

        <!-- UK Voice Speed -->
        <div class="flex items-center gap-1 bg-white/90 border border-[#dfd0b5] rounded-xl px-2 py-1 shadow-sm text-xs">
          <i data-lucide="volume-2" class="w-3.5 h-3.5 text-sage-600"></i>
          <button onclick="setVoiceRate(0.85)" id="rate-slow" class="px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition">0.85&times;</button>
          <button onclick="setVoiceRate(1.0)" id="rate-normal" class="px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition">UK 1&times;</button>
        </div>

        <!-- Theme Mood Selector -->
        <div class="hidden lg:flex items-center gap-1 bg-white/90 border border-[#dfd0b5] rounded-xl p-1 text-[11px] shadow-sm">
          <button onclick="setThemeMood('kensington')" id="theme-kensington" class="px-2 py-0.5 rounded-lg bg-autumn-100 text-autumn-800 font-semibold transition">Bath Stone</button>
          <button onclick="setThemeMood('winchester')" id="theme-winchester" class="px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition">Winchester Mist</button>
          <button onclick="setThemeMood('twilight')" id="theme-twilight" class="px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition">Warm Study</button>
        </div>
      </div>

    </div>
  </header>

  <!-- MAIN CONTAINER -->
  <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-7 space-y-7 relative z-10">

    <!-- HERO BANNER -->
    <section class="sanctuary-card rounded-3xl p-6 sm:p-9 relative overflow-hidden">
      <div class="absolute -right-12 -top-12 w-64 h-64 bg-autumn-200/30 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute -left-12 -bottom-12 w-64 h-64 bg-sage-200/35 rounded-full blur-3xl pointer-events-none"></div>

      <div class="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-7 items-center">
        <div class="lg:col-span-8 space-y-3.5">
          <div class="inline-flex flex-wrap items-center gap-2 px-3 py-1 rounded-full bg-sage-100/90 border border-sage-200 text-sage-800 text-xs font-medium">
            <i data-lucide="sparkles" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span>October 21, 2026 &bull; First Conversation with Louie &bull; Bologna, Hanoi &amp; The Tabletop Sanctuary</span>
          </div>

          <h1 class="font-serif text-3xl sm:text-4xl lg:text-[2.65rem] font-bold text-slatewarm-900 leading-[1.16]">
            Welcome, Simone &mdash; Your <span class="text-autumn-700 italic font-semibold">Autumn Sanctuary</span> for English Reflection
          </h1>

          <p class="text-stone-600 text-sm sm:text-base leading-relaxed max-w-3xl">
            Thank you so much for an engaging, wide-ranging first conversation! Just as promised at the end of class, here is your <strong class="text-slatewarm-800">tidy, forensic transcript</strong> with exact timestamps, <strong class="text-slatewarm-800">51 flagged vocabulary words &amp; idioms</strong>, and all the note-taker's funny spelling mishearings gently sorted out.
          </p>

          <div class="flex flex-wrap items-center gap-2.5 pt-1 text-xs text-stone-700">
            <span class="inline-flex items-center gap-1.5 bg-parchment-100/90 px-3 py-1.5 rounded-xl border border-parchment-300">
              <i data-lucide="mouse-pointer-click" class="w-3.5 h-3.5 text-autumn-600"></i>
              <span><strong>Tip 1:</strong> Hover or click any <span class="vocab-mark text-xs">highlighted word</span> in the transcript for definitions &amp; Italian translations</span>
            </span>
            <span class="inline-flex items-center gap-1.5 bg-sage-50/90 px-3 py-1.5 rounded-xl border border-sage-200">
              <i data-lucide="headphones" class="w-3.5 h-3.5 text-sage-600"></i>
              <span><strong>Tip 2:</strong> Use the ambient player at the top for relaxing study audio while reviewing your notes</span>
            </span>
          </div>
        </div>

        <!-- Lesson Summary Cards -->
        <div class="lg:col-span-4 grid grid-cols-2 gap-3">
          <div onclick="switchTab('transcript')" class="cursor-pointer p-4 rounded-2xl bg-parchment-50/95 border border-parchment-300 hover:border-autumn-400 transition shadow-sm group">
            <div class="flex items-center justify-between text-autumn-700 mb-1">
              <span class="text-[11px] font-mono font-semibold uppercase">50 Mins</span>
              <i data-lucide="scroll-text" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg">Full Transcript</div>
            <p class="text-[11px] text-stone-600 mt-0.5">105 cleaned turns with inline vocab &amp; timestamps</p>
          </div>

          <div onclick="switchTab('vocab')" class="cursor-pointer p-4 rounded-2xl bg-sage-50/95 border border-sage-200 hover:border-sage-400 transition shadow-sm group">
            <div class="flex items-center justify-between text-sage-700 mb-1">
              <span class="text-[11px] font-mono font-semibold uppercase">51 Words</span>
              <i data-lucide="book-open-check" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg">Flagged Lexicon</div>
            <p class="text-[11px] text-stone-600 mt-0.5">B2&ndash;C2 terms, UK audio &amp; Italian links</p>
          </div>

          <div onclick="switchTab('fixes')" class="cursor-pointer p-4 rounded-2xl bg-autumn-50/95 border border-autumn-200 hover:border-autumn-400 transition shadow-sm group">
            <div class="flex items-center justify-between text-autumn-700 mb-1">
              <span class="text-[11px] font-mono font-semibold uppercase">13 Fixes</span>
              <i data-lucide="wand-sparkles" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg">Note-Taker Fixes</div>
            <p class="text-[11px] text-stone-600 mt-0.5">Sorted errors &amp; gentle phrasing polishes</p>
          </div>

          <div onclick="switchTab('places')" class="cursor-pointer p-4 rounded-2xl bg-parchment-50/95 border border-parchment-300 hover:border-sage-400 transition shadow-sm group">
            <div class="flex items-center justify-between text-sage-700 mb-1">
              <span class="text-[11px] font-mono font-semibold uppercase">4 Topics</span>
              <i data-lucide="compass" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg">Culture &amp; Practice</div>
            <p class="text-[11px] text-stone-600 mt-0.5">Bologna, Hanoi, Hobbiton &amp; 7 Wonders</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 5-TAB NAVIGATION BAR -->
    <nav class="sanctuary-card rounded-2xl p-2 flex flex-wrap items-center justify-between gap-2 no-print" aria-label="Lesson Sections">
      <div class="flex flex-wrap items-center gap-1.5 w-full sm:w-auto">
        <button onclick="switchTab('transcript')" id="tab-btn-transcript" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm">
          <i data-lucide="message-square-quote" class="w-4 h-4"></i>
          <span>1. Lesson Transcript &amp; Inline Vocab</span>
          <span class="px-2 py-0.5 text-[10px] rounded-full bg-white/20 text-white font-mono">00:00&ndash;50:50</span>
        </button>

        <button onclick="switchTab('vocab')" id="tab-btn-vocab" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="book-marked" class="w-4 h-4 text-autumn-600"></i>
          <span>2. Vocabulary Dictionary</span>
          <span class="px-2 py-0.5 text-[10px] rounded-full bg-autumn-100 text-autumn-800 font-mono">51 Words</span>
        </button>

        <button onclick="switchTab('fixes')" id="tab-btn-fixes" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="sparkles" class="w-4 h-4 text-sage-600"></i>
          <span>3. Note-Taker Fixes &amp; Gentle Notes</span>
        </button>

        <button onclick="switchTab('places')" id="tab-btn-places" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="landmark" class="w-4 h-4 text-autumn-600"></i>
          <span>4. Cultural Places &amp; Topics</span>
        </button>

        <button onclick="switchTab('practice')" id="tab-btn-practice" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="coffee" class="w-4 h-4 text-sage-600"></i>
          <span>5. Peaceful Practice Sanctuary</span>
        </button>
      </div>
    </nav>

    <!-- =================================================================== -->
    <!-- TAB 1: FULL CONVERSATION TRANSCRIPT WITH INLINE VOCAB & SPOTLIGHT   -->
    <!-- =================================================================== -->
    <section id="tab-panel-transcript" class="tab-panel space-y-6">
      
      <!-- Transcript Controls & Chapter Bar -->
      <div class="sanctuary-card rounded-3xl p-5 sm:p-6 space-y-4">
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b border-[#e6decb] pb-4">
          <div>
            <div class="flex items-center gap-2">
              <span class="text-xs font-mono uppercase tracking-widest text-sage-700 font-semibold">Interactive Conversation Transcript</span>
              <span class="px-2 py-0.5 text-[11px] rounded-full bg-autumn-100 text-autumn-800 font-medium">All Spelling Errors Sorted</span>
            </div>
            <h2 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900 mt-0.5">
              Full Lesson Conversation (00:00 &ndash; 50:50)
            </h2>
            <p class="text-xs sm:text-sm text-stone-600 mt-1">
              Hover over any <span class="vocab-mark">highlighted word</span> to see its meaning, or click it to pin it in the right-hand Spotlight panel.
            </p>
          </div>

          <!-- Search & Display Toggles -->
          <div class="flex flex-wrap items-center gap-2 shrink-0">
            <div class="relative">
              <i data-lucide="search" class="w-4 h-4 text-stone-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
              <input id="transcript-search" type="text" oninput="filterTranscript()" placeholder="Search transcript or time..." class="pl-9 pr-3 py-1.5 rounded-xl bg-white border border-[#dfd0b5] text-xs text-stone-800 focus:outline-none focus:border-sage-600 w-48" />
            </div>

            <select id="speaker-filter" onchange="filterTranscript()" class="px-3 py-1.5 rounded-xl bg-white border border-[#dfd0b5] text-xs font-medium text-stone-700">
              <option value="all">Both Speakers</option>
              <option value="Simone">Simone (Student) Only</option>
              <option value="Louie">Louie (Tutor) Only</option>
            </select>

            <button onclick="toggleVocabHighlights()" id="btn-toggle-highlights" class="px-3 py-1.5 rounded-xl bg-autumn-100 text-autumn-800 border border-autumn-300 text-xs font-semibold flex items-center gap-1.5">
              <i data-lucide="highlighter" class="w-3.5 h-3.5"></i>
              <span>Vocab Highlights: On</span>
            </button>

            <button onclick="toggleAsrBadges()" id="btn-toggle-asr" class="px-3 py-1.5 rounded-xl bg-sage-100 text-sage-800 border border-sage-300 text-xs font-semibold flex items-center gap-1.5">
              <i data-lucide="check-check" class="w-3.5 h-3.5"></i>
              <span>Note-Taker Fixes: Visible</span>
            </button>
          </div>
        </div>

        <!-- Chapters -->
        <div class="flex flex-wrap items-center gap-1.5 pt-1">
          <span class="text-[11px] font-mono uppercase tracking-wider text-stone-500 mr-1">Chapters:</span>
          <button onclick="scrollToChapter('chap-1')" class="px-2.5 py-1 rounded-lg bg-parchment-100 hover:bg-autumn-100 text-stone-700 text-xs font-medium transition border border-parchment-200">
            00:00 &bull; I. Welcome &amp; Technical Support
          </button>
          <button onclick="scrollToChapter('chap-2')" class="px-2.5 py-1 rounded-lg bg-parchment-100 hover:bg-autumn-100 text-stone-700 text-xs font-medium transition border border-parchment-200">
            05:34 &bull; II. Trade-offs, Bottlenecks &amp; Demo
          </button>
          <button onclick="scrollToChapter('chap-3')" class="px-2.5 py-1 rounded-lg bg-parchment-100 hover:bg-autumn-100 text-stone-700 text-xs font-medium transition border border-parchment-200">
            15:10 &bull; III. Word Association &amp; Italian Table
          </button>
          <button onclick="scrollToChapter('chap-4')" class="px-2.5 py-1 rounded-lg bg-parchment-100 hover:bg-autumn-100 text-stone-700 text-xs font-medium transition border border-parchment-200">
            20:38 &bull; IV. Bologna, Twins &amp; Family Ties
          </button>
          <button onclick="scrollToChapter('chap-5')" class="px-2.5 py-1 rounded-lg bg-parchment-100 hover:bg-autumn-100 text-stone-700 text-xs font-medium transition border border-parchment-200">
            26:14 &bull; V. Board Games, 7 Wonders &amp; Gaming
          </button>
          <button onclick="scrollToChapter('chap-6')" class="px-2.5 py-1 rounded-lg bg-parchment-100 hover:bg-autumn-100 text-stone-700 text-xs font-medium transition border border-parchment-200">
            41:40 &bull; VI. New Zealand, Tolkien &amp; Looking Ahead
          </button>
        </div>
      </div>

      <!-- Transcript Columns: Stream on Left, Sticky Spotlight on Right -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        
        <!-- Conversation Turns Container -->
        <div class="lg:col-span-8 space-y-4" id="transcript-stream-container">
          <!-- Rendered dynamically by JS -->
        </div>

        <!-- Sticky Right-Hand Vocabulary Spotlight Inspector -->
        <aside class="lg:col-span-4 lg:sticky lg:top-20 space-y-4">
          <div class="sanctuary-card rounded-3xl p-5 sm:p-6 border-t-4 border-t-autumn-500 space-y-4" id="vocab-inspector-card">
            <div class="flex items-center justify-between gap-2">
              <span class="text-[11px] font-mono uppercase tracking-widest text-autumn-700 font-semibold flex items-center gap-1.5">
                <i data-lucide="sparkle" class="w-3.5 h-3.5"></i>
                Vocabulary Spotlight
              </span>
              <span id="insp-time" class="px-2.5 py-0.5 rounded-full bg-parchment-100 border border-parchment-300 font-mono text-xs text-stone-700 inline-flex items-center gap-1">
                <i data-lucide="clock" class="w-3 h-3 text-stone-500"></i>
                <span>05:52</span>
              </span>
            </div>

            <div>
              <div class="flex items-center justify-between gap-2">
                <h3 id="insp-word" class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900">trade-off</h3>
                <button id="insp-audio-btn" onclick="speakWord('trade-off')" class="p-2.5 rounded-xl bg-sage-100 hover:bg-sage-200 text-sage-800 transition shrink-0" title="Listen in British English">
                  <i data-lucide="volume-2" class="w-4 h-4"></i>
                </button>
              </div>
              <div class="flex flex-wrap items-center gap-2 mt-1">
                <span id="insp-ipa" class="text-xs font-mono text-stone-500">/'trayd-awf/</span>
                <span id="insp-pos" class="px-2 py-0.5 text-[11px] rounded-md bg-parchment-100 text-stone-700 font-medium">noun</span>
                <span id="insp-level" class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800 font-mono font-semibold">B2 Business</span>
              </div>
            </div>

            <div class="p-3.5 rounded-2xl bg-parchment-50 border border-parchment-200 space-y-1.5">
              <div class="text-[11px] font-mono uppercase tracking-wider text-stone-500">Meaning &amp; Nuance</div>
              <p id="insp-def" class="text-xs sm:text-sm text-slatewarm-800 leading-relaxed">
                A situational decision where one acceptable benefit is given up in return for gaining a different desirable quality.
              </p>
            </div>

            <div class="p-3.5 rounded-2xl bg-sage-50/80 border border-sage-200 space-y-1.5">
              <div class="text-[11px] font-mono uppercase tracking-wider text-sage-700">How It Was Used in Our Lesson</div>
              <p id="insp-quote" class="text-xs italic text-stone-700 leading-relaxed">
                Simone: "It's a sort of balance between two or more things." / Louie: "You balance one benefit against another."
              </p>
            </div>

            <div class="flex items-center justify-between pt-1 text-xs border-t border-[#e6decb]">
              <span class="text-stone-500">Italian Equivalent:</span>
              <span id="insp-it" class="font-semibold text-sage-800">compromesso / bilanciamento</span>
            </div>
          </div>

          <!-- Thoughtful Teacher Note -->
          <div class="sanctuary-card rounded-3xl p-5 space-y-3">
            <div class="flex items-center gap-2 text-sage-800 font-serif font-bold text-lg">
              <i data-lucide="heart-handshake" class="w-5 h-5 text-autumn-600"></i>
              <span>Teacher's Note for Simone</span>
            </div>
            <p class="text-xs text-stone-600 leading-relaxed">
              Simone, you have a natural gift for structural thinking and precise definitions. You defined "trade-off" and "bottleneck" with immediate clarity.
            </p>
            <p class="text-xs text-stone-600 leading-relaxed">
              Whenever you feel "locked" or "tongue-tied", take a relaxed breath&mdash;you already possess the grammatical foundation to speak comfortably.
            </p>
          </div>
        </aside>

      </div>
    </section>

    <!-- =================================================================== -->
    <!-- TAB 2: VOCABULARY DICTIONARY                                        -->
    <!-- =================================================================== -->
    <section id="tab-panel-vocab" class="tab-panel hidden space-y-6">
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b border-[#e6decb] pb-5">
          <div>
            <span class="text-xs font-mono uppercase tracking-widest text-autumn-700 font-semibold">Timestamped Lexicon &bull; 51 Flagged Items</span>
            <h2 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900 mt-1">
              Curated Vocabulary, Idioms &amp; Engineering Terminology
            </h2>
            <p class="text-xs sm:text-sm text-stone-600 mt-1">
              Click the timestamp badge on any card to jump directly to where it was spoken in our transcript!
            </p>
          </div>

          <div class="flex flex-wrap items-center gap-2">
            <input id="vocab-search" type="text" oninput="renderVocabGrid()" placeholder="Search word, meaning, Italian..." class="px-3 py-2 rounded-xl bg-white border border-[#dfd0b5] text-xs text-stone-800 w-52" />
            <select id="vocab-level-filter" onchange="renderVocabGrid()" class="px-3 py-2 rounded-xl bg-white border border-[#dfd0b5] text-xs font-medium text-stone-700">
              <option value="all">All Levels (B2&ndash;C2)</option>
              <option value="C2">C2 Mastery</option>
              <option value="C1">C1 Advanced</option>
              <option value="B2">B2 Upper-Intermediate</option>
            </select>
          </div>
        </div>

        <div id="vocab-cards-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 pt-2">
          <!-- Populated by JS -->
        </div>
      </div>
    </section>

    <!-- =================================================================== -->
    <!-- TAB 3: NOTE-TAKER FIXES & GENTLE PHRASING NOTES                     -->
    <!-- =================================================================== -->
    <section id="tab-panel-fixes" class="tab-panel hidden space-y-6">
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-6">
        <div class="border-b border-[#e6decb] pb-4">
          <span class="text-xs font-mono uppercase tracking-widest text-sage-700 font-semibold">Supportive Language Feedback</span>
          <h2 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900 mt-1">
            Strengths First: Celebrating What You Said Brilliantly
          </h2>
          <p class="text-xs sm:text-sm text-stone-600 mt-1">
            We never use red pens. Here are 6 moments where your natural instinct for English shone brightly, followed by 6 gentle phrasing polishes.
          </p>
        </div>

        <!-- 6 Natural Strengths -->
        <div class="p-5 rounded-2xl bg-sage-50/90 border border-sage-200 space-y-3">
          <div class="flex items-center gap-2 text-sage-800 font-serif font-bold text-xl">
            <i data-lucide="award" class="w-5 h-5 text-autumn-600"></i>
            <span>Your Natural Strengths Observed Today</span>
          </div>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3 text-xs" id="strengths-container">
            <!-- Populated by JS -->
          </div>
        </div>

        <!-- Gentle Polishes -->
        <div class="space-y-4 pt-2">
          <h3 class="font-serif text-2xl font-bold text-slatewarm-900">Gentle Phrasing Polishes</h3>
          <p class="text-xs text-stone-600">Natural upgrades designed to make your English feel effortless and idiomatic.</p>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4" id="gentle-polishes-grid">
            <!-- Populated by JS -->
          </div>
        </div>
      </div>

      <!-- Note-Taker Fixes Log -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="border-b border-[#e6decb] pb-4">
          <span class="text-xs font-mono uppercase tracking-widest text-autumn-700 font-semibold">Transcript Forensic Clean-Up</span>
          <h2 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900 mt-1">
            How Louie Sorted Out Automated Speech-to-Text Mishearings
          </h2>
          <p class="text-xs sm:text-sm text-stone-600 mt-1">
            Automated speech recognition frequently mishears proper nouns, game titles, and cultural terms. Here is the complete clean-up log:
          </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4" id="asr-fixes-grid">
          <!-- Populated by JS -->
        </div>
      </div>
    </section>

    <!-- =================================================================== -->
    <!-- TAB 4: CULTURAL PLACES & TOPICS                                     -->
    <!-- =================================================================== -->
    <section id="tab-panel-places" class="tab-panel hidden space-y-6">
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-6">
        <div class="border-b border-[#e6decb] pb-4">
          <span class="text-xs font-mono uppercase tracking-widest text-autumn-700 font-semibold">Cultural Deep-Dives</span>
          <h2 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900 mt-1">
            Cultural Places &amp; Topics Explored in Today's Lesson
          </h2>
          <p class="text-xs sm:text-sm text-stone-600 mt-1">
            Every lesson connects practical language with travel, architecture, storytelling, and tabletop culture.
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          
          <!-- Card 1: Bologna -->
          <div class="sanctuary-subcard rounded-2xl p-6 space-y-3 border-l-4 border-l-autumn-500">
            <span class="text-xs font-mono text-autumn-700 font-semibold">00:00 &amp; 20:44 &bull; Emilia-Romagna</span>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">1. Bologna &amp; The Porticoes of Knowledge</h3>
            <p class="text-xs sm:text-sm text-stone-600 leading-relaxed">
              Home to the world's oldest university in continuous operation (founded in 1088), Bologna is famous for its 38 kilometers of medieval covered porticoes, vibrant piazzas, and warm culinary gatherings. Its rich student culture also fosters one of Italy's most passionate tabletop and board game communities.
            </p>
            <div class="flex flex-wrap gap-1.5 pt-1">
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">whereabouts</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">first-course</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">spare-time</span>
            </div>
          </div>

          <!-- Card 2: Hanoi -->
          <div class="sanctuary-subcard rounded-2xl p-6 space-y-3 border-l-4 border-l-sage-600">
            <span class="text-xs font-mono text-sage-700 font-semibold">21:20 &amp; 40:35 &bull; Vietnam</span>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">2. Hanoi: Life on Two Wheels &amp; Street Dining</h3>
            <p class="text-xs sm:text-sm text-stone-600 leading-relaxed">
              Louie's journey from historical architectural restoration in England to university in Hanoi. Unlike Western car culture where people are separated by windshields, life in Vietnam unfolds on motorbikes and low stools along the pavement&mdash;where whole families eat together outdoors and greet each other like one large family.
            </p>
            <div class="flex flex-wrap gap-1.5 pt-1">
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">restoration</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">abroad</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">free-form</span>
            </div>
          </div>

          <!-- Card 3: Hobbiton -->
          <div class="sanctuary-subcard rounded-2xl p-6 space-y-3 border-l-4 border-l-autumn-600">
            <span class="text-xs font-mono text-autumn-700 font-semibold">45:10 &ndash; 47:15 &bull; New Zealand</span>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">3. Hobbiton &amp; The Green Hills of Matamata</h3>
            <p class="text-xs sm:text-sm text-stone-600 leading-relaxed">
              Simone and his wife's unforgettable honeymoon road trip from Auckland to Wellington. Walking across the Alexander sheep farm, preserved as the permanent Hobbiton movie set. Simone noted the uncanny feeling of standing in a place you know is pure fantasy from books and cinema, yet feeling the morning breeze on your face.
            </p>
            <div class="flex flex-wrap gap-1.5 pt-1">
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">honeymoon</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">itinerary</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">scenery</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-sage-100 text-sage-800">fantasy</span>
            </div>
          </div>

          <!-- Card 4: Tabletop Renaissance -->
          <div class="sanctuary-subcard rounded-2xl p-6 space-y-3 border-l-4 border-l-sage-500">
            <span class="text-xs font-mono text-sage-700 font-semibold">26:30 &ndash; 39:45 &bull; Tabletop Strategy</span>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">4. The Tabletop Renaissance: 7 Wonders &amp; Beyond</h3>
            <p class="text-xs sm:text-sm text-stone-600 leading-relaxed">
              From Antoine Bauza's simultaneous card drafting across three ancient eras in <em>7 Wonders</em> to the psychological deduction of <em>Lupus in Tabula</em> and nightly global games of <em>Risk</em>. Modern board games offer a rich landscape of shared storytelling, tactical trade-offs, and genuine face-to-face connection.
            </p>
            <div class="flex flex-wrap gap-1.5 pt-1">
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">mechanics</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">card-drafting</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">victory-points</span>
              <span class="px-2 py-0.5 text-[11px] rounded-md bg-autumn-100 text-autumn-800">combo</span>
            </div>
          </div>

        </div>
      </div>
    </section>

    <!-- =================================================================== -->
    <!-- TAB 5: PEACEFUL PRACTICE SANCTUARY                                  -->
    <!-- =================================================================== -->
    <section id="tab-panel-practice" class="tab-panel hidden space-y-6">
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        <!-- Left: Interactive Flashcards -->
        <div class="lg:col-span-6 sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5 flex flex-col justify-between">
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <span class="text-xs font-mono uppercase tracking-widest text-sage-700 font-semibold">Active Recall</span>
              <span id="fc-counter" class="text-xs font-mono text-stone-500">Card 1 of 12</span>
            </div>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">Interactive Vocabulary Cards</h3>
            <p class="text-xs text-stone-600">Click the card to reveal the definition, Italian equivalent, and quote from our lesson.</p>
          </div>

          <div onclick="flipFlashcard()" class="cursor-pointer sanctuary-subcard rounded-2xl p-7 min-h-[240px] flex flex-col items-center justify-center text-center space-y-3 border-2 border-[#dfd0b5] hover:border-autumn-400 transition select-none">
            <span id="fc-badge" class="px-2.5 py-0.5 rounded-full bg-autumn-100 text-autumn-800 text-[11px] font-mono">05:52 &bull; B2 Business</span>
            <h4 id="fc-front-title" class="font-serif text-3xl font-bold text-slatewarm-900">trade-off</h4>
            <p id="fc-sub" class="text-xs sm:text-sm text-stone-600 max-w-md leading-relaxed">
              Click anywhere on this card to reveal the meaning &amp; lesson context
            </p>
            <div id="fc-back-details" class="hidden space-y-2 pt-2 border-t border-parchment-200 w-full">
              <p id="fc-quote" class="text-xs italic text-sage-800"></p>
              <p id="fc-it" class="text-xs font-semibold text-autumn-700"></p>
            </div>
          </div>

          <div class="flex items-center justify-between gap-2 pt-2">
            <button onclick="prevFlashcard()" class="px-4 py-2 rounded-xl bg-parchment-100 hover:bg-parchment-200 text-xs font-semibold text-stone-700 flex items-center gap-1.5 transition">
              <i data-lucide="arrow-left" class="w-4 h-4"></i> Previous
            </button>
            <button onclick="speakCurrentFlashcard()" class="px-4 py-2 rounded-xl bg-sage-100 hover:bg-sage-200 text-xs font-semibold text-sage-800 flex items-center gap-1.5 transition">
              <i data-lucide="volume-2" class="w-4 h-4"></i> Listen (UK)
            </button>
            <button onclick="nextFlashcard()" class="px-4 py-2 rounded-xl bg-sage-700 hover:bg-sage-800 text-xs font-semibold text-white flex items-center gap-1.5 transition">
              Next <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>
          </div>
        </div>

        <!-- Right: Context Quiz -->
        <div class="lg:col-span-6 sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
          <div class="flex items-center justify-between">
            <div>
              <span class="text-xs font-mono uppercase tracking-widest text-autumn-700 font-semibold">No-Pressure Practice</span>
              <h3 class="font-serif text-2xl font-bold text-slatewarm-900 mt-0.5">Match the Word to Conversation</h3>
            </div>
            <span id="quiz-score-badge" class="px-3 py-1 rounded-full bg-sage-100 text-sage-800 text-xs font-mono font-semibold">0 / 6 Completed</span>
          </div>

          <div id="quiz-container" class="space-y-4 max-h-[420px] overflow-y-auto pr-1">
            <!-- Populated by JS -->
          </div>
        </div>

      </div>

      <!-- Reflection Prompts for Next Lesson -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4 border-2 border-sage-300">
        <div class="flex items-center gap-2 text-sage-800 font-serif font-bold text-xl">
          <i data-lucide="compass" class="w-5 h-5 text-autumn-600"></i>
          <span>Reflection Prompts for Next Lesson with Louie</span>
        </div>
        <p class="text-xs sm:text-sm text-stone-600">
          Take a quiet moment over the week to think about these three prompts. There are no right or wrong answers&mdash;only ideas to fuel our next chat!
        </p>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-1" id="prompts-container">
          <!-- Populated by JS -->
        </div>
      </div>
    </section>

  </main>

  <footer class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 text-center text-xs text-stone-500 border-t border-[#e6decb]/80 mt-8 no-print">
    <p class="font-serif italic text-base text-slatewarm-800 mb-1">"Speak freely, reflect quietly, and let the language become second nature."</p>
    <p>Personal lesson companion prepared for Simone by Louie &bull; Bologna &amp; Hanoi Autumn 2026</p>
  </footer>

  <script>
    // -------------------------------------------------------------------------
    // 1. EMBEDDED DATA FOR SIMONE'S LESSON 01
    // -------------------------------------------------------------------------
    const VOCAB_DB = /*__VOCAB_JSON__*/;
    const TRANSCRIPT_TURNS = /*__TRANSCRIPT_JSON__*/;
    const EXTRAS = /*__EXTRAS_JSON__*/;

    const POLISHES = EXTRAS.polishes;
    const ASR_FIXES = EXTRAS.asrFixes;
    const FLASHCARD_KEYS = EXTRAS.flashcardKeys;
    const QUIZ = EXTRAS.quiz;
    const STRENGTHS = EXTRAS.naturalStrengths;
    const PROMPTS = EXTRAS.reflectionPrompts;

    let currentCardIndex = 0;
    let isCardFlipped = false;
    let quizAnswered = new Set();

    // -------------------------------------------------------------------------
    // 2. HELPER FUNCTIONS FOR INLINE RENDERING
    // -------------------------------------------------------------------------
    function v(key, displayWord) {
      const item = VOCAB_DB[key];
      const label = displayWord || (item ? item.word : key);
      return `<span class="vocab-mark" data-vkey="${key}" onclick="inspectVocab('${key}')">${label}</span>`;
    }

    function fixBadge(corrected, rawMistake) {
      return `<span class="asr-fix-pill" title="Note-taker wrote '${rawMistake}'"><i data-lucide="check-check" class="w-3 h-3 text-sage-600 inline"></i> Fixed: &ldquo;${corrected}&rdquo; <span class="text-stone-400">(note-taker wrote: &ldquo;${rawMistake}&rdquo;)</span></span>`;
    }

    // -------------------------------------------------------------------------
    // 3. TRANSCRIPT RENDERING & CHAPTERS
    // -------------------------------------------------------------------------
    function renderTranscript() {
      const container = document.getElementById('transcript-stream-container');
      const searchVal = (document.getElementById('transcript-search')?.value || '').toLowerCase().trim();
      const speakerFilter = document.getElementById('speaker-filter')?.value || 'all';

      let html = '';
      TRANSCRIPT_TURNS.forEach(turn => {
        if (turn.chapterTitle && speakerFilter === 'all' && !searchVal) {
          html += `
            <div id="${turn.chapterId}" class="pt-4 pb-1">
              <div class="px-4 py-2.5 rounded-2xl bg-gradient-to-r from-sage-100/90 via-parchment-100 to-autumn-50 border border-sage-200 flex items-center gap-2 text-xs sm:text-sm font-serif font-bold text-sage-800 shadow-sm">
                <i data-lucide="bookmark" class="w-4 h-4 text-autumn-600 shrink-0"></i>
                <span>${turn.chapterTitle}</span>
              </div>
            </div>
          `;
        }

        if (speakerFilter !== 'all' && turn.speaker !== speakerFilter) return;
        const plainText = turn.text.replace(/<[^>]+>/g, '').toLowerCase();
        if (searchVal && !plainText.includes(searchVal) && !turn.time.includes(searchVal)) return;

        const isSimone = turn.speaker === 'Simone';
        const cardStyle = isSimone
          ? 'bg-[#fffdf9] border-l-4 border-l-autumn-500 border border-[#e6decb]'
          : 'bg-[#f8faf8] border-l-4 border-l-sage-600 border border-[#d8e4dc]';
        const badgeStyle = isSimone
          ? 'bg-autumn-100 text-autumn-800 border-autumn-200'
          : 'bg-sage-100 text-sage-800 border-sage-200';
        const speakerIcon = isSimone ? 'user' : 'graduation-cap';
        const speakerLabel = isSimone ? 'Simone (Student)' : 'Louie (Tutor)';
        const iconColor = isSimone ? 'text-autumn-600' : 'text-sage-600';

        html += `
          <article id="${turn.id}" class="rounded-2xl p-4 sm:p-5 ${cardStyle} shadow-sm transition-all duration-300 space-y-2">
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-2">
                <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-semibold border ${badgeStyle}">
                  <i data-lucide="${speakerIcon}" class="w-3.5 h-3.5 ${iconColor}"></i>
                  <span>${speakerLabel}</span>
                </span>
                <span class="font-mono text-xs text-stone-500 flex items-center gap-1">
                  <i data-lucide="clock" class="w-3 h-3"></i>
                  <span>${turn.time}</span>
                </span>
              </div>
              <button onclick="speakPlainTurn('${turn.id}')" class="text-stone-400 hover:text-sage-700 transition p-1 rounded-lg" title="Listen in British English">
                <i data-lucide="volume-2" class="w-3.5 h-3.5"></i>
              </button>
            </div>
            <div class="text-sm sm:text-[15px] text-slatewarm-800 leading-relaxed font-sans">
              ${turn.text}
            </div>
          </article>
        `;
      });

      container.innerHTML = html;
      lucide.createIcons();
      initVocabTooltips();
    }

    function initVocabTooltips() {
      document.querySelectorAll('.vocab-mark').forEach(el => {
        const key = el.getAttribute('data-vkey');
        const item = VOCAB_DB[key];
        if (!item) return;

        if (el._tippy) el._tippy.destroy();

        tippy(el, {
          theme: 'autumn-sanctuary',
          allowHTML: true,
          interactive: true,
          animation: 'shift-away',
          maxWidth: 320,
          content: `
            <div class="p-2.5 space-y-2 text-left">
              <div class="flex items-center justify-between gap-2 border-b border-parchment-200 pb-1.5">
                <div>
                  <span class="font-serif font-bold text-base text-slatewarm-900">${item.word}</span>
                  <span class="block font-mono text-[10px] text-stone-500">${item.ipa} &bull; ${item.pos}</span>
                </div>
                <div class="flex items-center gap-1">
                  <span class="px-1.5 py-0.5 rounded bg-autumn-100 text-autumn-800 font-mono text-[10px] font-bold">${item.level}</span>
                  <span class="px-1.5 py-0.5 rounded bg-sage-100 text-sage-800 font-mono text-[10px] inline-flex items-center gap-1"><i data-lucide="clock" class="w-2.5 h-2.5"></i>${item.time}</span>
                </div>
              </div>
              <p class="text-xs text-stone-700 leading-snug">${item.def}</p>
              <div class="flex items-center justify-between pt-1 text-[11px] border-t border-parchment-200">
                <span class="text-sage-800 font-semibold">${item.it}</span>
                <button onclick="speakWord('${item.word.replace(/'/g, "\\'")}')" class="px-2 py-0.5 rounded bg-sage-700 text-white text-[10px] font-semibold inline-flex items-center gap-1"><i data-lucide="volume-2" class="w-2.5 h-2.5"></i> Listen UK</button>
              </div>
            </div>
          `
        });
      });
      lucide.createIcons();
    }

    function inspectVocab(key) {
      const item = VOCAB_DB[key];
      if (!item) return;

      document.querySelectorAll('.vocab-mark').forEach(el => {
        el.classList.toggle('active-vocab', el.getAttribute('data-vkey') === key);
      });

      document.getElementById('insp-time').innerHTML = `<i data-lucide="clock" class="w-3 h-3 text-stone-500 inline mr-1"></i><span>${item.time}</span>`;
      document.getElementById('insp-word').textContent = item.word;
      document.getElementById('insp-ipa').textContent = item.ipa;
      document.getElementById('insp-pos').textContent = item.pos;
      document.getElementById('insp-level').textContent = `${item.level} ${item.cat}`;
      document.getElementById('insp-def').textContent = item.def;
      document.getElementById('insp-quote').textContent = item.quote;
      document.getElementById('insp-it').textContent = item.it;
      document.getElementById('insp-audio-btn').setAttribute('onclick', `speakWord('${item.word.replace(/\s*\(.*?\)/g, '').replace(/'/g, "\\'")}')`);
      lucide.createIcons();
    }

    function renderVocabGrid() {
      const grid = document.getElementById('vocab-cards-grid');
      const search = (document.getElementById('vocab-search')?.value || '').toLowerCase().trim();
      const levelFilter = document.getElementById('vocab-level-filter')?.value || 'all';

      const entries = Object.entries(VOCAB_DB).filter(([key, item]) => {
        if (levelFilter !== 'all' && item.level !== levelFilter) return false;
        if (search) {
          const hay = `${item.word} ${item.def} ${item.it} ${item.time} ${item.cat}`.toLowerCase();
          if (!hay.includes(search)) return false;
        }
        return true;
      });

      grid.innerHTML = entries.map(([key, item]) => `
        <div class="sanctuary-subcard rounded-2xl p-5 flex flex-col justify-between space-y-3 hover:border-autumn-400">
          <div class="space-y-2">
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-1.5">
                <span class="px-2 py-0.5 rounded-md bg-autumn-100 text-autumn-800 font-mono text-[11px] font-bold">${item.level}</span>
                <span class="px-2 py-0.5 rounded-md bg-parchment-100 text-stone-600 text-[11px]">${item.pos}</span>
              </div>
              <button onclick="jumpToTranscriptTurn('${item.turnId}', '${key}')" class="px-2.5 py-0.5 rounded-full bg-sage-100 hover:bg-sage-200 text-sage-800 font-mono text-[11px] font-semibold flex items-center gap-1 transition">
                <i data-lucide="clock" class="w-3 h-3"></i>
                <span>${item.time}</span>
                <i data-lucide="arrow-up-right" class="w-3 h-3"></i>
              </button>
            </div>

            <div class="flex items-center justify-between gap-2 pt-1">
              <div>
                <h3 class="font-serif text-xl font-bold text-slatewarm-900">${item.word}</h3>
                <span class="text-xs font-mono text-stone-500">${item.ipa}</span>
              </div>
              <button onclick="speakWord('${item.word.replace(/\s*\(.*?\)/g, '').replace(/'/g, "\\'")}')" class="p-2 rounded-xl bg-parchment-100 hover:bg-sage-100 text-sage-800 transition">
                <i data-lucide="volume-2" class="w-4 h-4"></i>
              </button>
            </div>

            <p class="text-xs sm:text-sm text-stone-700 leading-relaxed">${item.def}</p>
            <p class="text-xs italic text-stone-500 bg-parchment-50 p-2.5 rounded-xl border border-parchment-200">${item.quote}</p>
          </div>

          <div class="pt-2 border-t border-parchment-200 flex items-center justify-between text-xs">
            <span class="text-sage-800 font-medium">${item.it}</span>
            <button onclick="jumpToTranscriptTurn('${item.turnId}', '${key}')" class="text-autumn-700 hover:underline font-semibold text-[11px] inline-flex items-center gap-1">
              <span>See in Transcript</span>
              <i data-lucide="arrow-right" class="w-3 h-3"></i>
            </button>
          </div>
        </div>
      `).join('');
      lucide.createIcons();
    }

    function jumpToTranscriptTurn(turnId, vocabKey) {
      switchTab('transcript');
      setTimeout(() => {
        if (vocabKey) inspectVocab(vocabKey);
        const el = document.getElementById(turnId);
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'center' });
          el.classList.remove('turn-highlight-flash');
          void el.offsetWidth;
          el.classList.add('turn-highlight-flash');
        }
      }, 100);
    }

    // -------------------------------------------------------------------------
    // 4. FIXES, STRENGTHS & POLISHES
    // -------------------------------------------------------------------------
    function renderFixes() {
      // Natural Strengths
      document.getElementById('strengths-container').innerHTML = STRENGTHS.map(s => `
        <div class="p-3.5 rounded-xl bg-white/90 border border-sage-200 space-y-1">
          <span class="font-mono text-[11px] text-sage-700 font-semibold inline-flex items-center gap-1"><i data-lucide="clock" class="w-2.5 h-2.5"></i>${s.time}</span>
          <div class="font-bold text-slatewarm-900 text-xs">${s.phrase}</div>
          <p class="text-stone-600 text-[11px] leading-relaxed">${s.note}</p>
        </div>
      `).join('');

      // Gentle Polishes
      document.getElementById('gentle-polishes-grid').innerHTML = POLISHES.map(p => `
        <div class="sanctuary-subcard rounded-2xl p-5 space-y-2.5 border-l-4 border-l-sage-500">
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold text-sage-800">${p.topic}</span>
            <span class="px-2 py-0.5 rounded-full bg-parchment-100 font-mono text-[11px] text-stone-600 inline-flex items-center gap-1"><i data-lucide="clock" class="w-3 h-3"></i><span>${p.time}</span></span>
          </div>
          <div class="p-2.5 rounded-xl bg-autumn-50/70 border border-autumn-200/80 text-xs text-stone-600">
            <span class="font-semibold text-autumn-800">In the moment:</span> "${p.said}"
          </div>
          <div class="p-2.5 rounded-xl bg-sage-50 border border-sage-200 text-xs text-slatewarm-900 flex items-center justify-between gap-2">
            <div><span class="font-semibold text-sage-800">Natural Polish:</span> <strong>"${p.natural}"</strong></div>
            <button onclick="speakWord('${p.natural.replace(/'/g, "\\'")}')" class="p-1.5 rounded-lg bg-white text-sage-700 hover:bg-sage-100 shrink-0">
              <i data-lucide="volume-2" class="w-3.5 h-3.5"></i>
            </button>
          </div>
          <p class="text-xs text-stone-600 leading-relaxed">${p.why}</p>
        </div>
      `).join('');

      // ASR Fixes
      document.getElementById('asr-fixes-grid').innerHTML = ASR_FIXES.map(f => `
        <div class="sanctuary-subcard rounded-2xl p-4 space-y-2 border-t-2 border-t-autumn-400">
          <div class="flex items-center justify-between text-[11px] font-mono text-stone-500">
            <span class="font-semibold text-slatewarm-800">${f.speaker}</span>
            <span class="inline-flex items-center gap-1"><i data-lucide="clock" class="w-3 h-3"></i><span>${f.time}</span></span>
          </div>
          <div class="text-xs line-through text-stone-400">Note-taker wrote: "${f.wrong}"</div>
          <div class="text-sm font-serif font-bold text-sage-800">Actually said: "${f.right}"</div>
          <p class="text-xs text-stone-600 leading-relaxed">${f.note}</p>
        </div>
      `).join('');

      // Reflection Prompts
      document.getElementById('prompts-container').innerHTML = PROMPTS.map(pr => `
        <div class="sanctuary-subcard rounded-2xl p-4 space-y-2 border-l-4 border-l-sage-500">
          <h4 class="font-serif font-bold text-base text-slatewarm-900">${pr.title}</h4>
          <p class="text-xs text-stone-600 leading-relaxed">${pr.prompt}</p>
        </div>
      `).join('');

      lucide.createIcons();
    }

    // -------------------------------------------------------------------------
    // 5. FLASHCARDS & QUIZ
    // -------------------------------------------------------------------------
    function renderFlashcard() {
      const key = FLASHCARD_KEYS[currentCardIndex];
      const item = VOCAB_DB[key];
      if (!item) return;

      document.getElementById('fc-counter').textContent = `Card ${currentCardIndex + 1} of ${FLASHCARD_KEYS.length}`;
      document.getElementById('fc-badge').textContent = `${item.time} \u2022 ${item.pos} (${item.level})`;

      const titleEl = document.getElementById('fc-front-title');
      const subEl = document.getElementById('fc-sub');
      const backEl = document.getElementById('fc-back-details');

      if (!isCardFlipped) {
        titleEl.textContent = item.word;
        subEl.textContent = `${item.ipa} \u2014 Click card to reveal meaning & lesson context`;
        backEl.classList.add('hidden');
      } else {
        titleEl.textContent = item.word;
        subEl.textContent = item.def;
        document.getElementById('fc-quote').textContent = item.quote;
        document.getElementById('fc-it').textContent = `Connessione in italiano: ${item.it}`;
        backEl.classList.remove('hidden');
      }
    }

    function flipFlashcard() { isCardFlipped = !isCardFlipped; renderFlashcard(); }
    function nextFlashcard() { isCardFlipped = false; currentCardIndex = (currentCardIndex + 1) % FLASHCARD_KEYS.length; renderFlashcard(); }
    function prevFlashcard() { isCardFlipped = false; currentCardIndex = (currentCardIndex - 1 + FLASHCARD_KEYS.length) % FLASHCARD_KEYS.length; renderFlashcard(); }
    function speakCurrentFlashcard() { const item = VOCAB_DB[FLASHCARD_KEYS[currentCardIndex]]; if (item) speakWord(item.word); }

    function renderQuiz() {
      document.getElementById('quiz-container').innerHTML = QUIZ.map((q, qIdx) => `
        <div class="sanctuary-subcard rounded-2xl p-4 space-y-2.5">
          <p class="text-xs sm:text-sm font-medium text-slatewarm-900">${q.q}</p>
          <div class="flex flex-wrap gap-2">
            ${q.options.map((opt, oIdx) => `
              <button id="qbtn-${qIdx}-${oIdx}" onclick="answerQuiz(${qIdx}, ${oIdx})" class="px-3 py-1.5 rounded-xl border border-[#dfd0b5] bg-parchment-50 hover:bg-autumn-100 text-xs font-medium text-stone-700 transition">
                ${opt}
              </button>
            `).join('')}
          </div>
          <p id="qexp-${qIdx}" class="hidden text-xs text-sage-800 bg-sage-50 p-2.5 rounded-xl border border-sage-200"></p>
        </div>
      `).join('');
    }

    function answerQuiz(qIdx, oIdx) {
      const q = QUIZ[qIdx];
      const expEl = document.getElementById(`qexp-${qIdx}`);
      q.options.forEach((_, idx) => {
        const btn = document.getElementById(`qbtn-${qIdx}-${idx}`);
        if (idx === q.correct) btn.className = 'px-3 py-1.5 rounded-xl border border-sage-500 bg-sage-600 text-white text-xs font-semibold';
        else if (idx === oIdx) btn.className = 'px-3 py-1.5 rounded-xl border border-autumn-300 bg-autumn-100 text-autumn-900 text-xs';
      });
      expEl.innerHTML = `<span class="inline-flex items-center gap-1.5"><i data-lucide="sparkles" class="w-3.5 h-3.5 text-sage-600"></i><span>${q.explain}</span></span>`;
      expEl.classList.remove('hidden');

      if (oIdx === q.correct && !quizAnswered.has(qIdx)) {
        quizAnswered.add(qIdx);
        document.getElementById('quiz-score-badge').textContent = `${quizAnswered.size} / ${QUIZ.length} Completed`;
        if (quizAnswered.size === QUIZ.length && typeof confetti === 'function') {
          confetti({ particleCount: 55, spread: 60, origin: { y: 0.7 }, colors: ['#be6f38', '#5b826f', '#e2b086'] });
        }
      }
      lucide.createIcons();
    }

    // -------------------------------------------------------------------------
    // 6. UI TOGGLES, SPEECH & TAB SWITCHING
    // -------------------------------------------------------------------------
    function switchTab(tabName) {
      ['transcript', 'vocab', 'fixes', 'places', 'practice'].forEach(t => {
        const panel = document.getElementById(`tab-panel-${t}`);
        const btn = document.getElementById(`tab-btn-${t}`);
        if (t === tabName) {
          panel.classList.remove('hidden');
          btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm';
          gsap.fromTo(panel, { opacity: 0, y: 8 }, { opacity: 1, y: 0, duration: 0.3, ease: 'power2.out' });
        } else {
          panel.classList.add('hidden');
          btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100';
        }
      });
    }

    function filterTranscript() { renderTranscript(); }
    function scrollToChapter(chapId) {
      document.getElementById('speaker-filter').value = 'all';
      document.getElementById('transcript-search').value = '';
      renderTranscript();
      const el = document.getElementById(chapId);
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    let highlightsOn = true;
    function toggleVocabHighlights() {
      highlightsOn = !highlightsOn;
      document.body.classList.toggle('hide-vocab-highlights', !highlightsOn);
      document.getElementById('btn-toggle-highlights').querySelector('span').textContent = `Vocab Highlights: ${highlightsOn ? 'On' : 'Off'}`;
    }

    let asrBadgesOn = true;
    function toggleAsrBadges() {
      asrBadgesOn = !asrBadgesOn;
      document.body.classList.toggle('hide-asr-fixes', !asrBadgesOn);
      document.getElementById('btn-toggle-asr').querySelector('span').textContent = `Note-Taker Fixes: ${asrBadgesOn ? 'Visible' : 'Hidden'}`;
    }

    function setThemeMood(mood) { document.body.setAttribute('data-theme', mood); }
    let speechRate = 1.0;
    function setVoiceRate(rate) { speechRate = rate; }

    function speakWord(text) {
      if (!('speechSynthesis' in window)) return;
      window.speechSynthesis.cancel();
      const utter = new SpeechSynthesisUtterance(text);
      utter.lang = 'en-GB';
      utter.rate = speechRate;
      window.speechSynthesis.speak(utter);
    }

    function speakPlainTurn(turnId) {
      const turn = TRANSCRIPT_TURNS.find(t => t.id === turnId);
      if (!turn) return;
      const temp = document.createElement('div');
      temp.innerHTML = turn.text;
      temp.querySelectorAll('.asr-fix-pill').forEach(el => el.remove());
      speakWord(temp.textContent || '');
    }

    // -------------------------------------------------------------------------
    // 7. WEB AUDIO PROCEDURAL SOUNDSCAPE
    // -------------------------------------------------------------------------
    let audioCtx = null, soundscapePlaying = false, masterGain = null, lfoTimer = null, currentFilter = null;
    function buildNoiseBuffer(ctx) {
      const bufferSize = ctx.sampleRate * 4;
      const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
      const output = buffer.getChannelData(0);
      let b0=0,b1=0,b2=0,b3=0,b4=0,b5=0,b6=0;
      for (let i = 0; i < bufferSize; i++) {
        const white = Math.random() * 2 - 1;
        b0 = 0.99886 * b0 + white * 0.0555179;
        b1 = 0.99332 * b1 + white * 0.0750759;
        b2 = 0.96900 * b2 + white * 0.1538520;
        b3 = 0.86650 * b3 + white * 0.3104856;
        b4 = 0.55000 * b4 + white * 0.5329522;
        b5 = -0.7616 * b5 - white * 0.0168980;
        output[i] = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362) * 0.04;
        b6 = white * 0.115926;
      }
      return buffer;
    }

    function toggleSoundscape() {
      const label = document.getElementById('soundscape-label');
      if (!soundscapePlaying) {
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        if (!audioCtx) audioCtx = new AudioContext();
        if (audioCtx.state === 'suspended') audioCtx.resume();
        const noiseSource = audioCtx.createBufferSource();
        noiseSource.buffer = buildNoiseBuffer(audioCtx);
        noiseSource.loop = true;
        currentFilter = audioCtx.createBiquadFilter();
        masterGain = audioCtx.createGain();
        masterGain.gain.value = parseFloat(document.getElementById('soundscape-volume').value || '0.22');
        noiseSource.connect(currentFilter);
        currentFilter.connect(masterGain);
        masterGain.connect(audioCtx.destination);
        noiseSource.start();
        audioCtx._activeSource = noiseSource;
        soundscapePlaying = true;
        changeSoundscapePreset(document.getElementById('soundscape-preset').value);
        label.textContent = 'Ambient: Playing';
      } else {
        if (lfoTimer) clearInterval(lfoTimer);
        if (audioCtx && audioCtx._activeSource) { try { audioCtx._activeSource.stop(); } catch (e) {} }
        soundscapePlaying = false;
        label.textContent = 'Ambient: Off';
      }
    }

    function changeSoundscapePreset(preset) {
      if (!currentFilter || !audioCtx) return;
      if (lfoTimer) clearInterval(lfoTimer);
      if (preset === 'breeze') {
        currentFilter.type = 'bandpass';
        currentFilter.frequency.value = 340;
      } else if (preset === 'rain') {
        currentFilter.type = 'lowpass';
        currentFilter.frequency.value = 880;
      } else {
        currentFilter.type = 'lowpass';
        currentFilter.frequency.value = 240;
      }
    }
    function updateSoundscapeVolume(val) { if (masterGain && audioCtx) masterGain.gain.value = parseFloat(val); }

    // -------------------------------------------------------------------------
    // 8. CANVAS FALLING LEAVES
    // -------------------------------------------------------------------------
    const canvas = document.getElementById('autumn-breeze-canvas');
    const ctx = canvas.getContext('2d');
    let leaves = [], leafMode = 1, breezeTime = 0;
    const LEAF_COLORS = ['rgba(190,111,56,0.42)', 'rgba(211,140,87,0.40)', 'rgba(165,191,177,0.42)', 'rgba(203,179,142,0.45)'];
    function resizeCanvas() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();
    function rebuildLeaves() {
      const count = leafMode === 1 ? 15 : leafMode === 2 ? 30 : 0;
      leaves = Array.from({ length: count }, () => ({
        x: Math.random() * canvas.width, y: Math.random() * canvas.height,
        size: 6 + Math.random() * 8, speedY: 0.35 + Math.random() * 0.55, speedX: 0.25 + Math.random() * 0.45,
        angle: Math.random() * Math.PI * 2, spin: (Math.random() - 0.5) * 0.014, swayOffset: Math.random() * 100,
        color: LEAF_COLORS[Math.floor(Math.random() * LEAF_COLORS.length)]
      }));
    }
    function cycleLeafBreeze() {
      leafMode = (leafMode + 1) % 3;
      document.getElementById('leaves-label').textContent = leafMode === 1 ? 'Leaves: Gentle' : leafMode === 2 ? 'Leaves: Breeze' : 'Leaves: Still';
      rebuildLeaves();
    }
    function animateLeaves() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      if (leafMode !== 0) {
        breezeTime += 0.01;
        leaves.forEach(l => {
          l.y += l.speedY; l.x += l.speedX + Math.sin(breezeTime + l.swayOffset) * 0.45; l.angle += l.spin;
          if (l.y > canvas.height + 20) { l.y = -20; l.x = Math.random() * canvas.width; }
          if (l.x > canvas.width + 20) l.x = -20;
          ctx.save(); ctx.translate(l.x, l.y); ctx.rotate(l.angle); ctx.fillStyle = l.color;
          ctx.beginPath(); ctx.ellipse(0, 0, l.size, l.size * 0.52, 0, 0, Math.PI * 2); ctx.fill(); ctx.restore();
        });
      }
      requestAnimationFrame(animateLeaves);
    }

    // -------------------------------------------------------------------------
    // 9. INITIALIZATION
    // -------------------------------------------------------------------------
    window.addEventListener('DOMContentLoaded', () => {
      renderTranscript();
      renderVocabGrid();
      renderFixes();
      renderFlashcard();
      renderQuiz();
      inspectVocab('trade-off');
      rebuildLeaves();
      animateLeaves();
      lucide.createIcons();
    });
  </script>
</body>
</html>
'@

$finalHtml = $template.Replace('/*__VOCAB_JSON__*/', $vocabJson).Replace('/*__TRANSCRIPT_JSON__*/', $transcriptJson).Replace('/*__EXTRAS_JSON__*/', $extrasJson)

$utf8Encoding = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("d:\Documents\Simone\index.html", $finalHtml, $utf8Encoding)
Write-Host "Successfully generated clean index.html. File size:" (Get-Item "d:\Documents\Simone\index.html").Length
