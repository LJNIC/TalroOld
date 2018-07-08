logger = {}
logger.levels = {["INFO"]=true, ["ERROR"]=true}

function init()
	local file = io.open("logs/") 
	if file == nil then
		os.execute("mkdir " .. "logs")
	end
	local filename = "logs/" .. tostring(os.date("%d-%m-%Y[%R]")) .. ".log"
	logger.logFile = io.open(filename, "w")
	log("Log starting...", "INFO")
end

function log(message, level)
	if logger.levels[level] == false then
		print("Invalid logger level!")
		return
	end

	if logger.logFile == nil then
		print("Logger not initialized!")
		return
	end

	local logMessage = "[" .. os.date("%X") .. "]" .. "[" .. level .. "]" .. " " .. message .. "\n"
	logger.logFile:write(logMessage)
end


logger.init = init
logger.info = log
return logger
