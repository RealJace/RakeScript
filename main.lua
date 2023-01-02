-- if game.PlaceId ~= 2413927524 then return end
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
	for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
		if plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local head = plr.Character:FindFirstChild("Head")
				local esp = plr.Character:FindFirstChild("ESP",true)
				if esp then
					esp.Enabled = esps.players
				end
				if esps.players then
					
					if not boxes[plr.Character] then
						boxes[plr.Character] = {}
					end
					
					if not boxes[plr.Character].outline then
						boxes[plr.Character].outline = Drawing.new("Square")
						boxes[plr.Character].outline.Visible = false
						boxes[plr.Character].outline.Color = Color3.new(1,1,1)
						boxes[plr.Character].outline.Thickness = 3
						boxes[plr.Character].outline.Transparency = 1
						boxes[plr.Character].outline.Filled = false
					end
					if not boxes[plr.Character].fill then
						boxes[plr.Character].fill = Drawing.new("Square")
						boxes[plr.Character].fill.Visible = false
						boxes[plr.Character].fill.Color = Color3.new(1,1,1)
						boxes[plr.Character].fill.Thickness = 1
						boxes[plr.Character].fill.Transparency = 1
						boxes[plr.Character].fill.Filled = false
					end
					
					if hrp and head then
						local pos1,onScreen = camera:worldToViewportPoint(hrp.Position)
						
						local rootPos,rootV = worldToViewportPoint(currentCamera,hrp.Position)
						local headPos = worldToViewportPoint(currentCamera,head.Position + headOff)
						local legPos = worldToViewportPoint(currentCamera,hrp.Position - legOff)
						
						boxes[plr.Character].outline.Visible = true
						boxes[plr.Character].fill.Visible = true
						boxes[plr.Character].outline.Size = Vector2.new(1000 / rootPos.Z,headPos.Y - legPos.Y)
						boxes[plr.Character].outline.Position = Vector2.new(rootPos.X - boxes[plr.Character].outline.Size.X / 2,rootPos.Y - boxes[plr.Character].outline.Size.Y / 2)
						boxes[plr.Character].fill.Size = boxes[plr.Character].outline.Size
						boxes[plr.Character].fill.Position = boxes[plr.Character].outline.Position
					else
						boxes[plr.Character].outline.Visible = false
						boxes[plr.Character].fill.Visible = false
					end
				end
		end
	end
	if workspace:FindFirstChild("Rake") then
		local hrp = workspace.Rake:FindFirstChild("HumanoidRootPart")
		local head = workspace.Rake:FindFirstChild("Head")
		addCharEsp(workspace.Rake,Color3.fromRGB(255,0,0))
		local esp = workspace.Rake:FindFirstChild("ESP",true)
		if esp then
			esp.Enabled = esps.rake
		end
		if esps.rake then
					if not boxes[workspace.Rake] then
						boxes[workspace.Rake] = {}
					end
					
					if not boxes[workspace.Rake].outline then
						boxes[workspace.Rake].outline = Drawing.new("Square")
						boxes[workspace.Rake].outline.Visible = false
						boxes[workspace.Rake].outline.Color = Color3.new(1,0,0)
						boxes[workspace.Rake].outline.Thickness = 3
						boxes[workspace.Rake].outline.Transparency = 1
						boxes[workspace.Rake].outline.Filled = false
					end
					if not boxes[workspace.Rake].fill then
						boxes[workspace.Rake].fill = Drawing.new("Square")
						boxes[workspace.Rake].fill.Visible = false
						boxes[workspace.Rake].fill.Color = Color3.new(1,0,0)
						boxes[workspace.Rake].fill.Thickness = 1
						boxes[workspace.Rake].fill.Transparency = 1
						boxes[workspace.Rake].fill.Filled = false
					end
					
					if hrp and head then
						local pos1,onScreen = camera:worldToViewportPoint(hrp.Position)
						
						local rootPos,rootV = worldToViewportPoint(currentCamera,hrp.Position)
						local headPos = worldToViewportPoint(currentCamera,head.Position + headOff)
						local legPos = worldToViewportPoint(currentCamera,hrp.Position - legOff)
						
						boxes[workspace.Rake].outline.Visible = true
						boxes[workspace.Rake].fill.Visible = true
						boxes[workspace.Rake].outline.Size = Vector2.new(1000 / rootPos.Z,headPos.Y - legPos.Y)
						boxes[workspace.Rake].outline.Position = Vector2.new(rootPos.X - boxes[workspace.Rake].outline.Size.X / 2,rootPos.Y - boxes[workspace.Rake].outline.Size.Y / 2)
						boxes[workspace.Rake].fill.Size = boxes[workspace.Rake].outline.Size
						boxes[workspace.Rake].fill.Position = boxes[workspace.Rake].outline.Position
					else
						boxes[workspace.Rake].outline.Visible = false
						boxes[workspace.Rake].fill.Visible = false
					end
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
