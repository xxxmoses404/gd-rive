[![Releases](https://img.shields.io/badge/Releases-Download-blue?logo=github)](https://github.com/xxxmoses404/gd-rive/releases)

# gd-rive: Godot 4 Dialogue Manager Plugin with RiveScript

![Godot Engine](https://godotengine.org/themes/godotengine/assets/press/godot_press_icon.svg) ![Chatbot](https://img.icons8.com/ios/256/chatbot.png)

A fluid dialogue manager plugin for Godot 4.x. gd-rive combines Godot scene flow and signals with RiveScript-style scripting for NPCs, chatbots, and interactive text systems. Use it in RPGs, visual novels, text adventures, and voice-driven scenes.

Topics: ai, chatbot, chatterbot, dialog-engine, dialog-management, dialog-manager, dialog-system, dialogue-system, dialogue-systems, game-engine, gdscript, godot, godot-engine, rive, rivescript, rpg, rpg-tool, text-based-adventure, tts, visual-novel

Table of contents
- Features
- Quick demo image
- Requirements
- Install (download and run release)
- Manual install
- Basic usage
- RiveScript primer
- Nodes, signals, and scene setup
- API reference (core methods)
- Examples (Visual Novel, NPC, TTS)
- Debugging and testing
- Contributing
- License
- Credits

Features
- RiveScript-driven dialogue in Godot 4.x.
- Node-based dialog manager that integrates with Godot signals.
- Context, variables, and user memory per session.
- Multi-language support via RiveScript includes.
- Built-in match scoring and fallback replies.
- Hooks for TTS, audio, and animation sync.
- Small runtime overhead and editor plugin for inspectors.

Quick demo
![gd-rive demo](https://raw.githubusercontent.com/xxxmoses404/gd-rive/main/assets/demo.gif)

Requirements
- Godot 4.x (stable or later).
- Project set to use GDScript 2.
- RiveScript files (.rive) authored for the plugin. See RiveScript primer below.
- For text-to-speech link: external TTS provider plugin or platform TTS.

Install (download and run release)
- Visit the Releases page and download the release asset for your platform.
- The release file must be downloaded and executed.
- Releases: https://github.com/xxxmoses404/gd-rive/releases

Steps
1. Open the Releases page.
2. Download the asset named gd-rive-vX.Y.Z.zip or gd-rive-plugin.gdplugin.
3. Extract into your Godot project's addons/gd-rive folder or run the installer asset if provided.
4. Enable the plugin in Project > Project Settings > Plugins.

If the release provides a runnable installer, run that file to install the plugin into your project. If the release provides a zip, extract its contents to addons/gd-rive and enable the plugin.

Manual install
1. Copy the addons/gd-rive folder into your project root.
2. Enable the plugin in Project > Project Settings > Plugins.
3. Add a DialogManager node to your main scene or a persistent manager scene.

Basic usage

Add DialogManager
- Create a Node3D or Control scene named DialogManager.
- Attach the provided DialogManager.gd script or use the plugin node type if installed.

Load RiveScript
- Put your .rive files in res://dialog/.
- Use DialogManager.load_rive("res://dialog/npc.rive")

Example GDScript
```gdscript
# DialogManager usage example
var dm: DialogManager

func _ready():
    dm = get_node("/root/DialogManager")
    dm.load_rive("res://dialog/npc.rive")
    dm.set_user_id("player1")
    dm.send("hello")

func _on_DialogManager_reply(reply_text):
    print("NPC:", reply_text)
```

Methods (common)
- load_rive(path: String) -> bool
- set_user_id(id: String)
- send(message: String) -> void
- reply() -> String
- set_var(name: String, value: Variant)
- get_var(name: String) -> Variant
- save_user() -> void
- load_user() -> void

RiveScript primer
- RiveScript is a scripting language for chatbots. It uses triggers and replies with simple syntax.
- Use topics, includes, and subroutines to organize complex flow.
- Example file: res://dialog/npc.rive

Example npc.rive
```
! version = 2.0

+ hello
- Hello, traveler. What brings you here?

+ my name is *
- Nice to meet you, <star>. I am the village guardian.

+ help
- You can ask about quests, rumors, or services.

> topic quests
    + i need a quest
    - Seek the blacksmith. He lost his hammer.
< topic
```

Context and session
- The plugin stores context per user id.
- Use set_user_id("player1") to isolate conversation for each player.
- The plugin supports variables and memory. Use %session% style keys in GDScript via set_var/get_var.

Nodes, signals, and scene setup

DialogManager node
- DialogManager handles the RiveScript engine instance and exposed API.
- It emits signals on reply, error, and update:
  - signal reply(user_id: String, text: String)
  - signal error(code: int, message: String)
  - signal text_ready(user_id: String, text: String)

Scene example
- Create an AutoLoad scene at /root/DialogManager.
- Add child nodes:
  - SpeechSynth (optional) for TTS integration.
  - DialogueUI: Control node to render text and choices.
- Connect DialogManager.reply to DialogueUI.on_reply to display text.

Signals usage
- Connect signals from DialogManager to your UI:
```gdscript
dm.connect("reply", self, "_on_reply")
func _on_reply(user_id, text):
    $DialogueLabel.text = text
    $AudioPlayer.play() # sync audio if needed
```

API reference (core methods)
- load_rive(path: String) -> bool
  - Load a .rive file. Returns true on success.
- add_rive(path: String) -> bool
  - Merge an include file at runtime.
- set_user_id(uid: String)
  - Set the active user context.
- send(message: String)
  - Send text to the engine. The engine processes and emits reply.
- ask_async(message: String) -> void
  - Send text and receive async reply via signal.
- register_macro(name: String, func: Callable)
  - Register a GDScript function callable from RiveScript.
- set_var(name: String, value: Variant)
  - Set engine or user variable.
- get_var(name: String) -> Variant
  - Read variable.

Examples

Visual Novel flow
- Use DialogManager to drive scenes and choices.
- Map RiveScript topics to scene states. For choices, use a pattern like:
```
+ choose * (option1|option2)
- {topic=option1} You chose option one.
```
- In GDScript, catch the reply metadata to switch scenes.

NPC with quest state
- Persist user variables: save_user() writes player memory to disk.
- Use get_var("quest_state") to check progress.
- Use RiveScript conditionals to change replies based on quest state.

TTS and audio sync
- Connect DialogManager.reply to your TTS node.
- On reply, call the TTS speak method. Use callbacks to animate lips or play sound.

Debugging and testing
- Enable debug mode in plugin settings to log RiveScript parsing.
- Use the interactive console scene in addons/gd-rive/examples/console.tscn to test replies.
- If a reply fails, DialogManager emits error(signal) with a parse error code and line number.

Examples folder
- The repo includes example scenes:
  - examples/visual_novel/
  - examples/npc/
  - examples/console/
- Open these scenes in Godot to inspect flow and signals.

Best practices
- Keep RiveScript files modular. Use includes per NPC.
- Keep the DialogManager as a singleton for global access.
- Use short triggers to improve match accuracy.
- Use topics to scope replies and avoid cross-talk.

Contributing
- Fork the repo.
- Create a feature branch.
- Open a pull request with tests or example scenes.
- Follow Godot coding style and include GDScript docstrings.
- Report issues in GitHub issues.

Releases and updates
- Check Releases for binaries, installer assets, and prebuilt zips.
- The Releases page contains the file to download and execute for easy install.
- Visit releases: https://github.com/xxxmoses404/gd-rive/releases

License
- MIT License. See LICENSE file in the repo.

Credits
- Built on RiveScript. See rivescript.com for language docs.
- Godot Engine team for the core engine.
- Contributors and testers listed in CONTRIBUTORS.md.

Images and assets
- Some images in this README link to public assets and logos.
- Use your own art for game release and credits.

Contact
- Open issues on GitHub for bugs, feature requests, or questions.
- For direct contributions, submit a PR with a clear description and test scene.

Changelog
- Keep changelog entries in CHANGELOG.md. Follow semantic versioning.

Quick checklist
- [ ] Download the release asset and execute it from Releases.
- [ ] Enable plugin in Project Settings.
- [ ] Add DialogManager to your scene or register as AutoLoad.
- [ ] Load your RiveScript files.
- [ ] Connect reply signal to your UI or TTS node.

Further reading
- RiveScript docs: https://www.rivescript.com/docs
- Godot plugin docs: see Godot docs for editor plugins and autoloads
- Example RiveScript patterns: consult examples in the repo

Badge and links
[![Releases](https://img.shields.io/github/v/release/xxxmoses404/gd-rive?label=gd-rive%20releases&logo=github)](https://github.com/xxxmoses404/gd-rive/releases)