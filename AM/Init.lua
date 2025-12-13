WindUI = getgenv().WindUI
Window = getgenv().Window

print('windows updated all success loaded man youre maked great work, i love you')

if getgenv().Loaded ~= nil then
	getgenv().Loaded = true
	Notify('Successful hub loading!', 'GameID: ' .. game.PlaceId, 5)
else
	Window:Destroy()
end
