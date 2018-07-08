menuOptions = {}

function menuOptions:enter(previous, menuRoot)
	menuRoot = menuRoot
	options = GUI()
	local labelStyle = {
		font = menuFont, 
		default = COLORS.DARKEST,
		fg = COLORS.YELLOW,
		hilitefg = COLORS.YELLOW,
		hilite = COLORS.DARKEST
	}
	movementLabel = options:button('Movement', {x = SCREEN_WIDTH*30/2 - 100, y = 50, w = 200, h = 35})
	movementLabel.style = labelStyle

	upLabel = options:button('Up', {x = SCREEN_WIDTH*30/2 - 200, y = 100, w = 200, h = 35})
	upLabel.style = labelStyle

	upButton1 = options:button(Options.up[1], {x = SCREEN_WIDTH*30/2 - 75, y = 100, w = 50, h = 35})
	upButton2 = options:button(Options.up[2], {x = SCREEN_WIDTH*30/2 - 20, y = 100, w = 50, h = 35})

	actionsLabel = options:button('Actions', {x = SCREEN_WIDTH*30/2 - 100, y = 150, w = 200, h = 35})
	actionsLabel.style = labelStyle


	
end

function menuOptions:draw()
	menuRoot:draw()
	options:draw()
end

function menuOptions:update(dt)
end

return menuOptions
