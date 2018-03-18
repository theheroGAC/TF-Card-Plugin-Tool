-------musicplayer_autoplaynextmusic_function-------------------------


------------自动播放下一首音乐-------------------
function musicplayer_autoplaynextmusic()
 
 --如果ftp启动中或音乐播放中，则保持设备息屏运行
 power_tick()
 --如果有音乐正在播放，且播放结束，则自动播放下一首
 if autoPlayMusicNext and playingSongSnd and not sound.looping(playingSongSnd) and sound.endstream(playingSongSnd) then
  if musicplayerInfo.list and #musicplayerInfo.list > 0 then
   if musicPlayMode == 1 then
	   if not playingSongInt then
	    playingSongInt = 0
	   end
    if not musicplayer_play_next_song() then
     autoPlayMusicNext = false
    end
   elseif musicPlayMode == 3 then
	   if not playingSongInt then
	    playingSongInt = 0
	   end
    if not musicplayer_play_next_song() then
     playingSongInt = 0
     if not musicplayer_play_next_song() then
      autoPlayMusicNext = false
     end
    end
   end
  end --if playingSongInt
 end --if autoPlayMusicNext

end










