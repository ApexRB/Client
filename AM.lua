--[[WindUI = getgenv().WindUI
Window = getgenv().Window]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "ApexClient",
    Author = "t.me/ApexClientRB",
    Folder = "apexclient",
    Icon = "solar:crown-line-bold",
    NewElements = true,
    HideSearchBar = false,
	User = {
		Enabled = true,
		Anonymous = false,
		Callback = function() end,
	},
})

WindUI:AddTheme({
    Name = "Aurora",
    
    Accent = Color3.fromHex("#a9dc76"),
    Dialog = Color3.fromHex("#1e1e1e"),
    Outline = Color3.fromHex("#a9dc76"),
    Text = Color3.fromHex("#fcfcfa"),
    Placeholder = Color3.fromHex("#6f6f6f"),
    Background = Color3.fromHex("#191622"),
    Button = Color3.fromHex("#a9dc76"),
    Icon = Color3.fromHex("#a9dc76"),
})

Window:ToggleTransparency(false)
WindUI:SetTheme("Aurora")

-- ПОТОМ ВСЕ ЧТО РАНЬШЕ НУЖНО БУДЕТ УБРАТЬ, ОТКРЫТЬ СКОБКИ С GETGENV!!!!! --

Window:Tag({
    Title = "Winter edition",
    Color = Color3.fromHex("#a9dc76"),
    Radius = 13,
})

-- // ERROR FUNCTION // --
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

do
	local AutofarmTab = Window:Tab({
		Title = "Autofarm",
		Icon = "solar:programming-bold",
		Locked = false,
	})

	local Section = AutofarmTab:Section({ 
        Title = "Christmas Event",
        Box = false,
        Icon = "solar:stars-bold-1",
        TextTransparency = 0.05,
        TextXAlignment = "Left",
        Opened = true,
    })

    local Paragraph = AutofarmTab:Paragraph({
        Title = "The script has been suspended.",
        Desc = "To resolve the issue, contact support.",
        Color = "Red",
    })
end
