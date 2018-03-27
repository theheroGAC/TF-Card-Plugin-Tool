----------main_graphics_function------------------------


-----------------构画主界面---------------------
function main_graphics()

 --背景
 if back then back:blit(0,0) end
 --列表要显示的数量
 local showCount = 14
 --获取顶部序号
 if mainInfo.top > mainInfo.focus then
  mainInfo.top = mainInfo.focus
 elseif mainInfo.top < mainInfo.focus - (showCount-1) then
  mainInfo.top = mainInfo.focus - (showCount-1)
 end
 --获取底部序号
 local bottom = #mainInfo.list
 if bottom > mainInfo.top + (showCount-1) then
  bottom = mainInfo.top + (showCount-1)
 end
 local x = 220
 local y = 80
 for i = mainInfo.top, bottom do
  if i == mainInfo.focus then
   screen.print(x, y, mainInfo.list[i], 1.2, COLOR_FOCUS, color.black)
  else
   screen.print(x, y, mainInfo.list[i], 1.2, color.white, color.black)
  end
  y += (screen.textheight(1.2) + 10)
 end
 --标题状态栏
 titleShow(APP_NAME_VERSION)
 --按键栏
 buttonShow(mainButtonTextList)
 --刷新页面
 screen.flip()
 
end















