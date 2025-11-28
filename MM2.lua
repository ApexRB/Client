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
--nil

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

local function KillAll()
    local character = LocalPlayer.Character
    for _, plr in pairs(game.Players:GetPlayers()) do
		if character then
			if not character:FindFirstChild('Knife') then
                character.Backpack:FindFirstChild('Knife').Parent = character
            end
            local knife = character:FindFirstChild('Knife')
            local handle = knife:FindFirstChild('Handle')
            local plrRoot = plr.Character:FindFirstChild('HumanoidRootPart')
            if knife and handle and character and plr.Character and plrRoot then
                knife:Activate()
                firetouchinterest(handle, plrRoot, 0)
                task.wait()
                firetouchinterest(handle, plrRoot, 1)
            end
		end
	end
end

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

    local Button = Tab:Button({
        Title = "Kill All",
        Locked = false,
        Callback = function()
            KillAll()
        end
    })
end
