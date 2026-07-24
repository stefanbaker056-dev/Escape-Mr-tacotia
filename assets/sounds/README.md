# Escape Mr. Taqueria - Audio Assets

This folder contains all sound effects and music for the game.

## Sound Effects

### Death Sounds
- `death.ogg` - Played when player dies (falls in lava, hit by obstacle, etc.)

## How to Add Sounds

1. Place your audio files (.ogg, .wav, .mp3) in this folder
2. Godot will automatically import them
3. Reference them in scripts as: `load("res://assets/sounds/filename.ogg")`
4. Create AudioStreamPlayer nodes and assign the sound

## Recommended Sound Effects to Add

- `jump.ogg` - When player jumps
- `land.ogg` - When player lands
- `success.ogg` - When stage is completed
- `music_menu.ogg` - Main menu music
- `music_gameplay.ogg` - Gameplay background music
- `hit.ogg` - When player gets hit by obstacle
- `machine_gun.ogg` - Taco machine gun sound (for boss fight)