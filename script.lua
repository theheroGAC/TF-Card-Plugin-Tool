--------------------script-------------------------------------------------------------------


-------------------加载脚本---------------------- 
dofile("scripts/strings.lua")
dofile("scripts/colors.lua")
dofile("scripts/sample_functions.lua")
dofile("scripts/dialog_functions.lua")
dofile("scripts/callbacks.lua")

dofile("scripts/script/script_functions.lua")
dofile("scripts/script/script_graphics_function.lua")
dofile("scripts/script/script_button_setting_function.lua")

dofile("scripts/musicplayer/musicplayer_functions.lua")
dofile("scripts/musicplayer/musicplayer_autoplaynextmusic_function.lua")

------------------全局变量------------------------------------------------------
if files.exists("resources/back.png") then
 back = image.load("resources/back.png") --读取背景图片
elseif files.exists("resources/back.jpg") then
 back = image.load("resources/back.jpg") --读取背景图片
end
if back then image.resize(back, 960, 544) end --重定义图片大小充满屏幕
--mCdirPath = files.cdir() --记录软件本身的默认工作目录
INSTALL_APP_SCAN = true

VITA_SWVERSION = os.swversion() + 0

--选项
scriptInfo = {
 list = {
  MOUNT_TF_UMA,
  MOUNT_TF_UX,
  MOUNT_USB_UX,
  UNMOUNT_TF_USB_PLUGINS,
  REFRESH_APP,
  EXPLORE,
  ABOUT,
 },
 top = 1,
 focus = 1,
}

--按键
scriptButtonTextList = {
 MAIN_BUTTON_SELECT,
 MAIN_BUTTON_POSITIVE,
}

-------------------continue----------------------------
buttons.interval(10,10) --设置按键延迟和连发间隔
--buttons.analogtodpad(30) --设置摇杆死区
color.loadpalette() --读取颜色参数

--检测安全模式
check_safe()

--------------软件启动时自动循环播放音乐----------------------
--（请将要自动播放的mp3音乐命名为bgm.mp3放于resources目录下）----
local pathToBgmMusic = "resources/bgm.mp3"
if files.exists(pathToBgmMusic) then
 playingSongSnd = sound.load(pathToBgmMusic)
 sound.play(playingSongSnd)
 sound.loop(playingSongSnd)
 musicPlayMode = 2
 autoPlayMusicNext = false
end --自动播放音乐代码结束

---------------------while---------------------------------------
scriptRun = true
while scriptRun do

 script_graphics() --构画界面
 script_button_setting() --设置按键
 musicplayer_autoplaynextmusic() --自动播放下一首音乐

end
















