----musicplayer_functions_function.lua---------------------------------------------------------


-----------------获取取音乐列表---------------------
function musicplayer_get_music_list(path)
	
	musicplayerInfo.list = {}
	local tmpList = files.listfiles(path)
	if tmpList then
		table.sort(tmpList, function(a,b) return string.lower(a.name) < string.lower(b.name) end)
 	local j = 0
 	local getPlayingSongInt = false
		for s,t in pairs(tmpList) do
			if t.ext then
			 if t.ext == "mp3" or t.ext == "ogg" or t.ext == "wav" then
			  --t.size = files.sizeformat(t.size)
			  t.nameNoExt = getFileNameNoExt(t.name)
			  table.insert(musicplayerInfo.list, t)
			  j += 1
			  if not getPlayingSongInt and playingSongName and playingSongName == t.nameNoExt then
			   playingSongInt = j
			   getPlayingSongInt = true
			  end
			 end
	 	end
		end
		if #musicplayerInfo.list < 1 then
		 musicplayerInfo.focus = 1
		elseif musicplayerInfo.focus > #musicplayerInfo.list then
		 musicplayerInfo.focus = #musicplayerInfo.list
		end
		oldMusicplayerInfoPos = musicplayerInfo.focus
	end --if tmpList

	if #musicplayerInfo.list > musicplayerListShowCount then
  musicplayer_scrollbarOne_h = musicplayer_scrollbarBK_h/#musicplayerInfo.list
  musicplayer_scrollbar_h = musicplayer_scrollbarOne_h*musicplayerListShowCount
 end

end

-----------------获取取音乐封面---------------------
function musicplayer_get_music_cover()
 if musicplayerInfo.list[playingSongInt].cover then
  if musicplayerInfo.list[playingSongInt].cover == noCover then
   cover = coverIcon
  else
   cover = musicplayerInfo.list[playingSongInt].cover
  end
  return
 end
 local tmpCover = nil
 if playingSongInt and musicplayerInfo.list[playingSongInt].ext == "mp3" then
  if musicplayerInfo.list[playingSongInt].id3 == nil then
   musicplayerInfo.list[playingSongInt].id3 = sound.getid3(musicplayerInfo.list[playingSongInt].path)
  end
  --構畫音乐封面
  tmpCover = musicplayerInfo.list[playingSongInt].id3.cover 
 end
 if tmpCover then
  local cW = image.getw(tmpCover)
  local cH = image.geth(tmpCover)
  local cNw = 362
  local cNh = cNw/cW*cH
  if cNh > cNw then --如果高度大宽度，则重定义为等于宽度
   cNh = cNw
  end
  cY = 80 + (cNw-cNh)/2
  image.resize(tmpCover, cNw, cNh)
  cover = tmpCover
  musicplayerInfo.list[playingSongInt].cover = tmpCover
 else
  cover = coverIcon
  musicplayerInfo.list[playingSongInt].cover = noCover
 end
end

------------------播放上一首---------------------
function musicplayer_play_previous_song()
 if not playingSongInt or playingSongInt < 0 or not musicplayerInfo.list or #musicplayerInfo.list < 1 then
  return
 end
 local tmpPlayingSongInt = 1
 if playingSongInt and playingSongInt > 0 then
  tmpPlayingSongInt = playingSongInt
  if playingSongInt > 1 then
   tmpPlayingSongInt = playingSongInt - 1
  end
 end
 while not files.exists(musicplayerInfo.list[tmpPlayingSongInt].path) and tmpPlayingSongInt > 1 do
  tmpPlayingSongInt -= 1
 end
	if files.exists(musicplayerInfo.list[tmpPlayingSongInt].path) then
	 if playingSongInt and tmpPlayingSongInt == playingSongInt then
	  return
	 end
	 if playingSongSnd and sound.playing(playingSongSnd) then
   sound.stop(playingSongSnd)
  end
	 playingSongInt = tmpPlayingSongInt
	 playingSongName = musicplayerInfo.list[playingSongInt].nameNoExt
	 playingSongSnd = sound.load(musicplayerInfo.list[playingSongInt].path)
	 sound.play(playingSongSnd)
	 
	 return true
	end
	
	return false
end

------------------播放下一首---------------------
function musicplayer_play_next_song()
 if not musicplayerInfo.list or #musicplayerInfo.list < 1 then
  return
 end
 local tmpPlayingSongInt = 1
 if playingSongInt and playingSongInt > 0 then
  tmpPlayingSongInt = playingSongInt
  if playingSongInt < #musicplayerInfo.list then
   tmpPlayingSongInt = playingSongInt + 1
  end
 end
 while not files.exists(musicplayerInfo.list[tmpPlayingSongInt].path) and tmpPlayingSongInt < #musicplayerInfo.list do
  tmpPlayingSongInt += 1
 end
	if files.exists(musicplayerInfo.list[tmpPlayingSongInt].path) then
	 if playingSongInt and tmpPlayingSongInt == playingSongInt then
	  return
	 end
	 if playingSongSnd and sound.playing(playingSongSnd) then
   sound.stop(playingSongSnd)
  end
	 playingSongInt = tmpPlayingSongInt
	 playingSongName = musicplayerInfo.list[playingSongInt].nameNoExt
	 playingSongSnd = sound.load(musicplayerInfo.list[playingSongInt].path)
	 sound.play(playingSongSnd)
	 
	 return true
	end
	
	return false
end














