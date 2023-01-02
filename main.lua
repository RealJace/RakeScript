repeat task.wait() until game:IsLoaded()

if game.PlaceId ~= 2413927524 then return end

local player = game:GetService("Players").LocalPlayer

local camera = workspace.Camera
local currentCamera = game:GetService("Workspace").CurrentCamera

local worldToViewportPoint = currentCamera.worldToViewportPoint

local headOff = Vector3.new(0,0.5,0)
local legOff = Vector3.new(0,3,0)

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

local boxes = {}

EntitiesSection:NewToggle("Players","See where players are",function(state)
	esps.players = state
end)

EntitiesSection:NewToggle("Rake","See where Rake is",function(state)
	esps.rake = state
end)

local function addCharEsp(character,color)
	if not character then return end
	task.spawn(function()
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		if not hrp:FindFirstChild("ESP") then
			local highlight = Instance.new("Highlight")
			highlight.Name = "ESP"
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = Color3.fromRGB(255,255,255)
			highlight.FillTransparency = 0.5
			highlight.FillColor = color or Color3.fromRGB(81,204,252)
			highlight.Parent = hrp or character
			highlight.Adornee = character
		end	
	end)
end

RunService.RenderStepped:Connect(function()
	for _,player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player.Character then
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				local head = player.Character:FindFirstChild("Head")
				local esp = player.Character:FindFirstChild("ESP",true)
				if esp then
					esp.Enabled = esps.players
				end
				if esps.players then
					
					if not boxes[player.Character] then
						boxes[player.Character] = {}
					end
					
					if not boxes[player.Character].outline then
						boxes[player.Character].outline = Drawing.new("Square")
						boxes[player.Character].outline.Visible = false
						boxes[player.Character].outline.Color = Color3.new(0,0,0)
						boxes[player.Character].outline.Thickness = 3
						boxes[player.Character].outline.Transparency = 1
						boxes[player.Character].outline.Filled = false
					end
					if not boxes[player.Character].fill then
						boxes[player.Character].fill = Drawing.new("Square")
						boxes[player.Character].fill.Visible = false
						boxes[player.Character].fill.Color = Color3.new(1,1,1)
						boxes[player.Character].fill.Thickness = 1
						boxes[player.Character].fill.Transparency = 1
						boxes[player.Character].fill.Filled = false
					end
					
					if hrp and head then
						local pos1,onScreen = camera:worldToViewportPoint(hrp.Position)
						
						local rootPos,rootV = worldToViewportPoint(currentCamera,hrp.Position)
						local headPos = worldToViewportPoint(currentCamera,head.Position + headOff)
						local legPos = worldToViewportPoint(currentCamera,hrp.Position - legOff
						
						boxOutline.Visible = onScreen
						box.Visible = onScreen
						if onScreen then
							boxes[player.Character].outline.Size = Vector2.new(1000 / rootPos.Z,headPos.Y - legPos.Y)
							boxes[player.Character].outline.Position = Vector2.new(rootPos.X - boxOutline.Size.X / 2,rootPos.Y - boxOutline.Size.Y / 2)
							boxes[player.Character].fill.Size = boxOutline.Size
							boxes[player.Character].fill.Position = boxOutline.Position
						end
					end
				end
		end
	end
	if workspace:FindFirstChild("Rake") then
		addCharEsp(workspace.Rake,Color3.fromRGB(255,0,0))
		local esp = workspace.Rake:FindFirstChild("ESP")
		if esp then
			esp.Enabled = esps.rake
		end
	end
end)

workspace.ChildAdded:Connect(function(character)
	if game:GetService("Players"):GetPlayerFromCharacter(character) then
		addCharEsp(character)
	end
end)

for _,character in ipairs(workspace:GetChildren()) do
	if game:GetService("Players"):GetPlayerFromCharacter(character) then
		addCharEsp(character)
	end
end
