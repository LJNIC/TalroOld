local util = {}
local left = options.movement.left
local right = options.movement.right
local up = options.movement.up
local down = options.movement.down
local whip = options.actions.whip

--returns a 'vector' unit based on the key
function keyToDirection(key)
	if up[key] then
		return {x=0, y=-1}
	elseif right[key] then
		return {x=1, y=0}
	elseif down[key] then
		return {x=0, y=1}
	elseif left[key] then
		return {x=-1, y=0}
	end
end

function keyToAction(key)
	if key == whip then
		return WhipState
	end
end
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
function loadTable(filename)
	return Serpent.load(io.open(filename, 'r'):read('*all'))
end

function util.getOption()
	return options.movement.up[1]
end
	
--Generates the default options and writes them to the options file
function generateDefaults()
	local options = {
	 movement = {
		up = {'up', 'k'},
		down = {'down', 'j'},
		right = {'right', 'l'},
		left = {'left', 'h'}
		},
	 actions = {
		whip = 't'
		}
	}
	local file = io.open('options.conf', 'w')
	file:write(Serpent.block(options, {comment = false}))
	file:close()
end
				

--add two vectors
function addVector(x1, y1, x2, y2)
	return  x1 + x2, y1 + y2
end

--multiply two vectors
function multVector(x1, y1, x2, y2)
	return x1 * x2, y1 * y2
end

util.generateDefaults = generateDefaults
util.parseCSV = parseCSV
util.keyToDirection = keyToDirection
util.addVector = addVector
util.multVector = multVector
util.loadTable = loadTable

return util
