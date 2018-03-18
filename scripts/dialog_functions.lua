---------------dialog_function---------------------

DIALOGWIDTH = 0
MAXDIALOGWIDTH = 0
MAXDIALOGHEIGHT = 0

------------------关闭弹窗-----------------
function close_dialog()

 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
 elseif back then 
	 back:blit(0,0)
 end
 local h = MAXDIALOGHEIGHT*(DIALOGWIDTH/MAXDIALOGWIDTH)
 local x = (960 - DIALOGWIDTH)/2
 local y = (544 - h)/2
 --弹窗区域
 draw.fillrect(x, y, DIALOGWIDTH, h, COLOR_DIALOG_BACKGROUND)
 --弹窗描边
 draw.rect(x, y, DIALOGWIDTH, h, COLOR_DIALOG_STROKE)

 screen.flip()
 
 if DIALOGWIDTH > 0 then
  DIALOGWIDTH = DIALOGWIDTH - dialogIncrementWidth
 end
 if DIALOGWIDTH <= 0 then
  DIALOGWIDTH = 0
  MAXDIALOGWIDTH = 0
  SCREENSHOTS = nil
  SHOW_CLOSE_DIALOG = false
 end

end

----------------启动关闭弹窗------------
function show_close_dialog()
 
 DIALOGWIDTH = MAXDIALOGWIDTH
 dialogIncrementTimes = 10
 dialogIncrementWidth = string.format("%d", MAXDIALOGWIDTH/dialogIncrementTimes)
 if DIALOGWIDTH > 0 then
  SHOW_CLOSE_DIALOG = true
  while SHOW_CLOSE_DIALOG do
   close_dialog()
  end
 end
 
end

--------------等待弹窗构画------------
function waiting_dialog(message)

 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
 elseif back then 
  back:blit(0,0)
 end
 
 dialogHeightInterval = 32
 dialogWidthInterval = 32

 dialogMessageHeight = screen.textheight(message)
 dialogMessageWidth = 580
 local tmpMessageWidth = screen.textwidth(message)
 if tmpMessageWidth > dialogMessageWidth then
  dialogMessageWidth = tmpMessageWidth
 end

 MAXDIALOGWIDTH = dialogWidthInterval + dialogMessageWidth + dialogWidthInterval 
 MAXDIALOGHEIGHT = dialogHeightInterval + dialogMessageHeight + dialogHeightInterval

 local x = (960 - MAXDIALOGWIDTH)/2
 local y = (544 - MAXDIALOGHEIGHT)/2
 --弹窗区域
 draw.fillrect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_BACKGROUND)
 --弹窗描边
 draw.rect(x, y, MAXDIALOGWIDTH, MAXDIALOGHEIGHT, COLOR_DIALOG_STROKE)
 --文本
 screen.print(480, y + dialogHeightInterval, message, 1.1, color.white, color.black, __ACENTER)
  
end

--------------等待弹窗显示------------
function show_waiting_dialog(message)
 
 waiting_dialog(message)
 screen.flip()

end

