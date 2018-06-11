local util = {}
--returns a 'vector' unit based on the key
function keyToDirection(key)
	if key == 'w' then
		return {x=0, y=-1}
	elseif key == 'd' then
		return {x=1, y=0}
	elseif key == 's' then
		return {x=0, y=1}
	elseif key == 'a' then
		return {x=-1, y=0}
	end
end

--add two vectors
function addVector(x1, y1, x2, y2)
	return  x1 + x2, y1 + y2
end

--multiply two vectors
function multVector(x1, y1, x2, y2)
	return x1 * x2, y1 * y2
end

util.keyToDirection = keyToDirection
util.addVector = addVector
util.multVector = multVector

return util
