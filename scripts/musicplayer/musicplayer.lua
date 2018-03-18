-----------------musicplayer-------------------------------------------------------------------


---------------第一次进初始化----------------------
if not secondIntoMusicplayer then
 -----------------加载脚本---------------------- 
 dofile("scripts/musicplayer/musicplayer_graphics_function.lua")--加载界面腳本
 dofile("scripts/musicplayer/musicplayer_button_setting_function.lua")--加载按键脚本

 folderIcon = image.load("resources/icons/folder_icon.png")
 musicIcon = image.load("resources/icons/audio_icon.png")
 coverIcon = image.load("resources/icons/cover.png")
 image.resize(coverIcon, 362, 362)
 secondIntoMusicplayer = true
 cover = coverIcon
 
 --列表显示行数
 musicplayerListShowCount = 19
 --列表显示间隔
 musicplayer_list_y_interval = 5
 --列表滚动条
 musicplayer_scrollbarBK_w = 6
 musicplayer_scrollbar_w = musicplayer_scrollbarBK_w
 musicplayer_scrollbarBK_h = (screen.textheight(1) + musicplayer_list_y_interval)*musicplayerListShowCount - musicplayer_list_y_interval
 
 --进度条
 musicplayer_progressbarBK_w = 480-60
 musicplayer_progressbarBK_h = 6
 musicplayer_progressbar_h = musicplayer_progressbarBK_h
 musicplayer_progressbar_one_w = musicplayer_progressbarBK_w/100
 
 musicplayerInfo = {
  list = nil,
  top = 1,
  focus = 1,
 }

 musicplayerButtonTextList = {
  MUSIC_PLAYER_BUTTON_PLAY,
  MUSIC_PLAYER_BUTTON_POSITIVE,
  MUSIC_PLAYER_BUTTON_LR,
  MUSIC_PLAYER_BUTTON_START,
 }

 playModeTextList = {
  MUSIC_PLAYER_BUTTON_ORDER_PLAY,
  MUSIC_PLAYER_BUTTON_SINGLE_REPEAT,
  MUSIC_PLAYER_BUTTON_CYCLE_PLAY,
 }
 
 if musicPlayMode == nil then
  musicPlayMode = 1
  autoPlayMusicNext = true
 end
 
 secondIntoMusicplayer = true
end

----------------continue------------------------------------------------------------------------
local musicRootPath = "ux0:data/music/"
if check_file(musicRootPath) ~= 2 then
 mainLoadWaiting(MUSIC_PLAYER, musicplayerButtonTextList)
 files.delete(musicRootPath)
 files.mkdir(musicRootPath)
 show_close_dialog()
end

musicplayerMusicName_default_x = 504
musicplayerMusicName_x = musicplayerMusicName_default_x

---------------获取文件列表---------------------
musicplayer_get_music_list(musicRootPath)

-----------------while---------------------------------------
musicplayerRun = true
while musicplayerRun do
 
 musicplayer_graphics() --构画界面
 musicplayer_button_setting() --按键设置
 musicplayer_autoplaynextmusic() --自动播放下首音乐
 
end --while musicplayerRun
------------------------------------------------














