Pause = {}

function Pause:init()
	self.menu = GUI()
	self.shader = love.graphics.newShader('assets/dim.glsl')
	self.stateToSwitch = nil

	self.resumeButton = self.menu:textbutton('RESUME', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 - 100, w = 100, h = 35})
	self.resumeButton.style = Styles.buttonStyle
	self.resumeButton.click = function(this, x, y)
		self.stateToSwitch = PlayState
	end

	self.menuButton = self.menu:textbutton('QUIT TO MENU', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 - 50, w = 100, h = 35})
	self.menuButton.style = Styles.buttonStyle
	self.menuButton.click = function(this, x, y)
		self.stateToSwitch = MenuState
	end

	self.optionButton = self.menu:textbutton('OPTIONS', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2, w = 100, h = 35})
	self.optionButton.style = Styles.buttonStyle
	self.optionButton.click = function(this, x, y)
		self.stateToSwitch = PauseOptionsState
	end
	self.quitButton = self.menu:textbutton('QUIT GAME', {x = SCREEN_WIDTH*30/2 - 50, y = SCREEN_HEIGHT*30/2 + 50, w = 100, h = 35})
	self.quitButton.style = Styles.buttonStyle
	self.quitButton.click = function(this, x, y)
		love.event.quit()
	end

	self.display = hero.map.display
end

function Pause:enter(previous)
	self.stateToSwitch = nil
end

function Pause:draw()
	love.graphics.setShader(self.shader)
	self.display:draw()
	love.graphics.setShader()
	self.menu:draw()
	if self.stateToSwitch then
		Gamestate.switch(self.stateToSwitch)
	end
end

function Pause:keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		self.stateToSwitch = PlayState
	end
end

function Pause:mousepressed(x, y, button)
	self.menu:mousepress(x, y, button)
end

function Pause:mousereleased(x, y, button)
	self.menu:mouserelease(x, y, button)
end

function Pause:update(dt)
	self.menu:update(dt)	
end

return Pause
