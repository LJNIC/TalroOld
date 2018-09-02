local base = require 'states/options-base'
menuOptions = {}

function menuOptions:init()
	base.loadMenu(self, MenuState)
end

function menuOptions:enter(previous)
	self.stateToSwitch = nil
end

function menuOptions:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(background)
	self.menu:draw()

	if self.stateToSwitch then
		Gamestate.switch(self.stateToSwitch)
	end
end

function menuOptions:keypressed(key, scancode, isrepeat)
	if self.keyChoice.choosing then
		if Options.prohibited[key] then
			self.infoLabel.label = 'That key cannot be bound'
			return 
		elseif key == 'escape' then 
	--Cancel the key change
			self.keyChoice.button.label = Options[self.keyChoice.move][self.keyChoice.index]
		elseif Options:containsKey(key) then
			self.keyChoice.button.label = Options[self.keyChoice.move][self.keyChoice.index]
			self.infoLabel.label = 'That key is already bound'
		else
			self.keyChoice.button.label = key		
			Options[self.keyChoice.move][self.keyChoice.index] = key
			Options:reload()
			self.infoLabel.label = ''
		end
		self.keyChoice.button.fg = COLORS.BROWN
		self.keyChoice.choosing = false
	end
end

--Menu callbacks, we don't allow any other menu options until the player is done with their keybind
function menuOptions:mousepressed(x, y, button)
	if not self.keyChoice.choosing then
		self.menu:mousepress(x, y, button)
	end
end

function menuOptions:mousereleased(x, y, button)
	if not self.keyChoice.choosing then
		self.menu:mouserelease(x, y, button)
	end
end

function menuOptions:update(dt)
	if not self.keyChoice.choosing then
		self.menu:update(dt)	
	end
end

function menuOptions:extend(backState)
	local state = {}
	setmetatable(state, self)
	self.__index = self
	return state
end

return menuOptions
