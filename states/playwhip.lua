local playwhip = {}

function playwhip:textinput(t)
	if self.moveKeys[t] then
		hero:whip(keyToDirection(t))
		Gamestate.switch(IntroState)
	end	
end

function playwhip:enter(previous, hero, moveKeys)
	hero = hero
	self.moveKeys = moveKeys
end

function playwhip:update(dt)
	hero.map:drawMap()
end

function playwhip:draw()
	hero.map:renderMap()
end

return playwhip
