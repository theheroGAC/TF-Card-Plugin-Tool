------texteditor_button_setting_function-----------------------------------


function texteditor_button_setting()
 
 buttons.read()

 ---------------select键设置-------------------------
 if buttons.select then
 
  ftp_server()
  
 end --select键设置
 
 -------------------↑键设置-------------------------------
 if buttons.up or buttons.analogly < -60 then
  
  if texteditorInfo.list and #texteditorInfo.list > 0 then
	  if TEXTEDITOR_READ_ONLY then
    if texteditorInfo.top > 1 then
	    texteditorInfo.top -= 1
    end    
   else
	   if texteditorInfo.focus > 1 then
	    texteditorInfo.focus -= 1
    end    
   end
	 end
	  
	end --↑键设置
     
 -------------------↓鍵設置-------------------------------
 if buttons.down or buttons.analogly > 60 then
  
  if texteditorInfo.list and #texteditorInfo.list > 0 then
   if TEXTEDITOR_READ_ONLY then
    if texteditorInfo.top < #texteditorInfo.list - (texteditorListShowCount - 1) then
     texteditorInfo.top += 1
	   end
   else
    if texteditorInfo.focus < #texteditorInfo.list then
     texteditorInfo.focus += 1
	   end
	  end
  end
   
	end --↓键设置

 -------------------←键设置-------------------------------
 if buttons.left or buttons.analoglx < -60 then

  if texteditorText_x < texteditorDefaultText_x then
   texteditorText_x += 10
  end
  
 end --←键设置
     
 -------------------→键设置-------------------------------
 if buttons.right or buttons.analoglx > 60 then

  if texteditorDefaultText_x	- texteditorText_x + texteditorTextDefaultWidth < texteditorTextWidth then
   texteditorText_x -= 10
  end
  
	end --→键设置

 -------------------L键设置-------------------------------
 if buttons.l then
  
  --上翻页
	 local tmpTop = texteditorInfo.top - texteditorListShowCount
	 if tmpTop < 1 then
	  tmpTop = 1
	 end
	 if texteditorInfo.top ~= tmpTop then
	  texteditorInfo.focus = tmpTop + (texteditorInfo.focus - texteditorInfo.top)
	  texteditorInfo.top = tmpTop
	 end
	 
	end --if buttons.l
     
 -------------------R键设置-------------------------------
 if buttons.r then
 
  --下翻页
	 local tmpTop = texteditorInfo.top + texteditorListShowCount
	 if tmpTop <= #texteditorInfo.list then
	  if tmpTop > #texteditorInfo.list - (texteditorListShowCount - 1) then
	   tmpTop = #texteditorInfo.list - (texteditorListShowCount - 1)
	  end
	  texteditorInfo.focus = tmpTop + (texteditorInfo.focus - texteditorInfo.top)
	  if texteditorInfo.focus > #texteditorInfo.list then
	   texteditorInfo.focus = #texteditorInfo.list
	  end
	  texteditorInfo.top = tmpTop
	 end

 end
 
 ----------------X键设置-------------------------
	if buttons.cross then
	 
	 if textHadChange then
	  local state = show_sample_dialog(TIPS, TEXTEDITOR_QUIT_SAVE_READY, BUTTON_BACK, TEXTEDITOR_BUTTON_SAVE, TEXTEDITOR_BUTTON_UNSAVE)
   --保存文本后退出
   if state == 1 then
    texteditor_save_text()
   --不保存文本退出
   elseif state == 2 then
    show_close_dialog()
    texteditorRun = false
   end
  else
   texteditorRun = false
  end

	end --X键设置

-------------------□键设置-------------------------------
 if buttons.square then

  if not TEXTEDITOR_READ_ONLY then
   --删除行
   table.remove(texteditorInfo.list, texteditorInfo.focus)  
   if #texteditorInfo.list < 1 then
    table.insert(texteditorInfo.list, "")
   elseif texteditorInfo.focus > #texteditorInfo.list then
    texteditorInfo.focus = #texteditorInfo.list
   end
   textHadChange = true
  end
  
 end

 ------------------△键设置-------------------------
 if buttons.triangle then
  
  if not TEXTEDITOR_READ_ONLY then
   --添加行
   table.insert(texteditorInfo.list, texteditorInfo.focus + 1, "")
   textHadChange = true
  end
  
 end --△键设置

 ------------------○键设置-------------------------------
 if buttons.circle then 
 
  
  if not TEXTEDITOR_READ_ONLY then
   --编辑行
   local editStr = texteditorInfo.list[texteditorInfo.focus]
   local newStr = osk.init(TEXTEDITOR_PLEASE_INPUT, editStr)
   if newStr and newStr ~= editStr then
    texteditorInfo.list[texteditorInfo.focus] = newStr
    textHadChange = true
   end
  end

 end

end