----------------普通弹窗构画------------
function sample_dialog(title, messageInfo, buttonL, buttonR, buttonM)

 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
 elseif back then 
	 back:blit(0,0)
 end

 local h = string.format("%d", MAXDIALOGHEIGHT*(DIALOGWIDTH/MAXDIALOGWIDTH))
 local x = string.format("%d", (960 - DIALOGWIDTH)/2)
 local y = string.format("%d", (544 - h)/2)
 --弹窗区域
 draw.fillrect(x, y, DIALOGWIDTH, h, COLOR_DIALOG_BACKGROUND)
 --弹窗描边
 draw.rect(x, y, DIALOGWIDTH, h, COLOR_DIALOG_STROKE)
 if DIALOGWIDTH == MAXDIALOGWIDTH then
  --标题
  local textY = y + dialogHeightInterval
  screen.print(480, textY, title, 1, color.white, color.black, __ACENTER)
  --列表
  local bottom = #messageInfo.list
  if bottom > messageInfo.top + (dialogListShowCounts - 1) then
   bottom = messageInfo.top + (dialogListShowCounts - 1)
  end
  local messageX = x + dialogWidthInterval
  local messageY = textY + dialogTitleHeight + dialogHeightInterval
  for i = messageInfo.top, bottom do
   screen.print(messageX, messageY, messageInfo.list[i], 1, color.white, color.black)
   messageY = messageY + dialogListLineHeight + dialogListLineInterval
  end
  --弹窗按键
  local buttonY = y + h - dialogHeightInterval - dialogButtonHeight
  --确定按键
  local buttonR_x = x + DIALOGWIDTH - (screen.textwidth(buttonR or "") + dialogWidthInterval)
  if buttonR then
   screen.print(buttonR_x, buttonY, buttonR, 1, color.white, color.black)
  end
  --中间按键
  local buttonM_x = buttonR_x
  if buttonM then
   if buttonR then
    buttonM_x = buttonR_x - (screen.textwidth(buttonM or "") + dialogWidthInterval)
   else
    buttonM_x = x + DIALOGWIDTH - (screen.textwidth(buttonM or "") + dialogWidthInterval)
   end
   screen.print(buttonM_x, buttonY, buttonM, 1, color.white, color.black)
  end
  --取消按键
  local buttonL_x = buttonM_x - (screen.textwidth(buttonL or "") + dialogWidthInterval)
  if buttonL then
   screen.print(buttonL_x, buttonY, buttonL, 1, color.white, color.black)
  end
 end
 if DIALOGWIDTH < MAXDIALOGWIDTH then
  DIALOGWIDTH += dialogIncrementWidth
 end
 if DIALOGWIDTH > MAXDIALOGWIDTH then
  DIALOGWIDTH = MAXDIALOGWIDTH
  h = MAXDIALOGHEIGHT
 end
 
 screen.flip()
 
end

----------------获取普通弹窗数据----------------
function get_sample_dialog_info(message)
 
 if not SCREENSHOTS then
  SCREENSHOTS = screen.buffertoimage()
 end
 
 dialogHeightInterval = 16
 dialogWidthInterval = 32
 dialogListLineInterval = 4
 
 dialogTitleHeight = screen.textheight(1)

 local messageInfo = {list = {}, top = 1}
 if type(message) == "table" then
  messageInfo.list = message
 else
  messageInfo.list = stringSplit(message, "\n")
 end
 
 dialogListLineHeight = screen.textheight(1)
 local minShowCounts = 4 --最小显示行数高度
 local maxShowCounts = 18 --最大显示行数高度
 dialogListShowCounts = #messageInfo.list
 if dialogListShowCounts < minShowCounts then
  dialogListShowCounts = minShowCounts
 elseif dialogListShowCounts > maxShowCounts then
  dialogListShowCounts = maxShowCounts
 end
 dialogMessageHeight = (dialogListLineHeight + dialogListLineInterval)*dialogListShowCounts - dialogListLineInterval
 
 dialogMessageWidth = 440
 for i = 1, #messageInfo.list do
  local tmpListLineWidth = screen.textwidth(messageInfo.list[i], 1)
  if tmpListLineWidth > dialogMessageWidth then
   dialogMessageWidth = tmpListLineWidth
  end
 end

 dialogButtonHeight = screen.textheight(1)
 
 MAXDIALOGWIDTH = dialogWidthInterval + dialogMessageWidth + dialogWidthInterval 
 MAXDIALOGHEIGHT = dialogHeightInterval + dialogTitleHeight + dialogHeightInterval + dialogMessageHeight + dialogHeightInterval + dialogButtonHeight + dialogHeightInterval

 dialogIncrementTimes = 10
 dialogIncrementWidth = string.format("%d", MAXDIALOGWIDTH/dialogIncrementTimes)
 
 return messageInfo
 
end

