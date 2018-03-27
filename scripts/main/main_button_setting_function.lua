-------main_button_setting_function-------------------------------------------------------------------

function main_button_setting()
 
 buttons.read() --读取按键

 ---------------select键设置-------------------------
 if buttons.select then
 
  ftp_server()
  
 end --select键设置
 
 -------------------↑键设置-------------------------------
 if buttons.up or buttons.analogly < -60 then
  
	 if mainInfo.focus > 1 then
	  mainInfo.focus -= 1 
  end

	end --↑键设置
     
 -------------------↓键设置-------------------------------
 if buttons.down or buttons.analogly > 60 then
  
  if mainInfo.focus < #mainInfo.list then
   mainInfo.focus += 1
  end
   
	end --↓键设置
 
 -------------------○键设置-------------------------------
 if buttons.circle then

  if mainInfo.focus == 1 then
   local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_READY, mainInfo.list[mainInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then 
    install_gamesd(1)
   end

  elseif mainInfo.focus == 2 then
   local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_READY, mainInfo.list[mainInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then 
    install_gamesd(2)
   end
   
  elseif mainInfo.focus == 3 then
   local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_READY, mainInfo.list[mainInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then 
    install_gamesd(3)
   end
   
  elseif mainInfo.focus == 4 then
   local installReady = show_sample_dialog(TIPS, string.format(UNINSTALL_TF_USB_READY, mainInfo.list[mainInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if installReady == 1 then
    uninstall_gamesd()
   end
  
  elseif mainInfo.focus == 5 then
   local state = show_sample_dialog(TIPS, REFRESH_APPS_READY, BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then
    refresh_psv_apps()
   end
  
  elseif mainInfo.focus == 6 then
   dofile("scripts/explorer/explorer.lua")
  
  elseif mainInfo.focus == 7 then
   local state = show_sample_dialog(ABOUT, ABOUT_TXT, BUTTON_BACK, nil, BUTTON_UPDATE_LOG)
   if state == 2 then
    SCREENSHOTS = nil
    EDIT_FILE_PATH = "resources/updatelog.txt"
    if files.exists(EDIT_FILE_PATH) then
     EDIT_FILE_NAME = UPDATE_LOG    
     TEXTEDITOR_READ_ONLY = true
     dofile("scripts/texteditor/texteditor.lua")
    end
   end
      
  end --if mainInfo.focus == 1
  
 end --○键设置
 
---------------------------------------
end














