Styles = require 'util/styles'
Menu = {}

function Menu:init()
	local spriteSheet = love.graphics.newImage('assets/altsheet2_15x15.png')
	spriteSheet:setFilter('nearest', 'nearest')

	menuRoot = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)

--Draw the border
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
end

function Menu:enter()
	title = love.graphics.newImage('assets/talro.png')
	titleX = SCREEN_WIDTH*30/2 - 180
	titleY = 60
	mainMenu = GUI()

	playButton = mainMenu:button('PLAY', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 - 50, w = 100, h = 35})
	playButton.style = Styles.buttonStyle
	playButton.click = function(this, x, y)
		Gamestate.switch(PlayState)
	end

	quitButton = mainMenu:button('QUIT', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 + 50, w = 100, h = 35})
	quitButton.style = Styles.buttonStyle
	quitButton.click = function(this, x, y)
		love.event.quit()
	end

	optionButton = mainMenu:button('OPTIONS', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2, w = 100, h = 35})
	optionButton.style = Styles.buttonStyle
	optionButton.click = function(this, x, y)
		Gamestate.switch(MenuOptions, menuRoot)
	end
end

function Menu:draw()
	menuRoot:draw()
	mainMenu:draw()
	love.graphics.setColor(COLORS.GREEN)
	love.graphics.draw(title, titleX, titleY)
end

function Menu:keypressed(key, scancode, isrepeat)
end

function Menu:mousepressed(x, y, button)
	mainMenu:mousepress(x, y, button)
end

function Menu:mousereleased(x, y, button)
	mainMenu:mouserelease(x, y, button)
end

function Menu:update(dt)
	mainMenu:update(dt)	
end

return Menu
