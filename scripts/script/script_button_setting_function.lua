-------script_button_setting_function-------------------------------------------------------------------

function script_button_setting()
 
 buttons.read() --读取按键

 ---------------select键设置-------------------------
 if buttons.select then
 
  ftp_server()
  
 end --select键设置
 
 -------------------↑键设置-------------------------------
 if buttons.up or buttons.analogly < -60 then
  
	 if scriptInfo.focus > 1 then
	  scriptInfo.focus -= 1 
  end

	end --↑键设置
     
 -------------------↓键设置-------------------------------
 if buttons.down or buttons.analogly > 60 then
  
  if scriptInfo.focus < #scriptInfo.list then
   scriptInfo.focus += 1
  end
   
	end --↓键设置
 
 -------------------○键设置-------------------------------
 if buttons.circle then

  if scriptInfo.focus == 1 then
   local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_READY, scriptInfo.list[scriptInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then 
    install_gamesd(1)
   end

  elseif scriptInfo.focus == 2 then
   local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_READY, scriptInfo.list[scriptInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then 
    install_gamesd(2)
   end
   
  elseif scriptInfo.focus == 3 then
   local state = show_sample_dialog(TIPS, string.format(INSTALL_TF_USB_READY, scriptInfo.list[scriptInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then 
    install_gamesd(3)
   end
   
  elseif scriptInfo.focus == 4 then
   local installReady = show_sample_dialog(TIPS, string.format(UNINSTALL_TF_USB_READY, scriptInfo.list[scriptInfo.focus]), BUTTON_CANCEL, BUTTON_POSITIVE)
   if installReady == 1 then
    uninstall_gamesd()
   end
  
  elseif scriptInfo.focus == 5 then
   local state = show_sample_dialog(TIPS, PSV_MANAGER_REFRESH_APP_READY, BUTTON_CANCEL, BUTTON_POSITIVE)
   if state == 1 then
    refresh_psv_apps()
   end
  
  elseif scriptInfo.focus == 6 then
   dofile("scripts/explorer/explorer.lua")
  
  elseif scriptInfo.focus == 7 then
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
      
  end --if scriptInfo.focus == 1
  
 end --○键设置
 
---------------------------------------
end














