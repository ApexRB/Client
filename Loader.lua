local Players = game:GetService("Players")

local __WindUI = nil
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/ApexRB/Client/refs/heads/main/Library/Theme"))()
local WindString = 'https://raw.githubusercontent.com/ApexRB/Client/refs/heads/main/WindUI'

local SupportedGames = {
    [142823291] = {Folder = 'MM2', FullName = 'Murder Mystery 2'},
}

getgenv().Loaded = false
getgenv().WindUI = loadstring(game:HttpGet(WindString))()

getgenv().Window = WindUI:CreateWindow({
    Title = "ApexClient",
    Author = "t.me/apexClientRB",
	Icon = "rbxassetid://89483335047361",
    --Icon = "rbxassetid://92142935801281",

    Folder = "apexclient",
    Size = UDim2.fromOffset(600, 450),

    ModernLayout = true,
    BottomDragBarEnabled = true,
    HideSearchBar = false,
    IconThemed = true,
    IconSize = 30,
})

WindUI:AddTheme(Theme)
WindUI:SetTheme('MonokaiPro')

local ConfigManager = Window.ConfigManager
local ConfigName = "Saved"

getgenv().Configuration = function(__type)
    if __type == 'load' then
        local Success, Error = pcall(function()
            task.spawn(function()
                task.wait(1)
                Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                Window.CurrentConfig:Load()
            end)
        end)

        return Success, Error
    elseif __type == 'save' then
        local Success, Error = pcall(function()
            task.spawn(function()
                Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                Window.CurrentConfig:Save()
            end)
        end)

        return Success, Error
    end
end

getgenv().Notify = function(__title, __text, __icon, __duration)
    WindUI:Notify({
        Title = __title or ':3',
        Content = __text or ':3',
        Duration = __duration or 3,
        Icon = __icon or 'solar:emoji-funny-square-bold',
    })
end

task.spawn(function()
    __WindUI = loadstring(game:HttpGet(WindString))()
    __WindUI:AddTheme(Theme)
    __WindUI:SetTheme("MonokaiPro")
end)

if game:GetService("ReplicatedStorage"):FindFirstChild("AxelMARK") then
    repeat task.wait() until __WindUI ~= nil
    __WindUI:Notify({
        Title = "You already have the script running.",
        Content = "Close the previous window permanently to launch a new one.",
        Duration = 7,
        Icon = "bell",
    })
    return
end

-- // INFO TAB // --
do
    local InfoTab = Window:Tab({
        Title = "Info",
        Icon = "solar:info-square-bold",
    })

    InfoTab:Section({ 
        Title = "Welcome, " .. Players.LocalPlayer.Name .. '!',
        Icon = "solar:bolt-bold",
        TextXAlignment = "Left",
        Opened = true,
    })

    local Changelog = InfoTab:Code({
        Title = 'Updates.lua',
        Code = [[Downloading latest updates, please wait...]]
    })

    task.spawn(function()
        local currentGame = SupportedGames[game.PlaceId]
        if currentGame then
            Updates = loadstring(game:HttpGet('https://raw.githubusercontent.com/ApexRB/Client/refs/heads/main/' .. currentGame.Folder .. '/Updates.lua'))()
            Changelog:SetCode(Updates)
        else
            Updates = "Game not supported. No updates available."
            Changelog:SetCode(Updates)
        end
    end)

    InfoTab:Space()
    InfoTab:Divider()
    InfoTab:Space()

    InfoTab:Keybind({
        Title = "ApexClient Keybind",
        Desc = "Keybind to open UI",
        Value = "F1",
        Callback = function(v)
            Window:SetToggleKey(Enum.KeyCode[v])
        end
    })

    InfoTab:Button({
        Title = "Join Discord Channel",
        Icon = "solar:login-2-bold",
        Callback = function()
           setclipboard("discord.gg/qkD7WRQjAq")
		   Notify('Link copied!', 'Paste the link into your browser to open the channel.', 5)
        end
    })

    InfoTab:Section({ 
        Title = "Other",
        Icon = "solar:broom-bold",
        TextXAlignment = "Left",
        Opened = true,
    })

    InfoTab:Button({
        Title = "Unload",
        Icon = "solar:trash-bin-minimalistic-bold",
        Callback = function()
           Window:Destroy()
        end
    })
end

Window:Divider()

print('✅ Main window was loaded successfully')

WindUI:Notify({
    Title = "Please wait, loading game functions...",
    Content = ":3",
    Duration = 5,
    Icon = "solar:emoji-funny-square-bold",
})

--[[task.wait(3)
if SupportedGames[game.PlaceId] then

    local scriptPath = 'https://raw.githubusercontent.com/ApexRB/Client/main/' .. SupportedGames[game.PlaceId].Folder .. '/Init'

    loadstring(game:HttpGet(scriptPath))()

    repeat task.wait() until getgenv().Loaded == true

    Window:Divider()
end]]
