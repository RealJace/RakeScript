repeat task.wait() until game:IsLoaded()

--if game.PlaceId ~= 2413927524 then return end

local player = game:GetService("Players").LocalPlayer

local RunService = game:GetService("RunService")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("THE RAKE REMASTERED SCRIPT V2", "DarkTheme")

-- Tabs
local ESPs = Window:NewTab("ESP")
local HumanoidMods = Window:NewTab("Humanoid Mods")
local Misc = Window:NewTab("Misc")

-- ESPs
local EntitiesSection = ESPs:NewSection("Entities")

local esps = {
	players = false,
	rake = false,
	crates = false,
	flare_gun = false,
	scraps = false
}

EntitiesSection:NewToggle("Players","See where players are",function(state)
	esps.players = state
end)

EntitiesSection:NewToggle("Rake","See where Rake is",function(state)
	esps.rake = state
end)

local function addPlayerEsp(player)
	task.spawn(function()
		local character = player
		if not character:FindFirstChild("ESP") then
			local highlight = Instance.new("Highlight")
			highlight.Name = "ESP"
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = Color3.fromRGB(255,255,255)
			highlight.FillTransparency = 0.5
			highlight.FillColor = Color3.fromRGB(81,204,252)
			highlight.Parent = character
			highlight.Adornee = character
		end	
	end)
end

RunService.Heartbeat:Connect(function()
	for _,player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player.Character then
				local esp = player.Character:FindFirstChild("ESP")
				if esp then
					esp.Enabled = esps.players
				end
		end
	end
end)

--workspace.ChildAdded

for _,character in ipairs(workspace:GetChildren()) do
	if game:GetService("Players"):GetPlayerFromCharacter(character) then
		addPlayerEsp(character)
	end
end
