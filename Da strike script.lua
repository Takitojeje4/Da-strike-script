local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Da strike script",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Da real da strike script",
    LoadingSubtitle = "by notjuanfr and Red_marte06",
    Theme = "Amber Glow", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "kkUfVgUU", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "notjuanfr key system",
       Subtitle = "Key System",
       Note = "https://discord.gg/CnV8QJx4", -- Use this to tell the user how to get a key
       FileName = "Key12341", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"juan"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local Tab = Window:CreateTab("Aimbot", 4483362458) -- Title, Image

 local Section = Tab:CreateSection("Aimbots")

 local Button = Tab:CreateButton({
    Name = "Keybind is z for all of them",
    Callback = function()
        print("I TOLD YOU THE KEYBIND IS Z")
    -- The function that takes place when the button is pressed
    end,
 })


 local Button = Tab:CreateButton({
    Name = "Aimbot 1",
    Callback = function()
        local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local localPlayer = players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local aimbotEnabled = false  
local connection -- Stores the RenderStepped connection

-- Function to get the closest player with more than 15 health
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localCharacter = localPlayer.Character

    if not localCharacter then return nil end
    local localHead = localCharacter:FindFirstChild("Head")

    if not localHead then return nil end

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetTorso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if targetTorso and humanoid and humanoid.Health > 15 then
                local distance = (localHead.Position - targetTorso.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = targetTorso
                end
            end
        end
    end
    return closestPlayer
end

-- Function to aim at the closest valid player
local function aimAtTarget()
    local target = getClosestPlayer()
    if target then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) -- Aim at torso
    end
end

-- Toggle aimbot with Z
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        aimbotEnabled = not aimbotEnabled

        if aimbotEnabled then
            connection = runService.RenderStepped:Connect(aimAtTarget)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
end)
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Aimbot 2",
    Callback = function()
        local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local camera = game:GetService("Workspace").CurrentCamera
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

local aimbotEnabled = false
local lockedTarget = nil
local connection

-- Function to get the closest valid player to the mouse
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetTorso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if targetTorso and humanoid and humanoid.Health > 15 then
                local screenPosition, onScreen = camera:WorldToViewportPoint(targetTorso.Position)
                if onScreen then
                    local mouseDistance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                    if mouseDistance < shortestDistance then
                        shortestDistance = mouseDistance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Function to track the locked target
local function aimAtTarget()
    if lockedTarget and lockedTarget.Character then
        local targetTorso = lockedTarget.Character:FindFirstChild("Torso") or lockedTarget.Character:FindFirstChild("UpperTorso")
        local humanoid = lockedTarget.Character:FindFirstChildOfClass("Humanoid")

        if targetTorso and humanoid then
            if humanoid.Health <= 5 then
                -- Stop aimbot if locked target HP drops below 5
                lockedTarget = nil
                aimbotEnabled = false
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                return
            end

            camera.CFrame = CFrame.new(camera.CFrame.Position, targetTorso.Position) -- Keep aiming at locked target
        end
    end
end

-- Toggle aimbot with Z
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        if aimbotEnabled then
            -- Disable aimbot
            aimbotEnabled = false
            lockedTarget = nil
            if connection then
                connection:Disconnect()
                connection = nil
            end
        else
            -- Enable aimbot and lock onto the closest player to mouse
            local targetPlayer = getClosestPlayerToMouse()
            if targetPlayer then
                lockedTarget = targetPlayer
                aimbotEnabled = true
                connection = runService.RenderStepped:Connect(aimAtTarget)
            end
        end
    end
end)
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Aimbot 2 with trashtalk after killing someone",
    Callback = function()
        local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local camera = game:GetService("Workspace").CurrentCamera
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

local aimbotEnabled = false
local lockedTarget = nil
local connection

-- Function to get the closest valid player to the mouse
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetTorso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if targetTorso and humanoid and humanoid.Health > 15 then
                local screenPosition, onScreen = camera:WorldToViewportPoint(targetTorso.Position)
                if onScreen then
                    local mouseDistance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                    if mouseDistance < shortestDistance then
                        shortestDistance = mouseDistance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Function to track the locked target
