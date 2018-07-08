local play = {}

function play:init()
	
	local spriteSheet = love.graphics.newImage('tilesheet_15x15.png') 
	spriteSheet:setFilter('nearest', 'nearest')
	Logger.log("Loaded graphics...", 1)

	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)
	digger = ROT.Map.Digger:new(SCREEN_WIDTH, SCREEN_HEIGHT + 20)

	introMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT + 20, root)
	levelMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT, root)
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

	hero = Player:new(20, 20, '\35', COLORS.GREEN, COLORS.YELLOW, introMap)
	local bat = Mummy:new(21, 21, '\33', COLORS.WHITE, COLORS.YELLOW, introMap)

	--FOV light callback
	local lightCalbak = function(fov, x, y)
		return hero.map:isPassable(x, y)
	end

	digger:create(calbak)
	fov = ROT.FOV.Precise:new(lightCalbak)

	local found = false
	for x = 1, introMap.width do
		if found then break end
		for y = 1, introMap.height do
			if introMap:isPassable(x, y) then
				hero.x = x
				hero.y = y
				introMap:move({x=x, y=y})
				found = true
				break
			end
		end
	end

	introMap:addEntity(hero)
	introMap:addEntity(bat)

	fov:compute(hero.x, hero.y, 6, fovCalbak)
end

function fovCalbak(x, y, r, v)
	hero.map:see(x, y)
	hero.map:visible(x, y)
end

function play:keypressed(key, scancode, isrepeat)
	local acted = false
	if moveKeys[key] then
		local direction = Util.keyToDirection(key)
		if hero:move(direction) then
			if hero:shouldMove(direction) then hero.map:move(direction) end
			acted = true
		end
	elseif actionKeys[key] then
		if t == 't' then
			Gamestate.switch(WhipState, hero)
			return
		end
	end
	if acted then	
		hero.map:computeAI()
		hero.map:resetFOV()
		fov:compute(hero.x, hero.y, 6, fovCalbak)
	end
end

function play:draw()
	introMap:renderMap()
end

function play:update(dt)
	introMap:visible(hero.x, hero.y)
	introMap:drawMap()
end

return play 
