setxkbmap -option caps:escape
xset r rate 300 80
/usr/bin/amixer -c 0 sset "Auto-Mute Mode" Enabled
feh --bg-scale ~/Pictures/wallpapers/camera3.jpg
dwmblocks &
mpd ~/.mpdconf_pipewire &
blueman-applet &
volumeicon &
nm-applet &
picom --no-fading-openclose &
redshift -l '53.258949:-1.913020' &
exec dwm
