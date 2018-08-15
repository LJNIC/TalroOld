menuOptions = {}

function menuOptions:init()
--Initialize this state's GUI
	self.menu = GUI()

--Labels
	local movementLabel = self.menu:button('Movement', {x = SCREEN_WIDTH*30/2 - 100, y = 50, w = 200, h = 35})
	movementLabel.style = Styles.labelStyle

	local subLabelX = SCREEN_WIDTH * 30/2 - 150
	local subLabels = {
		self.menu:button('Up', {x = subLabelX, y = 100, w = 100, h = 35}),
		self.menu:button('Down', {x = subLabelX, y = 140, w = 100, h = 35}),
		self.menu:button('Right', {x = subLabelX, y = 180, w = 100, h = 35}),
		self.menu:button('Left', {x = subLabelX, y = 220, w = 100, h = 35}),
		self.menu:button('Whip', {x = subLabelX, y = 320, w = 100, h = 35}) 
	}

	for i = 1, #subLabels do subLabels[i].style = Styles.labelStyleMedium end
	
	local actionsLabel = self.menu:button('Actions', {x = SCREEN_WIDTH*30/2 - 100, y = 280, w = 200, h = 35})
	actionsLabel.style = Styles.labelStyle

	self.infoLabel = self.menu:text('', {x = 100, y = 400, w = 200})
	self.infoLabel.style.default = COLORS.BROWN
	self.infoLabel.style.bg = COLORS.BROWN

--Since each action has two keys, we need two buttons for each action
--button, action, index
	local buttons = {
		{self.menu:button(Options.up[1], {x = SCREEN_WIDTH*30/2 - 50, y = 100, w = 50, h = 35}), 'up', 1},
		{self.menu:button(Options.up[2], {x = SCREEN_WIDTH*30/2 + 5, y = 100, w = 50, h = 35}), 'up', 2},
		{self.menu:button(Options.down[1], {x = SCREEN_WIDTH*30/2 - 50, y = 140, w = 50, h = 35}), 'down',1},
		{self.menu:button(Options.down[2], {x = SCREEN_WIDTH*30/2 + 5, y = 140, w = 50, h = 35}), 'down',2},
		{self.menu:button(Options.right[1], {x = SCREEN_WIDTH*30/2 - 50, y = 180, w = 50, h = 35}), 'right',1},
		{self.menu:button(Options.right[2], {x = SCREEN_WIDTH*30/2 + 5, y = 180, w = 50, h = 35}), 'right',2},
		{self.menu:button(Options.left[1], {x = SCREEN_WIDTH*30/2 - 50, y = 220, w = 50, h = 35}), 'left',1},
		{self.menu:button(Options.left[2], {x = SCREEN_WIDTH*30/2 + 5, y = 220, w = 50, h = 35}), 'left',2} 
	}

--Keeps track of the player's key choice
	self.keyChoice = {choosing = false, move = '', index = 0, button = nil}

--Whenever an action button is clicked, the action associated with that button is put into keyChoice
	for i = 1, #buttons do 
		local button = buttons[i]
		button[1].style = Styles.smallButtonStyle

		button[1].click = function(this, x, y)
			self.keyChoice.choosing = true
			self.keyChoice.move = button[2]
			self.keyChoice.index = button[3]
			self.keyChoice.button = button[1]
			button[1].label = ''
			self.infoLabel.label = 'Press a key to bind a key, or escape to cancel.'
		end
	end

	local backButton = self.menu:button('Back', {x = SCREEN_WIDTH*30/2 - 100, y = 600, w = 200, h = 35})
	backButton.style = Styles.buttonStyle
	backButton.click = function(this, x, y)
		Options:save()
		Options:loadOptions()
		self.stateToSwitch = MenuState
	end

	self.stateToSwitch = nil
end

function menuOptions:enter(previous, background)
	self.stateToSwitch = nil
	self.background = background 
end

function menuOptions:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.background)
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

return menuOptions
