-- Universal Triggerbot for Da Hood Ripoffs (Da Strike, etc.) 2025 by Grok
-- Works on Mobile/PC | All Features in UI | Mouse/VirtualInput Auto-Detect
-- Left: Delay, Prediction, Keybind Inputs | Right: Toggles | Close Button

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    Enabled = false,
    FOV = 60,
    Prediction = 0.13,
    ShootDelay = 0.10,
    KnifeCheck = false,
    ForcefieldCheck = false,
    KnockedCheck = false,
    AmmoCheck = false,
    KeybindStr = "RightShift"
}

local is_mobile = UserInputService.TouchEnabled
local virtualinputmanager = getgenv().VirtualInputManager or _G.VirtualInputManager
local heartbeatConn
local keybindConn

-- Functions
local function getCenter()
    if is_mobile then
        local size = Camera.ViewportSize
        return Vector2.new(size.X * 0.5, size.Y * 0.5)
    else
        return Vector2.new(Mouse.X, Mouse.Y)
    end
end

local function worldToScreen(pos)
    local vec, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vec.X, vec.Y), onScreen
end

local function hasAmmo()
    if not Config.AmmoCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local ammo = tool:FindFirstChild("Ammo")
    if ammo and (ammo:IsA("IntValue") or ammo:IsA("NumberValue")) then
        return ammo.Value > 0
    end
    return true
end

local function shootInstant()
    local mx, my = getCenter()
    if virtualinputmanager then
        virtualinputmanager:SendMouseButtonEvent(mx, my, 0, true, game, 0)
        task.wait(0.015)
        virtualinputmanager:SendMouseButtonEvent(mx, my, 0, false, game, 0)
    else
        mous1press()
        task.wait(0.015)
        mous1release()
    end
end

-- Main Loop
local canShoot = true
heartbeatConn = RunService.Heartbeat:Connect(function()
    if not Config.Enabled or not canShoot then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local center = getCenter()
    local closestDist = Config.FOV
    local foundTarget = false

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not hum or not root then continue end

        local dist3d = (root.Position - char.HumanoidRootPart.Position).Magnitude
        if dist3d > 1200 then continue end

        -- Forcefield Check
        if Config.ForcefieldCheck and player.Character:FindFirstChild("ForceField") then continue end

        -- Knocked Check (Da Hood/Da Strike)
        if Config.KnockedCheck and (hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead or hum.PlatformStand) then continue end

        -- Knife Check
        local targetTool = player.Character:FindFirstChildOfClass("Tool")
        if Config.KnifeCheck and targetTool and (string.lower(targetTool.Name):find("knife") or string.lower(targetTool.Name):find("combat")) then continue end

        local targetPart = player.Character:FindFirstChild("Head") or root
        local vel = root.AssemblyLinearVelocity
        local predPos = targetPart.Position + (vel * Config.Prediction)

        local screenPos, onScreen = worldToScreen(predPos)
        if not onScreen then continue end

        local pixelDist = (screenPos - center).Magnitude
        if pixelDist < closestDist then
            closestDist = pixelDist
            foundTarget = true
        end
    end

    if foundTarget and hasAmmo() then
        shootInstant()
        canShoot = false
        task.spawn(function()
            task.wait(Config.ShootDelay)
            canShoot = true
        end)
    end
end)

-- Keybind Update
local function updateKeybind(str)
    if keybindConn then keybindConn:Disconnect() end
    local keyName = str:gsub(" ", ""):upper()
    local success, keyCode = pcall(function()
        return Enum.KeyCode[keyName]
    end)
    if success and keyCode then
        keybindConn = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == keyCode then
                Config.Enabled = not Config.Enabled
                updateToggles() -- Defined later
            end
        end)
        Config.KeybindStr = str
    end
end
updateKeybind(Config.KeybindStr)

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalTB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 380)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 162, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Universal Triggerbot"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.5, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    if heartbeatConn then heartbeatConn:Disconnect() end
    if keybindConn then keybindConn:Disconnect() end
    ScreenGui:Destroy()
end)

-- Draggable
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Toggle Button Creator
local function createToggle(posY, text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 140, 0, 45)
    Toggle.Position = UDim2.new(0, 20, 0, posY)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Toggle.Text = text
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.TextScaled = true
    Toggle.Font = Enum.Font.Gotham
    Toggle.Parent = MainFrame

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 12)
    TCorner.Parent = Toggle

    local TStroke = Instance.new("UIStroke")
    TStroke.Color = Color3.fromRGB(0, 162, 255)
    TStroke.Thickness = 1.5
    TStroke.Parent = Toggle

    Toggle.MouseButton1Click:Connect(callback)
    return Toggle
end

-- Main Enabled Toggle
local EnabledToggle = createToggle(70, "Disabled", function()
    Config.Enabled = not Config.Enabled
    EnabledToggle.Text = Config.Enabled and "Enabled" or "Disabled"
    EnabledToggle.BackgroundColor3 = Config.Enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)

