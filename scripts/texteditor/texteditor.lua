-------------------texteditor--------------------


---------------第一次进初始化----------------------
if not secondIntoTexteditor then
 -----------------加载脚本------------------- 
 dofile("scripts/texteditor/texteditor_functions.lua")
 dofile("scripts/texteditor/texteditor_graphics_function.lua")
 dofile("scripts/texteditor/texteditor_button_setting_function.lua")
 
 --列表显示行数
 texteditorListShowCount = 20
 --列表显示间隔
 texteditor_list_y_interval = 5
 --列表滚动条
 texteditor_scrollbarBK_w = 6
 texteditor_scrollbar_w = texteditor_scrollbarBK_w
 texteditor_scrollbarBK_h = (screen.textheight(1) + texteditor_list_y_interval)*texteditorListShowCount - texteditor_list_y_interval

 secondIntoTexteditor = true
  
end

----------------continue---------------------------
texteditorInfo = {
 list = {},
 focus = 1,
 top = 1,
}

--只读/读写模式下按键显示
if TEXTEDITOR_READ_ONLY then
 texteditorButtonTextList = {
  TEXTEDITOR_BUTTON_LR,
  TEXTEDITOR_BUTTON_BUTTON_QUIT,
 }
else
 texteditorButtonTextList = {
  TEXTEDITOR_BUTTON_INSERT_LINE,
  TEXTEDITOR_BUTTON_DELETE_LINE,
  TEXTEDITOR_BUTTON_POSITIVE,
  TEXTEDITOR_BUTTON_LR,
  TEXTEDITOR_BUTTON_BUTTON_QUIT,
 }
end

texteditorMainLoadWaiting(EDIT_FILE_NAME, texteditorButtonTextList)
texteditor_get_text_list()
SCREENSHOTS = nil

--构图布局部分设置
--屏幕左间隔
texteditorOrdinal_x = 6
--序号背景宽度
texteditorOrdinalWidth = texteditorOrdinal_x + screen.textwidth("0000") + texteditorOrdinal_x
--右覆层宽度
texteditorTextRightWidth = 18
--文字默认显示位置x轴
texteditorDefaultText_x = texteditorOrdinalWidth
--文字显示位置x轴
texteditorText_x = texteditorDefaultText_x
--文字默认显示宽度
texteditorTextDefaultWidth = 960 - texteditorOrdinalWidth - texteditorTextRightWidth
--文字显示宽度
texteditorTextWidth = texteditorTextDefaultWidth
--文本内容变动
textHadChange = false

-----------------while---------------------
texteditorRun = true
while texteditorRun do

 texteditor_graphics() --构画界面
 texteditor_button_setting() --设置按键
 musicplayer_autoplaynextmusic() --自动播放音乐

end









