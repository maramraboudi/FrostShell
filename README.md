# ❄ FrostShell

**A little Christmas magic in your terminal.**

FrostShell is a lightweight Christmas-inspired terminal theme for Windows and Linux. It adds a festive prompt, Git branch/status hints, seasonal commands, and a matching Windows Terminal color scheme—without replacing your shell.

![Christmas theme](https://img.shields.io/badge/theme-Christmas-178B57?style=for-the-badge) ![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20Linux-23395d?style=for-the-badge) ![License](https://img.shields.io/badge/license-MIT-gold?style=for-the-badge)

## Preview

The prompt and tree use multiple console colors on a dark-blue winter-night background:

The CMD theme uses a black night sky, colored ASCII snowfall, a large lit tree, a Christmas greeting sign, and an interactive colored prompt. Each launch and `frost` command twinkles the lights.

## Features

- A colored ASCII Christmas tree with lights that twinkle at startup and when you run `frost`.
- Evergreen branches, multicolor ornaments, a gold star and trunk, and a time-of-day greeting.
- A session-only winter-night background and Christmas-colored PowerShell syntax highlighting.
- Prompt shows the current folder, clock, Git branch and working-tree state.
- ASCII tree works in Windows PowerShell 5.1 and classic Windows console fonts.
- `frost`, `frost-help`, and `frost-greet` commands.
- PowerShell, CMD, Bash and Zsh support; optional Windows Terminal color scheme.
- Installers back up shell profiles before editing them.
- No external dependencies, administrator/root privileges, or network calls.

## Installation

### Windows PowerShell

Windows PowerShell 5.1 is included with Windows; PowerShell 7 (`pwsh`) is optional. Install Git for Windows, then open a regular PowerShell window (do not start in `C:\Windows\System32`) and clone the repository into your user folder:

```powershell
Set-Location $HOME
git clone https://github.com/maramraboudi/FrostShell.git
Set-Location "$HOME\FrostShell"
```

To update a clone you already have, go to its folder and pull instead:

```powershell
Set-Location "$HOME\FrostShell"
git pull
```

Load the theme into the current window and try its commands:

```powershell
. .\windows\FrostShell.ps1
frost
frost-help
frost-greet
```

The dot and space before the script path are important: they load the functions into the current PowerShell session. To enable FrostShell automatically in new PowerShell windows, run:

```powershell
.\install.ps1
```

If Windows blocks a script, run `Set-ExecutionPolicy -Scope Process Bypass` in that PowerShell window only, then retry. Restart PowerShell to check the persistent installation. To remove the loader later, run this from the repository folder:

```powershell
.\uninstall.ps1
```

### Linux Bash or Zsh

```bash
chmod +x install.sh uninstall.sh
./install.sh
```

Restart the terminal. To uninstall:

```bash
./uninstall.sh
```

The installer detects the current shell, backs up `.bashrc` or `.zshrc`, and adds one source line.

### Windows Terminal colors

1. Open Windows Terminal Settings and select **Color schemes**.
2. Add the contents of `windows/FrostShell-ColorScheme.json` to the `schemes` array in `settings.json`.
3. Select **FrostShell** in your PowerShell profile's Appearance settings.

### Windows CMD (interactive Christmas theme)

In CMD, `%USERPROFILE%` is the Windows home-folder variable (`$HOME` is PowerShell syntax). If you are currently in `C:\Windows\System32`, go to your user folder before cloning:

```cmd
cd /d "%USERPROFILE%"
git clone --branch main https://github.com/maramraboudi/FrostShell.git
cd /d "%USERPROFILE%\FrostShell"
```

Start the festive CMD session with:

```cmd
call windows\FrostShell.cmd
```

The launcher switches to the repository folder, uses a black background for the current console window, shows the animated tree and greeting, then leaves you at an interactive colored prompt. In that same CMD window, use:

```cmd
frost
frost-tree
frost-greet
frost-help
```

These are DOSKEY aliases active in that CMD session. The background and prompt changes are temporary; close the window to restore your usual colors. Use Windows Terminal for the best emoji and color support.

To update later, run `git pull` from `%USERPROFILE%\FrostShell`, then call `windows\FrostShell.cmd` again.

To try the same theme in PowerShell, use `Set-Location "$HOME\FrostShell"` and then `. .\windows\FrostShell.ps1`. The theme changes the background and syntax colors only in that PowerShell session.

## Commands

| Command | Description |
|---|---|
| `frost` | Display the greeting and current Git context |
| `frost-help` | List FrostShell commands |
| `frost-greet` | Print a seasonal greeting |

## Customize

- Edit the palette in `windows/FrostShell-ColorScheme.json`.
- Change the tree in `windows/FrostShell.ps1` or the banner in `linux/frostshell.sh`.
- Git integration is optional; the prompt still works without Git.

## Safety

FrostShell changes only the interactive prompt and adds a loader line to your shell profile. It does not run as administrator/root, install packages, change Git settings, or modify system-wide variables. Review scripts before running them. Timestamped profile backups are retained after uninstall.

## Troubleshooting

- **CMD prompt colors do not appear:** use Windows Terminal or another ANSI-capable console; CMD prompt colors depend on terminal support.
- **Git branch is missing:** install Git and ensure it is in `PATH`.
- **Prompt did not change:** restart the shell and check that the FrostShell loader line exists in your profile/rc file.

## Roadmap

- [ ] Add real PowerShell, Bash and Windows Terminal screenshots.
- [ ] Optional animated snowfall for compatible terminals.
- [ ] Starship preset.
- [ ] More seasonal palettes and shell syntax checks in CI.

## Contributing

Issues and pull requests are welcome. Test changes in a fresh shell and avoid system-wide settings. See [CONTRIBUTING](docs/CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).
