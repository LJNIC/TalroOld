local playwhip = {}

function playwhip:keypressed(t)
	if Options.moveKeys[t] then
		hero:whip(Options:keyToDirection(t))
		hero.map:resetFOV()
		fov:compute(hero.x, hero.y, 6, fovCalbak)
		self.stateToSwitch = PlayState
	end	
end

function playwhip:enter(previous)
	self.stateToSwitch = nil
end

function playwhip:update(dt)
	hero.map:drawMap()
end

function playwhip:draw()
	hero.map:renderMap()
	if self.stateToSwitch then
		Gamestate.switch(self.stateToSwitch)
	end
end

return playwhip