local function aimAtTarget()
    if lockedTarget and lockedTarget.Character then
        local targetTorso = lockedTarget.Character:FindFirstChild("Torso") or lockedTarget.Character:FindFirstChild("UpperTorso")
        local humanoid = lockedTarget.Character:FindFirstChildOfClass("Humanoid")

        if targetTorso and humanoid then
            if humanoid.Health <= 5 then
                -- Stop aimbot if locked target HP drops below 5
                -- Send a random message
                local messages = {"Get better", "Son", "sybau", "ez", "I would quit if I had that kind of aim"}
                local randomMessage = messages[math.random(1, #messages)]
                game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(randomMessage, "All")
                
                -- Reset aimbot
                lockedTarget = nil
                aimbotEnabled = false
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                return
            end

            camera.CFrame = CFrame.new(camera.CFrame.Position, targetTorso.Position) -- Keep aiming at locked target
        end
    end
end

-- Toggle aimbot with Z
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        if aimbotEnabled then
            -- Disable aimbot
            aimbotEnabled = false
            lockedTarget = nil
            if connection then
                connection:Disconnect()
                connection = nil
            end
        else
            -- Enable aimbot and lock onto the closest player to mouse
            local targetPlayer = getClosestPlayerToMouse()
            if targetPlayer then
                lockedTarget = targetPlayer
                aimbotEnabled = true
                connection = runService.RenderStepped:Connect(aimAtTarget)
            end
        end
    end
end)
    -- The function that takes place when the button is pressed
    end,
 })

 local Tab = Window:CreateTab("Esp", 4483362458) -- Title, Image

 local Section = Tab:CreateSection("hightlighters")

 local Button = Tab:CreateButton({
    Name = "The keybind is v",
    Callback = function()
        print("KEYBIND IS V")
    -- The function that takes place when the button is pressed
    end,
 })


 local Button = Tab:CreateButton({
    Name = "Hightlight with name and health",
    Callback = function()
        local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local localPlayer = players.LocalPlayer
local isActive = false  -- Toggle state

-- Function to create/remove highlight effect
local function toggleHighlight(character, enable)
    if not character then return end

    local highlight = character:FindFirstChild("Highlight")
    if enable then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Red
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  -- White
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
        end
    else
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Function to create/remove name & health display
local function toggleBillboard(player, enable)
    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local billboard = character:FindFirstChild("InfoBillboard")

    if enable then
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "InfoBillboard"
            billboard.Adornee = head
            billboard.Size = UDim2.new(5, 0, 1, 0)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = character

            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = billboard
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

            local function updateLabel()
                while billboard.Parent and isActive do
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        textLabel.Text = player.Name .. " | Health: " .. math.floor(humanoid.Health)
                    end
                    task.wait(0.1) -- Update every 0.1s
                end
            end
            task.spawn(updateLabel)
        end
    else
        if billboard then
            billboard:Destroy()
        end
    end
end

-- Function to update all players
local function toggleAllPlayers(enable)
    for _, player in pairs(players:GetPlayers()) do
        if player.Character then
            toggleHighlight(player.Character, enable)
            toggleBillboard(player, enable)
        end
    end
end

-- Toggle function on key press (V)
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        isActive = not isActive
        toggleAllPlayers(isActive)
    end
end)

-- Handle new players
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1) -- Wait for character to load
        if isActive then
            toggleHighlight(player.Character, true)
            toggleBillboard(player, true)
        end
    end)
end)
    -- The function that takes place when the button is pressed
    end,
 })


 local Tab = Window:CreateTab("Teleport", 4483362458) -- Title, Image

 local Section = Tab:CreateSection("Armor")

 local Button = Tab:CreateButton({
    Name = "Armor 1",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(16.598514556884766, 18.009641647338867, 169.97305297851562)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Armor 2",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(24.643173217773438, 17.009756088256836, -146.0451202392578)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Armor 3",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(167.65501403808594, 14.009695053100586, -35.70392608642578)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })


 local Section = Tab:CreateSection("Pizza")

 local Button = Tab:CreateButton({
    Name = "Pizza 1",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(78.2142333984375, 14.009673118591309, -91.81829833984375)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Pizza 2",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(113.58424377441406, 14.009672164916992, 36.876564025878906)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Pizza 3",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(-68.5891342163086, 13.622751235961914, 102.0376205444336)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Section = Tab:CreateSection("Special stuff")

 local Button = Tab:CreateButton({
    Name = "Special stuff",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(113.17227935791016, -0.9904794692993164, -117.96794891357422)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Section = Tab:CreateSection("Usp")

 local Button = Tab:CreateButton({
    Name = "Usp",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(121.85009002685547, 26.009702682495117, 134.6433868408203)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Section = Tab:CreateSection("Tactical shotgun")

 local Button = Tab:CreateButton({
    Name = "Tactical Shotgun",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(-27.988908767700195, 14.209676742553711, 10.349111557006836)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Section = Tab:CreateSection("Places")

 local Button = Tab:CreateButton({
    Name = "Place 1",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(-111.67878723144531, 24.00978660583496, -50.91568374633789)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Place 2",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(-85.14131164550781, 14.009641647338867, 142.71420288085938)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Place 3",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(-95.04522705078125, 2.0096116065979004, -27.114437103271484)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Place 4",
    Callback = function()
        local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

-- New Target Position: (x, y, z)
local targetPosition = Vector3.new(177.17662048339844, 27.675203323364258, 131.23899841308594)

-- Teleport function
local function teleportToPosition()
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleports to the target position
end

-- Teleport to the specified position immediately when the script is executed
teleportToPosition()

    -- The function that takes place when the button is pressed
    end,
 })

 local Tab = Window:CreateTab("Other", 4483362458) -- Title, Image

 local Section = Tab:CreateSection("random")

 local Button = Tab:CreateButton({
    Name = "Fake stomp keybind is c",
    Callback = function()
        local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- The animation ID
local animationId = "rbxassetid://18152678848"

-- Create the animation object
local animation = Instance.new("Animation")
animation.AnimationId = animationId

-- Load the animation to the humanoid
local animationTrack = humanoid:LoadAnimation(animation)

-- Track whether the animation is playing
local isAnimationPlaying = false

-- Function to play the animation
local function playAnimation()
    animationTrack:Play()
    isAnimationPlaying = true
end

-- Function to stop the animation
local function stopAnimation()
    animationTrack:Stop()
    isAnimationPlaying = false
end

-- Function to stop the animation if the character jumps
local function stopAnimationIfJumping()
    -- Listen for jump events
    humanoid.Jumping:Connect(function()
        -- Stop the animation when jumping
        stopAnimation()
    end)
end

-- Listen for key press (C)
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.C then
        if isAnimationPlaying then
            -- Stop the animation if it is playing
            stopAnimation()
        else
            -- Play the animation if it is not playing
            playAnimation()
        end
    end
end)

-- Check for jumping state and stop the animation
stopAnimationIfJumping()

    -- The function that takes place when the button is pressed
    end,
 })


