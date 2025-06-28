![bdscthumb](https://github.com/user-attachments/assets/555c3450-8719-451f-bbeb-b3180aad3da4)

# BDSC - BOII Development Server Core

**Alpha Release**  
> The current version is an alpha release. Expect improvements, additions, and the occasional breaking change. Most updates will be minor, but be ready to adapt if a bigger change lands.

Full docs: [docs.boii.dev](https://docs.boii.dev)

# What Is BDSC?
Normally? **BOII Development Server Core**


When it’s running smoothly? **Barebones Done Smart & Clean**

When it refuses to co-operate? **Bug-Driven Sh*tfest of Chaos.**

BDSC is a lightweight server foundation designed for developers who want control.
It doesn’t care what your server does — it just gives you a clean, flexible structure to build on.

- No jobs.
- No inventory.
- No economy.
- No drama.

### You get the boring but essential stuff:
- Player management
- Object extensions
- A couple of handy utilities
- Everything else? You decide.

# Who It’s For
BDSC was built for internal use on BOII projects — survival, minigames, experiments. 
But it’s now open and modular enough to support anything.
If you're tired of bloated RP frameworks or want a clean, no-bullshit starting point, this is for you.

You get:
- A stable foundation
- A consistent object system
- A fully extensible runtime
- Zero assumptions about your gameplay

Use it. Fork it. Rewrite it. Just don’t make it worse.

# What It Provides
### BDSC handles:
- Player management and object lifecycle
- Extension hooks for runtime systems
- Server/client-safe data syncing
- Core exports for structured access
- Some basic utlity functions

No hardcoded gameplay.
No required systems.
No enforced dependencies.
You build what matters — BDSC stays out of the way.

# Ideal Use Cases

BDSC is framework-agnostic and gameplay-neutral.

### Perfect for:
- Custom survival servers
- Minigame or PvP modes
- Custom RP frameworks
- Experimental mechanics
- Hybrid / mashup servers

If you’re building something new, this is the foundation to do it clean.

# Player Extensions
BDSC supports extending player objects at runtime - without breaking structure:
```lua
player:add_data("stats", { health = 100 }, true)
player:add_method("stats", "get_health", function(self) return self:get_data("stats").health end)
player:run_method("stats", "get_health")
```

> All data/methods are namespaced, and replicated data syncs automatically to clients if marked as such.

# Structure
Everything is modular and clearly separated.
```bash
│
├── lib/              # Utility functions (e.g. utils.lua)
│
├── player/           # Main player system
│   ├── events.lua       # Join/leave, sync, client handlers
│   ├── factory.lua      # Creates player objects
│   ├── methods.lua      # Public/private extension logic
│   ├── registry.lua     # Player storage, save/remove/get
│
├── locales/          # Translation files
│   └── en.lua
│
├── finalise.lua      # Exports and locks bdsc namespace
├── fxmanifest.lua    # Resource manifest
└── init.lua          # Core bootloader
```

Want to add inventory? Authentication? Stats?
Just attach logic using add_data and add_method on player objects - no plugin boilerplate required.

# Quick Install

BDSC isn’t a full framework - it’s a clean server core. 
You don’t need to install databases, jobs, inventories, or other bloated systems.

To get started:

### 1) Drop It Into Your Server
- Place the bdsc resource into your resources/ folder.
- Make sure it starts after bdtk (required for user accounts, you could change this).
```bash
ensure bdtk
ensure bdsc
```

### 2) Start The Server
- BDSC will automatically initialize and log connected players.
- It doesn’t require SQL or any config to boot.

### 3) Extend It
Write your own logic using the exposed player API, or import it into your systems via:
```lua
local core = exports.bdsc:import()
```
That’s it. No setup wizard. No bloated dependencies.
Just a clean foundation for your own logic.

# Support

Need help? Found a bug? Need to vent about a bug that isn’t from this core? 
Support is available through the BOII Development [Discord](https://discord.gg/MUckUyS5Kq).

**Support Hours: Mon–Fri, 10AM–10PM GMT**

Outside those hours? Pray to the debug gods or leave a message.
