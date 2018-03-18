-------------musicplayer_graphics------------------------------------------------------------------------


---------------------界面构画----------------------------------------------------------------------
function musicplayer_graphics()
 
 if back then back:blit(0,0) end
 --播放列表标题
 local name_y = MAIN_TITLE_HEIGHT + 8
 screen.print(720, name_y, MUSIC_PLAYER_PLAYLIST.." ("..#musicplayerInfo.list..")", 1, color.white, color.black, __ACENTER, 460)
 --mp3封面
 local cover_y = name_y + screen.textheight(1) + 8
 image.blit(cover, 53, cover_y)
 musicplayerButtonTextList[1] = MUSIC_PLAYER_BUTTON_PLAY
 
 --滚动条背景
 local progressbarBK_x = 30
 local progressbarBK_y = 478
 draw.fillrect(progressbarBK_x, progressbarBK_y, musicplayer_progressbarBK_w, musicplayer_progressbarBK_h, COLOR_STATUS_BAR_BACKGROUND) 
 --播放时间
 local musicPlayingTime = "00:00:00"
 if playingSongSnd then
  --当前播放音乐名
  if playingSongName then
   screen.print(240, name_y, playingSongName, 1, color.green, color.black, __ACENTER, 460)
  else
   screen.print(240, 50, "BGM", 1, color.green, color.black, __ACENTER, 460)
  end
  musicPlayingTime = tostring(sound.time(playingSongSnd))
  --播放进度条
  local musicPlayingPercent = sound.percent(playingSongSnd)
  --滚动条
  local progressbar_x = progressbarBK_x
  local progressbar_y = progressbarBK_y
  musicplayer_progressbar_w = musicplayer_progressbar_one_w*musicPlayingPercent
  draw.fillrect(progressbar_x, progressbar_y, musicplayer_progressbar_w, musicplayer_progressbar_h, color.green)     

  if sound.playing(playingSongSnd) then
   musicplayerButtonTextList[1] = MUSIC_PLAYER_BUTTON_PARSE
  end
 end
 --播放时间
 screen.print(30, 448, musicPlayingTime, 1, color.white, color.black)
 --播放模式
 screen.print(480-30, 448, playModeTextList[musicPlayMode], 1, color.green, color.black, __ARIGHT)
 --播放列表
 local list_y_interval = musicplayer_list_y_interval
 local list_y_first = cover_y
 local list_y = list_y_first
 --如果列表不为空
 if musicplayerInfo.list and #musicplayerInfo.list > 0 then
  --列表显示行数
  local listShowCount = musicplayerListShowCount
	 --获得顶部序号
	 if musicplayerInfo.top > musicplayerInfo.focus then
	  musicplayerInfo.top = musicplayerInfo.focus
  elseif musicplayerInfo.top < musicplayerInfo.focus - (listShowCount-1) then
   musicplayerInfo.top = musicplayerInfo.focus - (listShowCount-1)
  end
  --获得底部序号
  local bottom = #musicplayerInfo.list
  if bottom > musicplayerInfo.top + (listShowCount-1) then
   bottom = musicplayerInfo.top + (listShowCount-1)
  end
  for i = musicplayerInfo.top, bottom do
   --文件图标
   if musicIcon then image.blit(musicIcon, 480, list_y) end
   --文件名称
   local showMusicNameWidth = 426
   if oldMusicplayerInfoPos ~= musicplayerInfo.focus then
    oldMusicplayerInfoPos = musicplayerInfo.focus
    musicplayerMusicName_x = musicplayerMusicName_default_x
   end
   if i == musicplayerInfo.focus then
    if screen.textwidth(musicplayerInfo.list[i].nameNoExt) > showMusicNameWidth then
     musicplayerMusicName_x = screen.print(musicplayerMusicName_x, list_y, musicplayerInfo.list[i].nameNoExt, 1, COLOR_FOCUS, color.black, __SLEFT, showMusicNameWidth)
    else
     screen.print(musicplayerMusicName_x, list_y, musicplayerInfo.list[i].nameNoExt, 1, COLOR_FOCUS, color.black, __ALEFT, showMusicNameWidth)
    end
   else
    if playingSongInt and i == playingSongInt then
     screen.print(musicplayerMusicName_x, list_y, musicplayerInfo.list[i].nameNoExt, 1, color.green, color.black, __ALEFT, showMusicNameWidth)
    else
     screen.print(musicplayerMusicName_x, list_y, musicplayerInfo.list[i].nameNoExt, 1, color.white, color.black, __ALEFT, showMusicNameWidth)
    end
   end --if i == musicplayerInfo.focus
   list_y += (screen.textheight(1) + list_y_interval)
  end --for i = musicplayerInfo.top
  --滚动条
	 if #musicplayerInfo.list > musicplayerListShowCount then
   local scrollbarBK_x = 960 - musicplayer_scrollbarBK_w - 6
   local scrollbarBK_y = list_y_first
   local scrollbar_x = scrollbarBK_x
   local scrollbar_y = scrollbarBK_y
   if musicplayerInfo.top > 1 then
    if musicplayerInfo.focus == #musicplayerInfo.list then
     scrollbar_y = scrollbarBK_y + musicplayer_scrollbarBK_h - musicplayer_scrollbar_h
    else
     scrollbar_y = scrollbarBK_y + (musicplayer_scrollbarOne_h*(musicplayerInfo.top - 1))
    end
   end
   --滚动条背景
   draw.fillrect(scrollbarBK_x, scrollbarBK_y, musicplayer_scrollbarBK_w, musicplayer_scrollbarBK_h, COLOR_STATUS_BAR_BACKGROUND) 
   --滚动条
   draw.fillrect(scrollbar_x, scrollbar_y, musicplayer_scrollbar_w, musicplayer_scrollbar_h, COLOR_SCROLL_BAR)     
  end
 else
  screen.print(480, list_y, MUSIC_PLAYER_SONG_NOFOUND, 1, color.red, color.black)
 end --if #musicplayerInfo.list > 0
 --标题状态栏
 titleShow(MUSIC_PLAYER)
 --按键栏
 buttonShow(musicplayerButtonTextList)
 --刷新页面
 screen.flip()

end













