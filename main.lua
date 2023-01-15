--if game.PlaceId ~= 2413927524 then return end

local player = game:GetService("Players").LocalPlayer

local camera = workspace.Camera

local headOff = Vector3.new(0,0.5,0)
local legOff = Vector3.new(0,3,0)

local RunService = game:GetService("RunService")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("THE RAKE REMASTERED SCRIPT V2", "DarkTheme")

-- Tabs
local ESPs = Window:NewTab("ESP")
local HumanoidMods = Window:NewTab("Humanoid Mods")
local Misc = Window:NewTab("Misc")

-- Sections
local EntitiesSection = ESPs:NewSection("Entities")
local ObjectsSection = ESPs:NewSection("Objects")
local HumanoidSection = HumanoidMods:NewSection("Humanoid Modifiers")
local MiscSection = Misc:NewSection("Misc stuff")

-- ESP

local esps = {
	players = false,
	rake = false,
	crates = false,
	flare_gun = false,
	scraps = false
}

local boxes = {}
local boxConnections = {}

EntitiesSection:NewToggle("Players","See where players are",function(state)
	esps.players = state
end)

EntitiesSection:NewToggle("Rake","See where Rake is",function(state)
	esps.rake = state
end)

ObjectsSection:NewToggle("Crates","See where crates are",function(state)
	esps.crates = state
end)

ObjectsSection:NewToggle("Flare guns","See where flare guns are",function(state)
	esps.flare_gun = state
end)

ObjectsSection:NewToggle("Scraps","See where scraps are",function(state)
	esps.rake = state
end)

local function addEsp(characterName,color,visible)

    local character = workspace:FindFirstChild(characterName)
	
    if not character and boxes[characterName] then
	boxes[character]:Remove()
    end

    if (not character) or (not color) then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")

    if (not rootPart) or (not head) then return end

    if not boxes[characterName] then
        boxes[characterName] = Drawing.new("Square")
	boxes[characterName].Thickness = 3
	boxes[characterName].Filled = false
	boxes[characterName].Color = color or Color3.new(1,1,1)
	boxes[characterName].Transparency = 0
    end
    local currentBox = boxes[characterName]
    
    if rootPart and head and currentBox then
        local _,onScreen = camera:worldToViewportPoint(rootPart.Position)
        
        local rootPos,_ = camera:worldToViewportPoint(rootPart.Position)
        local headPos,headV = camera:worldToViewportPoint(head.Position + headOff)
        local legPos,legV = camera:worldToViewportPoint(rootPart.Position - legOff)
        
        if visible == true then
            currentBox.Visible = (onScreen or headV or legV) or false
        else
            currentBox.Visible = visible
        end
        currentBox.Size = Vector2.new(1000 / rootPos.Z,headPos.Y - legPos.Y)
        currentBox.Position = Vector2.new(rootPos.X - outline.Size.X / 2,rootPos.Y - outline.Size.Y / 2)
    else
        if currentBox then
	    currentBox.Visible = false
	end
    end
end

-- Speed

local walkSpeed = 16

HumanoidSection:NewSlider("Speed", "Make you go fast", 33, 16, function(s)
    walkSpeed = s
end)

-- Fullbright
local fullBright = false

MiscSection:NewButton("Full bright", "See everything and you don't need flashlight!", function()
    fullBright = true
end)

-- No stamina drain
local noStaminaDrain = false

MiscSection:NewToggle("No stamina drain","Prevent stamina from going down",function(state)
	noStaminaDrain = state
end)

RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
	    addEsp(plr.Name,Color3.fromRGB(255,255,255),esps.players)
    end

    addEsp("Rake",Color3.fromRGB(255,0,0),esps.rake)

    if fullBright then
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").FogEnd = 786543
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Ambient = Color3.fromRGB(178,178,178)
    end

    if player.Character then
        local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = walkSpeed
        end
    end

    if noStaminaDrain then
        for _,gui in ipairs(player.PlayerGui:GetChildren()) do
            if gui.Name == "UI" then
                local frame = gui:FindFirstChild("Frame")
                if frame then
                    local staminaFrame = frame:FindFirstChild("StaminaFrame")
                    if staminaFrame then
		        local bar = staminaFrame:FindFirstChild("Bar")
			if bar then
			   bar.Size = UDim2.fromScale(1, 1)
			end
		    end
                end
            end
        end
    end
end)
