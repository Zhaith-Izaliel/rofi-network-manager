# ronema - Rofi-Network-manager
A Network manager for Tiling Window Managers [i3/bspwm/awesome/etc] or not.

Inspired from [rofi-wifi-menu](https://github.com/zbaylin/rofi-wifi-menu).
## Table of Contents

- [Requirements](#requirements)
- [Features](#features)
- [Screenshots](#screenshots)
- [Config](#config)
- [Languages](#language-localization)
- [Download-Usage](#download-usage)
- [Installation](#installing-uninstalling-and-updating-ronema)
- [Themes](#themes)
- [Examples-Usage](#examples-usage)
- [To-Do](#to-do)

### Requirements

- **NetworkManager** (_nmcli_)
- [**rofi**](https://github.com/davatorium/rofi)
- **Notification Daemon** (_Optional_) (_For notifications_)
  - [notify-osd](https://launchpad.net/notify-osd)
  - [dunst](https://github.com/dunst-project/dunst)
  - [fnott](https://codeberg.org/dnkl/fnott)
- **nm-connection-editor** (_Optional_) (_For editing connections_)
- [**qrencode**](https://fukuchi.org/works/qrencode) (_Optional_) (_For sharing Wi-Fi with qr code_)

### Features

- Connect to an existing network.
- Disconnect from the network.
- Turn on/off Wi-Fi.
- Support for Multiple Wi-Fi devices.
  - Option to change between Wi-Fi devices when available.
- Manual Connection to a Access Point or a hidden one.
- Turn on/off Ethernet.
  - See when Ethernet is unavailable.
- Restart the network.
- Status
  - See devices Connection name and local IP.
- See Current Wi-Fi password and share it with a qr code.
- Connect to pre-configured VPNs.
- Change the default signal strength bars with anything you want.
- Support for language localization based on configuration file.

### Screenshots

![Desktop](docs/images/main.png)
![Options](docs/images/options.png)

### Config

<details> 
 <summary>ronema.conf</summary>


```
# Location
# +-----------+
# | 1 | 2 | 3 |
# | 8 | 0 | 4 |
# | 7 | 6 | 5 |
# +-----------+
#The grid represents the screen with the numbers indicating the location of the window.
#If you want the window to be in the upper right corner, set location to 3.
LOCATION=0
#This sets the anchor point for the window displaying the QR code.         
QRCODE_LOCATION=$LOCATION 
#X, Y Offset
#This sets the distance of the window from the edge of the screen on the X and Y axis.
Y_AXIS=0
X_AXIS=0
#Use notifications or not
#Values can be "true" or "false"
NOTIFICATIONS="false"
NOTIFICATIONS_ICONS="false"
#Location of qrcode wifi image
QRCODE_DIR="/tmp/"
#WIDTH_FIX_MAIN/WIDTH_FIX_STATUS 
#These values can be adjusted if the text doesn't fit or
#if there is too much space at the end when you launch the script.
#It will depend on the font type and size.
WIDTH_FIX_MAIN=1
WIDTH_FIX_STATUS=10
#Values can be "true" or "false"
#Set it to true, if the script outputs the signal strength with asterisks
#and you want  bars.
ASCII_OUT="false"
#Values can be "true" or "false"
#Set it to true if you want to use custom icons
#for the signal strength instead of the default ones.
CHANGE_BARS="false"
#Custom signal strength indicators
SIGNAL_STRENGTH_0="0"
SIGNAL_STRENGTH_1="1"
SIGNAL_STRENGTH_2="12"
SIGNAL_STRENGTH_3="123"
SIGNAL_STRENGTH_4="1234"
#Selection prefix
SELECTION_PREFIX="~"
#Language
LANGUAGE="english"
#Default theme
THEME="ronema.rasi"
```
</details>

<details>
  <summary>Configuring with Nix</summary>

  All of the above configuration fields are accessible directly in the Home-Manager module, like so:
  ```nix
  { lib, ... }:

  {
    programs.ronema = {
      enable = true;

      theme = {}; # Define a theme the same way you do it for Rofi. See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.theme

      languages = ./languages; # A directory containing the languages you want to add. This directory should contain at least the language used in `programs.ronema.settings.language` 

      icons = ./icons; # A direction containing the icons for ronema. The directory must be similar in names and formats to `src/icons`

      settings = {
        ascii_out = false;
        selection_prefix = "-";
        y_axis = 0;
      };
    };
  }
  ```

  #### Module Options


  ##### [`options.programs.ronema.enable`](#L19)

  Rofi NetworkManager applet

  **Type:** `boolean`

  **Default:** `false`

  **Example:** `true`

  ##### [`options.programs.ronema.package`](#L21)

  The ronema package to use.

  **Type:** `types.package`

  **Default:** `package`

  ##### [`options.programs.ronema.theme`](#L27)

  Define the theme using rofi rasi. See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.theme

  **Type:** `rofiHelpers.themeType`

  **Default:** `null`

  ##### [`options.programs.ronema.languages`](#L33)


  The path to a directory containing languages file for ronema.

  The directory should contain at least the language defined in `programs.ronema.settings.language`

  See: https://github.com/P3rf/rofi-network-manager/blob/master/src/languages/lang_file.example to learn how to make language files for ronema.


  **Type:** `types.path`

  **Default:** `"${package}/languages"`

  ##### [`options.programs.ronema.icons`](#L45)


  The path to a directory containing icons for ronema.

  The directory must contain the following icons in the same names and formats:
  - `alert.svg`
  - `change.svg`
  - `restart.svg`
  - `scanning.svg`
  - `vpn.svg`
  - `wait.svg`
  - `wifi-off.svg`
  - `wifi-on.svg`
  - `wired-off.svg`
  - `wired-on.svg`


  **Type:** `types.path`

  **Default:** `"${package}/icons"`

  ##### [`options.programs.ronema.settings.location`](#L66)


  Location:
  +-----------+
  | 1 | 2 | 3 |
  | 8 | 0 | 4 |
  | 7 | 6 | 5 |
  +-----------+
  The grid represents the screen with the numbers indicating the location of the window.
  If you want the window to be in the upper right corner, set location to 3.


  **Type:** `locationType`

  **Default:** `0`

  ##### [`options.programs.ronema.settings.qrcode_location`](#L81)


  This sets the anchor point for the window displaying the QR code.


  **Type:** `locationType`

  **Default:** `cfg.settings.location`

  ##### [`options.programs.ronema.settings.x_axis`](#L89)

  This sets the distance of the window from the edge of the
  screen on the X axis.

  **Type:** `types.int`

  **Default:** `0`

  ##### [`options.programs.ronema.settings.y_axis`](#L96)

  This sets the distance of the window from the edge of the
  screen on the Y axis.

  **Type:** `types.int`

  **Default:** `0`

  ##### [`options.programs.ronema.settings.notifications`](#L103)

  Use notifications or not.

  **Type:** `types.bool`

  **Default:** `false`

  ##### [`options.programs.ronema.settings.notifications_icons`](#L109)

  Use notifications icons or not.

  **Type:** `types.bool`

  **Default:** `false`

  ##### [`options.programs.ronema.settings.qrcode_dir`](#L115)

  Location of QRCode WiFi image.

  **Type:** `types.nonEmptyStr`

  **Default:** `"/tmp/"`

  ##### [`options.programs.ronema.settings.width_fix_main`](#L121)


  WIDTH_FIX_MAIN/WIDTH_FIX_STATUS
  These values can be adjusted if the text doesn't fit or
  if there is too much space at the end when you launch the script.
  It will depend on the font type and size.


  **Type:** `types.int`

  **Default:** `1`

  ##### [`options.programs.ronema.settings.width_fix_status`](#L132)


  WIDTH_FIX_MAIN/WIDTH_FIX_STATUS
  These values can be adjusted if the text doesn't fit or
  if there is too much space at the end when you launch the script.
  It will depend on the font type and size.


  **Type:** `types.int`

  **Default:** `10`

  ##### [`options.programs.ronema.settings.ascii_out`](#L143)


  Set it to true, if the script outputs the signal strength with asterisks
  and you want bars.


  **Type:** `types.bool`

  **Default:** `false`

  ##### [`options.programs.ronema.settings.change_bars`](#L152)


  Set it to true if you want to use custom icons
  for the signal strength instead of the default ones.


  **Type:** `types.bool`

  **Default:** `false`

  ##### [`options.programs.ronema.settings.theme`](#L167)


  The theme name for ronema.

  This option is automatically set when you defined your own theme with `programs.rofi.applets.ronema`.
  If you change it, your defined theme will not be applied.


  **Type:** `types.nonEmptyStr`

  **Default:**

  ```nix
  if cfg.theme != null
  then generatedThemeName
  else "ronema.rasi"
  ```

  ##### [`options.programs.ronema.settings.selection_prefix`](#L181)

  The selection prefix.

  **Type:** `types.nonEmptyStr`

  **Default:** `"~"`

  ##### [`options.programs.ronema.settings.language`](#L187)

  The language file to use.

  **Type:** `types.nonEmptyStr`

  **Default:** `"english"`

  ---
  *Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
  </details>

### Language Localization

To localize ronema to your preferred language:

1. **Create a New Language File**: Duplicate `lang_file.example` and rename it to match your language (e.g., `french.lang`).

2. **Translate Strings**: Open the new language file (`french.lang`) and translate all strings to your language.

3. **Save the File**: Save your translated language file in `/languages`.

4. **Select the Language**: In `ronema.conf`, set `LANGUAGE` to your language file's name (without extension).

### Download-Usage

```bash
git clone --depth 1 --branch master https://github.com/P3rf/rofi-network-manager.git
cd rofi-network-manager
./src/ronema
```

### Installing, Uninstalling, and Updating ronema

#### With setup.sh

To install ronema, run the following command:

```bash
./setup.sh install
```
> **Note:** This will only install ronema, not its dependencies. Please refer to the [Requirements](#requirements) section and ensure all dependencies are installed.

To uninstall ronema, you can use the following command:

```bash
./setup.sh uninstall [--remove_config]
```

The `--remove_config` flag is optional. If provided, it will remove the configuration files along with the program.

To update ronema, run:

```bash
./setup.sh update [--override_conf]
```

The `--override_conf` flag is optional. If provided, it will override the existing configuration file during the update process.

Configuration files will be located at `~/.config/ronema`.

#### With Nix

You can install ronema by directly referencing the flake in your configuration:

```nix
inputs = {
  # ---Snip---
  ronema = {
    url = "gitlab:P3rf/rofi-network-manager";
    # Optional, by default this flake follows nixpkgs-unstable.
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # ---Snip---
}
```

This flake provides an overlay for Nixpkgs, a package and a Home-Manager module.
They are respectively found in the flake as `inputs.ronema.overlays.default`, `inputs.ronema.packages.${system}.default` (Where `${system}` is either `x86_64-linux` or `aarch64-linux`) and `inputs.ronema.homeManagerModules.default`.

Here is a simple example on how to install both the overlay and the module in
your Home-Manager configuration:

```nix
outputs = inputs@{ ronema, ...}: {
  # replace 'joes-desktop' with your hostname here.
  nixosConfigurations.joes-desktop = home-manager.lib.homeManagerConfiguration {
    system = "x86_64-linux";
    modules = [
      ronema.homeManagerModules.default
      # Add your own modules here

      # Example to add the overlay to Nixpkgs:
      {
        nixpkgs = {
          overlays = [
            ronema.overlays.default
          ];
        };
      }
    ];
  };
};
```

### Themes

Rofi themes for ronema are located in the `src/themes` directory, or if installed, in `~/.config/ronema/themes`. Available themes at the moment are:

- `nord.rasi`
- `ronema_grey.rasi`
- `ronema.rasi`

You can create your own Rofi theme for ronema and set it in the configuration file (`ronema.conf`) by changing the `THEME` option.


### Examples-Usage

<details> 
 <summary>Polybar modules</summary>

```
[module/wireless-network]
type = internal/network
interface = wlan0
interval = 3.0
unknown-as-up = true
format-connected-background = ${colors.background}
format-connected-foreground = ${colors.foreground}
format-connected-padding = 1
format-connected = %{A1:ronema:}<ramp-signal> <label-connected>%{A}
label-connected = %essid%/%local_ip%
format-disconnected-background = ${colors.background}
format-disconnected-foreground = ${colors.foreground}
format-disconnected-padding = 1
format-disconnected = %{A1:ronema:}<label-disconnected>%{A}
label-disconnected =""
ramp-signal-0 = "󰤯"
ramp-signal-1 = "󰤟"
ramp-signal-2 = "󰤢"
ramp-signal-3 = "󰤥"
ramp-signal-4 = "󰤨"
ramp-signal-foreground = ${colors.white}
```

```
[module/wired-network]
type = internal/network
interface = eth0
interval = 3.0
format-connected-background = ${colors.background}
format-connected-foreground = ${colors.foreground}
format-connected-padding = 1
format-connected = %{A1:ronema:}<label-connected>%{A}
label-connected =  %local_ip%
format-disconnected-background = ${colors.background}
format-disconnected-foreground = ${colors.foreground-alt}
format-disconnected-padding = 1
format-disconnected = %{A1:ronema:}<label-disconnected>%{A}
label-disconnected ="󰌺"
```
</details>

### To-Do

- [x] Fix notifications
- [x] Add notifications icons
- [x] Support for multiple Wi-Fi devices
- [ ] Add Hotspot support
- [x] Share Wi-Fi password with qr code inside Rofi
- [x] Find a way to manage duplicate Access Points
