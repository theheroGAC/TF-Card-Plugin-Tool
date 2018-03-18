-------musicplayer_button_setting_function-------------------------------------------------------------------

function musicplayer_button_setting()
 
 buttons.read() --读取按键

 ---------------select键设置-------------------------
 if buttons.select then
 
  ftp_server()
  
 end --select键设置
 
 -------------------↑键设置-------------------------------
 if buttons.up or buttons.analogly < -60 then
  
  if musicplayerInfo.list and #musicplayerInfo.list > 0 then
   --光标向上移动
   if musicplayerInfo.focus > 1 then
    musicplayerInfo.focus -= 1
   end
	 end
	 
	end --if buttons.up
     
 -------------------↓键设置-------------------------------
 if buttons.down or buttons.analogly > 60 then
  
  if musicplayerInfo.list and #musicplayerInfo.list > 0 then
   --光标向下移动
   if musicplayerInfo.focus < #musicplayerInfo.list then
    musicplayerInfo.focus += 1
   end
	 end
	 
	end --if buttons.down

 -------------------L键设置-------------------------------
 if buttons.l then
 
  if musicplayerInfo.list and #musicplayerInfo.list > 0 then --上一首
   --播放上一首
   musicplayer_play_previous_song()
   --musicplayer_get_music_cover()
   if musicPlayMode == 2 and not sound.looping(playingSongSnd) then
    sound.loop(playingSongSnd)
   end
   autoPlayMusicNext = true
	 end
	 
	end --if buttons.l
     
 -------------------R键设置-------------------------------
 if buttons.r then
 
  if musicplayerInfo.list and #musicplayerInfo.list > 0 then --下一首
   --播放下一首
   musicplayer_play_next_song()
   --musicplayer_get_music_cover()
   if musicPlayMode == 2 and not sound.looping(playingSongSnd) then
    sound.loop(playingSongSnd)
   end
   autoPlayMusicNext = true
	 end
	 
	end --if buttons.r

 -----------------start键设置-------------------------
 if buttons.start then
  
  power.display(0) --息屏
 
 end --if buttons.start

 --------------------X键设置----------------------
 if buttons.cross then
 
  musicplayerRun = false --退出
 
 end --buttons.cross
 
 --------------------△键设置-------------------------------
 if buttons.triangle then
 
  if musicplayerInfo.list and #musicplayerInfo.list > 0 then --播放模式
   if musicPlayMode == 1 then
    --单曲循环
    musicPlayMode = 2
    if playingSongSnd and not sound.looping(playingSongSnd) then
     sound.loop(playingSongSnd)
    end
    autoPlayMusicNext = false
   elseif musicPlayMode == 2 then
    --循环播放
    musicPlayMode = 3
    if playingSongSnd and sound.looping(playingSongSnd) then
     sound.loop(playingSongSnd)
    end
    autoPlayMusicNext = true
   elseif musicPlayMode == 3 then
    --顺序播放
    musicPlayMode = 1
    if playingSongSnd and sound.looping(playingSongSnd) then
     sound.loop(playingSongSnd)
    end
    autoPlayMusicNext = true
   end
  end
  
 end --if buttons.triangle
 
 --------------------□键设置-------------------------------
 if buttons.square then
  
  if playingSongSnd then --播放/暂停
   --播放/暂停
   if sound.endstream(playingSongSnd) then
    sound.play(playingSongSnd)
   else
    sound.pause(playingSongSnd)
   end
  elseif musicplayerInfo.list and #musicplayerInfo.list > 0 and files.exists(musicplayerInfo.list[musicplayerInfo.focus].path) then
   --播放新曲
   playingSongSnd = sound.load(musicplayerInfo.list[musicplayerInfo.focus].path)
   playingSongInt = musicplayerInfo.focus
   sound.play(playingSongSnd)
   --musicplayer_get_music_cover()  
  end
  if musicPlayMode == 2 and not sound.looping(playingSongSnd) then
   sound.loop(playingSongSnd)
  end
  autoPlayMusicNext = true
  
 end --if buttons.square

 -------------------○键设置-------------------------------
 if buttons.circle then 
  
  if musicplayerInfo.list and #musicplayerInfo.list > 0 and files.exists(musicplayerInfo.list[musicplayerInfo.focus].path) then
   if playingSongSnd and musicplayerInfo.focus == playingSongInt then
    --暂停/播放
    if sound.endstream(playingSongSnd) then
     sound.play(playingSongSnd)
    else
     sound.pause(playingSongSnd)
    end
   else
    --播放新曲
    if playingSongSnd and sound.playing(playingSongSnd) then
     sound.stop(playingSongSnd)
    end
    playingSongSnd = sound.load(musicplayerInfo.list[musicplayerInfo.focus].path)
	   playingSongName = musicplayerInfo.list[musicplayerInfo.focus].nameNoExt
    playingSongInt = musicplayerInfo.focus
    sound.play(playingSongSnd)
    --musicplayer_get_music_cover()
    if musicPlayMode == 2 and not sound.looping(playingSongSnd) then
     sound.loop(playingSongSnd)
    end
   end
  end
  autoPlayMusicNext = true
  
 end --if buttons.circle

end














