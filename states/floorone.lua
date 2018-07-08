floorone = {}

function floorone:init()
	digger = ROT.Map.Digger:new(SCREEN_WIDTH, SCREEN_HEIGHT)		
end

function floorone:enter(previous, hero, map)
	self.hero = hero

end

function floorone:textinput(t)
	if moveKeys[t] then
		if hero:move(Util.keyToDirection(t)) then
			tunnelMap:moveWindow(Util.keyToDirection(t))
		end
	elseif actionKeys[t] then
		if t == 't' then
			Gamestate.switch(WhipState, tunnelMap, hero, moveKeys)
		end
	end
end

function floorone:draw()
	tunnelMap:renderMap()
end

function floorone:update(dt)
	tunnelMap:drawMap()
end

return floorone
