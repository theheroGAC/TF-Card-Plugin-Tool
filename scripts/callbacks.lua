------------------callbacks-------------------------------------------------------------------


-------------------复制文件--------------------
function onCopyFiles(size, written, file)
 
 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
	elseif back then 
	 back:blit(0,0)
 end
 MAXDIALOGWIDTH = 740
 MAXDIALOGHEIGHT = 224
 local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
 local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
 screen.print(480, 176, CALLBACKS_COPYING, 1, color.white, color.black, __ACENTER)
 screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, tostring(files.nopath(file))), 1, color.white, color.black)
 screen.print(156, 228, string.format(CALLBACKS_PERCENT, math.floor((written*100)/size)), 1, color.white, color.black)
 screen.print(156, 248, string.format(CALLBACKS_FILE_SIZE, files.sizeformat(size)), 1, color.white, color.black)
 screen.print(396, 248, string.format(CALLBACKS_HAVE_COPYED, files.sizeformat(written)), 1, color.white, color.black)
 if SHOW_CALLBACK_SELF_COPY then
  COPY_FILES_TOTAL_WRITTEN = COPY_FILES_WRITED + written
  if size > 0 and written == size then
   COPY_FILES_WRITED += size
  end
 	screen.print(156, 268, string.format(CALLBACKS_TOTAL_PERCENT, math.floor((COPY_FILES_TOTAL_WRITTEN*100)/COPY_FILES_TOTAL_SIZE)), 1, color.white, color.black)
 	screen.print(156, 288, string.format(CALLBACKS_TOTAL_FILE_SIZE, files.sizeformat(COPY_FILES_TOTAL_SIZE)), 1, color.white, color.black)
 	screen.print(396, 288, string.format(CALLBACKS_HAVE_COPYED, files.sizeformat(COPY_FILES_TOTAL_WRITTEN)), 1, color.white, color.black)
	end
	screen.flip()
	
	--[[buttons.read()
	if buttons.cross then
	 buttons.read()
	 show_waiting_dialog(WAIT_CANCELING)
	 buttons.homepopup(1)
		return 0
	end--]]
	
	return 1

end

-------------------删除文件--------------------
function onDeleteFiles(file)
 
 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
	elseif back then 
	 back:blit(0,0)
 end
 MAXDIALOGWIDTH = 740
 MAXDIALOGHEIGHT = 224
 local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
 local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
	screen.print(480, 176, CALLBACKS_DELETING, 1, color.white, color.black, __ACENTER)
 screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, tostring(files.nopath(file))), 1, color.white, color.black)
	screen.flip()
	
	--[[buttons.read()
	if buttons.cross then
	 buttons.read()
	 show_waiting_dialog(WAIT_CANCELING)
	 buttons.homepopup(1)
		return 0
	end]]
	
	return 1

end

