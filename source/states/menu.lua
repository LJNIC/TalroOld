Styles = require 'util/styles'
Menu = {}

function Menu:init()
	local spriteSheet = love.graphics.newImage('assets/altsheet2_15x15.png')
	spriteSheet:setFilter('nearest', 'nearest')
	self.display = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 2, COLORS.YELLOW, COLORS.DARKEST, nil, spriteSheet, 15, 15)
	self.display:write('\201')	
	self.display:write('\187', SCREEN_WIDTH, 1)
	self.display:write('\200', 1, SCREEN_HEIGHT)
	self.display:write('\188', SCREEN_WIDTH, SCREEN_HEIGHT)

	for x = 2, SCREEN_WIDTH - 1 do
		self.display:write('\205', x, 1)
		self.display:write('\205', x, SCREEN_HEIGHT)
	end

	for y = 2, SCREEN_HEIGHT - 1 do
		self.display:write('\186', 1, y)
		self.display:write('\186', SCREEN_WIDTH, y)
	end

	self.title = {
		img = love.graphics.newImage('assets/talro.png'),
		x = SCREEN_WIDTH * 30/2 - 180,
		y = 60
	}

	self.menu = GUI()
	self.stateToSwitch = nil

	self.playButton = self.menu:button('PLAY', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 - 50, w = 100, h = 35})
	self.playButton.style = Styles.buttonStyle
	self.playButton.click = function(this, x, y)
		self.stateToSwitch = PlayState
	end

	self.quitButton = self.menu:button('QUIT', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 + 50, w = 100, h = 35})
	self.quitButton.style = Styles.buttonStyle
	self.quitButton.click = function(this, x, y)
		love.event.quit()
	end

	self.optionButton = self.menu:button('OPTIONS', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2, w = 100, h = 35})
	self.optionButton.style = Styles.buttonStyle
	self.optionButton.click = function(this, x, y)
		self.stateToSwitch = MenuOptions
	end
end

function Menu:enter(previous)
	self.stateToSwitch = nil
end

function Menu:draw()
	self.display:draw()
	self.menu:draw()
	love.graphics.setColor(COLORS.BROWN)
	love.graphics.draw(self.title.img, self.title.x, self.title.y)
	if self.stateToSwitch then
		Gamestate.switch(self.stateToSwitch)
	end
end

function Menu:keypressed(key, scancode, isrepeat)
end

function Menu:mousepressed(x, y, button)
	self.menu:mousepress(x, y, button)
end

function Menu:mousereleased(x, y, button)
	self.menu:mouserelease(x, y, button)
end

function Menu:update(dt)
	self.menu:update(dt)	
end

return Menu
