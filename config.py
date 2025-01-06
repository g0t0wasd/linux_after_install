# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os

from libqtile import bar, layout, qtile, widget
from libqtile.command import lazy
from libqtile.config import (
        Click, Drag, Group, Key, Match, Screen, EzKey, KeyChord
)
from subprocess import run
from datetime import datetime
from widgets import stocks


mod = "mod4"
alt = "mod1"
terminal = "st"
home = os.path.expanduser('~')


def take_screenshot(partial=False):
    def f(qtile):
        cur_time = datetime.now()
        filename = cur_time.strftime("%Y-%m-%d-%H:%M:%S")
        path = home + "/Pictures/screenshots/{filename}.png".format(
                     filename=filename)
        command = ['maim', path]
        if partial:
            command.append('-s')
        run(command)
        run(['notify-send', f"Saved picture to {path}"])
    return f


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "k",
        lazy.layout.up()
    ),
    Key(
        [mod], "j",
        lazy.layout.down()
    ),
    # Resize layout
    Key(
        [mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
    ),
    Key(
        [mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
    ),
    Key(
        [mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
    ),
    Key(
        [mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
    ),
    # Move windows up or down in current stack
    Key(
        [mod, "control"], "j",
        lazy.layout.shuffle_down()
    ),
    Key(
        [mod, "control"], "k",
        lazy.layout.shuffle_up()
    ),

    # Switch window focus to other pane(s) of stack
    Key(
        [mod], "space",
        lazy.layout.next()
    ),

    # Swap panes of split stack
    Key(
        [mod, "shift"], "space",
        lazy.next_screen()
    ),

    Key([mod], "comma", lazy.function(switch_screens)),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split()
    ),
    Key([mod], "Return", lazy.spawn(terminal)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    EzKey("M-w", lazy.window.kill()),
    # Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod, 'shift'], 'q', lazy.spawn('shutdown -h 0')),
    Key([mod], "r", lazy.spawn("dmenu_run -m 0")),
    Key([mod], 'F1', lazy.window.toggle_fullscreen()),
    Key([mod], 'F2', lazy.window.toggle_floating()),
    KeyChord([mod], "e", [
        Key([], "t", lazy.spawn(terminal + " -e nvim " + home + "/org/todo.org")),
        Key([], "b", lazy.spawn(terminal + " -e nvim " + home + "/org/books.org")),
        Key([], "w", lazy.spawn(terminal + " -e nvim " + home + "/org/week.org")),
        Key([], "i", lazy.spawn(terminal + " -e nvim " + home + "/org/ideas.org")),
        Key([], "c", lazy.spawn(terminal + " -e nvim " + home + "/.config/qtile/config.py")),
        Key([], "e", lazy.spawn(terminal + " -e nvim " + home + "/org/encyclopedia/")),
    ]),
    Key([mod], 'f', lazy.spawn('firefox')),
    Key([mod], 'a', lazy.spawn("aoutset")),
    Key([mod], 'l', lazy.spawn("libreoffice /home/wasd/Documents/Finance.ods")),
    Key([mod], 'c', lazy.spawn("libreoffice /home/wasd/Documents/JobSearch.ods")),
    Key([mod], 'd', lazy.spawn("dbeaver")),
    Key([mod], 'm', lazy.spawn("dmenumount")),
    Key([mod], 'u', lazy.spawn("dmenuumount")),
    Key([alt], 'Shift_L', lazy.widget['keyboardlayout'].next_keyboard()),
    Key([], 'Print', lazy.function(take_screenshot())),
    Key(['shift'], 'Print', lazy.function(take_screenshot(partial=True))),
    # Allow changing volume the old fashioned way.
    # Key([mod], "equal", lazy.spawn("amixer -c 1 -q set Speaker 2dB+")),
    # Key([mod], "minus", lazy.spawn("amixer -c 1 -q set Speaker 2dB-")),
    Key([mod], 'equal', lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%")),
    Key([mod], 'minus', lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%")),
]

group_names = [
    ("", {}),
    ("", {'matches': [Match(wm_class=['firefox'])]}),
    ("", {'matches': [Match(wm_class=['slack'])]}),
    # ("", {'matches': [Match(wm_class=['Tor Browser'])]}),
    ("", {'matches': [Match(wm_class=['DBeaver', 'Java', 'MongoDB Compass'])]}),
    ("", {}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    # mod1 + letter of group = switch to group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

layouts = [
    layout.MonadTall(margin=5, border_focus="#8ec07c", border_normal="000000"),
    layout.Max(),
]

widget_defaults = dict(
    font='Hack Nerd Font Mono',
    fontsize=14,
    padding=5,
)


colors = [
            ["#2F343F", "#2F343F"],  # 0 dark gray
            ["#c0c5ce", "#c0c5ce"],  # 1 light gray
            ["#fba922", "#fba922"],  # 2 orange
            ["#3384d0", "#3384d0"],  # 3 blue
            ["#f3f4f5", "#f3f4f5"],  # 4 beige
            ["#cd1f3f", "#cd1f3f"],  # 5 red
            ["#62FF00", "#62FF00"],  # 6 lime
            ["#6790eb", "#6790eb"],  # 7 violet
            ["#a9a9a9", "#a9a9a9"],  # 8 gray
            ["#000000", "#000000"],  # 9 black
            ["#FFFFFF", "#FFFFFF"],  # 10 white
            ["#FABD3F", "#FABD3F"],  # 11 bright yellow
            ["#d79921", "#d79921"],  # 12 dark yellow
            ["#282828", "#282828"],  # 13 bg - darkish
            ["#928374", "#928374"],  # 14 gray
            ["#cc241d", "#cc241d"],  # 15 dark red
            ["#fb4934", "#fb4934"],  # 16 light red
            ["#98971a", "#98971a"],  # 17 dark green
            ["#b8bb26", "#b8bb26"],  # 18 light green
            ["#458588", "#458588"],  # 19 blue
            ["#83a598", "#83a598"],  # 20 pale blue
            ["#b16286", "#b16286"],  # 21 purple
            ["#d3869b", "#d3869b"],  # 22 pale purple
            ["#689d6a", "#689d6a"],  # 23 aqua dark
            ["#8ec07c", "#8ec07c"],  # 24 aqua light
            ["#a89984", "#a89984"],  # 25 gray light
            ["#ebdbb2", "#ebdbb2"],  # 26 fg (dark beige)
            ["#928374", "#928374"],  # 27 gray darker
            ["#d65d0e", "#d65d0e"],  # 28 orange dark
            ["#fe8019", "#fe8019"],  # 29 orange light
            ["#282828", "#282828"],  # 30 bg2
    ]

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    font="Nerd Hack Font Mono",
                    fontsize=20,
                    borderwidth=5,
                    highlight_method="block",
                    rounded=False,
                    active=colors[10],
                    inactive=colors[8],
                ),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.CurrentLayout(
                    font="Hack",
                    foreground=colors[10],
                ),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.WindowName(),

                # widget.Pomodoro(),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.TextBox(
                    text="  ",
                    foreground=colors[10],
                    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(
                        terminal + " -e nvim " + home + "/.config/qtile/config.py")},
                    fontsize=25,
                    padding=-10
                ),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.Systray(),
                widget.KeyboardLayout(configured_keyboards=['us', 'ru', 'ua']),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.ThermalSensor(
                    font="Hack",
                    fontsize=14,
                    fmt='{}',
                    foreground=colors[10],
                    threshold=50,
                    padding=5,
                    foreground_alert="#ff0000"
                ),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.TextBox(
                    font="Hack",
                    text=" 墳 ",
                    foreground=colors[10],
                    padding=-10,
                    fontsize=25
                ),
                widget.Volume(
                    cardid=1,
                    channel='Speaker',
                    device=None,
                    mute_command="pactl set-sink-mute @DEFAULT_SINK@ toggle",
                    volume_up_command="",
                    volume_down_command="",
                    get_volume_command="amixer -c 0 -M -D pulse get Master | grep -o -E '[0-9]+%' | sed 1q",
                    check_mute_command="amixer -c 0 -M -D pulse get Master | grep -Eo '\[(on|off)]' | sed q1",
                ),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[12],
                ),
                widget.TextBox(
                    font="Hack Nerd Font Mono",
                    text="  ",
                    foreground=colors[10],
                    padding=-10,
                    fontsize=20
                ),
                widget.Clock(format='%Y/%m/%d %a %H:%M',
                             mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(terminal + " -e calcurse")},
                             font="Hack"
                             ),
                stocks.StocksCount(),
            ],
            30,
            background=colors[13]
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    font="Hack Nerd Font Mono",
                    fontsize=20,
                    borderwidth=5,
                    highlight_method="block",
                    rounded=False,
                    active=colors[10],
                    inactive=colors[8]
                ),
                widget.Clock(format='%Y/%m/%d %a %H:%M',
                             fontsize=20,
                             foreground='#006666',
                             background=colors[10],
                             ),
                widget.WindowName(),
            ],
            30,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
# cursor_warp = True
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True
focus_on_window_activation = "smart"
extentions = []

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

os.system("bash ~/.config/qtile/autostart.sh")
