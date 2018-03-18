----------explorer_graphics_function------------------------------------------------------------------------

explorerFileName_x = 18 + 24
oldExplorerInfoPos = 1

----------------文件管理器界面构画----------------------------------------------------------------------
function explorer_graphics()

 if back then back:blit(0,0) end --構畫背景圖
 local path_x_interval = 18
 local path_y_interval = 4
 local path_y = MAIN_TITLE_HEIGHT + path_y_interval
 if explorerDevInfo.list and #explorerDevInfo.list > 0 then
  --盘符可用容量/总量
  local diskDevStr = EXPLORE_DEVINFO_NO_INFORMATION
  local diskDev = os.devinfo(explorerDevInfo.list[explorerDevInfo.focus])
  if diskDev then
   diskDevStr = string.format(EXPLORE_DEVINFO_INFORMATION, files.sizeformat(diskDev.used), files.sizeformat(diskDev.max))
   screen.print(960 - path_x_interval, path_y, diskDevStr, 1, COLOR_FOCUS, color.black, __ARIGHT)
  else
   screen.print(960 - path_x_interval, path_y, EXPLORE_DEVINFO_NO_INFORMATION, 1, color.red, color.black, __ARIGHT)
  end
  --文件路径
  local showRootPathWidth = 960 - path_x_interval*2 - screen.textwidth(diskDevStr, 1) - 10
  if explorerInfo.rootType == "zip" then
   screen.print(path_x_interval, path_y, explorerInfo.rootPath, 1, color.red, color.black, __ALEFT, showRootPathWidth)
  else
   screen.print(path_x_interval, path_y, explorerInfo.rootPath, 1, color.green, color.black, __ALEFT, showRootPathWidth)
  end
  --盘符列表
  local diskInt = #explorerDevInfo.list
  local diskX = path_x_interval
  local diskY = path_y + screen.textheight(1) + path_y_interval
  local diskY_interval = 2
  local diskW_all = 960 - diskX*2
  local diskW = string.format("%d", (diskW_all - (diskInt - 1))/diskInt)
  local diskH = diskY_interval + screen.textheight(1) + diskY_interval
  diskW_all = diskW*diskInt + (diskInt - 1)
  draw.fillrect(diskX, diskY, diskW_all, diskH, COLOR_STATUS_BAR_BACKGROUND) 
  for i = 1, #explorerDevInfo.list do
   if i == explorerDevInfo.focus then
    draw.fillrect(diskX, diskY, diskW, diskH, COLOR_EXPLORE_DEV_FOCUS) 
    screen.print(diskX + diskW/2, diskY + diskY_interval, explorerDevInfo.list[i], 1, color.white, 0x0, __ACENTER)
   else
    screen.print(diskX + diskW/2, diskY + diskY_interval, explorerDevInfo.list[i], 1, 0xFFEEEEEE, 0x0, __ACENTER)
   end
   if i > 1 then
    draw.fillrect(diskX - 1, diskY + 2, 1, diskH - 4, color.black) 
   end
   diskX += diskW + 1
  end
  local list_y_first = diskY + diskH + 6
  local list_y = list_y_first
  --文件列表
  if explorerInfo.list and #explorerInfo.list > 0 then --如果列表大于0
	  --获得顶部序号
	  if explorerInfo.top > explorerInfo.focus then
	   explorerInfo.top = explorerInfo.focus
   elseif explorerInfo.top < explorerInfo.focus - (explorerShowCount-1) then
    explorerInfo.top = explorerInfo.focus - (explorerShowCount-1)
   end
   --获得底部序号
   local bottom = #explorerInfo.list
   if bottom > explorerInfo.top + (explorerShowCount-1) then
    bottom = explorerInfo.top + (explorerShowCount-1)
   end
   for i = explorerInfo.top, bottom do
    --文件图标
    local icon = fileIcon
    if explorerInfo.list[i].isDir then
     icon = folderIcon
    else
     local fileExt = explorerInfo.list[i].ext
		   if fileExt == "txt" or fileExt == "ini" then
		    icon = textIcon
		   elseif fileExt == "jpg" or fileExt == "png" then
		    icon = imageIcon
		   elseif fileExt == "mp3" or fileExt == "wave" then
		    icon = audioIcon
		   elseif fileExt == "zip" or fileExt == "vpk" then
		    icon = archiveIcon
		   end
    end
    image.blit(icon, path_x_interval, list_y)
    local showFileNameWidth = 460
    if oldExplorerInfoPos ~= explorerInfo.focus then
     oldExplorerInfoPos = explorerInfo.focus
     explorerFileName_x = 42
    end
    local fileName = explorerInfo.list[i].name
    if i == explorerInfo.focus then
     --文件名称
     if screen.textwidth(explorerInfo.list[i].name) > showFileNameWidth then
      explorerFileName_x = screen.print(explorerFileName_x, list_y, fileName, 1, COLOR_FOCUS, color.black, __SLEFT, showFileNameWidth)
     else
      screen.print(explorerFileName_x, list_y, fileName, 1, COLOR_FOCUS, color.black, __ALEFT, showFileNameWidth)
     end
     --文件大小
     screen.print(620, list_y, explorerInfo.list[i].formatSize or EXPLORE_DIRECTORY, 1, COLOR_FOCUS, color.black, __ARIGHT)
     --显示日期
     screen.print(960-path_x_interval, list_y, explorerInfo.list[i].ctime or "", 1, COLOR_FOCUS, color.black, __ARIGHT)
    else
     --文件名称
     screen.print(explorerFileName_x, list_y, fileName, 1, color.white, color.black, __ALEFT, showFileNameWidth)
     --文件大小
     screen.print(620, list_y, explorerInfo.list[i].formatSize or EXPLORE_DIRECTORY, 1, color.white, color.black, __ARIGHT)
     --显示日期
     screen.print(960-path_x_interval, list_y, explorerInfo.list[i].ctime or "", 1, color.white, color.black, __ARIGHT)
    end
    --标记
    if explorerInfo.list[i].mark then
     draw.fillrect(path_x_interval, list_y-2, 960-path_x_interval*2, screen.textheight(1) + 4, COLOR_MARK) 
    end
    list_y += (screen.textheight(1) + explorer_list_y_interval)
   end
   --滚动条
	  if #explorerInfo.list > explorerShowCount then
    local scrollbarBK_x = 960 - explorer_scrollbarBK_w - 6
    local scrollbarBK_y = list_y_first
    local scrollbar_x = scrollbarBK_x
    local scrollbar_y = scrollbarBK_y
    if explorerInfo.top > 1 then
     if explorerInfo.focus == #explorerInfo.list then
      scrollbar_y = scrollbarBK_y + explorer_scrollbarBK_h - explorer_scrollbar_h
     else
      scrollbar_y = scrollbarBK_y + (explorer_scrollbarOne_h*(explorerInfo.top - 1))
     end
    end
    --滚动条背景
    draw.fillrect(scrollbarBK_x, scrollbarBK_y, explorer_scrollbarBK_w, explorer_scrollbarBK_h, COLOR_STATUS_BAR_BACKGROUND) 
    --滚动条
    draw.fillrect(scrollbar_x, scrollbar_y, explorer_scrollbar_w, explorer_scrollbar_h, COLOR_SCROLL_BAR)     
   end
  else
   screen.print(path_x_interval, list_y, EXPLORE_NO_FILE, 1, color.red, color.black)
  end
 else
  screen.print(path_x_interval, path_y, EXPLORE_NO_DISK, 1, color.red, color.black)
 end
 --标题状态栏
 titleShow(EXPLORE)
 --按键栏
 buttonShow(explorerButtonTextList)
 --刷新页面
 screen.flip()

-----------------------------------------
end













