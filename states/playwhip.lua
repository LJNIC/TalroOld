local playwhip = {}

function playwhip:textinput(t)
	if moveKeys[t] then
		hero:whip(keyToDirection(t))
		Gamestate.switch(PlayState)
		hero.map:resetFOV()
		fov:compute(hero.x, hero.y, 6, fovCalbak)
	end	
end

function playwhip:enter(previous, hero)
	hero = hero
end

function playwhip:update(dt)
	hero.map:drawMap()
end

function playwhip:draw()
	hero.map:renderMap()
end

return playwhip
