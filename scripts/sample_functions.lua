----------------sample_functions------------------------


------------------安全模式检测----------------------------------------------------------
function check_safe()
 if os.access() == 0 then
  SCREENSHOTS = back
  local state = show_sample_dialog(TIPS, SAFE_MODE_TIP, BUTTON_QUIT)
  if state == 0 then
   os.exit()
  end
 end
end

----------------检测内存卡空闲容量-----------------------
function check_freespace(dev, size)
	local info = os.devinfo(dev)
	if info and info.free > size then
	 return true
	else
	 return false
	end
end

----------------检测内存卡容量-----------------------
function check_dev()
	local info = os.devinfo()
	if info then
	 return info.max
	else
	 return false
	end
end

----------------检测文件属性-----------------------
function check_file(pathToFile)
 if files.exists(pathToFile) then
  if not files.list(pathToFile) then
   return 1 --是文件
  else
   return 2 --是文件夹
  end
 end
 return false --不存在
end

----------------创建文件-----------------------
function create_file(pathToFile)
 if files.exists(pathToFile) then
  return false
 else
  local pathToParent = files.nofile(pathToFile)
  if not files.exists(pathToParent) then
   files.mkdir(pathToParent)
   if check_file(pathToParent) ~= 2 then
    return false
   end
  end
 end
 
 local writeHandle = io.open(pathToFile, "w+")
 writeHandle:close()
 
 if check_file(pathToFile) ~= 1 then
  return false
 end
 return true
end

----------------复制文件到文件-----------------------
function file_copy_to_file(fromFile, toFile)
 local fromFileExist = check_file(fromFile)
 local toFileExist = check_file(toFile)
 if not fromFileExist or fromFileExist == 2 or fromFile == toFile or toFileExist == 2 then
  return false
 end
 if not toFileExist then
  local toDir = files.nofile(toFile)
  files.mkdir(toDir)
  if check_file(toDir) ~= 2 then
   return false
  end
 end
 --读取文件
 local readHandle = io.open(fromFile, "r")
 local fromFileStr = readHandle:read("*a")
 readHandle:close()
 --写入文件
 local writeHandle = io.open(toFile, "w+")
 writeHandle:write(fromFileStr)
 writeHandle:close()
 
 if check_file(toFile) == 1 then
  return true
 end
 return false
end

---------------复制文件---------------------------
function copyfile(source, destinationParentDir)

 if not files.exists(destinationParentDir) then
  files.mkdir(destinationParentDir)
 end
 if string.sub(destinationParentDir, -1, -1) ~= "/" then
  destinationParentDir = destinationParentDir.."/"
 end
 local destinationFilePath = destinationParentDir..files.nopath(source)
 local sourcefile = io.open(source, "r")
 local destinationfile = io.open(destinationFilePath, "w+")
 destinationfile:write(sourcefile:read("*all"))
 sourcefile:close()
 destinationfile:close()
 
end

---------------按字母顺序列表---------------------------
function files.listsort(path)
	local tmp1 = files.listdirs(path)
	if tmp1 then 
		table.sort(tmp1,function(a,b) return string.lower(a.name)<string.lower(b.name) end)
	else
		tmp1 = {}
	end

	local tmp2 = files.listfiles(path)
	if tmp2 then
		table.sort(tmp2,function(a,b) return string.lower(a.name)<string.lower(b.name) end)
		for s,t in pairs(tmp2) do
			t.size = files.sizeformat(t.size)
			table.insert(tmp1,t)
		end
	end

	return tmp1
end

---------------去掉字符串两边的空格---------------------------
function trim(s)
 return (string.gsub(s, "^%s*(.-)%s*$", "%1"))  
end  

---------------获取去扩展的文件名-------------------
function getFileNameNoExt(str)
 local idx = str:match(".+()%.%w+$")
 if(idx) then
  return str:sub(1, idx-1)
 else
  return str
 end
end

-----------------分割字符串-------------------
function stringSplit(szFullString, szSeparator)
 
 local nFindStartIndex = 1
 local nSplitIndex = 1
 local nSplitArray = {}
 while true do
  local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
  if not nFindLastIndex then
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
   break
  end
  nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
  nFindStartIndex = nFindLastIndex + string.len(szSeparator)
  nSplitIndex = nSplitIndex + 1
 end
 return nSplitArray
 
end

-----------------文件转字符串列表-------------------
function getFileToStringlist(file)
 
 local textList = {}
 if files.exists(file) then
  for linea in io.lines(file) do
	  table.insert(textList, linea)
	 end
	end
 return textList

end

------------------获取盘符路径---------------------
function getDevPath(filePath)
 
 local focus = string.find(filePath, ":")
 if focus then
  return string.sub(filePath, 1, focus)
 else
  return false
 end
 
end

--------------------防止休眠-----------------------------
function power_tick()
 
 --如果ftp启动中或音乐播放中，则保持设备息屏运行
 if (wlan.isconnected() and ftp.state()) or (playingSongSnd and sound.playing(playingSongSnd)) then
  power.tick(1)
 end

end











