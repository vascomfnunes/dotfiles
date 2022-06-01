function tv --wraps=mpv --description 'alias tv=mpv <tv-m3u-list>'
  mpv http://192.168.1.128:9981/playlist/channels.m3u;
end
