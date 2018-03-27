----------------vita_function.lua------------------------


----------------标题栏界面显示-----------------------
function titleShow(title)

 local title_x_interval = 18
 local title_y_interval = 14
 MAIN_TITLE_HEIGHT = title_y_interval + screen.textwidth(1) + title_y_interval
 --标题背景
 draw.fillrect(0, 0, 960, MAIN_TITLE_HEIGHT, COLOR_STATUS_BAR_BACKGROUND)
 --标题
 local title_x = title_x_interval
 local title_y = title_y_interval
 screen.print(title_x, title_y, title, 1, color.white, color.black, __ALEFT)
 --电量
 local battery_x = 960 - title_x_interval
 local batteryInt = batt.lifepercent()
 local batteryShowStr = string.format(BATTERY_SHOW, batteryInt)
 if batt.charging() then
  screen.print(battery_x, title_y, batteryShowStr, 1, color.yellow, color.black, __ARIGHT) 
 else
  if batteryInt > 20 then
   screen.print(battery_x, title_y, batteryShowStr, 1, color.green, color.black, __ARIGHT)
  else
   screen.print(battery_x, title_y, batteryShowStr, 1, color.red, color.black, __ARIGHT) 
  end
 end
 --时间
 local time_x = battery_x - screen.textwidth(batteryShowStr) - title_x_interval
 local timeShowStr = os.date("%Y/%m/%d   %H:%M")
 screen.print(time_x, title_y, timeShowStr, 1, color.white, color.black, __ARIGHT)
end

----------------按键栏界面显示-----------------------
function buttonShow(buttonTxtList)
 
 local button_x_interval = 18
 local button_y_interval = 14
 MAIN_BUTTON_HEIGHT = button_y_interval + screen.textwidth(1) + button_y_interval
 --按键背景
 local button_x = button_x_interval
 local button_y = 544 - MAIN_BUTTON_HEIGHT + button_y_interval
 draw.fillrect(0, 544 - MAIN_BUTTON_HEIGHT, 960, MAIN_BUTTON_HEIGHT, COLOR_STATUS_BAR_BACKGROUND)
 --按键
 for i = 1, #buttonTxtList do
  screen.print(button_x, button_y, buttonTxtList[i], 1, color.white, color.black, __ALEFT)
  button_x += (screen.textwidth(buttonTxtList[i], 1) + 34)
 end
 --ftp状态界面显示
 local ftp_x = 960 - button_x_interval
 local ftp_y = button_y
 if wlan.isconnected() then
  if ftp.state() then
   screen.print(ftp_x, ftp_y, string.format(FTP_INFORMATION_TIP, tostring(wlan.getip())), 1, color.white, color.black, __ARIGHT)
  else
   screen.print(ftp_x, ftp_y, WLAN_ON, 1, color.green, color.black, __ARIGHT)   
  end
 else
  screen.print(ftp_x, ftp_y, WLAN_OFF, 1, color.red, color.black, __ARIGHT)   
 end
 
end

----------------进入加载界面-----------------------
function mainLoadWaiting(title, buttonTxtList)

 if back then back:blit(0,0) end
 titleShow(title)
 buttonShow(buttonTxtList)
 screen.flip()
 SCREENSHOTS = screen.buffertoimage()
 show_waiting_dialog(WAIT_LOADING)
 
end

----------------ftp服务器-----------------------
function ftp_server()
 
 DIALOGWIDTH = 0

 SHOW_SAMPLE_DIALOG = true
 while SHOW_SAMPLE_DIALOG do
  local ftpButtonL = nil
  local ftpButtonR = nil
  local wlanState = WLAN_OFF
  local ftpState = ""
  if wlan.isconnected() then
   wlanState = WLAN_ON
   if ftp.state() then
    ftpState = string.format(FTP_ON, tostring(wlan.getip()))
   else
    ftpState = FTP_OFF
   end
   ftpButtonL = BUTTON_CANCEL
   ftpButtonR = BUTTON_POSITIVE
  else
   ftpButtonL = BUTTON_BACK
   ftpButtonR = nil
  end
  
  dialogFtpMessage = wlanState.."\n"..ftpState
  local messageInfo = get_sample_dialog_info(dialogFtpMessage)
  
  sample_dialog(FTP_SERVER, messageInfo, ftpButtonL, ftpButtonR)
  musicplayer_autoplaynextmusic()
  buttons.read()
  
  --X键设置
	 if ftpButtonL and buttons.cross then
	  buttons.read()
	  show_close_dialog()
	  return 0
	 --○键设置
	 elseif ftpButtonR and buttons.circle then
	  buttons.read()
	  if wlan.isconnected() then
    if not ftp.state() then
     ftpState = ftp.init()
    else
     ftpState = ftp.term()
    end
    show_close_dialog()
   end
	  return 1
	 end
 end
 
