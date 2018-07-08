local intro = {}

function intro:init()
	
	local spriteSheet = love.graphics.newImage('tilesheet_15x15.png') 
	spriteSheet:setFilter('nearest', 'nearest')
	Logger.log("Loaded graphics...", 1)

	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)
	digger = ROT.Map.Digger:new(SCREEN_WIDTH, SCREEN_HEIGHT + 20)

	introMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT + 20, root)
	levelMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT, root)
	Logger.log("Loaded maps...", 1)

	--Digger map callback function
	calbak = function(x, y, val)
		local char = ' '
		if val == 0 then 
			introMap:setTile(x, y, TileTypes.Floor)
		else
			introMap:setTile(x, y, TileTypes.Wall)
		end
	end

	hero = Player:new(20, 20, '\35', COLORS.GREEN, COLORS.YELLOW, introMap)
	bat = Mummy:new(21, 21, '\38', COLORS.BROWN, COLORS.YELLOW, introMap)

	--FOV light callback
	lightCalbak = function(fov, x, y)
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

function intro:keypressed(key, scancode, isrepeat)
	if key == 'up' then
		--hero:move({x=0, y=-1})
	elseif key == 'right' then
		--hero:move({x=1, y=0})
	end
end

function intro:textinput(t)
	local acted = false
	if moveKeys[t] then
		local direction = Util.keyToDirection(t)
		if hero:move(direction) then
			if hero:shouldMove(direction) then hero.map:move(direction) end
			acted = true
		end
	elseif actionKeys[t] then
		if t == 't' then
			Gamestate.switch(WhipState, hero, moveKeys)
			return
		end
	end
	if acted then	
		hero.map:computeAI()
		hero.map:resetFOV()
		fov:compute(hero.x, hero.y, 6, fovCalbak)
	end
end

function intro:draw()
	introMap:renderMap()
end

function intro:update(dt)
	introMap:visible(hero.x, hero.y)
	introMap:drawMap()
end

return intro
