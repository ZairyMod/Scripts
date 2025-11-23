-- Universal Triggerbot 2025 - Exact UI Match + Mobile Re-Open Button
-- Works on Da Strike + ALL Da Hood rip-offs (Hood Modded, Hood Customs, etc.)
-- Mobile & PC | VirtualInput + mouse1press auto-detect

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled or not UserInputService.KeyboardEnabled

-- Config
local Config = {
    Enabled = false,
    Delay = 0.10,
    Prediction = 0.13,
    Keybind = Enum.KeyCode.RightShift,
    KnifeCheck = false,
    ForcefieldCheck = false,
    KnockedCheck = true,
    AmmoCheck = false,
    FOV = 55
}

local vim = (getgenv and getgenv().VirtualInputManager) or nil
local heartbeat

-- Shoot Function (Mobile + PC)
local function Shoot()
    if vim then
        local x, y = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2
        vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.02)
        vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
    else
        mousem1press()
        task.wait(0.02)
        mousem1release()
    end
end

-- Main Triggerbot Loop
local function StartTB()
    if heartbeat then heartbeat:Disconnect() end
    heartbeat = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

        local closest = math.huge
        local targetFound = false

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character
            if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            -- Checks
            if Config.KnockedCheck and (hum:GetState() == Enum.HumanoidStateType.Dead or hum.PlatformStand) then continue end
            if Config.ForcefieldCheck and char:FindFirstChild("ForceField") then continue end
            if Config.KnifeCheck then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("combat")) then continue end
            end
            if Config.AmmoCheck then
                local myTool = myChar:FindFirstChildOfClass("Tool")
                if myTool and myTool:FindFirstChild("Ammo") and myTool.Ammo.Value <= 0 then return end
            end

            local head = char.Head
            local vel = char.HumanoidRootPart.AssemblyLinearVelocity
            local pred = head.Position + vel * Config.Prediction
            local screenPos, onScreen = Camera:WorldToViewportPoint(pred)
            if not onScreen then continue end

            local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude

            if dist < Config.FOV and dist < closest then
                closest = dist
                targetFound = true
            end
        end

        if targetFound then
            Shoot()
            task.wait(Config.Delay)
        end
    end)
end

-- UI Creation (Exact Match + Mobile Reopen)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "24kOG_TB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Hidden by default)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 340)
Main.Position = UDim2.new(0.5, -210, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 20)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 180, 255)
Stroke.Thickness = 3

-- Title + Close
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "24kOG Triggerbot"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-50,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Draggable
local dragging
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        Main.Position = Main.Position + UDim2.new(0, i.Position.X - Main.AbsolutePosition.X - Main.AbsoluteSize.X/2, 0, i.Position.Y - Main.AbsolutePosition.Y - Main.AbsoluteSize.Y/2)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

-- Left Column (Delay / Prediction / Keybind)
local function CreateInput(y, label, default, isKeybind)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0,100,0,40)
    L.Position = UDim2.new(0,20,0,y)
    L.BackgroundTransparency = 1
    L.Text = label..":"
    L.TextColor3 = Color3.new(1,1,1)
    L.TextScaled = true
    L.Font = Enum.Font.GothamBold
    L.Parent = Main

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0,180,0,40)
    Box.Position = UDim2.new(0,130,0,y)
    Box.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Box.PlaceholderText = "Enter "..label
    Box.Text = default
    Box.TextColor3 = Color3.new(1,1,1)
    Box.TextScaled = true
    Box.Parent = Main
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0,12)

    if isKeybind then
        Box.FocusLost:Connect(function()
            local kc = Enum.KeyCode[Box.Text:upper()] or Config.Keybind
            Config.Keybind = kc
            Box.Text = kc.Name
        end)
    else
        Box.FocusLost:Connect(function()
            local n = tonumber(Box.Text)
            if n then
                if label == "Delay" then Config.Delay = n
                elseif label == "Prediction" then Config.Prediction = math.clamp(n,0,0.5) end
            end
        end)
    end
end

CreateInput(70, "Delay", "0.10", false)
CreateInput(130, "Prediction", "0.13", false)
CreateInput(190, "Keybind", "RightShift", true)

-- Right Column Toggles (Exact Picture Match)
local function CreateToggle(y, text, configKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0,180,0,50)
    Btn.Position = UDim2.new(0,220,0,y)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Btn.Text = text .. ": OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Main
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,14)

    Btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        Btn.Text = text .. ": " .. (Config[configKey] and "ON" or "OFF")
        Btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 170, 255)
    end)
end

local EnableBtn = CreateToggle(60, "Enabled", "Enabled")
CreateToggle(120, "Knife Check", "KnifeCheck")
CreateToggle(180, "Forcefield Check", "ForcefieldCheck")
CreateToggle(240, "Knocked Check", "KnockedCheck")
CreateToggle(300, "Ammo Check", "AmmoCheck")  -- Extra row fits perfectly

-- Mobile Re-Open Button (Always Visible)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,90,0,90)
OpenBtn.Position = UDim2.new(0,15,0.5,-45)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255,215,0)
OpenBtn.Text = "TB"
OpenBtn.TextColor3 = Color3.new(0,0,0)
OpenBtn.TextScaled = true
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0.5,0)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Keybind listener
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Config.Keybind then
        Config.Enabled = not Config.Enabled
        EnableBtn.Text = "Enabled: " .. (Config.Enabled and "ON" or "OFF")
        EnableBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(0,170,255)
    end
end)

-- Start
StartTB()
game.StarterGui:SetCore("SendNotification", {Title="24kOG TB"; Text="Loaded – Tap yellow button to open"; Duration=5})
