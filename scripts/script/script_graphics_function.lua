----------script_graphics_function------------------------


-----------------构画主界面---------------------
function script_graphics()

 --背景
 if back then back:blit(0,0) end
 --列表要显示的数量
 local showCount = 14
 --获取顶部序号
 if scriptInfo.top > scriptInfo.focus then
  scriptInfo.top = scriptInfo.focus
 elseif scriptInfo.top < scriptInfo.focus - (showCount-1) then
  scriptInfo.top = scriptInfo.focus - (showCount-1)
 end
 --获取底部序号
 local bottom = #scriptInfo.list
 if bottom > scriptInfo.top + (showCount-1) then
  bottom = scriptInfo.top + (showCount-1)
 end
 local x = 220
 local y = 80
 for i = scriptInfo.top, bottom do
  if i == scriptInfo.focus then
   screen.print(x, y, scriptInfo.list[i], 1.2, COLOR_FOCUS, color.black)
  else
   screen.print(x, y, scriptInfo.list[i], 1.2, color.white, color.black)
  end
  y += (screen.textheight(1.2) + 10)
 end
 --标题状态栏
 titleShow(APP_NAME_VERSION)
 --按键栏
 buttonShow(scriptButtonTextList)
 --刷新页面
 screen.flip()
 
end















