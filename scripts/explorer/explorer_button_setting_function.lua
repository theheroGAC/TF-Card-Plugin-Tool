-------explorer_button_setting_function-------------------------------------------------------------------

function explorer_button_setting()
 
 buttons.read() --读取按键

 ---------------select键设置-------------------------
 if buttons.select then
 
  ftp_server()
  
 end --select键设置
 
 -------------------↑键设置-------------------------------
 if buttons.up or buttons.analogly < -60 then
  
  if explorerInfo.list and #explorerInfo.list > 0 then
	  if explorerInfo.focus > 1 then
	   explorerInfo.focus -= 1
   end
	 end
	  
	end --↑键设置
     
 -------------------↓鍵設置-------------------------------
 if buttons.down or buttons.analogly > 60 then
  
  if explorerInfo.list and #explorerInfo.list > 0 then
   if explorerInfo.focus < #explorerInfo.list then
    explorerInfo.focus += 1
	  end
  end
   
	end --↓键设置

 -------------------←键设置-------------------------------
 if buttons.left then

  if explorerDevInfo.list and #explorerDevInfo.list > 0 then
   local tmpPos = explorerDevInfo.focus - 1
   if tmpPos < 1 then
    tmpPos = #explorerDevInfo.list
   end
	  if tmpPos ~= explorerDevInfo.focus then
	   explorerDevInfo.focus = tmpPos
	   explorerInfo = explorerInfos[explorerDevInfo.focus]
	   if explorerInfo.rootType and explorerInfo.rootType == "zip" then
	    explorer_get_zipFileList(explorerInfo.rootPath)
	   else
	    explorer_get_filelist(explorerInfo.rootPath)
	   end
	  end
	 end

 end --←键设置
     
 -------------------→键设置-------------------------------
 if buttons.right then

  if explorerDevInfo.list and #explorerDevInfo.list > 0 then
   local tmpPos = explorerDevInfo.focus + 1
   if tmpPos > #explorerDevInfo.list then
    tmpPos = 1
   end
	  if tmpPos ~= explorerDevInfo.focus then
	   explorerDevInfo.focus = tmpPos
	   explorerInfo = explorerInfos[explorerDevInfo.focus]
	   if explorerInfo.rootType and explorerInfo.rootType == "zip" then
	    explorer_get_zipFileList(explorerInfo.rootPath)
	   else
	    explorer_get_filelist(explorerInfo.rootPath)
	   end
	  end
	 end
	
	end --→键设置

