----------texteditor_graphics_function.lua------------------------------------------------------------------------


----------------构画界面----------------------------------------------------------------------
function texteditor_graphics()

 --背景
 draw.fillrect(0, 0, 960, 544, COLOR_TEXTEDITOR_BACKGROUND)
 
 --状态栏间隔
 local title_y_interval = 12
 --列表起始y点
 local list_y_first = MAIN_TITLE_HEIGHT + title_y_interval
 local list_y = list_y_first
 --列表显示间隔
 local list_y_interval = texteditor_list_y_interval
 if texteditorInfo.list and #texteditorInfo.list > 0 then --如果列表大于0
  --列表显示数量
  local listShowCount = texteditorListShowCount
	 --获得顶部序号
	 if not TEXTEDITOR_READ_ONLY then
	  if texteditorInfo.top > texteditorInfo.focus then
	   texteditorInfo.top = texteditorInfo.focus
   elseif texteditorInfo.top < texteditorInfo.focus - (listShowCount - 1) then
    texteditorInfo.top = texteditorInfo.focus - (listShowCount - 1)
   end
  end
  --获得底部序号
  local bottom = #texteditorInfo.list
  if bottom > texteditorInfo.top + (listShowCount - 1) then
   bottom = texteditorInfo.top + (listShowCount - 1)
  end
  for i = texteditorInfo.top, bottom do
   local tmpTextWidth = screen.textwidth(texteditorInfo.list[i])
   if tmpTextWidth > texteditorTextWidth then
    texteditorTextWidth = tmpTextWidth
   end
   screen.print(texteditorText_x, list_y, texteditorInfo.list[i], 1, color.white, color.black, __ALEFT)
   list_y += (screen.textheight(1) + list_y_interval)
  end
  --文本行序数背景
  draw.fillrect(0, MAIN_TITLE_HEIGHT, texteditorOrdinalWidth, 544 - MAIN_TITLE_HEIGHT - MAIN_BUTTON_HEIGHT, COLOR_TEXTEDITOR_BACKGROUND)
  --文本行序数显示
  list_y = MAIN_TITLE_HEIGHT + title_y_interval
  for i = texteditorInfo.top, bottom do
   screen.print(texteditorOrdinal_x, list_y, string.format("%04d", i), 1, 0xFF666666, color.black, __ALEFT)
   --光标显示
   if not TEXTEDITOR_READ_ONLY then
    if i == texteditorInfo.focus then
	    draw.fillrect(texteditorOrdinal_x, list_y - 2, 960 - texteditorOrdinal_x - texteditorTextRightWidth, screen.textheight(1) + 4, COLOR_TEXTEDITOR_FOCUS) 
    end
   end
   list_y += (screen.textheight(1) + list_y_interval)
  end
  --文本右边覆图背景
  draw.fillrect(960 - texteditorTextRightWidth, MAIN_TITLE_HEIGHT, texteditorTextRightWidth, 544 - MAIN_TITLE_HEIGHT - MAIN_BUTTON_HEIGHT, COLOR_TEXTEDITOR_BACKGROUND)
  --滚动条
	 if #texteditorInfo.list > texteditorListShowCount then
   local scrollbarBK_x = 960 - texteditor_scrollbarBK_w - 6
   local scrollbarBK_y = list_y_first
   local scrollbar_x = scrollbarBK_x
   local scrollbar_y = scrollbarBK_y
   if texteditorInfo.top > 1 then
    if texteditorInfo.focus == #texteditorInfo.list then
     scrollbar_y = scrollbarBK_y + texteditor_scrollbarBK_h - texteditor_scrollbar_h
    else
     scrollbar_y = scrollbarBK_y + (texteditor_scrollbarOne_h*(texteditorInfo.top - 1))
    end
   end
   --滚动条背景
   draw.fillrect(scrollbarBK_x, scrollbarBK_y, texteditor_scrollbarBK_w, texteditor_scrollbarBK_h, COLOR_STATUS_BAR_BACKGROUND) 
   --滚动条
   draw.fillrect(scrollbar_x, scrollbar_y, texteditor_scrollbar_w, texteditor_scrollbar_h, COLOR_SCROLL_BAR)     
  end
 end
 --标题状态栏
 titleShow(EDIT_FILE_NAME)
 --按键栏
 buttonShow(texteditorButtonTextList)
 --刷新页面
 screen.flip()
 
end