end

--------------------防止休眠-----------------------------
function power_tick()
 
 --如果ftp启动中或音乐播放中，则保持设备息屏运行
 if (wlan.isconnected() and ftp.state()) or (playingSongSnd and sound.playing(playingSongSnd)) then
  power.tick(1)
 end

end

---------------重构数据库--------------------------
function rebuilddb()
 
 files.delete("ur0:shell/db/app.db")

end

function list_get_top_down(listInfo, showCounts)
 
 	if listInfo.top > listInfo.focus then
 	 listInfo.top = listInfo.focus
 elseif listInfo.top < listInfo.focus - (explorerShowCount-1) then
  listInfo.top = listInfo.focus - (explorerShowCount-1)
 end
 --获得底部序号
 local bottom = #listInfo.list
 if bottom > listInfo.top + (explorerShowCount-1) then
  bottom = listInfo.top + (explorerShowCount-1)
 end

end

--------------安装游戏-------------------------------
function install_psv_app(pathToSrcFile)
 
 local uxDev = "ux0:"
 local srcDev = files_devpath(pathToSrcFile)
 --如果安装包不在ux0盘符，检测剩余空间是否足够
 if srcDev ~= uxDev then
  local needSpace = files.size(pathToSrcFile)
  local freespaceBl = check_freespace(uxDev, needSpace)
  if not freespaceBl then
   return -10 --空间不足
  end
 end

 local srcFileName = files.nopath(pathToSrcFile)
 local pathToSrcFileEboot = pathToSrcFile.."/eboot.bin"
 local pathToSrcFileSfo = pathToSrcFile.."/sce_sys/param.sfo"
 --如果游戏文件夹合法
 if files.exists(pathToSrcFileEboot) and files.exists(pathToSrcFileSfo) then
  --读取sfo
  local gameInfo = game.info(pathToSrcFileSfo)
  --如果sfo合法
  if gameInfo and gameInfo.TITLE_ID then
   --获取要安装的游戏ID
   INSTALL_GAME_ID = gameInfo.TITLE_ID
   if INSTALL_GAME_ID == os.titleid() then
    return -13 --安装包为当前软件
   end
  else
   return -12 --包装包有错误
  end
 else
  return -11 --安装包不合法
 end
 --临时目录
 local pathToSrcTmp = srcDev.."/temp/install_game_tmp"
 local pathToUxAppTmp = "ux0:/temp/ux_app_tmp"
 local pathToUrAppmetaTmp = "ur0:/temp/ur_appmeta_tmp"
 local pathToUxInstallTmp = "ux0:/temp/install_game_tmp"
 --移动游戏包
 local pathToSrcTmpFile = pathToSrcTmp.."/"..srcFileName
 local pathToSrcTmpGame = pathToSrcTmp.."/"..INSTALL_GAME_ID
 files.delete(pathToSrcTmpFile)
 files.delete(pathToSrcTmpGame)
 files.mkdir(pathToSrcTmp)
 files.move(pathToSrcFile, pathToSrcTmp)
 files.rename(pathToSrcTmpFile, INSTALL_GAME_ID)
 --备份ux0:app下同名游戏文件
 local pathToUxApp = "ux0:/app"
 local pathToUxAppGame = pathToUxApp.."/"..INSTALL_GAME_ID
 local pathToUxAppTmpGame = pathToUxAppTmp.."/"..INSTALL_GAME_ID
 files.delete(pathToUxAppTmpGame)
 if files.exists(pathToUxAppGame) then
  files.mkdir(pathToUxAppTmp)
  files.move(pathToUxAppGame, pathToUxAppTmp)
 end
 --备份ur0:appmeta文件
 local pathToUrAppmeta = "ur0:/appmeta"
 local pathToUrAppmetaGame = pathToUrAppmeta.."/"..INSTALL_GAME_ID
 local pathToUrAppmetaTmpGame = pathToUrAppmetaTmp.."/"..INSTALL_GAME_ID
 files.delete(pathToUrAppmetaTmpGame)
 if files.exists(pathToUrAppmetaGame) then
  files.mkdir(pathToUrAppmetaTmp)
  files.move(pathToUrAppmetaGame, pathToUrAppmetaTmp)
 end
 ----如果安装包不在ux0
 local pathToSrcTmpGameSys = pathToSrcTmpGame.."/sce_sys"
 local pathToSrcTmpGamePfs = pathToSrcTmpGame.."/sce_pfs"
 local pathToSrcTmpGameEboot = pathToSrcTmpGame.."/eboot.bin"
 local pathToSrcTmpGamePackage = pathToSrcTmpGameSys.."/package"
 local pathToSrcTmpPackage = pathToSrcTmp.."/package"
 files.delete(pathToSrcTmpPackage)
 if files.exists(pathToSrcTmpGamePackage) then
  files.move(pathToSrcTmpGamePackage, pathToSrcTmp)
 end
 local pathToUxInstallTmpGame = pathToUxInstallTmp.."/"..INSTALL_GAME_ID
 if srcDev ~= "ux0:" then
  files.delete(pathToUxInstallTmpGame)
  files.mkdir(pathToUxInstallTmp)
  files.mkdir(pathToUxInstallTmpGame)
  --复制游戏小包到ux0
  files.copy(pathToSrcTmpGameSys, pathToUxInstallTmpGame)
  files.copy(pathToSrcTmpGamePfs, pathToUxInstallTmpGame)
  files.copy(pathToSrcTmpGameEboot, pathToUxInstallTmpGame)
 end
 --刷新游戏
 local installResult = game.installdir(pathToUxInstallTmpGame)     
 if installResult == 1 then
  files.delete(pathToUxAppTmpGame)
  files.delete(pathToUrAppmetaTmpGame)
  --如果安装包不在ux0
  if srcDev ~= "ux0:" then
   --复制剩下的文件
   local fileList = files.list(pathToSrcTmpGame)
   if fileList then
    for i = 1, #fileList do
     local fileName = fileList[i].name
     if fileName ~= "sce_sys" and fileName ~= "sce_pfs" and fileName ~= "eboot.bin" then
      files.copy(fileList[i].path, pathToUxAppGame)
     end
    end
   end
   --还原源安装包
   files.move(pathToSrcTmpPackage, pathToSrcTmpGameSys)
   files.rename(pathToSrcTmpGame, srcFileName)
   files.move(pathToSrcTmpFile, files.nofile(pathToSrcFile))
  else
   files.delete(pathToSrcTmpPackage)
  end --if refreshDev ~= "ux0:"
 else
  --还原所有文件
  files.delete(pathToSrcTmpGamePackage)
  files.move(pathToSrcTmpPackage, pathToSrcTmpGameSys)
  files.rename(pathToSrcTmpGame, srcFileName)
  files.move(pathToSrcTmpFile, files.nofile(pathToSrcFile))
  files.move(pathToUxAppTmpGame, pathToUxApp)
  files.move(pathToUrAppmetaTmpGame, pathToUrAppmeta)
  --如果安装包不在ux0
  if srcDev ~= "ux0:" then
   --删除ux0下的安装包
   files.delete(pathToUxInstallTmpGame)
  end
 end
 --删除临时目录
 files.delete(pathToSrcTmp)
 files.delete(pathToUxAppTmp)
 files.delete(pathToUrAppmetaTmp)
 
 return installResult
 