-------------------解压文件--------------------
function onExtractFiles(size, written, file, totalsize, totalwritten)
 
 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
	elseif back then 
	 back:blit(0,0)
 end
 MAXDIALOGWIDTH = 740
 MAXDIALOGHEIGHT = 224
 local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
 local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
	screen.print(480, 176, CALLBACKS_EXTRACTING, 1, color.white, color.black, __ACENTER)
	screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, tostring(files.nopath(file))), 1, color.white, color.black)
	screen.print(156, 228, string.format(CALLBACKS_PERCENT, math.floor((written*100)/size)), 1, color.white, color.black)
	screen.print(156, 248, string.format(CALLBACKS_FILE_SIZE, files.sizeformat(size)), 1, color.white, color.black)
	screen.print(396, 248, string.format(CALLBACKS_HAVE_EXTRACTED, files.sizeformat(written)), 1, color.white, color.black)
 if SHOW_CALLBACK_SELF_UNZIP then
  UNZIP_FILES_TOTAL_WRITTEN = UNZIP_FILES_WRITED + written
  screen.print(156, 268, string.format(CALLBACKS_TOTAL_PERCENT, math.floor((UNZIP_FILES_TOTAL_WRITTEN*100)/UNZIP_FILES_TOTAL_SIZE)), 1, color.white, color.black)
  screen.print(156, 288, string.format(CALLBACKS_TOTAL_FILE_SIZE, files.sizeformat(UNZIP_FILES_TOTAL_SIZE)), 1, color.white, color.black)
  screen.print(396, 288, string.format(CALLBACKS_HAVE_EXTRACTED, files.sizeformat(UNZIP_FILES_TOTAL_WRITTEN)), 1, color.white, color.black)
  screen.print(640, 354, BUTTON_CANCEL, 1, color.white, color.black)

  --[[buttons.read()
  if buttons.cross then
   buttons.read()
   show_waiting_dialog(WAIT_CANCELING)
   buttons.homepopup(1)
		 return 0
	 end]]
 else
  screen.print(156, 268, string.format(CALLBACKS_TOTAL_PERCENT, math.floor((totalwritten*100)/totalsize)), 1, color.white, color.black)
  screen.print(156, 288, string.format(CALLBACKS_TOTAL_FILE_SIZE, files.sizeformat(totalsize)), 1, color.white, color.black)
  screen.print(396, 288, string.format(CALLBACKS_HAVE_EXTRACTED, files.sizeformat(totalwritten)), 1, color.white, color.black)
 end
 screen.flip()
	
end

-------------------压缩文件--------------------
function onCompressZip(size, written, file)

 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
	elseif back then 
	 back:blit(0,0)
 end
 MAXDIALOGWIDTH = 740
 MAXDIALOGHEIGHT = 224
 local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
 local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
	screen.print(480, 176, CALLBACKS_COMPRESSING, 1, color.white, color.black, __ACENTER)
 screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, tostring(files.nopath(file))), 1, color.white, color.black)
 screen.print(156, 228, string.format(CALLBACKS_PERCENT, math.floor((written*100)/size)), 1, color.white, color.black)
 screen.print(640, 354, BUTTON_CANCEL, 1, color.white, color.black)
 screen.flip()

 buttons.read()
	if buttons.cross then
	 	buttons.read()
	 show_waiting_dialog(WAIT_CANCELING)
	 buttons.homepopup(1)
	 UNZIP_CANCEL = true
	 return 0
	end
	
	return 1
	
end

-------------------下载文件--------------------
function onNetGetFile(size, written, speed, step)

 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
	elseif back then 
	 back:blit(0,0)
 end
 MAXDIALOGWIDTH = 740
 MAXDIALOGHEIGHT = 224
 local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
 local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
	screen.print(480, 176, CALLBACKS_DOWNLOADING, 1, color.white, color.black, __ACENTER)
 screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, DOWNLOAD_FILE_NAME), 1, color.white, color.black)
 screen.print(156, 228, string.format(CALLBACKS_PERCENT, math.floor((written*100)/size)), 1, color.white, color.black)
 screen.print(396, 228, tostring(speed).." KB/s", 1, color.white, color.black)
 screen.print(156, 248, string.format(CALLBACKS_FILE_SIZE, files.sizeformat(size)), 1, color.white, color.black)
 screen.print(396, 248, string.format(CALLBACKS_HAVE_DOWNLOADED, files.sizeformat(written)), 1, color.white, color.black)
 screen.print(640, 354, BUTTON_CANCEL, 1, color.white, color.black)
 screen.flip()
 
 buttons.read()
	if buttons.cross then
	 buttons.read()
	 show_waiting_dialog(WAIT_CANCELING)
	 buttons.homepopup(1)
	 return 0
	end
	return 1

end

