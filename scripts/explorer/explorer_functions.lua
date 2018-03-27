--------------explorer_function---------------------------------------------------------


------------------获取文件列表---------------------
function explorer_get_filelist(filePath)
	
	explorerInfo.list = {}
	explorerInfo.rootType  = nil
	local dirList = files.listdirs(filePath)
	if dirList then 
		table.sort(dirList, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
	 for i = 1, #dirList do
	  dirList[i].isDir = true
	  dirList[i].mark = false
	  table.insert(explorerInfo.list, dirList[i])
	 end
	end

	local fileList = files.listfiles(filePath)
	if fileList then
		table.sort(fileList, function(a,b) return string.lower(a.name) < string.lower(b.name) end)
		for i = 1, #fileList do
		 fileList[i].formatSize = files.sizeformat(fileList[i].size)
		 fileList[i].isDir = false
		 fileList[i].mark = false
			table.insert(explorerInfo.list, fileList[i])
		end
	end
 
 explorerInfo.marksCounts = 0
 local listCounts = #explorerInfo.list
 if listCounts == 0 then
	 explorerInfo.focus = 1
	elseif explorerInfo.focus > listCounts then
	 explorerInfo.focus = listCounts
	end
	if #explorerInfo.list > explorerShowCount and explorerInfo.top > #explorerInfo.list - (explorerShowCount - 1) then
	 explorerInfo.top = #explorerInfo.list - (explorerShowCount - 1)
	end

	if listCounts > explorerShowCount then
  explorer_scrollbarOne_h = explorer_scrollbarBK_h/listCounts
  explorer_scrollbar_h = explorer_scrollbarOne_h*explorerShowCount
 end

end

------------------获取压缩包文件信息列表--------------------------
function explorer_get_zipFileDataList(filePath)
 
 show_waiting_dialog(WAIT_EXECUTING)
 
 local tmpZipList = files.scan(filePath)
 if not tmpZipList then
  return false
 end
 explorerInfo.zipFileList = {}
 explorerInfo.zipFilePath = filePath
 table.sort(tmpZipList, function(a,b) return string.lower(a.name) < string.lower(b.name) end)
 local insertLine = 1
 for i = 1, #tmpZipList do
  local mFilePath = filePath.."/"..tmpZipList[i].name
  local fileIsDir = false
  if string.sub(mFilePath, -1, -1) == "/" then
   fileIsDir = true
   mFilePath = string.sub(mFilePath, 1, -2)
  end
  local mName = files.nopath(mFilePath)
  local mFileName = tmpZipList[i].name
  local tmpList = {name = mName, filename = mFileName, path = mFilePath, size = tmpZipList[i].size, focus = tmpZipList[i].focus, unsafe = tmpZipList[i].unsafe, realsize = tmpZipList[i].realsize, isDir = fileIsDir}
  if fileIsDir then
   table.insert(explorerInfo.zipFileList, insertLine, tmpList)
   insertLine += 1
  else
   tmpList.formatSize = files.sizeformat(tmpList.size)
   table.insert(explorerInfo.zipFileList, tmpList)
  end
 end
 return true
 
end

------------------获取压缩包文件列表--------------------------
function explorer_get_zipFileList(filePath)
 
 explorerInfo.list = {}
 explorerInfo.rootType = "zip"
 local newRootPath = filePath
 if string.sub(filePath, -1, -1) ~= "/" then
  newRootPath = filePath.."/"
 end
 local newRootPathLen = string.len(newRootPath)
 if explorerInfo.zipFileList then
  local index = newRootPathLen + 1
  for i = 1, #explorerInfo.zipFileList do
   local fileList = explorerInfo.zipFileList[i]
   fileList.mark = false
   local filePathLen = string.len(fileList.path)
   if filePathLen > newRootPathLen and string.sub(fileList.path, 1, newRootPathLen) == newRootPath then
    local a, b = string.find(fileList.path, "/", index)
    if not b or b == filePathLen then
     table.insert(explorerInfo.list, fileList)
    end
   end
  end
 end
 
 	explorerInfo.marksCounts = 0
 if #explorerInfo.list == 0 then
	 explorerInfo.focus = 1
	elseif explorerInfo.focus > #explorerInfo.list then
	 explorerInfo.focus = #explorerInfo.list
	end

end

-------------------全选--------------------------
function explore_mark_all()
	for i = 1, #explorerInfo.list do
  explorerInfo.list[i].mark = true
 end
 explorerInfo.marksCounts = #explorerInfo.list
end

------------------取消全选--------------------------
function explore_unmark_all()
	for i = 1, #explorerInfo.list do
  explorerInfo.list[i].mark = false
 end
 explorerInfo.marksCounts = 0
end

-----------------获取标记列表---------------------
function explore_get_markslist(pasteMode)

 explorerMarksInfo.list = {}
 explorerMarksInfo.focus = explorerDevInfo.focus
 explorerMarksInfo.mode = pasteMode
 explorerMarksInfo.rootPath = explorerInfo.rootPath
 if pasteMode == 3 then
  explorerMarksInfo.zipFilePath = explorerInfo.zipFilePath
  explorerMarksInfo.zipRootPath = string.sub(explorerInfo.rootPath, string.len(explorerInfo.zipFilePath) + 2, -1)
  explorerMarksInfo.zipFileList = explorerInfo.zipFileList
 end
 local focusMarkBl = explorerInfo.list[explorerInfo.focus].mark
 for i = 1, #explorerInfo.list do
  if i == explorerInfo.focus or (focusMarkBl and explorerInfo.list[i].mark) then
   table.insert(explorerMarksInfo.list, explorerInfo.list[i])
   explorerInfo.list[i].mark = false
  end
 end
 show_close_dialog()
 
end

------------------粘贴文件---------------------
function explore_paste_files()
 
 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 if explorerMarksInfo.rootPath == explorerInfo.rootPath then
  buttons.homepopup(1)
  show_close_dialog()
  return
 end
 
 local filesTotalSize = 0
 local unzipTmpPath = explorerDevInfo.list[explorerDevInfo.focus].."/temp/unzip_tmp"

 if explorerMarksInfo.mode == 1 then
  --获取要粘贴的文件总大小
  SHOW_CALLBACK_SELF_COPY = true
  COPY_FILES_TOTAL_SIZE = 0
  COPY_FILES_TOTAL_WRITTEN = 0
  COPY_FILES_WRITED = 0
  
  for i = 1, #explorerMarksInfo.list do
   local copyFileSize = files.size(explorerMarksInfo.list[i].path)
   COPY_FILES_TOTAL_SIZE += copyFileSize
  end
  filesTotalSize = COPY_FILES_TOTAL_SIZE
  
 elseif explorerMarksInfo.mode == 3 then --解压缩
	 files.delete(unzipTmpPath)
	 files.mkdir(unzipTmpPath)

  --获取要解压的文件总大小
  SHOW_CALLBACK_SELF_UNZIP = true
  UNZIP_FILES_TOTAL_SIZE = 0
  UNZIP_FILES_TOTAL_WRITTEN = 0
  UNZIP_FILES_WRITED = 0

  --获取要解压缩的文件名列表和总大小
  local tmpList = {}
  for i = 1, #explorerMarksInfo.list do
		 table.insert(tmpList, explorerMarksInfo.list[i])
		 if explorerMarksInfo.list[i].isDir then
		  local unZipFileName = explorerMarksInfo.list[i].filename
		  local unZipFileNameLen = string.len(unZipFileName)
		  for j = 1, #explorerMarksInfo.zipFileList do
		   local zipFileName = explorerMarksInfo.zipFileList[j].filename
		   local zipFileNameLen = string.len(zipFileName)
		   if zipFileNameLen > unZipFileNameLen and string.sub(zipFileName, 1, unZipFileNameLen) == unZipFileName then
		    table.insert(tmpList, explorerMarksInfo.zipFileList[j])
		    UNZIP_FILES_TOTAL_SIZE += explorerMarksInfo.zipFileList[j].size
		   end
		  end
		 else
		  UNZIP_FILES_TOTAL_SIZE += explorerMarksInfo.list[i].size
		 end --if explorerMarksInfo.list[i].isDir
	 end --for i = 1, #explorerMarksInfo.list
	 explorerMarksInfo.list = tmpList
	 filesTotalSize = UNZIP_FILES_TOTAL_SIZE
 end --if explorerMarksInfo.mode == 3
 
 --检测安装空间是否足够
 local dstDev = explorerDevInfo.list[explorerDevInfo.focus]
 local freespaceBl = true
 if explorerMarksInfo.mode ~= 2 then
  freespaceBl = check_freespace(dstDev, filesTotalSize)
 end
 if not freespaceBl then
  buttons.homepopup(1)
  show_sample_dialog(TIPS, EXPLORE_FREESPACE_NOTENOUGH, BUTTON_BACK)
  return
 end

 --粘贴文件
 local stopCopy = false
 for i = 1, #explorerMarksInfo.list do
  --判断是否自我复制
  if explorerMarksInfo.list[i].isDir and explorerMarksInfo.mode ~= 3 then
   local pathToSrcDir = explorerMarksInfo.list[i].path.."/"
   local pathSrcLength = string.len(pathToSrcDir)
   local pathDstLength = string.len(explorerInfo.rootPath)
   if pathDstLength >= pathSrcLength and string.sub(explorerInfo.rootPath, 1, pathSrcLength) == pathToSrcDir then
    stopCopy = true
   end
  end
  --如果不是自我复制则执行粘贴
  if not stopCopy then
   --判断是复制或剪切或解压缩
   if explorerMarksInfo.mode == 1 then
    files.copy(explorerMarksInfo.list[i].path, explorerInfo.rootPath)
   elseif explorerMarksInfo.mode == 2 then
    files.move(explorerMarksInfo.list[i].path, explorerInfo.rootPath)
	  	elseif explorerMarksInfo.mode == 3 then --解压缩
	  	 local state = files.extractfile(explorerMarksInfo.zipFilePath, explorerMarksInfo.list[i].filename, unzipTmpPath)
	  	 if state == 1 and not explorerMarksInfo.list[i].isDir then
	  	  UNZIP_FILES_WRITED += explorerMarksInfo.list[i].size
	  	 end
	  	end --if explorerMarksInfo.mode == 1
  end --if not stopCopy
  
 end --for i = 1, #explorerMarksInfo.list
 
 if explorerMarksInfo.mode == 3 then --解压缩
  local fileList = files.list(unzipTmpPath.."/"..explorerMarksInfo.zipRootPath)
	 if fileList then
	  for i = 1, #fileList do
	   files.move(fileList[i].path, explorerInfo.rootPath)
	  end
	 end
	 --删除临时文件
	 files.delete(unzipTmpPath)
	end
 --刷新列表
 explorer_get_filelist(explorerInfo.rootPath)
 --标记复制的文件，并重定义光标
 for i = 1, #explorerInfo.list do
  for j = 1, #explorerMarksInfo.list do
   if explorerMarksInfo.list[j].name == explorerInfo.list[i].name then
    explorerInfo.focus = i
    explorerInfo.list[i].mark = true
    explorerInfo.marksCounts += 1
    break
   end
  end
 end
 --清空粘贴板
 explorerMarksInfo.list = nil
 SHOW_CALLBACK_SELF_COPY = false
 SHOW_CALLBACK_SELF_UNZIP = false
 
 buttons.homepopup(1)
 show_close_dialog()
 
end

------------------删除文件---------------------
function explore_delete_files()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 local completeCounts = 0
 local tmpPos = explorerInfo.focus
 local tmpTop = explorerInfo.top
 for i = 1, #explorerInfo.list do
  if i == explorerInfo.focus or (explorerInfo.list[explorerInfo.focus].mark and explorerInfo.list[i].mark) then
   files.delete(explorerInfo.list[i].path)
   if not files.exists(explorerInfo.list[i].path) then
    completeCounts += 1
    if explorerInfo.focus > i then
     tmpPos -= 1
    end
    if explorerInfo.top > i then
     tmpTop -= 1
    end
   end --if not files.exists
  end --if i == focus or
 end --for i = 1, #explorerInfo.list

 if completeCounts > 0 then
  explorerInfo.focus = tmpPos
  explorerInfo.top = tmpTop
  explorer_get_filelist(explorerInfo.rootPath)
 end
 
 buttons.homepopup(1)
 show_sample_dialog(TIPS, string.format(EXPLORE_DELETE_COMPLETE, completeCounts), BUTTON_BACK)

end

--------------------压缩------------------------------------------
function explore_make_zip()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 UNZIP_CANCEL = false
 local makeZipFileList = {}
 local dstZipFileName = ""
 if files.nofile(explorerInfo.rootPath) == explorerInfo.rootPath then
  local fileNameNumber = 1
  while files.exists(explorerInfo.rootPath..fileNameNumber..".zip") do
   fileNameNumber += 1
  end
  dstZipFileName = fileNameNumber..".zip"
 else
  dstZipFileName = files.nopath(string.sub(explorerInfo.rootPath, 1, -2))
  if files.exists(explorerInfo.rootPath..dstZipFileName..".zip") then
   local fileNameNumber = 1   
   while files.exists(explorerInfo.rootPath..dstZipFileName.."_"..fileNameNumber..".zip") do
    fileNameNumber += 1
   end
   dstZipFileName = dstZipFileName.."_"..fileNameNumber
  end
  dstZipFileName = dstZipFileName..".zip"
 end
 local dstZipFilePath = explorerInfo.rootPath..dstZipFileName
 for i = 1, #explorerInfo.list do
  if i == explorerInfo.focus or (explorerInfo.list[explorerInfo.focus].mark and explorerInfo.list[i].mark) then
   table.insert(makeZipFileList, explorerInfo.list[i].path)
  end --if i == focus or
 end --for i = 1, #explorerInfo.list
 local makezipResult = files.makezip(dstZipFilePath, makeZipFileList)
 --刷新列表
 explorer_get_filelist(explorerInfo.rootPath)
 --重定义光标为刚创建的压缩文档
 for i = 1, #explorerInfo.list do
  if dstZipFileName == explorerInfo.list[i].name then
   explorerInfo.focus = i
   explorerInfo.list[i].mark = true
   explorerInfo.marksCounts += 1
   break
  end
 end
 buttons.homepopup(1)
 if makezipResult == 1 or UNZIP_CANCEL then
  show_close_dialog()
 else
  show_sample_dialog(TIPS, EXPLORE_MAKE_ZIP_FAILED, BUTTON_BACK)
 end

end

------------------重命名---------------------
function explore_rename_file()
 
 show_waiting_dialog(WAIT_EXECUTING)

 local newName = osk.init(EXPLORE_RENAME, explorerInfo.list[explorerInfo.focus].name)
 if newName and newName ~= explorerInfo.list[explorerInfo.focus].name then
  local pathToNewName = files.nofile(explorerInfo.list[explorerInfo.focus].path)..newName
  if not files.exists(pathToNewName) then
   files.rename(explorerInfo.list[explorerInfo.focus].path, newName)
   if files.exists(pathToNewName) then
    --刷新列表
    explorer_get_filelist(explorerInfo.rootPath)
    --标记复制的文件，并重定义光标
    for i = 1, #explorerInfo.list do
     if newName == explorerInfo.list[i].name then
      explorerInfo.focus = i
      explorerInfo.list[i].mark = true
      explorerInfo.marksCounts += 1
      break
     end
    end
    show_close_dialog()
   else
    show_sample_dialog(TIPS, EXPLORE_RENAME_FAILED, BUTTON_BACK)
   end
  else
   show_sample_dialog(TIPS, EXPLORE_RENAME_FAILED_ALREADY_EXISTS, BUTTON_BACK)
  end
 else
  show_close_dialog()
 end
 
end

------------------新建文件---------------------
function explore_create_file()
 
 show_waiting_dialog(WAIT_EXECUTING)

 local newName = osk.init(EXPLORE_CREATE_FILE, "")
 if newName and newName ~= "" then
  local pathToNewName = explorerInfo.rootPath..newName
  if not files.exists(pathToNewName) then
   if files_create(pathToNewName) then
    --刷新列表
    explorer_get_filelist(explorerInfo.rootPath)
    --标记复制的文件，并重定义光标
    for i = 1, #explorerInfo.list do
     if newName == explorerInfo.list[i].name then
      explorerInfo.focus = i
      explorerInfo.list[i].mark = true
      explorerInfo.marksCounts += 1
      break
     end
    end
    show_close_dialog()
   else
    show_sample_dialog(TIPS, EXPLORE_CREATE_FILE_FAILED, BUTTON_BACK)
   end
  else
   show_sample_dialog(TIPS, EXPLORE_CREATE_FILE_FAILED_ALREADY_EXISTS, BUTTON_BACK)
  end
 else
  show_close_dialog()
 end

end

------------------新建文件夹---------------------
function explore_mark_dir()
 
 show_waiting_dialog(WAIT_EXECUTING)

 local newName = osk.init(EXPLORE_MAKE_DIR, "")
 if newName and newName ~= "" then
  local pathToNewName = explorerInfo.rootPath..newName
  if not files.exists(pathToNewName) then
   files.mkdir(pathToNewName)
   if files.exists(pathToNewName) then
    --刷新列表
    explorer_get_filelist(explorerInfo.rootPath)
    --标记复制的文件，并重定义光标
    for i = 1, #explorerInfo.list do
     if newName == explorerInfo.list[i].name then
      explorerInfo.focus = i
      explorerInfo.list[i].mark = true
      explorerInfo.marksCounts += 1
      break
     end
    end
    show_close_dialog()
   else
    show_sample_dialog(TIPS, EXPLORE_MAKE_DIR_FAILED, BUTTON_BACK)
   end
  else
   show_sample_dialog(TIPS, EXPLORE_MAKE_DIR_FAILED_ALREADY_EXISTS, BUTTON_BACK)
  end
 else
  show_close_dialog()
 end

end

----------------安装游戏文件夹---------------------
function explore_install_apps(mode)
 
 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 local uxDev = "ux0:"
 local srcDev = explorerDevInfo.list[explorerDevInfo.focus]
  --如果没有找到ux0盘符，则返回
 if not files.exists(uxDev) then
  buttons.homepopup(1)
  show_sample_dialog(TIPS, EXPLORE_INSTALL_APP_NO_UX_DEV, BUTTON_BACK)
  return
 end

 INSTALL_APP_NOT_SCAN = false
 INSTALL_CANCEL = false
 if srcDev ~= uxDev or SELECT_COUNTS > 1 then
  INSTALL_APP_NOT_SCAN = true
 end
 local completeCounts = 0

 for i = 1, #explorerInfo.list do
  
  if i == explorerInfo.focus or (explorerInfo.list[explorerInfo.focus].mark and explorerInfo.list[i].mark) then 
   if explorerInfo.list[i].isDir then
    local pathToInstallFile = explorerInfo.list[i].path
    local installResult = 0
    if mode == 1 then
     installResult = install_psv_app(pathToInstallFile)
    elseif mode == 2 then
     installResult = refresh_psv_app(pathToInstallFile)    
    end
    if installResult == 1 then
     completeCounts += 1
    elseif installResult == -10 then
     show_sample_dialog(TIPS, EXPLORE_FREESPACE_NOTENOUGH, nil, BUTTON_POSITIVE)
     break
    end
   end --if explorerInfo.list[i].isDir
  end --if i == explorerInfo.focus and
   
 end --for i = 1, #explorerInfo.list do 
 
 explorer_get_filelist(explorerInfo.rootPath)
 if completeCounts > 0 then
  if SECOND_INTO_PSVMANAGER then
   psvmanagerInfo.list = nil
  end
 end
 
 INSTALL_APP_NOT_SCAN = false
 buttons.homepopup(1)
 if INSTALL_CANCEL then
  show_close_dialog()
 else
  show_sample_dialog(TIPS, string.format(EXPLORE_INSTALL_APP_COMPLETE, completeCounts), BUTTON_BACK)
 end
 
end

------------------导出多媒体文件---------------------
function explore_export_files()

 buttons.homepopup(0)
 show_waiting_dialog(WAIT_EXECUTING)
 
 local completeCounts = 0
 for i = 1, #explorerInfo.list do
  
  if i == explorerInfo.focus or (explorerInfo.list[explorerInfo.focus].mark and explorerInfo.list[i].mark) then
   if not explorerInfo.list[i].isDir then
    local fileExt = explorerInfo.list[i].ext
    if fileExt == "png" or fileExt == "jpg" or fileExt == "bmp" or fileExt == "gif" or fileExt == "mp3" or fileExt == "mp4" then
     show_waiting_dialog(explorerInfo.list[i].name)
     local exportResult = files.export(explorerInfo.list[i].path)
     if exportResult == 1 then
      completeCounts += 1
     end
    end
   end
  end
  
 end
 
 explorer_get_filelist(explorerInfo.rootPath)
 
 buttons.homepopup(1)
 show_sample_dialog(TIPS, string.format(EXPLORE_EXPORT_MULTIMEDIA_COMPLETE, completeCounts), BUTTON_BACK)

end
















