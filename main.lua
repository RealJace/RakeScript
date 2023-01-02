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

local function addEsp(character,color,visible)

    if (not character) or (not color) then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")

    if (not rootPart) or (not head) then return end

    if not boxes[character] then
        boxes[character] = {}
    end
    
    if not boxes[character].outline then
        boxes[character].outline = Drawing.new("Square")
        boxes[character].outline.Visible = false
        boxes[character].outline.Color = color
        boxes[character].outline.Thickness = 3
        boxes[character].outline.Transparency = 1
        boxes[character].outline.Filled = false
    end
    if not boxes[character].fill then
        boxes[character].fill = Drawing.new("Square")
        boxes[character].fill.Visible = false
        boxes[character].fill.Color = color
        boxes[character].fill.Thickness = 1
        boxes[character].fill.Transparency = 1
        boxes[character].fill.Filled = false
    end
    if not boxes[character].name then
        boxes[character].name = Drawing.new("Text")
        boxes[character].name.Visible = false
        boxes[character].name.Color = color
        boxes[character].name.OutlineColor = Color3.fromRGB(0,0,0)
        boxes[character].name.Text = character.Name
        boxes[character].name.Outline = true
        boxes[character].name.Center = true
        boxes[character].name.Size = 12
        boxes[character].name.Font = 1
    end

    local outline = boxes[character].outline
    local fill = boxes[character].fill
    local nameText = boxes[character].name
    
    if rootPart and head and outline and fill and nameText then
        local _,onScreen = camera:worldToViewportPoint(rootPart.Position)
        
        local rootPos,_ = camera:worldToViewportPoint(rootPart.Position)
        local headPos,headV = camera:worldToViewportPoint(head.Position + headOff)
        local legPos,legV = camera:worldToViewportPoint(rootPart.Position - legOff)
        
        if visible == true then
            outline.Visible = (onScreen or headV or legV) or false
            fill.Visible = (onScreen or headV or legV) or false
            nameText.Visible = (onScreen or headV or legV) or false
        else
            outline.Visible = visible
            fill.Visible = visible
            nameText.Visible = visible
        end
        outline.Size = Vector2.new(1000 / rootPos.Z,headPos.Y - legPos.Y)
        outline.Position = Vector2.new(rootPos.X - outline.Size.X / 2,rootPos.Y - outline.Size.Y / 2)
        fill.Size = outline.Size
        fill.Position = outline.Position
        nameText.Position = outline.Position + Vector2.new(0,(outline.Size.Y / 2) + 1)
    else
        if outline and fill and nameText then
	    outline.Visible = false
	    fill.Visible = false
	    nameText.Visible = false
	end
    end
	
    if not boxConnections[character] then
        boxConnections[character] = character.Destroying:Connect(function()
            repeat wait() until outline and fill and nameText
            outline:Remove()
            fill:Remove()
            nameText:Remove()
            boxConnections[character]:Disconnect()
        end)
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
	    addEsp(plr.Character,Color3.fromRGB(255,255,255),esps.players)
    end

    local rake = workspace:FindFirstChild("Rake")
    if workspace:FindFirstChild("Rake") then
	    addEsp(rake,Color3.fromRGB(255,0,0),esps.rake)
    end

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
