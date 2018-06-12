local playwhip = {}

function playwhip:textinput(t)
	if self.moveKeys[t] then
		hero:whip(keyToDirection(t))
		Gamestate.switch(PlayState)
	end	
end

function playwhip:enter(previous, map, hero, moveKeys)
	self.hero = hero
	self.map = map
	self.moveKeys = moveKeys
end

function playwhip:update(dt)
	self.map:drawMap()
end

function playwhip:draw()
	self.map:renderMap()
end

return playwhip
