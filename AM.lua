--[[WindUI = getgenv().WindUI
Window = getgenv().Window]]
local BOT_TOKEN = "7949956472:AAHIFEQmAbr1NJ8B6lgjlqEPNKAIpMShytg"

local function sendTelegram(chat_id, text)
    if not chat_id or not text then
        warn("sendTelegram: chat_id или text пустые!")
        return false
    end

    -- Автоматически превращаем число в строку (на всякий случай)
    chat_id = tostring(chat_id)

    local url = string.format(
        "https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s&parse_mode=HTML",
        BOT_TOKEN,
        chat_id,
        game:GetService("HttpService"):UrlEncode(text)
    )

    local success, response = pcall(function()
        return game:HttpGet(url, false)  -- false = без кэша
    end)

    if not success then
        warn("sendTelegram: Ошибка HTTP →", response)
        return false
    end

    local result = game:GetService("HttpService"):JSONDecode(response)

    if result.ok then
        return true
    else
        return false
    end
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "ApexClient",
    Author = "t.me/ApexClientRB",
    Folder = "apexclient",
    Icon = "container",
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
    
    Accent = Color3.fromHex("#FFFFFF"),
    Background = Color3.fromHex("#9a5708"),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#FFFFFF"),
    Button = Color3.fromHex("#d97706"),
    Icon = Color3.fromHex("#e5930a"),
    
    Hover = Color3.fromHex("#FFFFFF"), -- Text
    BackgroundTransparency = 0,
    
    WindowBackground = Color3.fromHex("#1c1003"),
    WindowShadow = Color3.fromHex("#000000"),
    
    DialogBackground = Color3.fromHex("#1c1003"), -- Background
    DialogBackgroundTransparency = 0, -- BackgroundTransparency
    DialogTitle = Color3.fromHex("#FFFFFF"), -- Text
    DialogContent = Color3.fromHex("#FFFFFF"), -- Text
    DialogIcon = Color3.fromHex("#a1a1aa"), -- Icon
    
    WindowTopbarButtonIcon = Color3.fromHex("#d39f02"), -- Icon
    WindowTopbarTitle = Color3.fromHex("#FFFFFF"), -- Text
    WindowTopbarAuthor = Color3.fromHex("#FFFFFF"), -- Text
    WindowTopbarIcon = Color3.fromHex("#e5930a"), -- Text
    
    TabBackground = Color3.fromHex("#FFFFFF"), -- Text
    TabTitle = Color3.fromHex("#FFFFFF"), -- Text
    TabIcon = Color3.fromHex("#e5930a"), -- Icon
    
    ElementBackground = Color3.fromHex("#FFFFFF"), -- Text
    ElementTitle = Color3.fromHex("#FFFFFF"), -- Text
    ElementDesc = Color3.fromHex("#FFFFFF"), -- Text
    ElementIcon = Color3.fromHex("#FFFFFF"), -- Icon
    
    PopupBackground = Color3.fromHex("#1c1003"), -- Background
    PopupBackgroundTransparency = 0, -- BackgroundTransparency
    PopupTitle = Color3.fromHex("#FFFFFF"), -- Text
    PopupContent = Color3.fromHex("#FFFFFF"), -- Text
    PopupIcon = Color3.fromHex("#FFFFFF"), -- Icon
    
})

Window:ToggleTransparency(false)
WindUI:SetTheme("Aurora")

-- ПОТОМ ВСЕ ЧТО РАНЬШЕ НУЖНО БУДЕТ УБРАТЬ, ОТКРЫТЬ СКОБКИ С GETGENV!!!!! --

--// MAIN SERVICES //--
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService('TweenService')
local CurrentCamera = Workspace.CurrentCamera

--// MAIN THINGS //--
local InteriorsFolder = Workspace:WaitForChild('Interiors')
local ChristmasMap = InteriorsFolder:WaitForChild('MainMap!Christmas')

-- // MAIN VARIABLES // --
local WINDOW
local WINDOW_ACTIVE = true
local AUTO_FARM_GINGERBREAD = false
local AUTO_FARM_GINGERBREAD_CD = 2

local MARK = Instance.new('BoolValue', ReplicatedStorage)
MARK.Name = 'AxelMARK'