----------------普通弹窗显示----------------
function show_sample_dialog(title, message, buttonL, buttonR, buttonM)

 messageInfo = get_sample_dialog_info(message)
 DIALOGWIDTH = 0

 SHOW_SAMPLE_DIALOG = true
 while SHOW_SAMPLE_DIALOG do
  sample_dialog(title, messageInfo, buttonL, buttonR, buttonM)
  musicplayer_autoplaynextmusic()
  buttons.read()
  
  -----------↑键设置-------------------------------
  if buttons.up or buttons.analogly < -60 then
   if messageInfo.top > 1 then
	   messageInfo.top -= 1
   end

  -----------↓键设置-------------------------------
  elseif buttons.down or buttons.analogly > 60 then
   if messageInfo.top < #messageInfo.list - 18 - 1 then	
    messageInfo.top += 1
   end
  end

  --X键设置
	 if buttonL and buttons.cross then
	  show_close_dialog()
	  buttons.read()
	  return 0
	 --○键设置
	 elseif buttonR and buttons.circle then
	  buttons.read()
	  return 1
	 --△键设置
	 elseif buttonM and buttons.triangle then
	  buttons.read()
	  return 2
	 end
 end
 
end

----------------列表弹窗构画------------
function list_dialog(title, messageInfo, buttonL, buttonR)

 if SCREENSHOTS then
  SCREENSHOTS:blit(0,0)
 elseif back then 
	 back:blit(0,0)
 end

 local h = string.format("%d", MAXDIALOGHEIGHT*(DIALOGWIDTH/MAXDIALOGWIDTH))
 local x = string.format("%d", (960 - DIALOGWIDTH)/2)
 local y = string.format("%d", (544 - h)/2)
 --弹窗区域
 draw.fillrect(x, y, DIALOGWIDTH, h, COLOR_DIALOG_BACKGROUND)
 --弹窗描边
 draw.rect(x, y, DIALOGWIDTH, h, COLOR_DIALOG_STROKE)
 if DIALOGWIDTH == MAXDIALOGWIDTH then
  --标题
  local textY = y + dialogHeightInterval
  screen.print(480, textY, title, 1, color.white, color.black, __ACENTER)
  --列表
	 if messageInfo.focus > 0 and messageInfo.top > messageInfo.focus then
   messageInfo.top = messageInfo.focus
	 elseif messageInfo.top < messageInfo.focus - (dialogListShowCounts - 1) then
   messageInfo.top = messageInfo.focus - (dialogListShowCounts - 1)
  end
  local bottom = #messageInfo.list
  if bottom > messageInfo.top + (dialogListShowCounts - 1) then
   bottom = messageInfo.top + (dialogListShowCounts - 1)
  end
  local messageX = x + dialogWidthInterval
  local messageY = textY + dialogTitleHeight + dialogHeightInterval
  for i = messageInfo.top, bottom do
   if i == messageInfo.focus then
    screen.print(messageX, messageY, messageInfo.list[i], 1, COLOR_FOCUS, color.black)
   else
    if not messageInfo.usable or messageInfo.usable[i] then --如果选项禁用，则显示灰色
     screen.print(messageX, messageY, messageInfo.list[i], 1, color.white, color.black)
    else
     screen.print(messageX, messageY, messageInfo.list[i], 1, color.shadow)
    end
   end
   messageY = messageY + dialogListLineHeight + dialogListLineInterval
  end
  --弹窗按键
  local buttonY = y + h - dialogHeightInterval - dialogButtonHeight
  --弹窗确定按键
  local buttonR_x = x + DIALOGWIDTH - (screen.textwidth(buttonR or "") + dialogWidthInterval)
  screen.print(buttonR_x, buttonY, buttonR or "", 1, color.white, color.black)
  --弹窗取消按键
  local buttonL_x = buttonR_x - (screen.textwidth(buttonL or "") + dialogWidthInterval)
  screen.print(buttonL_x, buttonY, buttonL or "", 1, color.white, color.black)
 end
 if DIALOGWIDTH < MAXDIALOGWIDTH then
  DIALOGWIDTH += dialogIncrementWidth
 end
 if DIALOGWIDTH > MAXDIALOGWIDTH then
  DIALOGWIDTH = MAXDIALOGWIDTH
  h = MAXDIALOGHEIGHT
 end
 
 screen.flip()
 