--------------------□键设置-------------------------------
 if buttons.square then

  if explorerInfo.list and #explorerInfo.list > 0 then
	  if explorerInfo.list[explorerInfo.focus].mark then
    explorerInfo.list[explorerInfo.focus].mark = false
    explorerInfo.marksCounts -= 1
   else
    explorerInfo.list[explorerInfo.focus].mark = true
    explorerInfo.marksCounts += 1
   end
  end

 end

 --------------------△键设置-------------------------------
 if buttons.triangle then
 
  explorerMenuInfo.usable = {false, false, false, false, false, false, false, false, false, false, false, false, true}
  explorerMenuInfo.focus = 13
  explorerMenuInfo.list[1] = EXPLORE_MARKS_ALL
  if explorerDevInfo.list and #explorerDevInfo.list > 0 then
   if explorerInfo.list then
    if not explorerInfo.rootType or explorerInfo.rootType ~= "zip" then
     explorerMenuInfo.usable[8] = true
     explorerMenuInfo.usable[9] = true
     explorerMenuInfo.focus = 8
     if explorerMarksInfo.list and #explorerMarksInfo.list > 0 and not (explorerMarksInfo.mode == 2 and explorerMarksInfo.focus ~= explorerDevInfo.focus) then
      explorerMenuInfo.usable[4] = true
      explorerMenuInfo.focus = 4
     end
    end
    if #explorerInfo.list > 0 then
     if explorerInfo.marksCounts == #explorerInfo.list then
      explorerMenuInfo.list[1] = EXPLORE_UNMARKS_ALL
     end
     explorerMenuInfo.usable[1] = true
     explorerMenuInfo.usable[2] = true
     if not explorerInfo.rootType or explorerInfo.rootType ~= "zip" then
      explorerMenuInfo.usable[3] = true
      explorerMenuInfo.usable[5] = true
      explorerMenuInfo.usable[6] = true
      explorerMenuInfo.usable[7] = true
      if explorerInfo.list[explorerInfo.focus].isDir then
       explorerMenuInfo.usable[10] = true
      else
       local fileExt = explorerInfo.list[explorerInfo.focus].ext
       if fileExt == "png" or fileExt == "jpg" or fileExt == "bmp" or fileExt == "gif" or fileExt == "mp3" or fileExt == "mp4" then
        explorerMenuInfo.usable[11] = true
       end
      end
     end
     explorerMenuInfo.focus = 1

    end
   end
  end
  local state = show_list_dialog(PLEASE_SELECT, explorerMenuInfo, BUTTON_CANCEL, BUTTON_POSITIVE)
  if state == 1 then --全选/全不选
   if explorerInfo.marksCounts < #explorerInfo.list then
    explore_mark_all()
   else
    explore_unmark_all()
   end
   show_close_dialog()
   
  elseif state == 2 then --复制
   if explorerInfo.rootType and explorerInfo.rootType == "zip" then 
    explore_get_markslist(3) --复制zip压缩包里的文件
   else
    explore_get_markslist(1) --复制普通文件
   end
   
  elseif state == 3 then --剪切
   explore_get_markslist(2)
   
  elseif state == 4 then --粘贴
   explore_paste_files()
   
  elseif state == 5 then --删除
   SELECT_COUNTS = 1 --要操作的文件数量
   if explorerInfo.list[explorerInfo.focus].mark and explorerInfo.marksCounts > 1 then
    SELECT_COUNTS = explorerInfo.marksCounts
   end
   local state = show_sample_dialog(TIPS, string.format(EXPLORE_DELETE_READY, SELECT_COUNTS), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then
    explore_delete_files()
   end
   
  elseif state == 6 then --创建压缩文档
   local state = show_sample_dialog(TIPS, EXPLORE_MAKE_ZIP_READY, BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then
    explore_make_zip()
   end

  elseif state == 7 then --重命名
   explore_rename_file()

  elseif state == 8 then --新建文件
   explore_create_file()

  elseif state == 9 then --新建文件夹
   explore_mark_dir()

  elseif state == 10 then --安装游戏文件夹
   explorerInstallPathSelectMenuInfo.focus = 1
   SELECT_COUNTS = 1 --要操作的文件数量
   if explorerInfo.list[explorerInfo.focus].mark then
    SELECT_COUNTS = explorerInfo.marksCounts
   end
   local state = show_list_dialog(PLEASE_SELECT, explorerInstallPathSelectMenuInfo, BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then --安装已解密的游戏
    local state = show_sample_dialog(TIPS, string.format(EXPLORE_INSTALL_APP_READY, SELECT_COUNTS), BUTTON_CANCEL, BUTTON_POSITIVE)
    if state == 1 then 
     explore_install_apps(1)
    end
   elseif state == 2 then --安装nonpdrm游戏
    local state = show_sample_dialog(TIPS, string.format(EXPLORE_INSTALL_APP_READY, SELECT_COUNTS), BUTTON_CANCEL, BUTTON_POSITIVE)
    if state == 1 then 
     explore_install_apps(2)
    end
   end
  
  elseif state == 11 then --导出多媒体文件
   SELECT_COUNTS = 1 --要操作的文件数量
   if explorerInfo.list[explorerInfo.focus].mark and explorerInfo.marksCounts > 1 then
    SELECT_COUNTS = explorerInfo.marksCounts
   end
   local state = show_sample_dialog(TIPS, string.format(EXPLORE_EXPORT_MULTIMEDIA_READY, SELECT_COUNTS), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then
    explore_export_files()
   end
  
  elseif state == 13 then --退出
   explorerRun = false
   show_close_dialog()
   
  end
  
 end --△键设置

 --------------------X键设置----------------------
 if buttons.cross then
 
  if explorerInfo.rootInfo and #explorerInfo.rootInfo > 0 then
   explorerInfo.top = explorerInfo.rootInfo[#explorerInfo.rootInfo].top
   explorerInfo.focus = explorerInfo.rootInfo[#explorerInfo.rootInfo].focus
   explorerInfo.rootPath = explorerInfo.rootInfo[#explorerInfo.rootInfo].rootPath
   explorerInfo.rootType = explorerInfo.rootInfo[#explorerInfo.rootInfo].rootType
   table.remove(explorerInfo.rootInfo, #explorerInfo.rootInfo)

   if explorerInfo.rootType and explorerInfo.rootType == "zip" then
    explorer_get_zipFileList(explorerInfo.rootPath)
   else
    explorer_get_filelist(explorerInfo.rootPath)
   end
  else
   explorerRun = false
  end
  
 end --X键设置

 -------------------○键设置-------------------------------
 if buttons.circle then 
  
  if explorerInfo.list and #explorerInfo.list > 0 then
   
   local filePath = explorerInfo.rootPath..explorerInfo.list[explorerInfo.focus].name
   if explorerInfo.list[explorerInfo.focus].isDir then
    
    local tmpInfo = {rootPath = explorerInfo.rootPath, rootType = explorerInfo.rootType, focus = explorerInfo.focus, top = explorerInfo.top} --保存历史文件列表信息
    table.insert(explorerInfo.rootInfo, tmpInfo)
    if explorerInfo.rootType and explorerInfo.rootType == "zip" then
     explorer_get_zipFileList(filePath)
    else
     explorer_get_filelist(filePath)
    end
    explorerInfo.rootPath = filePath.."/"
    explorerInfo.focus = 1
    explorerInfo.top = 1
    
   else
    
    --如果是压缩包则返回
    if explorerInfo.rootType and explorerInfo.rootType == "zip" then
     return
    end
    
    local fileExt = explorerInfo.list[explorerInfo.focus].ext
    if fileExt == "vpk" then
     SELECT_COUNTS = 1
     INSTALL_APP_SCAN = true
     local state = show_sample_dialog(TIPS, string.format(EXPLORE_INSTALL_APP_READY, SELECT_COUNTS), BUTTON_CANCEL, BUTTON_POSITIVE)
     if state == 1 then
      buttons.homepopup(0)
      COMPLETE_COUNTS = 0
      INSTALL_GAME_ID = nil
      local installBl = game.install(filePath)
      if installBl == 1 then
       COMPLETE_COUNTS += 1
       if secondIntoPsvmanager then
        psvmanagerInfo.list = nil
       end
      end
      buttons.homepopup(1)
      if INSTALL_CANCEL then
       show_close_dialog()
      else
       show_sample_dialog(TIPS, string.format(EXPLORE_INSTALL_APP_COMPLETE, COMPLETE_COUNTS), BUTTON_BACK)
      end
     end --if state == 1
    
    elseif fileExt == "zip" then
     if not SCREENSHOTS then
      SCREENSHOTS = screen.buffertoimage()
     end
     --获取压缩包文件列表
     local state = explorer_get_zipFileDataList(filePath)
     if state then
      --保存历史文件列表信息
      local tmpInfo = {rootPath = explorerInfo.rootPath, rootType = explorerInfo.rootType, focus = explorerInfo.focus, top = explorerInfo.top}
      table.insert(explorerInfo.rootInfo, tmpInfo)

      explorer_get_zipFileList(filePath)
      explorerInfo.rootPath = filePath.."/"
      explorerInfo.focus = 1
      explorerInfo.top = 1
      show_close_dialog()
     else
      show_sample_dialog(TIPS, EXPLORE_OPEN_ZIP_FAILED, BUTTON_BACK)
     end
     
    elseif fileExt == "txt" or fileExt == "ini" then
     EDIT_FILE_NAME = explorerInfo.list[explorerInfo.focus].name
     EDIT_FILE_PATH = filePath
     TEXTEDITOR_READ_ONLY = false
     dofile("scripts/texteditor/texteditor.lua")
     
    else
     local state = show_sample_dialog(TIPS, EXPLORE_OPEN_UKNOW_FILE_READY, BUTTON_CANCEL, BUTTON_POSITIVE)
     if state == 1 then
      EDIT_FILE_NAME = explorerInfo.list[explorerInfo.focus].name
      EDIT_FILE_PATH = filePath
      TEXTEDITOR_READ_ONLY = false
      dofile("scripts/texteditor/texteditor.lua")
     end
     
    end --if explorerInfo.list[explorerInfo.focus].ext == "vpk"
   
   end --if explorerInfo.list[explorerInfo.focus].size
  
  end --if explorerInfo.list and
  
 end --○键设置
 
---------------------------------------
end














