-----------------explorer-------------------------------------------------------------------


---------------第一次进初始化----------------------
if not secondIntoExplorer then

 -----------------加载脚本---------------------- 
 dofile("scripts/explorer/explorer_functions.lua")--加載函數集腳本
 dofile("scripts/explorer/explorer_graphics_function.lua")--加載構畫界面的函數腳本
 dofile("scripts/explorer/explorer_button_setting_function.lua")--加載按鍵設置的函數腳本
 
 folderIcon = image.load("resources/icons/folder_icon.png")
 fileIcon = image.load("resources/icons/file_icon.png")
 textIcon = image.load("resources/icons/text_icon.png")
 imageIcon = image.load("resources/icons/image_icon.png")
 audioIcon = image.load("resources/icons/audio_icon.png")
 archiveIcon = image.load("resources/icons/archive_icon.png")
 
 --列表显示行数
 explorerShowCount = 18
 --列表显示间隔
 explorer_list_y_interval = 5
 --列表滚动条
 explorer_scrollbarBK_w = 6
 explorer_scrollbar_w = explorer_scrollbarBK_w
 explorer_scrollbarBK_h = (screen.textheight(1) + explorer_list_y_interval)*explorerShowCount - explorer_list_y_interval
 
 explorerButtonTextList = {
  EXPLORE_BUTTON_MARK,
  EXPLORE_BUTTON_OPEN_MENU,
  EXPLORE_BUTTON_BACK,
  EXPLORE_BUTTON_POSITIVE,
  EXPLORE_BUTTON_SWITCH_DISK,
 }

 exploreSampleDevList = {
  "ux0:",
  "uma0:",
  "imc0:",
  "gro0:",
  "grw0:",
  "ur0:",
  --"os0:",
  --"pd0:",
  --"sa0:",
  --"tm0:",
  --"ud0:",
  --"vd0:",
  --"vs0:",
 }

 explorerDevInfo = {
  list = {},
  focus = 1,
 } 
 
 explorerInfos = {}
 
 explorerInfo = {
  rootPath = "",
  list = {},
  focus = 1,
  top = 1,
  marksCounts = 0,
  rootInfo = {},
 }

 explorerMarksInfo = {
  list = {},
  diskInt = 1,
  mode = 1,
 }
 
 explorerMenuInfo = {
  list = {
   EXPLORE_MARKS_ALL,
   EXPLORE_COPY,
   EXPLORE_CUT,
   EXPLORE_PASTE,
   EXPLORE_DELETE,
   EXPLORE_MAKE_ZIP,
   EXPLORE_RENAME,
   EXPLORE_CREATE_FILE,
   EXPLORE_MAKE_DIR,
   EXPLORE_INSTALL_APPDIR,
   EXPLORE_EXPORT_MULTIMEDIA,
   "",
   EXPLORE_QUIT,
  },
  focus = 1,
  top = 1,
  usable = {},
 }

 explorerInstallPathSelectMenuInfo = {
  list = {
   EXPLORE_INSTALL_APP_SAMPLE,
   EXPLORE_INSTALL_APP_NONPDRM,
  },
  focus = 1,
  top = 1,
 }
 
 explorerInstallMenuInfo = {
  list = {
   EXPLORE_INSTALL_APP_TO_UX,
   EXPLORE_INSTALL_APP_TO_UMA,
   EXPLORE_INSTALL_APP_TO_UR,
  },
  focus = 1,
  top = 1,
 }
 
 for i = 1, #exploreSampleDevList do
  if files.exists(exploreSampleDevList[i]) then
   local tmpListInfo = {
    rootPath = exploreSampleDevList[i].."/",
    rootType = nil,
    list = {},
    focus = 1,
    top = 1,
    marksCounts = 0,
    zipFileList = nil,
    rootInfo = {},
   }
   table.insert(explorerInfos, tmpListInfo)
   table.insert(explorerDevInfo.list, exploreSampleDevList[i])
  end
 end
 if #explorerInfos > 0 then
  explorerInfo = explorerInfos[1]
 end
 
 secondIntoExplorer = true

end

----------------continue---------------------------------------
--获取取文件列表
if explorerInfos and #explorerInfos > 0 then
 
 if explorerInfo.rootType and explorerInfo.rootType == "zip" then
  explorer_get_zipFileList(explorerInfo.rootPath)
 else
  explorer_get_filelist(explorerInfo.rootPath)
 end

end

-----------------while---------------------------------------
explorerRun = true
while explorerRun do
 
 explorer_graphics() --构画界面
 explorer_button_setting() --设置按键
 musicplayer_autoplaynextmusic() --自动播放下一首音乐

end
------------------------------------------------














