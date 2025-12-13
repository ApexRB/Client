WindUI = getgenv().WindUI
Window = getgenv().Window

function Notify(message, description, time)
	if message then
		WindUI:Notify({
			Title = message,
			Content = description,
			Duration = time or 3,
			Icon = "bell",
		})
	else
		WindUI:Notify({
			Title = "An error occurred",
			Content = "Please try again later.",
			Duration = 3,
			Icon = "bell",
		})
	end
end

if getgenv().Loaded ~= nil then
	getgenv().Loaded = true
	Notify('Successful hub loading!', 'GameID: ' .. game.PlaceId, 5)
else
	Window:Destroy()
end