------------------扫描压缩包--------------------
function onScanningFiles(file, unsize, focusition)
 
 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
	elseif back then 
	 back:blit(0,0)
 end
 MAXDIALOGWIDTH = 740
 MAXDIALOGHEIGHT = 224
 local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
 local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
 screen.print(480, 176, CALLBACKS_SCANING, 1, color.white, color.black, __ACENTER)
 screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, tostring(files.nopath(file))), 1, color.white, color.black)
 screen.print(156, 228, string.format(CALLBACKS_FILE_SIZE, files.sizeformat(unsize)), 1, color.white, color.black)
 screen.flip()
 
end

-------------------安装软件--------------------
function onAppInstall(step, size_argv, written, file, totalsize, totalwritten)
 
 INSTALL_CANCEL = false
 
 if step == 1 then --检测危险性中
  if INSTALL_APP_NOT_SCAN then
   show_waiting_dialog(string.format(WAIT_INSTALLING_APP, INSTALL_GAME_ID or ""))
  else
   show_waiting_dialog(WAIT_CHECKING_APP)
  end
  --INSTALL_GAME_ID = nil
		
 elseif step == 2 then
  if INSTALL_APP_NOT_SCAN then
   return 10  
  else
   local warningMessage = ""
   if size_argv == 1 then --危险警告
    warningMessage = CALLBACKS_SCAN_APP_UNSAFE
   elseif size_argv == 2 then --高危险警告
    warningMessage = CALLBACKS_SCAN_APP_DANGEROUS
   end
   
   messageInfo = get_sample_dialog_info(warningMessage)
   DIALOGWIDTH = 0
   
   while true do
    sample_dialog(TIPS, messageInfo, BUTTON_CANCEL, BUTTON_POSITIVE)	
    musicplayer_autoplaynextmusic()
    buttons.read()
    
    if buttons.circle then
     buttons.read()
     show_waiting_dialog(WAIT_EXECUTING)
     if INSTALL_JUST_CHECK_UNSELF then
      INSTALL_JUST_CHECK_UNSELF = false
      return 0
     else
      return 10
     end
    elseif buttons.cross then
     buttons.read()
     INSTALL_JUST_CHECK_UNSELF = false
     INSTALL_CANCEL = true
     return 0
    end
   end
  end
	
 elseif step == 3 then --解压安装包
  if SCREENSHOTS then
   SCREENSHOTS:blit(0,0)
  elseif back then 
   back:blit(0,0)
  end
  MAXDIALOGWIDTH = 740
  MAXDIALOGHEIGHT = 224
  local x = string.format("%d", (960 - MAXDIALOGWIDTH)/2)
  local y = string.format("%d", (544 - MAXDIALOGHEIGHT)/2)
  --弹窗区域
  draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, 0xFD333333)
  --弹窗描边
  draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
  screen.print(480, 176, CALLBACKS_EXTRACTING, 1, color.white, color.black, __ACENTER)
  screen.print(156, 208, string.format(CALLBACKS_FILE_NAME, tostring(files.nopath(file))), 1, color.white, color.black)
  screen.print(156, 228, string.format(CALLBACKS_PERCENT, math.floor((written*100)/size_argv)), 1, color.white, color.black)
  screen.print(156, 248, string.format(CALLBACKS_FILE_SIZE, files.sizeformat(size_argv)), 1, color.white, color.black)
  screen.print(396, 248, string.format(CALLBACKS_HAVE_EXTRACTED, files.sizeformat(written)), 1, color.white, color.black)
  screen.print(156, 268, string.format(CALLBACKS_TOTAL_PERCENT, math.floor((totalwritten*100)/totalsize)), 1, color.white, color.black)
  screen.print(156, 288, string.format(CALLBACKS_TOTAL_FILE_SIZE, files.sizeformat(totalsize)), 1, color.white, color.black)
  screen.print(396, 288, string.format(CALLBACKS_HAVE_EXTRACTED, files.sizeformat(totalwritten)), 1, color.white, color.black)
  screen.flip()
    
 elseif step == 4 then
  show_waiting_dialog(string.format(WAIT_INSTALLING_APP, INSTALL_GAME_ID or ""))
 
 end
   
end












