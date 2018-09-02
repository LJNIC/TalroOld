BaseOptions = {}

function BaseOptions.loadMenu(state, backState)
--Initialize this state's GUI
	state.menu = GUI()

	state.backState = backState
--Labels
	local movementLabel = state.menu:button('Movement', {x = SCREEN_WIDTH*30/2 - 100, y = 50, w = 200, h = 35})
	movementLabel.style = Styles.labelStyle

	local subLabelX = SCREEN_WIDTH * 30/2 - 150
	local subLabels = {
		state.menu:button('Up', {x = subLabelX, y = 100, w = 100, h = 35}),
		state.menu:button('Down', {x = subLabelX, y = 140, w = 100, h = 35}),
		state.menu:button('Right', {x = subLabelX, y = 180, w = 100, h = 35}),
		state.menu:button('Left', {x = subLabelX, y = 220, w = 100, h = 35}),
		state.menu:button('Whip', {x = subLabelX, y = 320, w = 100, h = 35}) 
	}

	for i = 1, #subLabels do subLabels[i].style = Styles.labelStyleMedium end
	
	local actionsLabel = state.menu:button('Actions', {x = SCREEN_WIDTH*30/2 - 100, y = 280, w = 200, h = 35})
	actionsLabel.style = Styles.labelStyle

	state.infoLabel = state.menu:text('', {x = 100, y = 400, w = 200})
	state.infoLabel.style.default = COLORS.BROWN
	state.infoLabel.style.bg = COLORS.BROWN

--Since each action has two keys, we need two buttons for each action
--button, action, index
	local buttons = {
		{state.menu:button(Options.up[1], {x = SCREEN_WIDTH*30/2 - 50, y = 100, w = 50, h = 35}), 'up', 1},
		{state.menu:button(Options.up[2], {x = SCREEN_WIDTH*30/2 + 5, y = 100, w = 50, h = 35}), 'up', 2},
		{state.menu:button(Options.down[1], {x = SCREEN_WIDTH*30/2 - 50, y = 140, w = 50, h = 35}), 'down',1},
		{state.menu:button(Options.down[2], {x = SCREEN_WIDTH*30/2 + 5, y = 140, w = 50, h = 35}), 'down',2},
		{state.menu:button(Options.right[1], {x = SCREEN_WIDTH*30/2 - 50, y = 180, w = 50, h = 35}), 'right',1},
		{state.menu:button(Options.right[2], {x = SCREEN_WIDTH*30/2 + 5, y = 180, w = 50, h = 35}), 'right',2},
		{state.menu:button(Options.left[1], {x = SCREEN_WIDTH*30/2 - 50, y = 220, w = 50, h = 35}), 'left',1},
		{state.menu:button(Options.left[2], {x = SCREEN_WIDTH*30/2 + 5, y = 220, w = 50, h = 35}), 'left',2} 
	}

--Keeps track of the player's key choice
	state.keyChoice = {choosing = false, move = '', index = 0, button = nil}

--Whenever an action button is clicked, the action associated with that button is put into keyChoice
	for i = 1, #buttons do 
		local button = buttons[i]
		button[1].style = Styles.smallButtonStyle

		button[1].click = function(this, x, y)
			state.keyChoice.choosing = true
			state.keyChoice.move = button[2]
			state.keyChoice.index = button[3]
			state.keyChoice.button = button[1]
			button[1].label = ''
			state.infoLabel.label = 'Press a key to bind a key, or escape to cancel.'
		end
	end

	state.backButton = state.menu:button('Back', {x = SCREEN_WIDTH*30/2 - 100, y = 600, w = 200, h = 35})
	state.backButton.style = Styles.buttonStyle
	state.backButton.click = function(this, x, y)
		Options:save()
		Options:loadOptions()
		state.stateToSwitch = state.backState
	end

	state.stateToSwitch = nil
end

return BaseOptions
