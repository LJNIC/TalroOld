local play = {}

function play:init()
	local spriteSheet = love.graphics.newImage('assets/altsheet2_15x15.png') 
	spriteSheet:setFilter('nearest', 'nearest')
	Logger.log("Loaded graphics...", 1)
	
	self.root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)

	self.floorOne = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT, self.root)
	Logger.log("Loaded maps...", 1)

	--Digger map callback function
	local calbak = function(x, y, val)
		local char = ' '
		if val == 0 then 
			self.floorOne:setTile(x, y, TileTypes.Floor)
		else
			self.floorOne:setTile(x, y, TileTypes.Wall)
		end
	end

	hero = Player:new(20, 20, '\41', COLORS.BLUE, COLORS.YELLOW)
	local bat = Mummy:new(21, 21, '\33', COLORS.WHITE, COLORS.YELLOW)

	--FOV light callback
	local lightCalbak = function(fov, x, y)
		return hero.map:isPassable(x, y)
	end
	local digger = ROT.Map.Digger(SCREEN_WIDTH, SCREEN_HEIGHT)
	digger:create(calbak)
	fov = ROT.FOV.Precise:new(lightCalbak)

	self.floorOne:addEntity(hero)
	self.floorOne:addEntity(bat)

	fov:compute(hero.x, hero.y, 6, fovCalbak)
	acted = false
	self.stateToSwitch = nil
end

function play:enter(previous)
	self.stateToSwitch = nil
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
		self.stateToSwitch = Options:keyToAction(key)
	elseif key == 'escape' then
		self.stateToSwitch = PauseState
	end
end

function play:draw()
	hero.map:renderMap()

	if self.stateToSwitch then
		Gamestate.switch(self.stateToSwitch)
	end
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
