menuOptions = {}

function menuOptions:init()
	options = GUI()

	movementLabel = options:button('Movement', {x = SCREEN_WIDTH*30/2 - 100, y = 50, w = 200, h = 35})
	movementLabel.style = Styles.labelStyle
	local subLabelX = SCREEN_WIDTH * 30/2 - 150

	local subLabels = {
		options:button('Up', {x = subLabelX, y = 100, w = 100, h = 35}),
		options:button('Down', {x = subLabelX, y = 140, w = 100, h = 35}),
		options:button('Right', {x = subLabelX, y = 180, w = 100, h = 35}),
		options:button('Left', {x = subLabelX, y = 220, w = 100, h = 35}),
		options:button('Whip', {x = subLabelX, y = 320, w = 100, h = 35}) 
	}

	for i = 1, #subLabels do subLabels[i].style = Styles.labelStyleMedium end

	buttons = {
		{options:button(Options.up[1], {x = SCREEN_WIDTH*30/2 - 50, y = 100, w = 50, h = 35}), 'up', 1},
		{options:button(Options.up[2], {x = SCREEN_WIDTH*30/2 + 5, y = 100, w = 50, h = 35}), 'up', 2},
		{options:button(Options.down[1], {x = SCREEN_WIDTH*30/2 - 50, y = 140, w = 50, h = 35}), 'down',1},
		{options:button(Options.down[2], {x = SCREEN_WIDTH*30/2 + 5, y = 140, w = 50, h = 35}), 'down',2},
		{options:button(Options.right[1], {x = SCREEN_WIDTH*30/2 - 50, y = 180, w = 50, h = 35}), 'right',1},
		{options:button(Options.right[2], {x = SCREEN_WIDTH*30/2 + 5, y = 180, w = 50, h = 35}), 'right',2},
		{options:button(Options.left[1], {x = SCREEN_WIDTH*30/2 - 50, y = 220, w = 50, h = 35}), 'left',1},
		{options:button(Options.left[2], {x = SCREEN_WIDTH*30/2 + 5, y = 220, w = 50, h = 35}), 'left',2} 
	}

	keyChoice = {choosing = false, move = '', num = 0, button = nil}

	for i = 1, #buttons do 
		local button = buttons[i]
		button[1].style = Styles.smallButtonStyle

		button[1].click = function(this, x, y)
			keyChoice.choosing = true
			keyChoice.move = button[2]
			keyChoice.num = button[3]
			keyChoice.button = button[1]
			button[1].label = ''
			infoLabel.label = 'Press a key to bind a key, or escape to cancel.'
		end
	end

	infoLabel = options:text('', {x = 100, y = 400, w = 200})
	infoLabel.style.default = COLORS.BROWN
	infoLabel.style.bg = COLORS.BROWN
	
	actionsLabel = options:button('Actions', {x = SCREEN_WIDTH*30/2 - 100, y = 280, w = 200, h = 35})
	actionsLabel.style = Styles.labelStyle

	backButton = options:button('Back', {x = SCREEN_WIDTH*30/2 - 100, y = 600, w = 200, h = 35})
	backButton.style = Styles.buttonStyle
	backButton.click = function(this, x, y)
		Options:save()
		Gamestate.switch(MenuState)
		Options:loadOptions()
	end
	prohibited = {
		['backspace'] = true,
		['capslock'] = true
	}

end

function menuOptions:enter(previous, menuRoot)
	menuRoot = menuRoot
end

function menuOptions:draw()
	menuRoot:draw()
	options:draw()
end

function menuOptions:update(dt)
	options:update(dt)
end

function menuOptions:keypressed(key, scancode, isrepeat)
	if keyChoice.choosing then
		if prohibited[key] then
			infoLabel.label = 'That key cannot be bound'
			return 
		elseif key == 'escape' then 
			keyChoice.button.label = Options[keyChoice.move][keyChoice.num]
		elseif Options:containsKey(key) then
			keyChoice.button.label = Options[keyChoice.move][keyChoice.num]
			infoLabel.label = 'That key is already bound'
		else
			keyChoice.button.label = key		
			Options[keyChoice.move][keyChoice.num] = key
			Options:reload()
			infoLabel.label = ''
		end
		keyChoice.button.fg = COLORS.BROWN
		keyChoice.choosing = false
	end
end

function menuOptions:mousepressed(x, y, button)
	if not keyChoice.choosing then
		options:mousepress(x, y, button)
	end
end

function menuOptions:mousereleased(x, y, button)
	if not keyChoice.choosing then
		options:mouserelease(x, y, button)
	end
end

function menuOptions:update(dt)
	if not keyChoice.choosing then
		options:update(dt)	
	end
end

return menuOptions
