function generate(width, height, length, roughness, windyness, maxWidth)
	map = {}
	for x = 1, width, 1 do
		map[x] = {}
		for y = 1, height, 1 do
			map[x][y] = '#'
		end
	end
	local tunnelWidth = 3
	local x = math.floor((width/2) - (tunnelWidth/2)) --start x at center
	local y = 2
	for i = 1, tunnelWidth, 1 do
		map[x + i][y] = '.'
	end
	math.randomseed(os.time())
	y = y + 1
	while y <= length + 1 do
		if math.random(100) <= roughness then
			local r = math.random(1, 2)
			if math.random(100) <= 50 then
				tunnelWidth = tunnelWidth + r
			else
				tunnelWidth = tunnelWidth - r
			end
			if tunnelWidth < 3 then
				tunnelWidth = 3
			elseif tunnelWidth > maxWidth then
				tunnelWidth = maxWidth
			elseif tunnelWidth > width then
				tunnelWidth = width
			end
		end
		if math.random(100) <= windyness then
			local z = math.random(1, 2)
			if math.random(100) <= 50 then
				x = x + z
			else
				x = x - z
			end
			if x + tunnelWidth > width then
				x = x - tunnelWidth
			end
			if x <= 0 then
				x = 1
			end
		end		
		local i = 0
		while x + i < width and i < tunnelWidth do
			print(x, y)
			map[x + i][y] = '.'
			i = i + 1
		end
		y = y + 1
	end 	
end	
generate(200, 200, 197, 100, 100, 40)
for y = 1, 200, 1 do
	for x = 1, 200, 1 do
		io.write(map[x][y])
	end
	io.write('\n')
end
