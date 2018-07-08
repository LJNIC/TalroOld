local play = {}

function play:init()
	moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
	actionKeys = {['t'] = true}
	--Setup tileset / display
	local spriteSheet = love.graphics.newImage('cheepicus_16x16.png') 
	logger.log("Loaded map", "INFO")
	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 1, spriteSheet, 16, 16, COLORS.YELLOW, COLORS.YELLOW)
	tunnelMap = Map(SCREEN_WIDTH, SCREEN_HEIGHT*2, root)

	hero = Player:new(37, 75, '@', COLORS.BLUE, COLORS.YELLOW, tunnelMap)
	
	if not tunnelMap:isPassable(hero.x, hero.y) then
		for x = 1, SCREEN_WIDTH do
			if tunnelMap:isPassable(x, hero.y) then
				hero.x = x
			end
		end
	end

	--parsing the start screen file: x position, y position, character, foreground, background
	for line in io.lines('pyramid.csv') do
		local tempTile = {}
		local i = 1
		for word in string.gmatch(line, '([^,]+)') do
    		tempTile[i] = word
			i = i + 1
		end
		
		local x = tonumber(tempTile[1])
		local y = tonumber(tempTile[2])
		local char = string.char(tempTile[3])
		local fore = ROT.Color.fromString(tempTile[4])
		local back = ROT.Color.fromString(tempTile[5])
		local pass = 1

		if char == '\176' or char == '\220' or char == '\214' then
			pass = 0
		end
		tunnelMap:setTile(x, y, char, pass, fore, back)
	end

	tunnelMap:moveWindow({x=0, y=40})
end

function play:textinput(t)
	if moveKeys[t] then
		if hero:move(util.keyToDirection(t)) then
			tunnelMap:moveWindow(util.keyToDirection(t))
		end
	elseif actionKeys[t] then
		if t == 't' then
			Gamestate.switch(whipstate, tunnelMap, hero, moveKeys)
		end
	end
end

function play:draw()
	tunnelMap:renderMap()
end

function play:update(dt)
	tunnelMap:drawMap()
end

return play
