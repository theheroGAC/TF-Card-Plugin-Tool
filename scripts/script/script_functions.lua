----------------script_function.lua------------------------


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

----------------安装tf卡和usb插件-----------------------
function install_gamesd(selection)

 buttons.homepopup(0)
	show_waiting_dialog(WAIT_EXECUTING)
	
 local pathToSrcStoragemgrSkprx = "resources/mc_plugins/storagemgr.skprx"
 local pathToSrcGamesdUmaSkprx = "resources/mc_plugins/tf-uma0/gamesd.skprx" 
 local pathToSrcGamesdUxSkprx = "resources/mc_plugins/tf-ux0/gamesd.skprx" 
 local pathToSrcUsbmcUxSkprx = "resources/mc_plugins/usb-ux0/usbmc.skprx" 
 
 local storagemgrSkprxName = "storagemgr.skprx"
 local gamesdSkprxName = "gamesd.skprx"
 local usbmcSkprxName = "usbmc.skprx"

 local pathToUrStoragemgrSkprx = "ur0:tai/"..storagemgrSkprxName
 local pathToUrGamesdSkprx = "ur0:tai/"..gamesdSkprxName
 local pathToUrUsbmcSkprx = "ur0:tai/"..usbmcSkprxName
 
 local tfToUmaStorageConfigTxts = {
  "INT=imc0",
  "GCD=uma0",
 }
 local tfToUxStorageConfigTxts = {
  "MCD=uma0",
  "INT=imc0",
  "GCD=ux0",
 }
 local usbToUxStorageConfigTxts = {
  "MCD=uma0",
  "INT=imc0",
  "UMA=ux0",
 }
 local storageConfigTxts = tfToUmaStorageConfigTxts
 local pathToUrStorageConfigTxt = "ur0:/tai/storage_config.txt"
 local pathToUrStoragemgrLogTxt = "ur0:/tai/storagemgr_log.txt"
 
 local pathToSrcSkprx = pathToSrcStoragemgrSkprx
 local pathToUrSkprx = pathToUrStoragemgrSkprx
 
	--判断选择哪个插件
	if selection == 1 then
	 storageConfigTxts = tfToUmaStorageConfigTxts
	elseif selection == 2 then
	 storageConfigTxts = tfToUxStorageConfigTxts
	elseif selection == 3 then
	 storageConfigTxts = usbToUxStorageConfigTxts
	elseif selection == 4 then
	 pathToSrcSkprx = pathToSrcGamesdUmaSkprx
	 pathToUrSkprx = pathToUrGamesdSkprx
	elseif selection == 5 then
	 pathToSrcSkprx = pathToSrcGamesdUxSkprx
	 pathToUrSkprx = pathToUrGamesdSkprx
	elseif selection == 6 then
	 pathToSrcSkprx = pathToSrcUsbmcUxSkprx
	 pathToUrSkprx = pathToUrUsbmcSkprx
 end

 local pathToTaiConfig = ""
 
 --循环修改ux0、uma0、imc0的config.txt文件
 local pathToDiskList = {
  "ux0:",
  "uma0:",
  "imc0:",
 }
 for i = 1, #pathToDiskList do
  local pathToDisk = pathToDiskList[i]
  pathToTaiConfig = pathToDisk.."tai/config.txt"
  local checkCon = check_file(pathToTaiConfig)
  if checkCon == 1 then
   if i == 1 then
    files.copy(pathToTaiConfig, "ur0:tai/")
   end
   local pathToTaiConfigBak = pathToTaiConfig..".bak"
   if files.exists(pathToTaiConfigBak) then
    files.delete(pathToTaiConfigBak)
   end
   files.rename(pathToTaiConfig, "config.txt.bak")
   files.mkdir(pathToTaiConfig)
  elseif not checkCon then
   files.mkdir(pathToTaiConfig)
  end
 end

 local taiConfigExists = false
 local gamesdBakBl = false
 --修改ur0的config.txt文件
 local pathToDisk = "ur0:"
 pathToTaiConfig = pathToDisk.."tai/config.txt"
 local checkCon = check_file(pathToTaiConfig)
 if checkCon ~= 1 then
  if checkCon == 2 then
   files.delete(pathToTaiConfig)
  end
  if create_file(pathToTaiConfig) then
   checkCon = 1
  end
 end
 if checkCon == 1 then
  taiConfigExists = true
  --备份config.txt
  file_copy_to_file(pathToTaiConfig, pathToTaiConfig..".bak")
  --读取文本
  local kernelStr = "*KERNEL"
  local stopCheckLine = false
  local findKernel = false
  local contenido = {}

	 for linea in io.lines(pathToTaiConfig) do
	  local lineStr = trim(linea)
   local linePreName = files.nopath(lineStr)
	  if linePreName ~= storagemgrSkprxName and linePreName ~= gamesdSkprxName and linePreName ~= usbmcSkprxName then
	   table.insert(contenido, linea)
	   if not stopCheckLine then
	    if not findKernel then
	     if linePreName == kernelStr then
	      table.insert(contenido, pathToUrSkprx)
	      findKernel = true
	     end
	    else
	     if string.sub(lineStr, 1, 1) == "*" then
	      stopCheckLine = true
	     end
	    end --if not findKernel
	   end --if not stopCheckLine
	  end --if linePreName ~= gamesdSkprxName
	 end --for linea in
	 --如果找不到位置文本，则添加
	 if not findKernel then
	  table.insert(contenido, kernelStr)
	  table.insert(contenido, pathToUrSkprx)
	 end
	 --写入文本
	 local taiConfigFile = io.open(pathToTaiConfig, "w+")
	 for i = 1, #contenido do
	  taiConfigFile:write(contenido[i].."\n")
	 end
	 taiConfigFile:close()  
	end
	
	--如果找不到config.txt文件，则返回
 if not taiConfigExists then
  buttons.homepopup(1)
  show_sample_dialog(TIPS, NO_CONFIG, BUTTON_BACK)
  return
 end
 
 --删除旧插件
 files.delete(pathToUrStoragemgrSkprx)
 files.delete(pathToUrStorageConfigTxt)
 files.delete(pathToUrStoragemgrLogTxt)
 files.delete(pathToUrGamesdSkprx)
 files.delete(pathToUrUsbmcSkprx)
 --复制新插件
 files.copy(pathToSrcSkprx, "ur0:tai")
 --写入插件配置文件
 if selection == 1 or selection == 2 or selection == 3 then
	 local storageConfigFile = io.open(pathToUrStorageConfigTxt, "w+")
	 for i = 1, #storageConfigTxts do
	  storageConfigFile:write(storageConfigTxts[i].."\n")
	 end
	 storageConfigFile:close()
 end
 
 buttons.homepopup(1)
 local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_COMPLETE, scriptInfo.list[scriptInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
 if state == 1 then
  show_waiting_dialog(WAIT_EXECUTING)
  power.restart()
 end

end

----------------卸载tf卡和usb插件-----------------------
function uninstall_gamesd()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)

 local storagemgrSkprxName = "storagemgr.skprx"
 local gamesdSkprxName = "gamesd.skprx"
 local usbmcSkprxName = "usbmc.skprx"

 local pathToUrStoragemgrSkprx = "ur0:tai/"..storagemgrSkprxName
 local pathToUrGamesdSkprx = "ur0:tai/"..gamesdSkprxName
 local pathToUrUsbmcSkprx = "ur0:tai/"..usbmcSkprxName
 
 local pathToUrStorageConfigTxt = "ur0:/tai/storage_config.txt"
 local pathToUrStoragemgrLogTxt = "ur0:/tai/storagemgr_log.txt"

 --修改config.txt文件--
 local pathToDiskList = {
  "ux0:",
  "uma0:",
  "imc0:",
  "ur0:",
 }
  --循环修改ux0、uma0、imc0、ur0的config.txt文件
 for i = 1, #pathToDiskList do
  local pathToDisk = pathToDiskList[i]
  local pathToTaiConfig = pathToDisk.."/tai/config.txt"
  local checkCon = check_file(pathToTaiConfig)
  if checkCon == 1 then
   --备份config.txt
   file_copy_to_file(pathToTaiConfig, pathToTaiConfig..".bak")
   --读取文本
   local contenido = {}
	  for linea in io.lines(pathToTaiConfig) do
	   local lineStr = trim(linea)
	   local linePreName = files.nopath(lineStr)
	   if linePreName ~= storagemgrSkprxName and linePreName ~= gamesdSkprxName and linePreName ~= usbmcSkprxName then
	    table.insert(contenido, linea)
	   end
	  end
   --写入文本
   local taiConfigFile = io.open(pathToTaiConfig, "w+")
 	 for i = 1, #contenido do
	   taiConfigFile:write(contenido[i].."\n")
  	end
	  taiConfigFile:close()
	 end
	end
 
 --删除旧插件
 files.delete(pathToUrStoragemgrSkprx)
 files.delete(pathToUrStorageConfigTxt)
 files.delete(pathToUrStoragemgrLogTxt)
 files.delete(pathToUrGamesdSkprx)
 files.delete(pathToUrUsbmcSkprx)

 buttons.homepopup(1)
 local state = show_sample_dialog(TIPS, UNINSTALL_TF_USB_COMPLETE, BUTTON_CANCEL, BUTTON_POSITIVE)
 if state == 1 then
  show_waiting_dialog(WAIT_EXECUTING)
  power.restart()
 end

