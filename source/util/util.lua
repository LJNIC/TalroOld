local util = {}

--Rounds a 0-1 number to 1 or 0
function round(num)
	return (num > 0.5) and 1 or 0
end

--returns a table with each entry a table
--of values
function parseCSV(csvfile)
	local values = {}
	local k = 1
	for line in love.filesystem.lines(csvfile) do
		local tempTile = {}
		local i = 1
		for word in string.gmatch(line, '([^,]+)') do
    		tempTile[i] = word
			i = i + 1
		end
		
		local x = tonumber(tempTile[1])
		local y = tonumber(tempTile[2])
		local char = string.char(tempTile[3])
		local fore = ROT.Color.fromString(tempTile[4])
		local back = ROT.Color.fromString(tempTile[5])
		values[k] = {x=x, y=y, char=char, fore=fore,back=back} 
		k = k + 1
	end
	return values
end

--Loads a file as a table using Serpent
function loadTable(fileName)
	local contents = love.filesystem.read(fileName)
	return Serpent.load(contents)
end

function util.getOption()
	return options.movement.up[1]
end
	
--add two vectors
function addVector(x1, y1, x2, y2)
	return  x1 + x2, y1 + y2
end

--multiply two vectors
function multVector(x1, y1, x2, y2)
	return x1 * x2, y1 * y2
end

util.parseCSV = parseCSV
util.addVector = addVector
util.multVector = multVector
util.loadTable = loadTable

return util
