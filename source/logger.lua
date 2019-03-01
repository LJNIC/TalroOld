logger = {}
logger.levels = {"INFO", "ERROR", "DEBUG"}

function init(printOutput)
	logger.printOutput = printOutput
	if not love.filesystem.getInfo("Talro-logs/") then
		love.filesystem.createDirectory("Talro-logs")
	end

	local date = os.date("%d-%m-%Y")
	local count = 1
	for _, file in pairs(love.filesystem.getDirectoryItems("Talro-logs/")) do
		if string.find(file, date, 1, true) then
			count = count + 1
		end
	end

	local filename = "Talro-logs/" .. date .. "-" .. count .. ".log"
	logger.logFile = love.filesystem.newFile(filename)
	logger.logFile:open("w")
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
	if logger.printOutput then
		print(logMessage)
	end
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
