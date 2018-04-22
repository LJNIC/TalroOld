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
