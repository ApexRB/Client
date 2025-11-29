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
Workspace.FallenPartsDestroyHeight = -9999999999999999

-- // MAIN VARIABLES // --
local KILL_AURA_DISTANCE = 15
local KILL_AURA = false
local HIGHLIGHT_MURDER = false
local HIGHLIGHT_SHERIFF = false
local HIGHLIGHT_PLAYERS = false
local PLAYER_NAMES = {}
local ESP_NAMES = false

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

function DrawName(player)
    PLAYER_NAMES[player] = Drawing.new("Text")
    PLAYER_NAMES[player].Size = 18
    PLAYER_NAMES[player].Center = true
    PLAYER_NAMES[player].Outline = true
    PLAYER_NAMES[player].Font = 2
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

local function KillPlayer(target, grip)
    local character = LocalPlayer.Character
	if character then
		if character:FindFirstChild('Knife') then
        else
            if LocalPlayer.Backpack:FindFirstChild('Knife') then
                LocalPlayer.Backpack:FindFirstChild('Knife').Parent = character
            end
        end
        local knife = character:FindFirstChild('Knife')
        if knife then
            local handle = knife:FindFirstChild('Handle')
            local plrRoot = target:FindFirstChild('HumanoidRootPart')
            if knife and handle and character and plrRoot then
                knife:FindFirstChild("Stab"):FireServer("Slash")
                firetouchinterest(handle, plrRoot, 0)
                task.wait()
                firetouchinterest(handle, plrRoot, 1)
            end
        end
	end
end

local function KillAll()
    local character = LocalPlayer.Character
    for _, plr in pairs(game.Players:GetPlayers()) do
		if character then
			if plr.Name == LocalPlayer.Name then
            else
                if plr.Character then
                    KillPlayer(plr.Character)
                end
                task.wait(.02)
            end
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
               if plr then
                    local plrCharacter = plr.Character
                    if plrCharacter then
                        local plrRoot = plrCharacter:FindFirstChild('HumanoidRootPart')
                        if plrRoot then
                            local magnitude = (root.Position - plrRoot.Position).magnitude
                            if magnitude < tonumber(KILL_AURA_DISTANCE) then
                                KillPlayer(plrCharacter, true)
                            end
                        end
                    end
                end
            end
            task.wait(.05)
        end
    end
end

local function Highlight(value, itemName, color, delete)
	if not delete then
		if value then
			for _, plr in pairs(Players:GetChildren()) do
				local character = plr.Character
				if character then
                    if itemName == 'none' then
                        if character:FindFirstChild('Gun') or plr.Backpack:FindFirstChild('Gun') then
                        elseif character:FindFirstChild('Knife') or plr.Backpack:FindFirstChild('Knife') then
                        else
                            local highlight
                            if character:FindFirstChildOfClass('Highlight') then
                                highlight = character:FindFirstChildOfClass('Highlight')
                            else
                                highlight = Instance.new('Highlight', character)
                            end
                            highlight.FillTransparency = 1
                            highlight.OutlineColor = Color3.new(0, 255, 0)
                        end
                    else
                        if character:FindFirstChild(itemName) or plr.Backpack:FindFirstChild(itemName) then
                            local highlight
                            if character:FindFirstChildOfClass('Highlight') then
                                highlight = character:FindFirstChildOfClass('Highlight')
                            else
                                highlight = Instance.new('Highlight', character)
                            end
                            highlight.FillTransparency = 1
                            highlight.OutlineColor = color
                        end
                    end
				end
			end
		end
	else
		for _, plr in pairs(Players:GetChildren()) do
			local character = plr.Character
			if character then
				if character:FindFirstChildOfClass('Highlight') then
					character:FindFirstChildOfClass('Highlight'):Destroy()
				end
			end
		end
	end
end

local function DrawNames(delete)
    if not delete then
        for plr, tag in pairs(PLAYER_NAMES) do
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            
            if head then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                tag.Visible = onScreen
                tag.Position = Vector2.new(screenPos.X, screenPos.Y)
                tag.Text = plr.Name
                local backpack = plr.Backpack
                if backpack:FindFirstChild('Knife') or char:FindFirstChild('Knife') then
                    tag.Color = Color3.new(1, 0, 0)
                elseif backpack:FindFirstChild('Gun') or char:FindFirstChild('Gun') then
                    tag.Color = Color3.new(0, 0, 1)
                else
                    tag.Color = Color3.new(0, 1, 0)
                end
            else
                tag.Visible = false
            end
        end
    else
        for plr, tag in pairs(PLAYER_NAMES) do
            tag.Visible = false
        end
    end
end

--// OTHER //--
for _, plr in pairs(Players:GetPlayers()) do
    DrawName(plr)
end

Players.PlayerAdded:Connect(function(plr)
    DrawName(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    if PLAYER_NAMES[plr] then PLAYER_NAMES[plr]:Remove() end
end)

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
		Title = "Highlight Murder" ,
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			HIGHLIGHT_MURDER = state
			if HIGHLIGHT_MURDER then
				MURDER_RUN = RunService.Heartbeat:Connect(function()
					Highlight(HIGHLIGHT_MURDER, 'Knife', Color3.new(255, 0, 0))
				end)
			else
				MURDER_RUN:Disconnect()
				Highlight(HIGHLIGHT_MURDER, 'Knife', Color3.new(255, 0, 0), true)
			end
		end
	})

    local Toggle = VisualsTab:Toggle({
		Title = "Highlight Sheriff" ,
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			HIGHLIGHT_SHERIFF = state
			if HIGHLIGHT_SHERIFF then
				SHERIFF_RUN = RunService.Heartbeat:Connect(function()
					Highlight(HIGHLIGHT_SHERIFF, 'Gun', Color3.new(0, 0, 255))
				end)
			else
				SHERIFF_RUN:Disconnect()
				Highlight(HIGHLIGHT_SHERIFF, 'Gun', Color3.new(0, 0, 255), true)
			end
		end
	})

    local Toggle = VisualsTab:Toggle({
		Title = "Highlight Innocents" ,
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			HIGHLIGHT_PLAYERS = state
			if HIGHLIGHT_PLAYERS then
				PLAYERS_RUN = RunService.Heartbeat:Connect(function()
					Highlight(HIGHLIGHT_PLAYERS, 'none', Color3.new(0, 255, 0))
				end)
			else
				PLAYERS_RUN:Disconnect()
				Highlight(HIGHLIGHT_PLAYERS, 'none', Color3.new(0, 255, 0), true)
			end
		end
	})

    local Toggle = VisualsTab:Toggle({
		Title = "Show Nicknames" ,
		Type = "Toggle",
		Value = false,
		Callback = function(state) 
			ESP_NAMES = state
			if ESP_NAMES then
				NAMES_RUN = RunService.Heartbeat:Connect(function()
					DrawNames()
				end)
			else
				NAMES_RUN:Disconnect()
				DrawNames(true)
			end
		end
	})
end