end

----------------列表弹窗显示------------
function show_list_dialog(title, messageInfo, buttonL, buttonR)
 
 if not SCREENSHOTS then
  SCREENSHOTS = screen.buffertoimage()
 end
 if messageInfo.focus == nil then
  messageInfo.focus = 1
 end
 if messageInfo.top == nil then
  messageInfo.top = 1
 end
 
 dialogHeightInterval = 16
 dialogWidthInterval = 32
 dialogListLineInterval = 6
 
 dialogTitleHeight = screen.textheight(1)
 
 dialogListLineHeight = screen.textheight(1)
 local minShowCounts = 4 --最小显示行数高度
 local maxShowCounts = 18 --最大显示行数高度
 dialogListShowCounts = #messageInfo.list
 if dialogListShowCounts < minShowCounts then
  dialogListShowCounts = minShowCounts
 elseif dialogListShowCounts > maxShowCounts then
  dialogListShowCounts = maxShowCounts
 end
 dialogMessageHeight = (dialogListLineHeight + dialogListLineInterval)*dialogListShowCounts - dialogListLineInterval
 
 dialogMessageWidth = 300
 for i = 1, #messageInfo.list do
  local tmpListLineWidth = screen.textwidth(messageInfo.list[i], 1)
  if tmpListLineWidth > dialogMessageWidth then
   dialogMessageWidth = tmpListLineWidth
  end
 end
 dialogButtonHeight = screen.textheight(1)

 MAXDIALOGWIDTH = dialogWidthInterval + dialogMessageWidth + dialogWidthInterval
 MAXDIALOGHEIGHT = dialogHeightInterval + dialogTitleHeight + dialogHeightInterval + dialogMessageHeight + dialogHeightInterval + dialogButtonHeight + dialogHeightInterval
 DIALOGWIDTH = 0
 
 dialogIncrementTimes = 10
 dialogIncrementWidth = string.format("%d", MAXDIALOGWIDTH/dialogIncrementTimes)

 SHOW_LIST_DIALOG = true
 while SHOW_LIST_DIALOG do
  list_dialog(title, messageInfo, buttonL, buttonR)
  musicplayer_autoplaynextmusic()
  buttons.read()
  
  -----------↑键设置-------------------------------
  if buttons.up or buttons.analogly < -60 then
   if messageInfo.focus > 1 then
    local tmpPos = messageInfo.focus - 1
    if messageInfo.usable then
     while not messageInfo.usable[tmpPos] and tmpPos > 1 do
      tmpPos -= 1
     end
	    if messageInfo.usable[tmpPos] then
	     messageInfo.focus = tmpPos
	    end
	   else
	    messageInfo.focus = tmpPos
	   end
   end

  -----------↓键设置-------------------------------
  elseif buttons.down or buttons.analogly > 60 then
   if messageInfo.focus < #messageInfo.list then
    local tmpPos = messageInfo.focus + 1
    if messageInfo.usable then
     while not messageInfo.usable[tmpPos] and tmpPos < #messageInfo.list do
      tmpPos += 1
     end
	    if messageInfo.usable[tmpPos] then
	     messageInfo.focus = tmpPos
	    end
	   else
	    messageInfo.focus = tmpPos
	   end
	  end
	  
  end
  
  ------------X键设置----------------------
	 if buttonL and buttons.cross then
	  show_close_dialog()
	  buttons.read()
	  return 0
	 
  -----------○键设置-------------------------------
	 elseif buttonR and buttons.circle then
	  buttons.read()
	  return messageInfo.focus
	  
	 end
	 
 end

end








