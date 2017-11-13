-- Configuration
function love.conf(t)
	t.title = "MiniCurso Fecitel" -- The title of the window the game is in (string)
	t.version = "0.10.2"         -- The LÖVE version this game was made for (string)
	t.window.width = 1375      -- we want our game to be long and thin.
	t.window.height = 765
	t.window.vsync = true
	-- For Windows debugging
	t.console = true
end