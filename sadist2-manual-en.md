# Sadist II: Final Scream — game manual

**Sadist ©1999 & Sadist II ©2000–2026** — [gadz.pl](https://gadz.pl/sadist-2)

## How does it work?

## Introduction

**Sadist II** was created in 2000 as a game for **MS-DOS** — a brutal sandbox where you build terrain, release groups of characters, and… well, the rest depends on your imagination (and an arsenal ranging from bazookas to anvils).

The **2026 version** is the same program, **still recompiled in Turbo Pascal 7.0**, with a few fixes. It is packaged in **DOSBox** with a ready-made configuration — you do not need to tweak `CONFIG.SYS`, worry about XMS memory, or fight with your Sound Blaster card. The problems described later in this document (out of memory, no sound, conflicts with WinAmp, etc.) apply to **running the original under plain DOS** and **should not occur** in the current distribution.

By the way, an **English version** was also created — better late than never, since 26 years have already passed.

The description below has been slightly edited, but keeps the rather specific, somewhat childish style of the original manual. Mostly for historical reasons — this is a document from another era…

---

## TL;DR — the essentials in brief

**What is Sadist II about?**

- You create or load a **two-dimensional terrain** (hills, pits, background).
- **Characters** appear on screen (max 5 groups) — they can fight each other, flee, panic, or stand around bored.
- **You** pick a weapon or “attraction” and shoot with the mouse — or take control of one character from the keyboard.
- You can change the **weather**, turn on **horror mode**, flood everything with **blood**, draw terrain, save levels.
- This is not a story-driven game — it is a **chaos simulator** in a tongue-in-cheek horror atmosphere.

**How to get started quickly?**

1. Launch the game (DOSBox handles the rest).
2. In the **main menu**, choose **New terrain**, set parameters, click **Create**.
3. On the menu bar at the bottom (key **6** or space) open the **main menu** and click the numbers next to the groups — characters will appear.
4. Switch to menu **1** (weapons), pick e.g. a shotgun or bazooka.
5. **Left mouse button** = shoot. **Right (held)** = crosshair.
6. Experiment with menu **4** (conditions) — turn on aggression, storms, blood rain…
7. **ESC** = return to the main menu; from there you can save the terrain.

The rest of this document is a detailed description of every option — the above is enough to start.

---

## First things first

I know this document is not short. Please forgive me — I tried to describe everything as thoroughly as possible, which produced this considerable length. Even so, I strongly urge you to read through to the end (even if only skim it), because you will find a lot of important information about Sadist II here, answers to many questions, and more.


---

## A. Main menu

This is the first screen after starting Sadist II. It contains all the basic options plus exit to the system. The “buttons” are arranged in a circle, with return to the game in the center — **Continue the massacre!!!** At first glance you may not see it, but the labels explain everything.

Terrain save and return-to-action options only become active after creating or loading terrain.

### A1. New terrain

This is where you create new terrain. It is generated randomly, but several settings are up to you.

- **Texture** — choice of texture on the created terrain. Textures are loaded from the `TEKSTURY` subdirectory. If you do not want any texture, choose **none**.
- **Color** — works only when texture is disabled; this is the terrain color.
- **Surface** — the top layer of the terrain (grass, etc.), loaded from the `TEKSTURY` subdirectory. If you choose **none**, there will be no surface layer.
- **Upper and lower height limits** — random terrain is created between these limits. The lower limit can go below ground level — there will be pits then.
- **Clear/keep previous terrain** — works only when some terrain already exists (loaded or created). When creating new terrain, the previous one may remain and the new one will be layered on top.
- **Game mode** — choice of game type; see section [C: Game modes](#c-game-modes).
- **Create** — pressing this button creates the terrain.

### A2. Save terrain

Saves the current terrain to a file. This option activates after creating or loading terrain. Terrains are saved in the `TERENY` subdirectory. Because terrains are compressed, saving takes a moment. The terrain file stores the terrain itself plus several settings: background (only its name, not the image!), character spawn settings, conditions, etc.

### A3. Load terrain

The opposite of saving terrain. After selecting a terrain file, it is loaded along with all settings. The specific background for that terrain is also loaded. If that background is missing from the backgrounds subdirectory, no background will be loaded and it will be black.

### A4. Load characters

The program always has five character groups. You can change them at any time to sets you have in the `POSTACI` subdirectory. On the list of available sets, the current sets for each group are marked with colored indicators. One set is assigned per group — you select it by clicking next to the group marker for that set. After pressing the **load** button, only the sets that were just changed will be loaded.

### A5. Load background

Loads a background image visible “behind” the terrain. Backgrounds are loaded from the `TLA` subdirectory. Remember: if background drawing is disabled, you will not notice any changes until you turn it on.

### A6. Options

Here you have access to many program options and settings.

#### Graphics and effects

- **background image** [on/off] — toggles background drawing. When off, the “color” button activates, letting you set a solid color instead of an image. This speeds up the program slightly.
- **smoke/explosions** [on/off] — explosion and smoke sprites; visual effect only, not needed for anything, and they slow the program down.
- **precipitation** [on/off] — can be turned off from the in-game menu, but disabling here causes them to be skipped entirely in the program, which should speed things up a bit more.
- **particles (stones, blood, etc.)** [on/off] — slows the program down a lot and is almost essential; turning this off costs you a lot of fun — no flying blood, sparks, stones after explosions, etc. Better not disable it.
- **bubbles underwater** [on/off] — disables bubbles underwater; works only when water is enabled.
- **shell casings** [on/off] — ejected casings from shotgun/minigun/rifle.
- **meat, bricks, etc.** [on/off] — better not disable; meat will not fly from characters, nor will objects like balls, bricks, etc.; “weapons” that throw meat will not work at all.
- **screen shakes** [on/off] — during explosions and earthquakes; no impact on program speed.
- **lightning screen flashes** [on/off] — full-screen flash when lightning strikes.
- **horror mode speed** [01–20] — controls how fast blood floods everything when horror mode is on; the lower the number, the slower. Horror mode has a big impact on speed — on slower computers, lower this number. Default: 2.
- **blood fountains** [on/off] — extra effect on death of characters and critters; for best results, set as many particles as possible in Details.
- **blood amount** [10%–500%] — amount of blood produced from wounds; 100% is standard.

#### Characters and gameplay

- **fall damage** [on/off] — when a character hits a wall, ground, or ceiling with enough force, they may lose strength (even their life) and bleed.
- **strength loss after major wounds** [on/off] — when a character loses a limb or head, they lose strength and die after a moment; with this off, they keep running until someone else kills them.
- **centering on controlled character** [on/off] — when controlling a character from the keyboard, the screen scrolls to keep them roughly centered.
- **critters** [on/off] — enables or disables all animals moving on the terrain: birds and fish.
- **critters spawn on their own** [on/off] — birds and fish enter from the screen edges on their own (fish only when water is enabled).
- **kid-friendly version** [on/off] — disables blood, meat, and death screams; characters simply vanish. If your child absolutely must play this — turn it on.

#### Crates

- **crates** [on/off] — falling crates with bonuses.
- **crate drop frequency** [01–30] — 01 = rarest, 30 = most frequent.
- **crates also underground** [on/off] — crates sometimes appear underground and must be dug out.
- **characters can open crates** [on/off] — characters can open crates on their own if they walk up to them.

#### Weather

- **multi-layer precipitation** [on/off] — rain and snow can fall on three layers: back, on terrain, and front. Only the middle layer affects the environment; the others are visual.
- **rain sounds** [on/off] — rain sound; especially atmospheric with storms.

#### Interface

- **menu bar** [on/off/auto-hide] — red menu at the bottom of the screen. Turning it off gives a larger visible area but makes play harder. Auto-hide is the optimal option: it appears when you move the mouse pointer to the bottom of the screen (TAB also toggles this during play).
- **captions, comments** [on/off] — short texts during actions or labels for the currently selected menu.
- **caption position** [top/bottom]
- **body counters** [on/off] — small body counters in the corner of the screen.
- **counter position** [top/bottom]
- **tooltips** [on/off] — short hints next to the mouse cursor; good for beginners.
- **off-screen projectile indicators** [on/off] — edge indicators when a projectile flies off screen.
- **off-screen character indicators** [on/off] — same for the selected character.
- **dripping blood in menu** [on/off] — in the main menu, blood constantly drips from the top of the screen.
- **menu tabs** [on/off] — tabs for each menu separately; right mouse button (` (tilde) key during play).
- **remember each menu's options** [on/off] — options are remembered per menu (applies to weapons and other attractions menus).

#### Sound and controls

- **evil master's voice** [on/off] — during more interesting actions (larger kills at once), laughter is heard in the background.
- **sounds** [on/off] — global mute for all sounds.
- **mouse sensitivity** [01–50]
- **screen scroll speed with mouse** [01–20]
- **screen scroll speed with keyboard** [01–20]
- **frameskip** [01–20] — if the program runs too slowly, set a higher number; showing every nth frame speeds up the game at the cost of smoothness.

**\* details \*** — opens a new menu (see: [section A7](#a7-details)).

### A7. Details

> The DOSBox version should allow maximum settings in this menu and you probably will not need to change them further. If you have speed problems, you can increase the emulated CPU speed in DOSBox with Ctrl+F12 (decrease with Ctrl+F11)

A specific menu compared to the others. Here you set exactly how many of each detail can exist at once. A given amount of conventional memory is allocated per detail. If you have little free memory, there is not much room to maneuver. The number of details affects program speed.

> ⚠️ Try not to use this menu too often — memory is reallocated each time and errors may occur. After every visit to this menu (even if you change nothing!) all objects on the terrain are reset.

Each entry has an intuitive name. The only one needing explanation: *Max number of explosions* — this does not mean explosions themselves (their count is unlimited), but explosion sprites. The more there are, the more impressive large explosions look. Next to each detail, the standard value at which the program should already look good is shown in parentheses.

At the bottom of the screen, free memory is displayed:

| Color | Meaning |
|-------|---------|
| Green (above 1000 B) | The program will run correctly 99% of the time |
| Orange (below 1000 B) | There is a chance it will crash |
| Red (below zero) | This can happen when allocating memory during startup — do not start playing in that situation |

On each program launch, free memory is checked. If there is not enough for the detail settings from before, details are reduced. When you exit the program, settings are saved to a file.

### A8. Statistics

A full list of statistics: counts of fired projectiles of various types, number of characters, bodies (how they died), etc. Statistics reset on each program launch.

### A9. Authors

A bit of information about what, who, and how.

### A10. Exit to system

Quick exit from the program — even if you already see blood, even after turning away from the monitor.

---

## B. Menu bar

The red menu at the bottom of the screen, visible during play. It has all the options you need, weapons, etc. Because there are too many icons, the menu is divided thematically into six parts. Switch it with space or digits 1 through 6, or with menu tabs (if enabled). TAB toggles the entire menu bar on and off.

### B1. Weapons

In this menu you choose the weapon you will fire with the mouse or a controlled character.

| Weapon | Description | Settings |
|--------|-------------|----------|
| **bazooka** | Classic projectile, slowly pulled down by gravity, affected by wind, explodes on contact | explosion power |
| **grenade** | Explodes after a set time, affected by wind, can be caught and thrown | power, time to explosion |
| **bomb** | Like a grenade, but heavier; after explosion splits into fragments | power, time to explosion |
| **rifle** | High rate of fire, no spread, fast invisible bullets | bullet power |
| **light cannon** | Large arc, hard to aim, bullets explode with greater force | bullet power |
| **shotgun** | Slow shots (reload), slight spread, kills on the spot | bullet power |
| **sniper rifle** | Instantly hits the character in the crosshair, high power | — |
| **flamethrower** | Fire does not wound, but sets things ablaze | fire/napalm |
| **air strike** | Projectiles dropped from a plane; left button = from left, right = from right | normal bullets/napalm |
| **homing missile** | Flies to a designated spot; after a while it falls if it does not hit | power, set target |
| **laser** | Beam cuts ground and people | power, normal/incendiary |
| **electricity** | Shock, can ignite | voltage (V), normal/incendiary |
| **fireball** | Heavy ball, after explosion burns everything around | explosion power |
| **mines** | Lie and wait; max 100 mines at once; right button = pick up mine; “detonate” button blows all of them | working/broken/random |
| **anvil** | Falling anvil destroys everything | — |
| **saw** | “Melee weapon” — cuts everything, sometimes you need to swing a few times | — |
| **railgun** | For Quake fans — fast, kills along its path, does not explode | — |
| **napalm** | Like a bazooka, but sets everything around on fire | explosion power |
| **fragment launcher** | Throws large amounts of fragments similar to bomb shrapnel | — |

### B2. Other attractions

More weapons, but of a different type:

- **trash** — throw apples, balls (characters like to kick them), bricks
- **meat** — for the completely depraved — throw meat or whole corpses from a selected or random group
- **blood** — like above, but you splash blood
- **lightning** — “shot” lightning from the cursor
- **snow** / **rain** — precipitation from the cursor
- **character** — manually throw a character from a selected group
- **critters** — manually throw a selected critter
- **fan** — blows away everything not attached to the terrain; left button = spin up, right = maintain speed
- **magnifier** — for close-up view; can be toggled continuously (F2); useful e.g. for the sniper rifle
- **crates** — throwing crates; three types: bonuses, traps, other; each can be enabled/disabled

### B3. Character options

This menu matters only when at least one character is selected. Under the icons you see strength, group, and character number (one selected) or the number of selected characters (more than one).

| Option | Action |
|--------|--------|
| **stand** | Makes selected characters stand; they can do surprising things… |
| **block** | “Blocker” role (like in Lemmings) — turns back characters that approach |
| **walk** / **run** | Makes them walk / run |
| **panic** | Running, screaming, changing direction — hard to control |
| **turn around** | Turns selected characters around |
| **add strength [+]** / **remove strength [-]** | ±50 strength units; at 0 the character dies |
| **free will [?]** | Character acts on their own — flees from threats, etc.; on by default |
| **death [skull]** | Kills instantly |
| **extinguish fire** | Puts out fire on all selected characters |
| **immortality** | Indestructible characters; killed only by abyss, water, lava, or acid |
| **deselect** | Deselects all selected (same as ALT without placing the cursor) |
| **select all** | Left button = all; right on color arrow = group; Ctrl = add group |

#### Character control

Works only with **one** selected character. Keyboard control:

| Key | Action |
|-----|--------|
| Left/right arrows | Walk or run |
| Up/down arrows | Change shooting angle |
| A / Z | Change shot power |
| S | Dig |
| D | Hit |
| X | Fire selected weapon |
| C | Jump |
| V + side arrow | Walk; without arrow — run |

Exit character control: press the control button again or the character dies.

### B4. Conditions

Weather control and more:

- **rain** / **snow** / **storm** / **blood rain** — will not work if precipitation is disabled in configuration
- **horror** — blood seeping from walls
- **earthquake** — works only after clicking; terrain slides downward
- **pit** / **water** / **lava** / **acid** — five ways to change the ground; only one active at a time
- **maniacs** — characters fight even within their own group
- **fighting** — general combat toggle

**Sliders:**

- **left** — wind speed and direction; AUTO changes wind between limits
- **center** — precipitation intensity; AUTO rules same as for wind
- **right** — aggression level; zero = like turning fighting off
- **vertical on the right** — water/lava/acid level

### B5. Drawing

Menu for drawing terrain. On the left, a “sample” of texture or color. Textures from the `TEKSTURY` subdirectory. Color can be used instead of texture. Some colors have special properties: **metal** (harder to destroy) and **blood** (dries and drips, in 4 shades). Next to that, brush size — same for objects (stairs, bridges, etc.).

### B6. Main menu

Portraits of characters from each of the five groups. Statistics:

- **characters are/max** — how many characters on screen / maximum possible
- **bodies here** — bodies in the current terrain (resets on new terrain)
- **bodies total** — bodies in the whole session since launch
- **last combo** — how many died at once last time

Numbers under a character show how many from that group are on the terrain (upper) out of how many are set (lower). Clicking sets how many characters appear on screen. A small marker next to the character toggles spawn points on/off.

Clicking a character portrait shows spawn options:

- **what the character should do** — after appearing
- **direction** — initial direction
- **initial strength**
- **free will** — on by default (see [B3](#b3-character-options))
- **spawn frequency**
- **%** — what percentage must stay alive before the next ones arrive (0% = after the last death, 100% = immediately after every death)
- **drop** — instant refill of missing characters
- **attitude toward other groups** — 5 icons; which groups fight each other (unless “maniacs”)

---

## C. Game modes

Two game modes are available.

### 1. Traditional — “killing for fun”

Like in Sadist: you can do everything, you have all weapons and options.

### 2. Timed game

Playing with several restrictions:

- Set time limit
- Limited ammunition per weapon
- Can only be started by **creating new terrain** in this mode — does not work on loaded terrains
- Start: 2000 ammunition + 3 bullets per required victim (e.g. 200 characters = 2600 ammunition, distributed randomly)
- Mission: kill 150–400 characters
- Characters fall from above in groups of 20; new ones appear after all current ones are killed
- Limited options — no character control, spawn points, water, etc.
- When time runs out: summary. Bonus for exceeding the threshold: `2 × required_body_count × bodies_above_threshold` (on average tens to hundreds of thousands of points)
- After summary, ESC → menu; you can return to the terrain or create a new one

---

## D. Keys and general controls

### Keys

| Key | Function |
|-----|----------|
| **F1** | Weapon selection |
| **F2** | Toggle magnifier on/off |
| **F3** | Toggle cursor on/off |
| **F11** | Save mega screenshot → `S2MS0123.BMP` (entire terrain) |
| **F12** | Save screenshot → `S2SS0123.PCX` (visible screen) |
| **Space** | Change bottom menu |
| **1–6** | Select specific menu (weapons, attractions, characters, conditions, drawing, main) |
| **Tab** | Toggle bottom menu on/off |
| **` (tilde)** | Toggle menu tabs on/off |
| **Cursor arrows** | Scroll screen (when not controlling a character) |
| **Home/End/Delete/Page Down** | Control shot power and direction (like right mouse button) |
| **Shift** | Move characters with cursor |
| **Ctrl** | Throw carried characters toward crosshair |
| **Alt** | Select characters |
| **Alt+Ctrl** | Add more characters to selection |
| **+/-** | Select/deselect character under cursor |
| **P** | Pause (everything stops, but you can still act) |
| **ESC** | Return to menu |

Character control keys — see [B3. Character options](#b3-character-options).

### Mouse

- **Left button** — shoot
- **Right button (held)** — crosshair control; sides = rotation, up/down = shot power

---

## E. First launch

A short guide for the first run:

1. **Configuration** — on first launch you may see a message about a missing config file and default settings. On later runs, the last settings are loaded.
2. **Intro** — can be skipped with the `-bezintro` parameter.
3. **Main menu** — default humans loaded for each group; you can load other sets from `POSTACI`.
4. **Terrain** — create new (`new terrain`) or load existing. Set parameters and press **create**.
5. **Characters** — the screen will be empty. Main menu on the bar (space or 6), click numbers next to groups.
6. **Weapon** — menu 1, pick a weapon and… good luck.
7. **Exploration** — check menus 1–6; in menu 4 (conditions) turn on aggression and weather.
8. **Save** — ESC, save terrain, change options.

> Unlike Sadist I, Sadist II **does not save** the last terrain on exit — on every launch you must load or create terrain anew.

---

## F. Shooting at problems (troubleshooting)

> 📎 The problems below apply to running under native DOS. They should not apply to the current version packaged in DOSBox.

### Startup problems

- **Hang after “XMS memory reservation”** — insufficient XMS memory, missing `EMM386.EXE`, or memory issues. With ~4 MB XMS, check `CONFIG.SYS` and the extended memory manager.

- **Hang after “conventional memory reservation”** — insufficient base memory. Remove resident programs and try again.

- **Hang/error after “loading data”** — missing file in the `DANE` subdirectory or a file error. Try unpacking the program again.

- **Hang after “loading sounds”** — incorrectly installed sound card, missing `BLASTER` variables (autodetection will not work without them!) or another program using the card (WinAmp, Sound Blaster mixer).

- **Hang/error after “building texture database”** — problem in the textures directory. Review and remove bad files.

- **Hang/error after “building character set database”** — problem in the characters directory. `POSTACI` **must** contain at least one character file.

- **Hang/error after “loading configuration”** — error in the configuration file. Delete `SADIST2.CFG` — this restores standard settings.

- **Runtime Error 203 or 207** — most likely insufficient conventional memory. Reduce details, leave free memory, remove resident programs.

- **Hang/computer reset** — conflict with sound card. Launch with the `-bezdzwieku` parameter (you also gain some memory).

### Other

- **No music in the game** — Sadist 2 has no music and never will. But playing without music is a waste. Put on Six Feet Under — created almost perfectly for this program.

- **WinAmp + Sadist = hang** — WinAmp occupies the sound card. Only option: `sadist2.exe /bezdzwieku`.

---

## G. FAQ — a collection of silly questions

**Why can't I control critters?**
Critters are just a detail — they were not made to interact with like characters. Be glad you can kill them.

**Why is there no music?**
Because there isn't. Sadist 2 has no music — put on Six Feet Under (Cannibal Corpse works too, etc.).

**Why isn't blood flowing?**
You probably forgot you have to work for it yourself — pick a weapon and get to it!

**Why don't characters shoot at each other like in Sadist I?**
I dropped that option — when enabled, the terrain was gone quickly. Now you have more varied fighting. You can shoot while controlling a character from the keyboard.

**Where are the icicles like in Sadist?**
I dropped them — they could slow the program down a lot.

**What about trees?**
They were pretty but useless — characters walked on them, not beside them. Terrain in Sadist II is much more developed.

**Why aren't there as many things as in old Sadist?**
This is a different program. Miss the old one — play it. Here you have innovations and new ideas. I ran out of memory to develop the code further.

**Why are characters missing from mega-screenshots?**
A mega screenshot is a visual record of the terrain (bitmap) — I use it for terrain previews on the website.

**Do broken mines block throwing working ones?**
Limit of 100 mines. Pick them up with the right mouse button or throw them into an abyss/water.

**How to configure conventional memory?**

Example files (Windows 95):

**Autoexec.bat:**

```bat
rem *** sound card settings, yours may differ: ***
SET SOUND=C:\PROGRA~1\CREATIVE\CTSND
SET MIDI=SYNTH:1 MAP:E MODE:0
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
PATH C:\WINDOWS;C:\WINDOWS\COMMAND
SET TEMP=C:\WINDOWS\TEMP
mode con codepage prepare=((852) C:\WINDOWS\COMMAND\ega.cpi) >nul
mode con codepage select=852 >nul
keyb pl,,C:\WINDOWS\COMMAND\keybrd4.sys
```

**Config.sys:**

```bat
DEVICE=C:\WINDOWS\HIMEM.SYS
DEVICE=C:\WINDOWS\EMM386.EXE RAM D=64
FILES=80
DOS=UMB,HIGH
device=C:\WINDOWS\COMMAND\display.sys con=(ega,,1)
Country=048,852,C:\WINDOWS\COMMAND\country.sys
```

This is only an example — your directories and settings may differ. Windows 98 behaves differently. For Windows 98 PL, download the patch from the [Official Sadist Website](http://www.sadist.qs.pl/) — ~40 KB more conventional memory.

---

## H. A few last words

The author is not responsible for damage resulting from use of this program, onset of mental illness (or its worsening), death of the player's family, mental distortion, and other psychological warping, etc. If you are under 18 — play at your own risk, but I do not consider this a game for you. If you have a child — better not show them this (I know how much kids like it!), because you will not pull them away from the computer.

Thanks to my niece for a few funny ideas and motivation to keep working — if you saw how much she likes Sadist! Thanks also to the people who nagged me to create Sadist II — without whom I probably would not have wanted to write it. At the same time: they really annoyed me by flooding me with questions about the next version and tossing ideas I clearly did not ask for.

I want to deny rumors that Sadist was a copy of some program. Sadist was created without copying anyone's ideas. I have already seen other games **based on** Sadist.

---

## I. Technical data

### File extensions

| Extension | Contents |
|-----------|----------|
| `*.S2P` | Character set |
| `*.S2T` | Saved terrain |
| `*.S2B` | Background image |
| `*.STX` | Texture image |
| `*.STW` | Terrain surface image |

### Formats

- **Character sets** — all animations, settings, and sounds. Sounds: RAW format (raw data), 8-bit, mono, 22050 Hz.
- **Terrains** — terrain appearance (LZSS compression), background name (not the image itself!), character spawn points, mines, weather conditions.
- **Backgrounds** — format similar to BMP, 48 colors, 640×300, transparency table after the bitmap.
- **Textures and surfaces** — simplified bitmap format. Palette reduced to standard — sometimes “color mutilation.” In surfaces, black `#000000` = transparent.

### About the program

Program written in **Turbo Pascal 7.0** for DOS, with assembler snippets (Xan, thanks for the help!), without objects, in real mode, using a unit for XMS memory handling.

- **Code:** 16,220 lines, 552 KB, 22 PAS files + CRT, DOS and MOUSE
- **Development time:** ~5 months of hard work (July 2000 → version 1.0, Dec 2000)
- **Goal:** so you would enjoy playing more!

---

## J. That would be all

And that is roughly everything I had to say. I hope that after reading this rather short document you will already know how to use Sadist 2. The controls are not the simplest, but that comes from the large number of options — you need to learn them and get used to them. After that, it is smooth sailing.

---

> **MAY THE BLOOD BE WITH YOU**
> *(and not all over you)*
