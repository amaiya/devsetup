# How to Setup WSL

1. Install WSL (start Command Prompt as Adminstrator): `wsl --install`
2. Install [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=en-us&gl=US)
3. Disable Terminal Bell in Settings of Windows Terminal
4. Add support for tab-switching in Windows Terminal JSON with:
  - `{ "command": "nextTab", "keys": "ctrl+pgdn" }`
  - `{ "command": "prevTab", "keys": "ctrl+pgup" }`
5. [OPTIONAL[ Edit Windows Terminal JSON to disable Ctrl-V paste (comment out or remove)
6. Install Mamba/Conda:
  - `wget https://raw.githubusercontent.com/amaiya/devsetup/main/setup-conda.sh`
  - `bash setup-conda.sh`
7. workplace setup:  Extra steps may be needed to install SSL certificates
