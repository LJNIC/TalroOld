gameLog = {}

function gameLog:new(width, height, display)
	local gl = {}
	gl.width = width
	gl.height = height
	gl.display = display

	print(gl.display.widthInChars - height)
	gl.display:write('\201', 1, gl.display.heightInChars - height)	
	gl.display:write('\187', width, gl.display.heightInChars - height)
	gl.display:write('\200', 1, gl.display.heightInChars)
	gl.display:write('\188', width, gl.display.heightInChars)
	for x = 2, width - 1 do
		gl.display:write('\205', x, gl.display.heightInChars - height)
		gl.display:write('\205', x, gl.display.heightInChars)
	end

	for y = 1, height - 1 do
		gl.display:write('\186', 1, gl.display.heightInChars - y)
		gl.display:write('\186', width, gl.display.heightInChars -y)
	end

	return gl
end

function gameLog:draw()
	print(self.height)
	self.display:draw()
end

return gameLog
