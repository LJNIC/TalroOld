local intro = {}

function intro:init()
	moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
	actionKeys = {['t'] = true}
	--Setup tileset / disintro
	local spriteSheet = love.graphics.newImage('cheepicus_16x16.png') 
	logger.log("Loaded map", 1)
	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 1, COLORS.YELLOW, COLORS.YELLOW, nil, spriteSheet, 16, 16)

	introMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT*2, root)
	levelMap = Map:new(SCREEN_WIDTH, SCREEN_HEIGHT, root)

	levelMap:drawCSV(36, 35, 'new-pyramid-entrance.csv', {'\250'})

	hero = Player:new(40, 75, '\23', COLORS.GREEN, COLORS.YELLOW, introMap)
	introMap:addEntity(hero)

	door1 = Door:new(37, 26, ' ', COLORS.BLACK, COLORS.YELLOW, introMap, levelMap, 37, 45)
	door2 = Door:new(38, 26, ' ', COLORS.BLACK, COLORS.YELLOW, introMap, levelMap, 38, 45)
	door3 = Door:new(41, 26, ' ', COLORS.BLACK, COLORS.YELLOW, introMap, levelMap, 41, 45)
	door4 = Door:new(42, 26, ' ', COLORS.BLACK, COLORS.YELLOW, introMap, levelMap, 42, 45)

	introMap:addEntity(door1)
	introMap:addEntity(door2)
	introMap:addEntity(door3)
	introMap:addEntity(door4)

	introMap:drawCSV(1, 1, 'pyramid.csv', {'\176', '\220', '\214'})
	introMap:move({x=0, y=40})
end

function intro:textinput(t)
	if moveKeys[t] then
		if hero:move(Util.keyToDirection(t)) then
			hero.map:move(Util.keyToDirection(t))
		end
	elseif actionKeys[t] then
		if t == 't' then
			Gamestate.switch(WhipState, hero, moveKeys)
		end
	end
	print(t)
end

function intro:draw()
	hero.map:renderMap()
end

function intro:update(dt)
	hero.map:drawMap()
end

return intro
