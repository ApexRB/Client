WindUI = getgenv().WindUI
Window = getgenv().Window

--// MAIN SERVICES //--
local ContentProvider = game:GetService("ContentProvider")
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
local AUTO_FARM_GINGERBREAD = false
local AUTOFARM_GINGERBOARD_TYPE = 'Teleport'
local AUTOFARM_GINGERBREAD_SPEED = 35
local ANTI_AFK = false
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
        if not WINDOW_ACTIVE then continue end
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
        
        local targetGingerbread
        local gingerbreads = {}
        
        for _, item in pairs(ChristmasMap:GetChildren()) do
            if item.Name == GingerbreadName and item:FindFirstChild('GingerbreadMan') then
                table.insert(gingerbreads, item)
            end
        end
        
        if #gingerbreads == 0 then continue end
        
        if AUTOFARM_GINGERBOARD_TYPE == "Tween" then
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

        local character = LocalPlayer.Character
        if not character then continue end

        local humRoot = character:FindFirstChild('HumanoidRootPart')
        if not humRoot then continue end

        if not character.PrimaryPart then character.PrimaryPart = humRoot end
        if AUTOFARM_GINGERBOARD_TYPE == 'Teleport' then
            humRoot.CFrame = mainRoot.CFrame
            repeat task.wait() until mainRoot.Size.Y < 4.01 or not mainRoot.Parent
        elseif AUTOFARM_GINGERBOARD_TYPE == 'Tween' then
            if mainRoot.Size.Y > 4.01 then
                local distance = (character.PrimaryPart.Position - mainRoot.Position).Magnitude
                local tweenTime = distance / AUTOFARM_GINGERBREAD_SPEED

                TweenService:Create(character.PrimaryPart, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {
                    CFrame = mainRoot.CFrame
                }):Play()
                                
                task.wait(tweenTime)
            end
        end
    end
end

function Minigame1Farm()
    while WINDOW_ACTIVE do
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
    if WINDOW_ACTIVE then
        if not Workspace then return end
        if not PenguinName then return end
        
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

function AntiAfk()
    while WINDOW_ACTIVE do
        while task.wait(1080) do
            if ANTI_AFK then
                VirtualInput:ClickButton2(Vector2.new())
            end
        end
    end
end

Window:OnDestroy(function()
	if MARK then
		MARK:Destroy()
	end
    task.wait(1)
    WINDOW_ACTIVE = false
end)

-- // AUTOFARM TAB // --
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

    local Toggle = AutofarmTab:Button({
		Title = "Delete Penguins",
		Callback = function() 
			DeletePenguins()
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
        Values = {"Teleport", "Tween"},
        Value = "Teleport",
        Callback = function(option) 
           AUTOFARM_GINGERBOARD_TYPE = option
        end
    })

    AutofarmTab:Space()

    local Toggle = AutofarmTab:Toggle({
		Title = "Anti-AFK",
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			ANTI_AFK = state
            if ANTI_AFK then
				afkCOROUTINE = coroutine.create(function() AntiAfk() end)
				coroutine.resume(afkCOROUTINE)
			else
				if afkCOROUTINE then
					coroutine.close(afkCOROUTINE)
                    CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
				end
			end
		end
	})

    --[[local Toggle = AutofarmTab:Toggle({
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
	})]]
end

if getgenv().Loaded ~= nil then
	getgenv().Loaded = true
	Notify('Successful hub loading!', 'GameID: ' .. game.PlaceId, 5)
else
	Window:Destroy()
end
