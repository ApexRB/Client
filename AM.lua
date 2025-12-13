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

--// MAIN SERVICES //--
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService('TweenService')
local CurrentCamera = Workspace.CurrentCamera

--// MAIN SETTINGS //--
local GingerbreadName = 'GingerbreadRig'
local InteriorsFolderName = 'Interiors'
local ChristmasMapName = 'MainMap!Christmas'
local PenguinName = 'Penguin'
local Minigame1FolderName = 'HumbugWorkspace'
local Minigame1InteriorName = 'HumbugInterior:'

-- // MAIN VARIABLES // --
local WINDOW_ACTIVE = true
local DELETE_PENGUINS = false
local AUTO_FARM_GINGERBREAD = false
local AUTOFARM_GINGERBOARD_TYPE = false
local startCFrame = CFrame.new(-289, 30, -1652)
local AUTO_FARM_MINIGAME1 = false

local MARK = Instance.new('BoolValue', ReplicatedStorage)
MARK.Name = 'AxelMARK'

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

function GingerbreadFarm()
    while task.wait() do
        if not AUTO_FARM_GINGERBREAD then continue end
        if not Workspace:FindFirstChild(InteriorsFolderName) then continue end
        if not Workspace[InteriorsFolderName]:FindFirstChild(ChristmasMapName) then continue end

        local ChristmasMap = Workspace[InteriorsFolderName]:FindFirstChild(ChristmasMapName)
        if not ChristmasMap:FindFirstChild(GingerbreadName) then continue end
        if not Workspace:FindFirstChild(ChristmasMapName) then continue end

        local iceSkates = Workspace[ChristmasMapName]
        if not iceSkates then continue end

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
                local humRoot = character:WaitForChild('HumanoidRootPart')
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

        if not playerSkates then continue end
        
        -- Выбор цели в зависимости от типа фарма
        local targetGingerbread
        local gingerbreads = {}
        
        -- Собираем все печеньки
        for _, item in pairs(ChristmasMap:GetChildren()) do
            if item.Name == GingerbreadName and item:FindFirstChild('GingerbreadMan') then
                table.insert(gingerbreads, item)
            end
        end
        
        if #gingerbreads == 0 then continue end
        
        if AUTOFARM_GINGERBOARD_TYPE == "Nearest" then
            local character = LocalPlayer.Character
            if character then
                local humRoot = character:FindFirstChild('HumanoidRootPart')
                if humRoot then
                    local closestDistance = math.huge
                    local closestGingerbread

                    for _, gingerbread in pairs(gingerbreads) do
                        local gingerbreadRoot = gingerbread:FindFirstChild('GingerbreadMan')
                        if gingerbreadRoot then
                            local distance = (humRoot.Position - gingerbreadRoot.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestGingerbread = gingerbread
                            end
                        end
                    end

                    targetGingerbread = closestGingerbread
                end
            end
        else
            targetGingerbread = gingerbreads[math.random(1, #gingerbreads)]
        end

        if not targetGingerbread then continue end
        if not targetGingerbread:FindFirstChild('GingerbreadMan') then continue end

        local mainRoot = targetGingerbread:FindFirstChild('GingerbreadMan')
        if not mainRoot then continue end

        repeat 
            task.wait(.1)
            local character = LocalPlayer.Character
            if character then
                local humRoot = character:FindFirstChild('HumanoidRootPart')
                if humRoot then
                    local offset1
                    local offset2

                    if AUTOFARM_GINGERBOARD_TYPE == 'Nearest' then
                        offset1 = CFrame.new(math.random(-4, 0), 0, math.random(-4, 0))
                        offset2 = CFrame.new(math.random(0, 4), 0, math.random(0, 4))
                    else
                        offset1 = CFrame.new(math.random(-7, 0), 0, math.random(-7, 0))
                        offset2 = CFrame.new(math.random(0, 7), 0, math.random(0, 7))
                    end

                    if not character.PrimaryPart then
                        character.PrimaryPart = humRoot
                    end

                    humRoot.CFrame = mainRoot.CFrame * offset1
                    TweenService:Create(character.PrimaryPart, TweenInfo.new(.1, Enum.EasingStyle.Linear), {
                            CFrame = mainRoot.CFrame * offset2
                    }):Play()

                    CurrentCamera.CameraSubject = mainRoot
                end
            end
        until mainRoot.Size.Y < 4.01 or not mainRoot.Parent
        CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
    end
end

function Minigame1Farm()
    while task.wait() do
        if not AUTO_FARM_MINIGAME1 then continue end
        if not Workspace:FindFirstChild(Minigame1FolderName) then continue end
        if not Workspace:FindFirstChild(InteriorsFolderName) then continue end
        if not Workspace[InteriorsFolderName]:FindFirstChildOfClass('Model') then continue end
        print('abcdefg')

        local MinigamePetModels = Workspace:FindFirstChild(Minigame1FolderName)
        if not MinigamePetModels then continue end
        local randomItem = MinigamePetModels:GetChildren()[math.random(1, #MinigamePetModels:GetChildren())]
        if not randomItem:FindFirstChildOfClass('Model') then continue end
        print('hkapfdghakldfhyglkjareyhiogurhjoia;ea')

        local mainRoot = randomItem:FindFirstChildOfClass('Model'):FindFirstChild('RootPart')
        if not mainRoot then continue end
        print('h1')

        repeat task.wait()
            local character = LocalPlayer.Character
            if character then
                local humRoot = character:FindFirstChild('HumanoidRootPart')
                if humRoot then
                    if not character.PrimaryPart then
                        character.PrimaryPart = humRoot
                    end
                    print('teleported player to mainROOOOT')
                    humRoot.CFrame = mainRoot.CFrame * CFrame.new(0, 1, 0)
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
        until mainRoot == nil
        print('ooops mainroot is nil')
    end
end

function DeletePenguins()
    while task.wait() do
        if not Workspace then continue end
        if not PenguinName then continue end
        
        for _, child in pairs(Workspace:GetChildren()) do
            if child.Name == PenguinName then
                local petModel = child:FindFirstChild('PetModel')
                if not petModel then continue end

                local humRoot = petModel:FindFirstChild('HumanoidRootPart')
                if not humRoot then continue end

                humRoot.CFrame = CFrame.new(0, 700, 0)
            end
        end
    end
end

-- // COMBAT TAB // --
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

    local Toggle = AutofarmTab:Toggle({
		Title = "Delete Penguins",
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			DELETE_PENGUINS = state
            if DELETE_PENGUINS then
				penguinsCOROUTINE = coroutine.create(function() DeletePenguins() end)
				coroutine.resume(penguinsCOROUTINE)
			else
				if penguinsCOROUTINE then
					coroutine.close(penguinsCOROUTINE)
				end
			end
		end
	})

    AutofarmTab:Space()

    local Toggle = AutofarmTab:Toggle({
		Title = "Autofarm Gingerbread",
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			AUTO_FARM_GINGERBREAD = state
            if AUTO_FARM_GINGERBREAD then
				gingerbreadCOROUTINE = coroutine.create(function() GingerbreadFarm() end)
				coroutine.resume(gingerbreadCOROUTINE)
			else
				if gingerbreadCOROUTINE then
					coroutine.close(gingerbreadCOROUTINE)
                    CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
				end
			end
		end
	})

    local Dropdown = AutofarmTab:Dropdown({
        Title = "Autofarm Type",
        Values = {"Random", "Nearest"},
        Value = "Random",
        Callback = function(option) 
           AUTOFARM_GINGERBOARD_TYPE = option
        end
    })

    AutofarmTab:Space()

    local Toggle = AutofarmTab:Toggle({
		Title = "Autofarm Humbug Minigame",
		Type = "Toggle",
		Value = false,
        Locked = true,
		Callback = function(state) 
			AUTO_FARM_MINIGAME1 = state
            if AUTO_FARM_MINIGAME1 then
				minigame1COROUTINE = coroutine.create(function() Minigame1Farm() end)
				coroutine.resume(minigame1COROUTINE)
			else
				if minigame1COROUTINE then
					coroutine.close(minigame1COROUTINE)
				end
			end
		end
	})
end
