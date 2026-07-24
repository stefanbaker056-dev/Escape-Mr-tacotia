# Escape Mr. Taqueria - Audio Assets

This folder contains all sound effects and music for the game.

## Sound Effects & Music

### Death Sounds
- `death.ogg` - Played when player dies (falls in lava, hit by obstacle, etc.)

### Movement Sounds
- `jump.ogg` - Played when player jumps
- `land.ogg` - Played when player lands on a platform

### Stage Sounds
- `success.ogg` - Played when player completes a stage

### Background Music
- `music_gameplay.ogg` - Background music during gameplay

## How to Add Sounds

1. Place your audio files (.ogg, .wav, .mp3) in this folder
2. Godot will automatically import them
3. Reference them in scripts as: `load("res://assets/sounds/filename.ogg")`
4. Create AudioStreamPlayer nodes and assign the sound

## Sound File Specifications

For best results, use these specifications:
- **Format:** .ogg (Vorbis codec) - smallest file size, best quality
- **Sample Rate:** 44100 Hz
- **Channels:** Mono (for 3D effects) or Stereo
- **Bitrate:** 128 kbps

## Recommended Sounds to Add

- ✅ `death.ogg` - DONE
- ✅ `jump.ogg` - DONE
- ✅ `land.ogg` - DONE
- ✅ `success.ogg` - DONE
- ⏳ `music_gameplay.ogg` - Needs to be added
- ⏳ `hit.ogg` - When player gets hit by obstacle
- ⏳ `machine_gun.ogg` - Taco machine gun sound (for boss fight)
- ⏳ `music_boss.ogg` - Boss fight music

## Free Sound Resources

Find free sounds at:
- **freesound.org** - Large collection of free sounds
- **zapsplat.com** - Free sound effects and music
- **opengameart.org** - Open source game audio
- **incompetech.com** - Royalty-free music
- **pixabay.com/sounds** - Free sound effects