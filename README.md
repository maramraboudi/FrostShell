# ❄ FrostShell

**A little Christmas magic in your terminal.**

FrostShell is a lightweight Christmas-inspired terminal theme for Windows and Linux. It adds a festive prompt, Git branch/status hints, seasonal commands, and a matching Windows Terminal color scheme—without replacing your shell.

![Christmas theme](https://img.shields.io/badge/theme-Christmas-178B57?style=for-the-badge) ![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20Linux-23395d?style=for-the-badge) ![License](https://img.shields.io/badge/license-MIT-gold?style=for-the-badge)

## Preview

```text
       *       .        ❄
   .      F R O S T S H E L L      *
        ✦  season's greetings  ✦

  ❄  ~/projects/winter-app   main
  15:42:08  ✦ working tree clean

  ❯
```

## Features

- Evergreen, cranberry, warm-gold and snow-white palette.
- Seasonal startup banner and greeting commands.
- Prompt shows current folder, clock and Git branch when Git is available.
- Git working-tree hint (`● changes` or `✓ clean`).
- `frost`, `frost-help`, and `frost-greet` commands.
- PowerShell, Bash and Zsh support; optional Windows Terminal color scheme.
- Installers back up shell profiles before editing them.
- No external dependencies, administrator/root privileges, or network calls.

## Installation

### Windows PowerShell

Open PowerShell in the extracted project directory:

```powershell
.\install.ps1
```

If Windows blocks the script, run `Set-ExecutionPolicy -Scope Process Bypass` in that PowerShell window only, then retry. Restart PowerShell. To preview without installing:

```powershell
. .\windows\FrostShell.ps1
frost
```

Uninstall the loader line with:

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

### Windows CMD (basic)

CMD has fewer customization features. For a simple festive session:

```cmd
color 0A
prompt $E[38;5;220m🎄 $P$G$E[0m
```

This is session-only. For the full interactive experience, use PowerShell 7 in Windows Terminal.

## Commands

| Command | Description |
|---|---|
| `frost` | Display the Christmas banner |
| `frost-help` | List FrostShell commands |
| `frost-greet` | Print a seasonal greeting |

## Customize

- Edit the palette in `windows/FrostShell-ColorScheme.json`.
- Change the banner in `windows/FrostShell.ps1` or `linux/frostshell.sh`.
- Git integration is optional; the prompt still works without Git.
- A Unicode-capable font such as Cascadia Code is recommended for symbols.

## Safety

FrostShell changes only the interactive prompt and adds a loader line to your shell profile. It does not run as administrator/root, install packages, change Git settings, or modify system-wide variables. Review scripts before running them. Timestamped profile backups are retained after uninstall.

## Troubleshooting

- **Icons look like boxes:** choose a Unicode-capable font in your terminal settings.
- **Colors look different:** use a terminal with ANSI true-color support; apply the included Windows Terminal scheme on Windows.
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
