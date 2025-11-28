---@diagnostic disable
WindUI = getgenv().WindUI
Window = getgenv().Window

--// MAIN SERVICES //--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local VirtualInput = game:GetService("VirtualInputManager")
local CurrentCamera = Workspace.CurrentCamera

--// MAIN THINGS //--
local KILL_AURA_DISTANCE = 15
local KILL_AURA = false

local MARK = Instance.new('BoolValue', ReplicatedStorage)
MARK.Name = 'AxelMARK'

-- // MAIN VARIABLES // --
--nil

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
function FindMap()
    local map
    for _, model in pairs(Workspace:GetChildren()) do
		if model:IsA('Model') and model:GetAttribute("MapID") then
			map = model
		end
	end
    return map
end

function LeftClick()
	VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
	task.wait()
	VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

function Noclip(status, children)
    if children and status then
        if status == true then
            for _, part in pairs(children:GetDescendants()) do
                if part:IsA('BasePart') then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(children:GetDescendants()) do
                if part.Name == 'LowerTorso' or part.Name == 'UpperTorso'or part.Name == 'HumanoidRootPart' then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function KillPlayer(target)
    local character = LocalPlayer.Character
	if character then
		if character:FindFirstChild('Knife') then
        else
            if LocalPlayer.Backpack:FindFirstChild('Knife') then
            else
                error()
            end
            LocalPlayer.Backpack:FindFirstChild('Knife').Parent = character
        end
        local knife = character:FindFirstChild('Knife')
        local handle = knife:FindFirstChild('Handle')
        local plrRoot = target:FindFirstChild('HumanoidRootPart')
        if knife and handle and character and plr.Character and plrRoot then
            knife:FindFirstChild("Stab"):FireServer("Slash")
            firetouchinterest(handle, plrRoot, 0)
            task.wait()
            firetouchinterest(handle, plrRoot, 1)
        else
            error()
        end
	end
end

local function KillAll()
    local character = LocalPlayer.Character
    for _, plr in pairs(game.Players:GetPlayers()) do
		if character then
			if plr.Character then
                KillPlayer(plr.Character)
            end
            task.wait(.02)
		end
	end
end

local function KillAura()
    local character = LocalPlayer.Character
    local root = character:FindFirstChild('HumanoidRootPart')
    if character and root and KILL_AURA then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Name == LocalPlayer.Name then
            else
                local plrCharacter = plr.Character
                if plrCharacter then
                    local plrRoot = plrCharacter:FindFirstChild('HumanoidRootPart')
                    if plrRoot then
                        local magnitude = (root.Position - plrRoot.Position).magnitude
                        if magnitude < KILL_AURA_DISTANCE then
                            KillPlayer(plrCharacter)
                        end
                    end
                end
            end
        end
    end
end


Window:OnDestroy(function()
	if MARK then
		MARK:Destroy()
	end
	KILL_AURA = false
end)

-- // COMBAT TAB // --
do
	local CombatTab = Window:Tab({
		Title = "Combat",
		Icon = "hand-fist", -- optional
		Locked = false,
	})

	local Section = CombatTab:Section({ 
        Title = "Murder",
        Box = false,
        Icon = "sword",
        TextTransparency = 0.05,
        TextXAlignment = "Left",
        Opened = true,
    })

    local Button = CombatTab:Button({
        Title = "Kill All",
        Locked = false,
        Callback = function()
            KillAll()
        end
    })

    local Slider = CombatTab:Slider({
        Title = "Kill Aura Distance",
        Step = 1,
        Value = {
            Min = 15,
            Max = 100,
            Default = 15,
        },
        Callback = function(value)
            print(value)
            KILL_AURA_DISTANCE = tonumber(value)
        end
    })

    local Toggle = CombatTab:Toggle({
        Title = "Kill Aura",
        Type = "Toggle",
        Value = false,
        Callback = function(state) 
            KILL_AURA = state
			if KILL_AURA then
				KILLAURA_RUN = RunService.Heartbeat:Connect(function()
					KillAura()
				end)
			else
				KILLAURA_RUN:Disconnect()
			end
        end
    })
end

-- // VISUALS TAB // --
do
	local VisualsTab = Window:Tab({
		Title = "Visuals",
		Icon = "eye",
		Locked = false,
	})

	local Section = VisualsTab:Section({ 
        Title = "Highlights",
        Box = false,
        Icon = "wand-sparkles",
        TextTransparency = 0.05,
        TextXAlignment = "Left",
        Opened = true,
    })

	local Toggle = VisualsTab:Toggle({
		Title = "Players" ,
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			PLAYERS_HIGHLIGHTS = state
			if PLAYERS_HIGHLIGHTS then
				PLAYERS_RUN = RunService.Heartbeat:Connect(function()
					HighlightPlayers()
				end)
			else
				PLAYERS_RUN:Disconnect()
				HighlightPlayers(true)
			end
		end
	})
end
