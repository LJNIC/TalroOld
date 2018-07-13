Styles = {}

Styles.menuFont = love.graphics.newFont('assets/BetterPixels.ttf', 48)
Styles.menuFontMedium = love.graphics.newFont('assets/BetterPixels.ttf', 32)
Styles.menuFontSmall = love.graphics.newFont('assets/BetterPixels.ttf', 28)

Styles.labelStyle = {
	font = Styles.menuFont, 
	default = COLORS.BROWN,
	fg = COLORS.YELLOW,
	hilitefg = COLORS.YELLOW,
	hilite = COLORS.BROWN
}

Styles.labelStyleMedium = {
	default = COLORS.DARKEST,
	font = Styles.menuFontMedium, 
	fg = COLORS.YELLOW,
	hilitefg = COLORS.YELLOW,
	hilite = COLORS.DARKEST
}

Styles.smallButtonStyle = {
	font = Styles.menuFontSmall,
	default = COLORS.DARKEST,
	fg = COLORS.YELLOW,
	hilite = COLORS.BROWN,
	hilitefg = COLORS.WHITE
}

Styles.buttonStyle = {
	font = Styles.menuFont, 
	default = COLORS.DARKEST,
	fg = COLORS.YELLOW,
	hilitefg = COLORS.WHITE,
	hilite = COLORS.DARKEST
}

return Styles
