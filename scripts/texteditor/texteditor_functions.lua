------------texteditor_functions_function-----------------------------------


----------------进入加载界面-----------------------
function texteditorMainLoadWaiting(title, buttonTxtList)
 
 --背景
 draw.fillrect(0, 0, 960, 544, COLOR_TEXTEDITOR_BACKGROUND)
 titleShow(title)
 buttonShow(buttonTxtList)
 screen.flip()
 SCREENSHOTS = screen.buffertoimage()
 show_waiting_dialog(WAIT_LOADING)

end

--------------获取文本字符串列表-------------------------------
function texteditor_get_text_list()
 
 texteditorInfo.list = {}
 local lineCount = 0
 for linea in io.lines(EDIT_FILE_PATH) do
	 lineCount += 1
	 table.insert(texteditorInfo.list, linea)
	 if lineCount > 9999 then
	  local state = show_sample_dialog(TIPS, TEXTEDITOR_FILE_TOO_BIG, nil, BUTTON_POSITIVE)
   if state == 1 then
    show_close_dialog()
    break
   end
	 end
	end --for linea in
	if #texteditorInfo.list == 0 then
	 table.insert(texteditorInfo.list, "")
	end

	if #texteditorInfo.list > texteditorListShowCount then
  texteditor_scrollbarOne_h = texteditor_scrollbarBK_h/#texteditorInfo.list
  texteditor_scrollbar_h = texteditor_scrollbarOne_h*texteditorListShowCount
 end

end

function texteditor_save_text()

 show_waiting_dialog(TEXTEDITOR_SAVING)
 --写入文本
 local textFile = io.open(EDIT_FILE_PATH, "w+")
 for i = 1, #texteditorInfo.list do
	 textFile:write(texteditorInfo.list[i].."\n")
 end
	textFile:close()
 show_waiting_dialog(TEXTEDITOR_SAVE_COMPLETE)
 os.delay(700)
 show_close_dialog()
 texteditorRun = false
 
end