end

--------------刷新游戏气泡-------------------------------
function refresh_psv_apps()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 --刷新成功数量
 COMPLETE_COUNTS = 0
 --要刷新的盘符和app路径
 local refreshDev = "ux0"
 local refreshDevPath = refreshDev..":"
 local pathToRefreshApp = refreshDevPath.."/app"
 --如果没有找到要刷新的目录，则返回
 if not files.exists(pathToRefreshApp) then
  buttons.homepopup(1)
  show_sample_dialog(TIPS, PSV_MANAGER_REFRESH_APP_NO_DIR, BUTTON_BACK)
  return
 end
 --刷新游戏
 local tmpGameList = game.list(3)
 local refreshGameList = files.listdirs(pathToRefreshApp)
	table.sort(refreshGameList, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
 for i = 1, #refreshGameList do
  local refreshFileName = refreshGameList[i].name
  local pathToRefreshFile = refreshGameList[i].path
  local pathToRefreshFileEboot = pathToRefreshFile.."/eboot.bin"
  local pathToRefreshFileSfo = pathToRefreshFile.."/sce_sys/param.sfo"
  local pathToRefreshFileHead = pathToRefreshFile.."/sce_sys/package/head.bin"
  --如果游戏文件夹合法
  if files.exists(pathToRefreshFileEboot) and files.exists(pathToRefreshFileSfo) and files.exists(pathToRefreshFileHead) then
   --读取sfo
   local gameInfo = game.info(pathToRefreshFileSfo)
   --如果sfo合法
   if gameInfo then
    --获取要安装的游戏ID
    refreshGameId = gameInfo.TITLE_ID
   end
   local gameExists = false
   local refreshBl = false
   local installResult = false
   --如果获取到的游戏ID不为空，且不是正在运行的本软件
   if refreshGameId and refreshGameId ~= os.titleid() then
    for j = 1, #tmpGameList do
     if tmpGameList[j].id == refreshGameId then
      gameExists = true
      break
     end
    end
    if gameExists then
     if not game.rif(refreshGameId) and not game.frif(refreshGameId) then
      refreshBl = true
     end
    else
     refreshBl = true
    end
   end     
   
   if refreshBl then
   
    INSTALL_GAME_ID = refreshGameId
    --创建要刷新的游戏的同盘符临时目录
    local pathToRefreshTmp = refreshDevPath.."/temp/refresh_app_tmp"
    files.delete(pathToRefreshTmp)
    files.mkdir(pathToRefreshTmp)
    --要刷新的盘符app相关目录
    local pathToRefreshApp = refreshDevPath.."/app"
    local pathToRefreshAppGame = pathToRefreshApp.."/"..refreshGameId
    --创建要刷新的盘符app下同名文件夹临时备份目录
    local pathToRefreshBakTmp = pathToRefreshTmp.."/backup"
    local pathToRefreshBakTmpAppGame = pathToRefreshBakTmp.."/"..refreshGameId
    files.delete(pathToRefreshBakTmp)
    files.mkdir(pathToRefreshBakTmp)
    --移动要刷新盘符的游戏安装包到同盘符临时目录
    files.move(pathToRefreshFile, pathToRefreshTmp)
    local pathToRefreshTmpFile = pathToRefreshTmp.."/"..refreshFileName
    files.rename(pathToRefreshTmpFile, refreshGameId)
    local pathToRefreshTmpGame = pathToRefreshTmp.."/"..refreshGameId
    --移动要刷新盘符app下的同名游戏目录到临时备份目录
    files.move(pathToRefreshAppGame, pathToRefreshBakTmp)
    --移动ux0盘符app下的同名游戏目录到临时备份目录
    files.move(pathToUxAppGame, pathToUxBakTmp)
    --临时目录下sce_sys和eboot路径
    local pathToRefreshTmpGameSys = pathToRefreshTmpGame.."/sce_sys"
    local pathToRefreshTmpGamePfs = pathToRefreshTmpGame.."/sce_pfs"
    local pathToRefreshTmpGameEboot = pathToRefreshTmpGame.."/eboot.bin"    local pathToRefreshBakTmpGameSysPackage = pathToRefreshTmpGameSys.."/package"
    installResult = game.refresh(pathToRefreshTmpGame)     
    if installResult == 1 then
     files.delete(pathToUxBakTmpAppGame)
     COMPLETE_COUNTS += 1
     local tmpInfo = {id = refreshGameId}
     table.insert(tmpGameList, tmpInfo)     
    else
     files.rename(pathToRefreshTmpGame, refreshFileName)
    end
    --还原文件
    files.move(pathToRefreshTmpFile, files.nofile(pathToRefreshFile))
    files.move(pathToRefreshBakTmpAppGame, pathToRefreshApp)
    --删除临时目录
    files.delete(pathToRefreshTmp)
   end --
  end --
 end --for i = 1, #refreshGameList
 
 buttons.homepopup(1)
 show_sample_dialog(TIPS, string.format(PSV_MANAGER_REFRESH_APP_COMPLETE, COMPLETE_COUNTS), BUTTON_BACK)

end

--------------刷新游戏气泡-------------------------------
function refresh_psv_apps()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 --刷新成功数量
 COMPLETE_COUNTS = 0
 --要刷新的盘符和app路径
 local refreshDev = "ux0"
 local refreshDevPath = refreshDev..":"
 local pathToRefreshApp = refreshDevPath.."/app"
 --如果没有找到要刷新的目录，则返回
 if not files.exists(pathToRefreshApp) then
  buttons.homepopup(1)
  show_sample_dialog(TIPS, PSV_MANAGER_REFRESH_APP_NO_DIR, BUTTON_BACK)
  return
 end
 --刷新游戏
 local tmpGameList = game.list(3)
 local refreshGameList = files.listdirs(pathToRefreshApp)
	table.sort(refreshGameList, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
 for i = 1, #refreshGameList do
  local refreshFileName = refreshGameList[i].name
  local pathToRefreshFile = refreshGameList[i].path
  local pathToRefreshFileEboot = pathToRefreshFile.."/eboot.bin"
  local pathToRefreshFileSfo = pathToRefreshFile.."/sce_sys/param.sfo"
  local pathToRefreshFileHead = pathToRefreshFile.."/sce_sys/package/head.bin"
  --如果游戏文件夹合法
  if files.exists(pathToRefreshFileEboot) and files.exists(pathToRefreshFileSfo) and files.exists(pathToRefreshFileHead) then
   --读取sfo
   local gameInfo = game.info(pathToRefreshFileSfo)
   --如果sfo合法
   if gameInfo then
    --获取要安装的游戏ID
    refreshGameId = gameInfo.TITLE_ID
   end
   local gameExists = false
   local refreshBl = false
   local installResult = false
   --如果获取到的游戏ID不为空，且不是正在运行的本软件
   if refreshGameId and refreshGameId ~= os.titleid() then
    for j = 1, #tmpGameList do
     if tmpGameList[j].id == refreshGameId then
      gameExists = true
      break
     end
    end
    if gameExists then
     if not game.rif(refreshGameId) and not game.frif(refreshGameId) then
      refreshBl = true
     end
    else
     refreshBl = true
    end
   end     
   
   if refreshBl then
   
    INSTALL_GAME_ID = refreshGameId
    --创建要刷新的游戏的同盘符临时目录
    local pathToRefreshTmp = refreshDevPath.."/temp/refresh_app_tmp"
    files.delete(pathToRefreshTmp)
    files.mkdir(pathToRefreshTmp)
    --要刷新的盘符app相关目录
    local pathToRefreshApp = refreshDevPath.."/app"
    local pathToRefreshAppGame = pathToRefreshApp.."/"..refreshGameId
    --创建要刷新的盘符app下同名文件夹临时备份目录
    local pathToRefreshBakTmp = pathToRefreshTmp.."/backup"
    local pathToRefreshBakTmpAppGame = pathToRefreshBakTmp.."/"..refreshGameId
    files.delete(pathToRefreshBakTmp)
    files.mkdir(pathToRefreshBakTmp)
    --移动要刷新盘符的游戏安装包到同盘符临时目录
    files.move(pathToRefreshFile, pathToRefreshTmp)
    local pathToRefreshTmpFile = pathToRefreshTmp.."/"..refreshFileName
    files.rename(pathToRefreshTmpFile, refreshGameId)
    local pathToRefreshTmpGame = pathToRefreshTmp.."/"..refreshGameId
    --移动要刷新盘符app下的同名游戏目录到临时备份目录
    files.move(pathToRefreshAppGame, pathToRefreshBakTmp)
    --临时目录下sce_sys和eboot路径
    local pathToRefreshTmpGameSys = pathToRefreshTmpGame.."/sce_sys"
    local pathToRefreshTmpGamePfs = pathToRefreshTmpGame.."/sce_pfs"
    local pathToRefreshTmpGameEboot = pathToRefreshTmpGame.."/eboot.bin"    local pathToRefreshBakTmpGameSysPackage = pathToRefreshTmpGameSys.."/package"
    installResult = game.refresh(pathToRefreshTmpGame)     
    if installResult == 1 then
     files.delete(pathToRefreshBakTmpAppGame)
     COMPLETE_COUNTS += 1
     local tmpInfo = {id = refreshGameId}
     table.insert(tmpGameList, tmpInfo)     
    else
     files.rename(pathToRefreshTmpGame, refreshFileName)
    end
    --还原文件
    files.move(pathToRefreshTmpFile, files.nofile(pathToRefreshFile))
    files.move(pathToRefreshBakTmpAppGame, pathToRefreshApp)
    --删除临时目录
    files.delete(pathToRefreshTmp)
   end --
  end --
 end --for i = 1, #refreshGameList
 
 if COMPLETE_COUNTS > 0 then
  show_waiting_dialog(WAIT_LOADING)
 end

 buttons.homepopup(1)
 show_sample_dialog(TIPS, string.format(PSV_MANAGER_REFRESH_APP_COMPLETE, COMPLETE_COUNTS), BUTTON_BACK)

end










