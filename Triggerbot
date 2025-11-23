local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG (Loaded from UI)
local Config = {
    Enabled = true,
    FOV = 45,
    Prediction = 0.13,
    ShootDelay = 0.12,
    MaxDistance = 300,
    PrioritizeHead = true
}

-- Virtual mouse for mobile
local function mouse1press()
    virtualinputmanager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait()
end
local function mouse1release()
    virtualinputmanager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Get screen center
local function GetScreenCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- Predicted position
local function GetPredictedPosition(part)
    local velocity = part.AssemblyLinearVelocity or part.Velocity or Vector3.new(0,0,0)
    local predictedPos = part.Position + (velocity * Config.Prediction)
    local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

-- Main Loop
local heartbeatConnection
local function StartLoop()
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

        local closestDist = math.huge
        local target = nil

        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            if not char then continue end

            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root or (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > Config.MaxDistance then continue end

            -- KO Check: Skip dead/KO/ragdoll
            if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then continue end
            if char:FindFirstChild("ForceField") or char:FindFirstChild("Ragdoll") or char:FindFirstChild("KO") then continue end -- Da Strike specifics

            local head = Config.PrioritizeHead and char:FindFirstChild("Head") or root
            if not head then continue end

            local screenPos, onScreen = GetPredictedPosition(head)
            if not onScreen then continue end

            local distFromCenter = (screenPos - GetScreenCenter()).Magnitude
            if distFromCenter < closestDist and distFromCenter <= Config.FOV then
                closestDist = distFromCenter
                target = head
            end
        end

        if target then
            mouse1press()
            task.wait(Config.ShootDelay)
            mouse1release()
        end
    end)
end

local function StopLoop()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "24kOGTB"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 420)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "24kOG TB"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Draggable
local dragging = false
local dragStart = nil
local startPos = nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Toggle Enabled
local EnabledToggle = Instance.new("TextButton")
EnabledToggle.Size = UDim2.new(1, -20, 0, 45)
EnabledToggle.Position = UDim2.new(0, 10, 0, 60)
EnabledToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
EnabledToggle.Text = "Enabled: ON"
EnabledToggle.TextColor3 = Color3.new(1,1,1)
EnabledToggle.TextScaled = true
EnabledToggle.Font = Enum.Font.Gotham
EnabledToggle.Parent = MainFrame
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = EnabledToggle

EnabledToggle.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    EnabledToggle.Text = "Enabled: " .. (Config.Enabled and "ON" or "OFF")
    EnabledToggle.BackgroundColor3 = Config.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if Config.Enabled then StartLoop() else StopLoop() end
end)

-- Slider Function
local function CreateSlider(parent, yPos, label, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderFrame.Parent = parent
    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 8)
    SCorner.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 0.5, 0)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. default
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextScaled = true
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0.55, 0, 0, 6)
    SliderBar.Position = UDim2.new(0.42, 0, 0.5, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBar.Parent = SliderFrame
    local SBarCorner = Instance.new("UICorner")
    SBarCorner.CornerRadius = UDim.new(0, 3)
    SBarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.Position = UDim2.new(0, 0, 0, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 3)
    FCorner.Parent = Fill

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(Fill.Size.X.Scale, -10, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Text = ""
    Knob.Parent = SliderBar
    local KCorner = Instance.new("UICorner")
    KCorner.CornerRadius = UDim.new(0.5, 0)
    KCorner.Parent = Knob

    local sliding = false
    Knob.MouseButton1Down:Connect(function()
        sliding = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * relativeX
            value = math.floor(value * 100) / 100 -- 2 decimal precision

            Fill:TweenSize(UDim2.new(relativeX, 0, 1, 0), "Out", "Quad", 0.1)
            Knob:TweenPosition(UDim2.new(relativeX, -10, 0.5, -10), "Out", "Quad", 0.1)
            Label.Text = label .. ": " .. value
            callback(value)
        end
    end)

    callback(default) -- Init
    return SliderFrame
end

-- Create Sliders
CreateSlider(MainFrame, 115, "FOV", 10, 120, Config.FOV, function(v) Config.FOV = v end)
CreateSlider(MainFrame, 170, "Prediction", 0.05, 0.25, Config.Prediction, function(v) Config.Prediction = v end)
CreateSlider(MainFrame, 225, "Shoot Delay", 0.05, 0.3, Config.ShootDelay, function(v) Config.ShootDelay = v end)
CreateSlider(MainFrame, 280, "Max Dist", 100, 1000, Config.MaxDistance, function(v) Config.MaxDistance = v end)

-- Head Toggle
local HeadToggle = Instance.new("TextButton")
HeadToggle.Size = UDim2.new(1, -20, 0, 45)
HeadToggle.Position = UDim2.new(0, 10, 0, 340)
HeadToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
HeadToggle.Text = "Head Priority: ON"
HeadToggle.TextColor3 = Color3.new(1,1,1)
HeadToggle.TextScaled = true
HeadToggle.Font = Enum.Font.Gotham
HeadToggle.Parent = MainFrame
local HTCorner = Instance.new("UICorner")
HTCorner.CornerRadius = UDim.new(0, 8)
HTCorner.Parent = HeadToggle

HeadToggle.MouseButton1Click:Connect(function()
    Config.PrioritizeHead = not Config.PrioritizeHead
    HeadToggle.Text = "Head Priority: " .. (Config.PrioritizeHead and "ON" or "OFF")
    HeadToggle.BackgroundColor3 = Config.PrioritizeHead and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(170, 0, 255)
end)

-- Start
StartLoop()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "24kOG TB Loaded";
    Text = "Full UI draggable | All features adjustable!";
    Duration = 5;
})

print("🟢 24kOG TB Full UI Loaded! Drag to move.")
