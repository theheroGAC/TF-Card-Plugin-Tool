----------------main_function.lua------------------------


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
  "MCD=ux0",
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
  local checkCon = files_exists(pathToTaiConfig)
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
 local checkCon = files_exists(pathToTaiConfig)
 if checkCon ~= 1 then
  if checkCon == 2 then
   files.delete(pathToTaiConfig)
  end
  if files_create(pathToTaiConfig) then
   checkCon = 1
  end
 end
 if checkCon == 1 then
  taiConfigExists = true
  --备份config.txt
  file_copy(pathToTaiConfig, pathToTaiConfig..".bak")
  --读取文本
  local kernelStr = "*KERNEL"
  local stopCheckLine = false
  local findKernel = false
  local contenido = {}

	 for linea in io.lines(pathToTaiConfig) do
	  local lineStr = string_trim(linea)
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
 local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_COMPLETE, mainInfo.list[mainInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
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
  local checkCon = files_exists(pathToTaiConfig)
  if checkCon == 1 then
   --备份config.txt
   file_copy(pathToTaiConfig, pathToTaiConfig..".bak")
   --读取文本
   local contenido = {}
	  for linea in io.lines(pathToTaiConfig) do
	   local lineStr = string_trim(linea)
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

--------------刷新ux0:app游戏气泡-------------------------------
function refresh_psv_apps()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 --刷新成功数量
 local completeCounts = 0
 --要刷新的盘符和app路径
 local refreshDev = "ux0:"
 local pathToRefreshApp = refreshDev.."/app"
 --如果没有找到要刷新的目录，则返回
 if not files.exists(pathToRefreshApp) then
  buttons.homepopup(1)
  show_sample_dialog(TIPS, REFRESH_APPS_NO_DIR, BUTTON_BACK)
  return
 end
 --刷新游戏
 local gameList = game.list(3)
 local refreshList = files.listdirs(pathToRefreshApp)
 for i = 1, #refreshList do
  local refreshBl = false
  local refreshGameId = nil
  --过滤已安装的游戏--
  local pathToRefreshFile = refreshList[i].path
  local pathToRefreshFileSfo = pathToRefreshFile.."/sce_sys/param.sfo"
  if files.exists(pathToRefreshFileSfo) then
   --读取sfo
   local gameInfo = game.info(pathToRefreshFileSfo)
   --如果sfo合法
   if gameInfo and gameInfo.TITLE_ID then
    refreshGameId = gameInfo.TITLE_ID
    local gameExists = false
    for j = 1, #gameList do
     if gameList[j].id == refreshGameId then
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
  end
  --如果符合刷新条件
  if refreshBl then
   --刷新游戏
   local refreshResult = refresh_psv_app(pathToRefreshFile)     
   if refreshResult == 1 then
    completeCounts += 1
    table.insert(gameList, {id = refreshGameId})     
   end
  end --if refreshBl then
 end --for i = 1, #refreshList
 
 if completeCounts > 0 then
  if SECOND_INTO_PSVMANAGER then
   psvmanagerInfo.list = nil
  end
 end

 buttons.homepopup(1)
 show_sample_dialog(TIPS, string.format(REFRESH_APPS_COMPLETE, completeCounts), BUTTON_BACK)

end