-- Knife Toggle
local KnifeToggle = createToggle(70, "Knife Check: OFF", function()
    Config.KnifeCheck = not Config.KnifeCheck
    KnifeToggle.Text = "Knife Check: " .. (Config.KnifeCheck and "ON" or "OFF")
    KnifeToggle.BackgroundColor3 = Config.KnifeCheck and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
end)
KnifeToggle.Position = UDim2.new(0, 175, 0, 70)

-- Right Toggles
local ForceToggle = createToggle(130, "Forcefield Check: OFF", function()
    Config.ForcefieldCheck = not Config.ForcefieldCheck
    ForceToggle.Text = "Forcefield Check: " .. (Config.ForcefieldCheck and "ON" or "OFF")
    ForceToggle.BackgroundColor3 = Config.ForcefieldCheck and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
end)
ForceToggle.Position = UDim2.new(0, 175, 0, 130)

local KnockedToggle = createToggle(185, "Knocked Check: OFF", function()
    Config.KnockedCheck = not Config.KnockedCheck
    KnockedToggle.Text = "Knocked Check: " .. (Config.KnockedCheck and "ON" or "OFF")
    KnockedToggle.BackgroundColor3 = Config.KnockedCheck and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
end)
KnockedToggle.Position = UDim2.new(0, 175, 0, 185)

local AmmoToggle = createToggle(240, "Ammo Check: OFF", function()
    Config.AmmoCheck = not Config.AmmoCheck
    AmmoToggle.Text = "Ammo Check: " .. (Config.AmmoCheck and "ON" or "OFF")
    AmmoToggle.BackgroundColor3 = Config.AmmoCheck and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
end)
AmmoToggle.Position = UDim2.new(0, 175, 0, 240)

-- Left Inputs
local inputY = {140, 195, 250}
local inputNames = {"Delay", "Prediction", "Keybind"}
local inputDefaults = {Config.ShootDelay, Config.Prediction, Config.KeybindStr}

for i, name in ipairs(inputNames) do
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 80, 0, 30)
    Label.Position = UDim2.new(0, 25, 0, inputY[i] - 25)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ":"
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextScaled = true
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Right
    Label.Parent = MainFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 140, 0, 40)
    InputBox.Position = UDim2.new(0, 110, 0, inputY[i])
    InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    InputBox.Text = tostring(inputDefaults[i])
    InputBox.PlaceholderText = "Enter " .. name
    InputBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
    InputBox.TextColor3 = Color3.new(1,1,1)
    InputBox.TextScaled = true
    InputBox.Font = Enum.Font.Gotham
    InputBox.Parent = MainFrame

    local ICorner = Instance.new("UICorner")
    ICorner.CornerRadius = UDim.new(0, 10)
    ICorner.Parent = InputBox

    local IStroke = Instance.new("UIStroke")
    IStroke.Color = Color3.fromRGB(0, 162, 255)
    IStroke.Thickness = 1.5
    IStroke.Parent = InputBox

    if name == "Keybind" then
        InputBox.FocusLost:Connect(function(enter)
            updateKeybind(InputBox.Text)
        end)
    else
        InputBox.FocusLost:Connect(function(enter)
            local num = tonumber(InputBox.Text)
            if num and num >= 0 then
                if name == "Delay" then Config.ShootDelay = num
                elseif name == "Prediction" then Config.Prediction = math.clamp(num, 0, 0.5) end
                InputBox.Text = tostring(Config[name:lower()])
            else
                InputBox.Text = tostring(inputDefaults[i])
            end
        end)
        InputBox:GetPropertyChangedSignal("Text"):Connect(function()
            local num = tonumber(InputBox.Text)
            if num then
                if name == "Delay" then Config.ShootDelay = num
                elseif name == "Prediction" then Config.Prediction = math.clamp(num, 0, 0.5) end
            end
        end)
    end
end

-- FOV Input (Bonus - Hidden in left top)
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0, 80, 0, 30)
FOVLabel.Position = UDim2.new(0, 25, 0, 70)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV:"
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.TextScaled = true
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.TextXAlignment = Enum.TextXAlignment.Right
FOVLabel.Parent = MainFrame

local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(0, 140, 0, 40)
FOVBox.Position = UDim2.new(0, 110, 0, 65)
FOVBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FOVBox.Text = tostring(Config.FOV)
FOVBox.PlaceholderText = "Enter FOV"
FOVBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.TextScaled = true
FOVBox.Font = Enum.Font.Gotham
FOVBox.Parent = MainFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 10)
FOVCorner.Parent = FOVBox

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(0, 162, 255)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVBox

FOVBox.FocusLost:Connect(function()
    local num = tonumber(FOVBox.Text)
    if num and num > 0 then
        Config.FOV = math.clamp(num, 10, 200)
        FOVBox.Text = tostring(Config.FOV)
    else
        FOVBox.Text = tostring(Config.FOV)
    end
end)
FOVBox:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(FOVBox.Text)
    if num then Config.FOV = math.clamp(num, 10, 200) end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Universal TB Loaded";
    Text = "Works on Da Hood Ripoffs (Da Strike) | Mobile/PC | Drag to move";
    Duration = 5;
})

print("🟢 Universal Triggerbot LOADED! | FOV:", Config.FOV, "| Drag UI & Toggle Away!")
