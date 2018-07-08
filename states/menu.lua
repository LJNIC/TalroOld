Menu = {}

function Menu:enter()
	local spriteSheet = love.graphics.newImage('assets/tilesheet_15x15.png')
	spriteSheet:setFilter('nearest', 'nearest')
	menuRoot = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)
	menuRoot:write('\201')	
	menuRoot:write('\187', SCREEN_WIDTH, 1)
	menuRoot:write('\200', 1, SCREEN_HEIGHT)
	menuRoot:write('\188', SCREEN_WIDTH, SCREEN_HEIGHT)
	for x = 2, SCREEN_WIDTH - 1 do
		menuRoot:write('\205', x, 1)
		menuRoot:write('\205', x, SCREEN_HEIGHT)
	end
	for y = 2, SCREEN_HEIGHT - 1 do
		menuRoot:write('\186', 1, y)
		menuRoot:write('\186', SCREEN_WIDTH, y)
	end
	font = love.graphics.newFont('assets/font.ttf', 32)
	title = love.graphics.newImage('assets/talro.png')
	titleX = SCREEN_WIDTH*30/2 - 180
	titleY = 60

	playButton = GUI:button('PLAY', {x = SCREEN_WIDTH*30/2-50, y = SCREEN_HEIGHT*30/2 - 50, w = 100, h = 35})
	playButton.style.font = font
	playButton.style.default= COLORS.DARKEST
	playButton.style.fg = COLORS.YELLOW
	playButton.style.hilitefg = COLORS.WHITE
	playButton.style.hilite = COLORS.DARKEST
	playButton.click = function(this, x, y)
		Gamestate.switch(PlayState)
	end

	quitButton = GUI:button('QUIT', {x = SCREEN_WIDTH*30/2-50, y = SCREEN_HEIGHT*30/2, w = 100, h = 35})
	quitButton.style.font = font
	quitButton.style.default= COLORS.DARKEST
	quitButton.style.hilitefg = COLORS.WHITE
	quitButton.style.fg = COLORS.YELLOW
	quitButton.style.hilite = COLORS.DARKEST
	quitButton.click = function(this, x, y)
		love.event.quit()
	end
end

function Menu:draw()
	menuRoot:draw()
	GUI:draw()
	love.graphics.setColor(COLORS.YELLOW)
	love.graphics.draw(title, titleX, titleY)
end

function Menu:keypressed(key, scancode, isrepeat)
	if key == 'return' then
		Gamestate.switch(PlayState)
	end
end

function Menu:mousepressed(x, y, button)
	GUI:mousepress(x, y, button)
end

function Menu:mousereleased(x, y, button)
	GUI:mouserelease(x, y, button)
end

function Menu:update(dt)
	GUI:update(dt)	
end

return Menu
