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
function check_devspace()
	
	local info = os.devinfo()
	if info then
	 return info.max
	else
	 return false
	end
	
end

----------------判断文件/文件夹-----------------------
function files_exists(file)

 if files.exists(file) then
  if not files.list(file) then
   return 1 --文件
  else
   return 2 --文件夹
  end
 end
 return false --不存在
 
end

----------------创建文件-----------------------
function files_create(file)

 if files.exists(file) then
  return false
 end
 local rootFile = files.nofile(file)
 if not files.exists(rootFile) then
  files.mkdir(rootFile)
 end
 if files_exists(rootFile) == 2 then
  local output = io.open(file, "w+")
  output:close()
  if files_exists(file) == 1 then
   return true
  end
 end
 
 return false
 
end

----------------复制文件-----------------------
function file_copy(srcFile, dstFile)
 
 local srcFileExist = files_exists(srcFile)
 local dstFileExist = files_exists(dstFile)
 if not srcFileExist or srcFile == dstFile or srcFileExist == 2 or dstFileExist == 2 then
  return false
 end
 local dstRootFile = files.nofile(dstFile)
 if not files.exists(dstRootFile) then
  files.mkdir(dstRootFile)
 end
 if files_exists(dstRootFile) == 2 then
  --复制文件
  local input = io.open(srcFile, "rb")
  local output = io.open(dstFile, "wb+")
  local buffSize = 8*1024
  while true do 
   local bytes = input:read(buffSize)
   if not bytes then
    break
   end
   output:write(bytes)
  end
  input:close()
  output:close()
  return true
 end
 
 return false
 
end

----------------复制文件/文件夹-----------------------
function files_copy(srcFile, dstFile)

 local srcFileExist = files_exist(srcFile)
 local dstFileExist = files_exist(dstFile)
 --如果源文件不存在、或源文件路径与目标路径相同、或目标文件属性不同于源文件，则返回失败
 if not srcFileExist or srcFile == dstFile or (dstFileExist and srcFileExist ~= dstFileExist) then
  return false
 end
 if srcFileExist == 1 then --如果要复制的是文件
  if file_copy(srcFile, dstFile) then
   return true
  end
 elseif srcFileExist == 2 then --如果要复制的是文件夹
  if not dstFileExist then
   files.mkdir(dstFile)
  end
  if files_exist(dstFile) ~= 2 then
   return false
  end
  if not string.find(srcFile, "/", -1) then
   srcFile = srcFile.."/"
  end
  if not string.find(dstFile, "/", -1) then
   dstFile = dstFile.."/"
  end
  local files = files.list(srcFile)
  if #files == 0 then
   return true
  elseif #files > 0 then   
   for i = 1, #files do
		   local mFileName = files[i].name
		   local mSrcFile = srcFile..mFileName
		   local mDstFile = dstFile..mFileName
		   files_copy(mSrcFile, mDstFile)
   end
   return true
  end --if files == nil or
 end --if srcFileExist == 1 then
 
 return false
	
end

---------------获取去扩展的文件名-------------------
function files_noext(str)

 local idx = str:match(".+()%.%w+$")
 if(idx) then
  return str:sub(1, idx-1)
 else
  return str
 end
 
end

------------------获取盘符路径---------------------
function files_devpath(file)
 
 local focus = string.find(file, ":", 1)
 if focus then
  return string.sub(file, 1, focus)
 end
 return false
 
end


---------------按字母顺序列表---------------------------
function files_listsort(path)

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
function string_trim(string)

 return (string.gsub(string, "^%s*(.-)%s*$", "%1"))  

end  

-----------------分割字符串-------------------
function string_split(string, separator)
 
 local findStartIndex = 1
 local splitIndex = 1
 local splitArray = {}
 while true do
  local findLastIndex = string.find(string, separator, findStartIndex)
  if not findLastIndex then
   splitArray[splitIndex] = string.sub(string, findStartIndex, string.len(string))
   break
  end
  splitArray[splitIndex] = string.sub(string, findStartIndex, findLastIndex - 1)
  findStartIndex = findLastIndex + string.len(separator)
  splitIndex = splitIndex + 1
 end
 return splitArray
 
end

-----------------文件转字符串列表-------------------
function fileToStringList(file)
 
 local textList = {}
 if files.exists(file) then
  for linea in io.lines(file) do
	  table.insert(textList, linea)
	 end
	end
 return textList

end











