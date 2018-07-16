local play = {}

function play:enter(previous)
	local spriteSheet = love.graphics.newImage('assets/altsheet2_15x15.png') 
	spriteSheet:setFilter('nearest', 'nearest')
	Logger.log("Loaded graphics...", 1)

	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)
	digger = ROT.Map.IceyMaze:new(SCREEN_WIDTH, SCREEN_HEIGHT + 20)
	logDisplay = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, {0, 0, 0, 0}, nil, spriteSheet, 15, 15)
	log = GameLog:new(SCREEN_WIDTH, 6, logDisplay)

	introMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT + 20, root)
	Logger.log("Loaded maps...", 1)

	--Digger map callback function
	local calbak = function(x, y, val)
		local char = ' '
		if val == 0 then 
			introMap:setTile(x, y, TileTypes.Floor)
		else
			introMap:setTile(x, y, TileTypes.Wall)
		end
	end

	hero = Player:new(20, 20, '\41', COLORS.BLUE, COLORS.YELLOW, introMap)
	local bat = Mummy:new(21, 21, '\33', COLORS.WHITE, COLORS.YELLOW, introMap)

	--FOV light callback
	local lightCalbak = function(fov, x, y)
		return hero.map:isPassable(x, y)
	end

	--digger:create(calbak)
	fov = ROT.FOV.Precise:new(lightCalbak)

	introMap:addEntity(hero)
	introMap:addEntity(bat)

	fov:compute(hero.x, hero.y, 6, fovCalbak)
	acted = false
end

--fov callback, sets the map tile to seen and visible
function fovCalbak(x, y, r, v)
	hero.map:see(x, y)
	hero.map:visible(x, y)
end

function play:keypressed(key, scancode, isrepeat)
	--If the key is part of the movement keys
	if Options.moveKeys[key] then
		local direction = Options:keyToDirection(key)
		if hero:move(direction) then
			if hero:shouldMove(direction) then hero.map:move(direction) end
			acted = true
		end
	elseif Options.actionKeys[key] then
		Gamestate.switch(Options:keyToAction(key), hero)
		return
	elseif key == 'escape' then
		Gamestate.switch(MenuState)
	end
end

function play:draw()
	hero.map:renderMap()
	log.display:draw()
end

function play:update(dt)
	if acted then	
		hero.map:computeAI()
		hero.map:resetFOV()
		fov:compute(hero.x, hero.y, 6, fovCalbak)
		acted = false
	end
	hero.map:visible(hero.x, hero.y)
	hero.map:drawMap()
end

return play 
