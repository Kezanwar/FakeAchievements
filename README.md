# Achievement Faker

A fun World of Warcraft Classic addon that lets you send fake achievement messages to chat channels. Perfect for pranking your guildmates or just having a laugh!

## Features

- 🎭 **Custom Achievements** - Create your own ridiculous achievements
- 💾 **Save Your Favorites** - Automatically saves achievements you send for quick reuse
- 🎯 **Target Support** - Quickly use your current target's name
- 📢 **Multiple Channels** - Send to Say, Yell, Party, Raid, Guild, or Officer chat
- 🗑️ **Easy Management** - Remove saved achievements with a single click
- 💻 **Cross-Platform** - Works on Windows, Mac, and Linux

## Installation

### Manual Installation

1. Download or clone this repository
2. Locate your WoW Classic AddOns folder:
   - **Windows**: `C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\`
   - **Mac**: `/Applications/World of Warcraft/_classic_/Interface/AddOns/`
   - **Linux**: `~/.wine/drive_c/Program Files (x86)/World of Warcraft/_classic_/Interface/AddOns/`
3. Copy the entire `AchievementFaker` folder into the AddOns directory
4. Restart WoW or type `/reload` in-game

### Via Git

```bash
cd "YOUR_WOW_ADDONS_FOLDER"
git clone https://github.com/yourusername/AchievementFaker.git
```

## Usage

### Opening the Addon

Type `/achfake` in chat to open the Achievement Faker window.

### Sending an Achievement

1. **Select Channel** - Choose where you want to send the message (Guild, Party, Raid, etc.)
2. **Set Player Name** (optional)
   - Leave empty to use your own name
   - Type a name manually
   - Or click "Use Target" to auto-fill your current target's name
3. **Create Achievement**
   - Type your achievement text in the "Custom Achievement" box
   - Press Enter or click "Send"
4. **Reuse Saved Achievements**
   - Click any saved achievement button to send it again
   - Click the "X" button to remove achievements you don't want

## Commands

- `/achfake` - Toggle the Achievement Faker window

## Compatibility

- **Classic Era** (Level 60)
- **Wrath Classic** (Level 80)
- **Cataclysm Classic** (Level 85)
- **Season of Discovery**

_Note: You may need to update the Interface version in the `.toc` file to match your game version._

## Updating Interface Version

If the addon doesn't load, you may need to update the interface version:

1. Open `AchievementFaker.toc` in a text editor
2. Change the `## Interface:` line to match your game version:
   - Classic Era: `11503`
   - Wrath Classic: `30403`
   - Cataclysm Classic: `40400`
3. Save and `/reload` in-game

## FAQ

**Q: Will this get me banned?**  
A: No, this addon only sends regular chat messages. It's purely for fun and doesn't modify game mechanics or break ToS.

**Q: Can other players tell it's fake?**  
A: Yes! The message format is different from real achievements. Anyone paying attention will know it's a joke. Use responsibly!

**Q: Can I add multiple achievements at once?**  
A: Not currently, but you can quickly send multiple by clicking saved achievements or typing new ones.

**Q: My guild doesn't find this funny...**  
A: Maybe try the Party channel instead? 😅

## Contributing

Feel free to submit issues or pull requests! Ideas for improvements:

- Random achievement button
- Import/export achievement lists
- Achievement categories
- More customization options

## License

MIT License - Feel free to modify and distribute!

## Credits

Created by Kez

---

**Disclaimer**: This addon is for entertainment purposes only. Use it responsibly and don't spam your guild chat too much! 😄