end

--------------刷新游戏-------------------------------
function refresh_psv_app(pathToSrcFile)
 
 local uxDev = "ux0:"
 local srcDev = files_devpath(pathToSrcFile)
 --如果安装包不在ux0盘符，检测剩余空间是否足够
 if srcDev ~= uxDev then
  local needSpace = files.size(pathToSrcFile)
  local freespaceBl = check_freespace(uxDev, needSpace)
  if not freespaceBl then
   return -10 --空间不足
  end
 end

 local srcFileName = files.nopath(pathToSrcFile)
 local pathToSrcFileEboot = pathToSrcFile.."/eboot.bin"
 local pathToSrcFileSfo = pathToSrcFile.."/sce_sys/param.sfo"
 local pathToSrcFileHead = pathToSrcFile.."/sce_sys/package/head.bin"
 --如果游戏文件夹合法
 if files.exists(pathToSrcFileEboot) and files.exists(pathToSrcFileSfo) and files.exists(pathToSrcFileHead) then
  --读取sfo
  local gameInfo = game.info(pathToSrcFileSfo)
  --如果sfo合法
  if gameInfo and gameInfo.TITLE_ID then
   --获取要安装的游戏ID
   INSTALL_GAME_ID = gameInfo.TITLE_ID
   if INSTALL_GAME_ID == os.titleid() then
    return -13 --安装包为当前软件
   end
  else
   return -12 --包装包有错误
  end
 else
  return -11 --安装包不合法
 end
 --临时目录
 local pathToSrcTmp = srcDev.."/temp/install_game_tmp"
 local pathToUxAppTmp = "ux0:/temp/ux_app_tmp"
 local pathToUrAppmetaTmp = "ur0:/temp/ur_appmeta_tmp"
 local pathToUxInstallTmp = "ux0:/temp/install_game_tmp"
 --移动游戏包
 local pathToSrcTmpFile = pathToSrcTmp.."/"..srcFileName
 local pathToSrcTmpGame = pathToSrcTmp.."/"..INSTALL_GAME_ID
 files.delete(pathToSrcTmpFile)
 files.delete(pathToSrcTmpGame)
 files.mkdir(pathToSrcTmp)
 files.move(pathToSrcFile, pathToSrcTmp)
 files.rename(pathToSrcTmpFile, INSTALL_GAME_ID)
 --备份ux0:app下同名游戏文件
 local pathToUxApp = "ux0:/app"
 local pathToUxAppGame = pathToUxApp.."/"..INSTALL_GAME_ID
 local pathToUxAppTmpGame = pathToUxAppTmp.."/"..INSTALL_GAME_ID
 files.delete(pathToUxAppTmpGame)
 if files.exists(pathToUxAppGame) then
  files.mkdir(pathToUxAppTmp)
  files.move(pathToUxAppGame, pathToUxAppTmp)
 end
 --备份ur0:appmeta文件
 local pathToUrAppmeta = "ur0:/appmeta"
 local pathToUrAppmetaGame = pathToUrAppmeta.."/"..INSTALL_GAME_ID
 local pathToUrAppmetaTmpGame = pathToUrAppmetaTmp.."/"..INSTALL_GAME_ID
 files.delete(pathToUrAppmetaTmpGame)
 if files.exists(pathToUrAppmetaGame) then
  files.mkdir(pathToUrAppmetaTmp)
  files.move(pathToUrAppmetaGame, pathToUrAppmetaTmp)
 end
 ----如果安装包不在ux0
 local pathToSrcTmpGameSys = pathToSrcTmpGame.."/sce_sys"
 local pathToSrcTmpGamePfs = pathToSrcTmpGame.."/sce_pfs"
 local pathToSrcTmpGameEboot = pathToSrcTmpGame.."/eboot.bin"
 local pathToUxInstallTmpGame = pathToUxInstallTmp.."/"..INSTALL_GAME_ID
 if srcDev ~= "ux0:" then
  files.delete(pathToUxInstallTmpGame)
  files.mkdir(pathToUxInstallTmp)
  files.mkdir(pathToUxInstallTmpGame)
  --复制游戏小包到ux0
  files.copy(pathToSrcTmpGameSys, pathToUxInstallTmpGame)
  files.copy(pathToSrcTmpGamePfs, pathToUxInstallTmpGame)
  files.copy(pathToSrcTmpGameEboot, pathToUxInstallTmpGame)
 end
 --刷新游戏
 local installResult = game.refresh(pathToUxInstallTmpGame)     
 if installResult == 1 then
  files.delete(pathToUxAppTmpGame)
  files.delete(pathToUrAppmetaTmpGame)
  --如果安装包不在ux0
  if srcDev ~= "ux0:" then
   --复制剩下的文件
   local fileList = files.list(pathToSrcTmpGame)
   if fileList then
    for i = 1, #fileList do
     local fileName = fileList[i].name
     if fileName ~= "sce_sys" and fileName ~= "sce_pfs" and fileName ~= "eboot.bin" then
      files.copy(fileList[i].path, pathToUxAppGame)
     end
    end
   end
   --还原源安装包
   files.rename(pathToSrcTmpGame, srcFileName)
   files.move(pathToSrcTmpFile, files.nofile(pathToSrcFile))
  end --if refreshDev ~= "ux0:"
 else
  --还原所有文件
  files.rename(pathToSrcTmpGame, srcFileName)
  files.move(pathToSrcTmpFile, files.nofile(pathToSrcFile))
  files.move(pathToUxAppTmpGame, pathToUxApp)
  files.move(pathToUrAppmetaTmpGame, pathToUrAppmeta)
  --如果安装包不在ux0
  if srcDev ~= "ux0:" then
   --删除ux0下的安装包
   files.delete(pathToUxInstallTmpGame)
  end
 end
 --删除临时目录
 files.delete(pathToSrcTmp)
 files.delete(pathToUxAppTmp)
 files.delete(pathToUrAppmetaTmp)
 
 return installResult
 
end







