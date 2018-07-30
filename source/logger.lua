logger = {}
logger.levels = {"INFO", "ERROR", "DEBUG"}

function init()
	local file = io.open("Talro-logs/") 
	if file == nil then
		os.execute("mkdir " .. "Talro-logs")
	end

	local count = 1
	for _, file in pairs(love.filesystem.getDirectoryItems("Talro-logs/")) do
		if string.gmatch(file, os.date("%d-%m-%Y")) then
			count = count + 1
		end
	end

	local filename = "Talro-logs/" .. tostring(os.date("%d-%m-%Y")) .. "-" .. count .. ".log"
	logger.logFile = io.open(filename, "w")
	log("Log starting...", 1)
end

local function checkFile()
	assert(logger.logFile, "Logger not initialized!")
end

function log(message, level)
	checkFile()
	assert(logger.levels[level] ~= nil, "Invalid logger level: " .. level)
	if not logger.levels[level] then return end

	local logMessage = "[" .. os.date("%X") .. "]" .. "[" .. logger.levels[level] .. "]" .. " " .. message .. "\n"
	logger.logFile:write(logMessage)
end

function disable(level)
	checkFile()
	if logger.levels[level] then
		logger.levels[level] = false
	end
end

function enable(level)
	checkFile()
	assert(logger.levels[level] ~= nil, "Invalid logger level: " .. level)

	if not logger.levels[level] then
		logger.levels[level] = true
	end
end
		
logger.init = init
logger.log = log
logger.disable = disable
logger.enable = enable
return logger