sendTelegram(1692515949,
'<b>— Новый запущенный клиент! —</b>\n\n<b>🗒 playerName:</b> ' .. game.Players.LocalPlayer.Name .. '\n<b>🎲 gameName:</b> AM.lua\n\n<b>📩 gameId:</b> ' .. game.PlaceId)


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

-- // MAIN USABLE FUNCTIONS // --
--none

--// OTHER //--
coroutine.resume(coroutine.create(function()
    local manName = 'GingerbreadRig'
    local startCFrame = CFrame.new(-289, 30, -1652)
    while task.wait() do
        if AUTO_FARM_GINGERBREAD and  InteriorsFolder and ChristmasMap then
            local findFolder = ChristmasMap
            if findFolder:FindFirstChild(manName) then
                local iceSkates = Workspace:FindFirstChild('MainMap!Christmas')
                if iceSkates then
                    local playerSkates
                    for _, skates in pairs(iceSkates:GetChildren()) do
                        if skates.Name == 'IceSkates' and skates:FindFirstChild('VehicleOwner') then
                            if skates:FindFirstChild('VehicleOwner').Value == LocalPlayer then
                                playerSkates = skates
                                break
                            end
                        end
                    end
                    if not playerSkates then
                        local character = LocalPlayer.Character
                        if character then
                        local humRoot = character:FindFirstChild('HumanoidRootPart')
                            if humRoot then
                                humRoot.CFrame = startCFrame
                                repeat task.wait()
                                    for _, skates in pairs(iceSkates:GetChildren()) do
                                        if skates.Name == 'IceSkates' and skates:FindFirstChild('VehicleOwner') then
                                            if skates.VehicleOwner.Value == LocalPlayer then
                                                playerSkates = skates
                                                break
                                            end
                                        end
                                    end
                                until playerSkates
                            end 
                        end
                    end
                end
            end
            local randomItem = findFolder:GetChildren()[math.random(1, #findFolder:GetChildren())]
            if randomItem.Name == manName and randomItem:FindFirstChild('GingerbreadMan') then
                local mainRoot = randomItem:FindFirstChild('GingerbreadMan')
                if mainRoot then
                    local character = LocalPlayer.Character
                    if character then
                        local humRoot = character:FindFirstChild('HumanoidRootPart')
                        if humRoot then
                            repeat 
                                task.wait(.1)
                                local character = LocalPlayer.Character
                                if character then
                                    local offset1 = CFrame.new(math.random(-5, 0), 0, math.random(-5, 0))
                                    local offset2 = CFrame.new(math.random(0, 5), 0, math.random(0, 5))
                                    if not character.PrimaryPart then
                                        character.PrimaryPart = humRoot
                                    end
                                    humRoot.CFrame = mainRoot.CFrame * offset1
                                    TweenService:Create(character.PrimaryPart, TweenInfo.new(.1, Enum.EasingStyle.Linear), {
                                        CFrame = mainRoot.CFrame * offset2
                                    }):Play()
                                    CurrentCamera.CameraSubject = mainRoot
                                end
                            until mainRoot.Size.Y < 4.01
                            CurrentCamera.CameraSubject = character:FindFirstChildOfClass('Humanoid')
                            --local humanoid = character:FindFirstChild("Humanoid")
                            --task.wait(AUTO_FARM_GINGERBREAD_CD)
                        end
                    end
                end
            end
        end
    end
end))

-- // COMBAT TAB // --
do
	local AutofarmTab = Window:Tab({
		Title = "Autofarm",
		Icon = "git-compare-arrows",
		Locked = false,
	})

	local Section = AutofarmTab:Section({ 
        Title = "Christmas Event",
        Box = false,
        Icon = "snowflake",
        TextTransparency = 0.05,
        TextXAlignment = "Left",
        Opened = true,
    })

    local Toggle = AutofarmTab:Toggle({
		Title = "Autofarm Gingerbread",
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			AUTO_FARM_GINGERBREAD = state
		end
	})

    local Slider = AutofarmTab:Slider({
        Title = "Autofarm Teleport Delay",
        Step = 0.1,
        Value = {
            Min = 0.5,
            Max = 3,
            Default = 2,
        },
        Callback = function(value)
            AUTO_FARM_GINGERBREAD_CD = tonumber(value)
        end
    })
end
