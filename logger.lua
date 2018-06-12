logger = {}
logger.levels = {["INFO"]=true, ["ERROR"]=true, ["DEBUG"]=true}

function init()
	local file = io.open("logs/") 
	if file == nil then
		os.execute("mkdir " .. "logs")
	end

	local count = 1
	for _, file in pairs(love.filesystem.getDirectoryItems("logs/")) do
		if string.gmatch(file, os.date("%d-%m-%Y")) then
			count = count + 1
		end
	end

	local filename = "logs/" .. tostring(os.date("%d-%m-%Y")) .. "-" .. count .. ".log"
	logger.logFile = io.open(filename, "w")
	log("Log starting...", "INFO")
end

function log(message, level)
	if logger.levels[level] == false then
		print(level .. " level is disabled.")
		return
	end

	if not logger.logFile then
		print("Logger not initialized!")
		return
	end

	local logMessage = "[" .. os.date("%X") .. "]" .. "[" .. level .. "]" .. " " .. message .. "\n"
	logger.logFile:write(logMessage)
end

function disable(level)
	if not logger.logFile then
		print("Logger not initialized!")
		return
	end

	if logger.levels[level] then
		logger.levels[level] = false
	end
end

function enable(level)
	if not logger.logFile then
		print("Logger not initialized!")
		return
	end

	if logger.levels[level] == nil then
		print("Invalid logger lvel: " .. level)
		return
	end

	if not logger.levels[level] then
		logger.levels[level] = true
	end
end
		

logger.init = init
logger.log = log
logger.disable = disable
logger.enable = enable
return logger
