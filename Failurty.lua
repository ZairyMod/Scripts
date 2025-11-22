--// fix hahah by khen.cc and update more
--// https://discord.gg/UgQAPcBtpy

game.StarterGui:SetCore("SendNotification", {
    Title = "UPDATE DONE!"; 
    Text = "Script has fixed all error functions by khen.cc."; 
    Duration = 20;
})
task.wait(0.5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/aa8283/i/refs/heads/main/Protected_2547730226887233.txt"))() 

loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/larplarpbypasser.txt"))()

getgenv().venus = {
    ["Enabled"] = false,
    ["AimPart"] = "Head",
    ["Prediction"] = 0.12588,
    ["Smoothness"] = 0.7,
    ["AutoPred"] = true,
    ["Loaded"] = false,
    ["AntiAimViewer"] = true,
    ["cframe"] = {
        ["enabled"] = false,
        ["speed"] = 2
    },
    ["TargetStrafe"] = {
        ["Enabled"] = false,
        ["StrafeSpeed"] = 10,
        ["StrafeRadius"] = 7,
        ["StrafeHeight"] = 3,
        ["RandomizerMode"] = false
    },
    ["targetaim"] = {
        ["Toggled"] = false,
        ["enabled"] = true,
        ["targetPart"] = "UpperTorso",
        ["prediction"] = 0.12588
    },
    ["FOV"] = {
        ["Enabled"] = true,
        ["Size"] = 13,
        ["Centered"] = false,
        ["Visible"] = true,
        ["Filled"] = false,
        ["Color"] = Color3.fromRGB(255, 0, 0)
    },
    ["desync"] = {
        ["sky"] = false,
        ["invis"] = false,
        ["jump"] = false,
        ["network"] = false
    },
    ["Misc"] = {
        ["LowGfx"] = false
    },
    ["FPSunlocker"] = {
        ["Enabled"] = true,
        ["FPSCap"] = 999
    },
    ["Resolver"] = {
        ["Enable"] = false, -- new update.
    }
}

local InnalillahiMataKiri = Instance.new("ScreenGui")
InnalillahiMataKiri.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
InnalillahiMataKiri.Parent = game:GetService("CoreGui") -- Ensures the GUI is parented to CoreGui

local Notifications_Frame = Instance.new("Frame")
Notifications_Frame.Name = "Notifications"
Notifications_Frame.BackgroundTransparency = 1
Notifications_Frame.Size = UDim2.new(1, 0, 1, 36)
Notifications_Frame.Position = UDim2.fromOffset(0, -36)
Notifications_Frame.ZIndex = 5
Notifications_Frame.Parent = InnalillahiMataKiri

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local NotificationSystem = {}
local ActiveNotifications = {}

local function GetDictionaryLength(dictionary)
    local count = 0
    for _ in pairs(dictionary) do
        count += 1
    end
    return count
end

function NotificationSystem:Notify(Content: string, Delay: number)
    assert(typeof(Content) == "string", "missing argument #1, (string expected got " .. typeof(Content) .. ")")
    local Delay = typeof(Delay) == "number" and Delay or 3

    local Text = Instance.new("TextLabel")
    local Notification = {
        self = Text,
        Class = "Notification"
    }

    Text.Name = "Notification"
    Text.BackgroundTransparency = 1
    -- Position kept on the left, slightly moved down (-130 instead of -150)
    Text.Position = UDim2.new(0.5, -190, 1, -130 - (GetDictionaryLength(ActiveNotifications) * 15)) -- Left side, slightly down
    Text.Size = UDim2.new(0, 200, 0, 15) -- Reduced height from 20 to 15
    Text.Text = Content
    Text.Font = Enum.Font.SourceSans
    Text.TextSize = 14 -- Reduced text size from 17 to 14
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.TextStrokeTransparency = 0.2
    Text.TextTransparency = 1
    Text.RichText = true
    Text.ZIndex = 4
    Text.Parent = Notifications_Frame

    local function CustomTweenOffset(Offset: number)
        spawn(function()
            local Steps = 33
            for i = 1, Steps do
                Text.Position += UDim2.fromOffset(Offset / Steps, 0)
                RunService.RenderStepped:Wait()
            end
        end)
    end

    function Notification:Destroy()
        ActiveNotifications[Notification] = nil
        Text:Destroy()

        for _, v in pairs(ActiveNotifications) do
            v.self.Position += UDim2.fromOffset(0, 15) -- Spacing adjusted for smaller text
        end
    end

    ActiveNotifications[Notification] = Notification

    local TweenIn = TweenService:Create(Text, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { TextTransparency = 0 })
    local TweenOut = TweenService:Create(Text, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { TextTransparency = 1 })

    TweenIn:Play()
    CustomTweenOffset(100)

    TweenIn.Completed:Connect(function()
        delay(Delay, function()
            TweenOut:Play()
            CustomTweenOffset(100)

            TweenOut.Completed:Connect(function()
                Notification:Destroy()
            end)
        end)
    end)
end

repeat wait() until game:IsLoaded()



local repo = 'https://raw.githubusercontent.com/khen791/library/main/'


local Library = loadstring(game:HttpGet(repo .. 'main.txt'))()

local ThemeManager = loadstring(game:HttpGet(repo .. 'nini/ThemeManager.lua'))()

local SaveManager = loadstring(game:HttpGet(repo .. 'nini/SaveManager.lua'))()


Library:Notify('khen.cc')
wait(1)



local player = game.Players.LocalPlayer

local playerGuii = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "khen.cc"
screenGui.Parent = playerGuii
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Position = UDim2.new(1, -90, 0, 10)
frame.Size = UDim2.new(0, 60, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true -- Required for dragging

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame


local frameShadow = Instance.new("UIStroke")
frameShadow.Parent = frame
frameShadow.Color = Color3.fromRGB(0, 0, 0)
frameShadow.Thickness = 2
frameShadow.Transparency = 0.7

local button = Instance.new("TextButton")
button.Parent = frame
button.Position = UDim2.new(0.5, -22, 0.5, -12) -- Centered better
button.Size = UDim2.new(0, 44, 0, 24) -- Slightly larger for better touch
button.Text = "Menu"
button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 15
button.BorderSizePixel = 0

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Add hover effect
local buttonHover = Instance.new("UIStroke")
buttonHover.Parent = button
buttonHover.Color = Color3.fromRGB(255, 255, 255)
buttonHover.Thickness = 1
buttonHover.Transparency = 1

local dragging = false
local dragStart = nil
local startPos = nil

-- Handle both mouse and touch input
local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = frame.Position
end

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, playerGui.AbsoluteSize.X - frame.Size.X.Offset)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, playerGui.AbsoluteSize.Y - frame.Size.Y.Offset)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

frame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or 
        input.UserInputType == Enum.UserInputType.Touch) and dragging then
        updateDrag(input)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Button effects
button.MouseEnter:Connect(function()
    buttonHover.Transparency = 0.8
    button.BackgroundColor3 = Color3.fromRGB(0, 140, 235)
end)

button.MouseLeave:Connect(function()
    buttonHover.Transparency = 1
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end)

button.MouseButton1Click:Connect(function()
    Library:Toggle()
end)




local Window = Library:CreateWindow({
    Title = "Failurty.cc [khen.cc]",
    Center = true,
    AutoShow = true,
    Size = UDim2.new(0, 450, 0, 380)
})

local Tabs = {
        Main = Window:AddTab("Main"),
        Rage = Window:AddTab("Visuals"),
        ["UI Settings"] = Window:AddTab("Configuration")
    }

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    local currentTime = os.date("%H:%M:%S")  -- Format the time as HH:MM:SS

    Library:SetWatermark(('Failurty.cc [khen.cc] | %s fps | %s ms | Time: %s'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()),
        currentTime
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)

local assist = Tabs.Main:AddLeftGroupbox("Aim Assist")

local air = Tabs.Main:AddLeftGroupbox("Air Settings")

local set = Tabs.Main:AddRightGroupbox("Prediction config")

local tar = Tabs.Main:AddRightGroupbox("Target Strafe")

local fov = Tabs.Main:AddLeftGroupbox("Fov")

local cframe = Tabs.Rage: AddRightGroupbox("Cframe")

local visuals = Tabs.Rage: AddLeftGroupbox("Visuals")

local fog = Tabs.Rage: AddRightGroupbox("Fog Costumization")

local esp = Tabs.Rage: AddLeftGroupbox("Esp")

local anti = Tabs.Rage: AddLeftGroupbox("Desync")

local net = Tabs.Rage: AddLeftGroupbox("Fast Flags")

local ant = Tabs.Rage: AddRightGroupbox("Anti Lock")

local fly = Tabs.Rage: AddRightGroupbox("Fly Costumization")

assist:AddToggle(
    "Enable Camlock",
    {
        Text = "Enable Aim assist",
        Default = false,
        Tooltip = "Enable",
        Callback = function(state)
            venus.Enabled = state
        end
    }
)

set:AddToggle(
    "Enable AutoPrediction",
    {
        Text = "Enable AutoPrediction",
        Default = false,
        Tooltip = "Enable",
        Callback = function(state)
            venus.AutoPred = state
            venus.CamlockEnabled = state -- Enable auto prediction for camlock
            venus.TargetAimEnabled = state -- Enable auto prediction for target aim
        end
    }
)

set:AddInput(
    "Prediction",
    {
        Default = "Prediction",
        Numeric = true,
        Finished = false,
        Text = "Prediction",
        Tooltip = "Change Prediction for Target and Camlock",
        Placeholder = "0.1",
        Callback = function(value)
            venus.Prediction = tonumber(value) or 1
        end
    }
)

set:AddInput(
        "Smoothness",
        {
            Default = "Smoothness",
            Numeric = false,
            Finished = false,
            Text = "Smoothness",
            Tooltip = "Change smoothing For Target",
            Placeholder = "0.1",
            Callback = function(value)
                venus.Smoothness = value
            end
        }
    )

assist:AddToggle(
    "Enable LookAt",
    {
        Text = "Enable Look At",
        Default = false,  -- Set default to true (enabled) or false (disabled)
        Tooltip = "Enable or disable the LookAt functionality",
        Callback = function(state)
            venus.LookAtEnabled = state
        end
    }
)

tar:AddToggle(
    "Enable Target Strafe",
    {
        Text = "Target Strafe",
        Default = false,
        Tooltip = "Toggle Target Strafe (Orbiting)",
        Callback = function(state)
            venus.cframe.TargetStrafe.Enabled = state
        end
    }
)

tar:AddInput(
    "Target Strafe Distance",
    {
        Default = "15",
        Numeric = true,
        Finished = false,
        Text = "Distance",
        Tooltip = "Adjust the distance for target strafe (orbit radius)",
        Placeholder = "20",
        Callback = function(value)
            venus.cframe.TargetStrafe.StrafeRadius = tonumber(value) or venus.cframe.TargetStrafe.StrafeRadius
        end
    }
)

tar:AddInput(
    "Target Strafe Speed",
    {
        Default = "5",
        Numeric = true,
        Finished = false,
        Text = "Speed",
        Tooltip = "Adjust the speed for target strafe (orbiting)",
        Placeholder = "10",
        Callback = function(value)
            venus.cframe.TargetStrafe.StrafeSpeed = tonumber(value) or venus.cframe.TargetStrafe.StrafeSpeed
        end
    }
)

tar:AddInput(
    "Target Strafe Height",
    {
        Default = "10",
        Numeric = true,
        Finished = false,
        Text = "Height",
        Tooltip = "Adjust the height for target strafe (orbiting)",
        Placeholder = "5",
        Callback = function(value)
            venus.cframe.TargetStrafe.Height = tonumber(value) or venus.cframe.TargetStrafe.Height
        end
    }
)

set:AddDropdown(
    "Hitpart",
    {
        Values = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLeg", "RightLeg"},
        Default = 1,  -- Default selection is "UpperTorso" (index 1)
        Multi = false,  -- Single selection (not multiple)
        Text = "Hitpart",
        Tooltip = "Choose the hit part",
        Callback = function(value)
            venus.AimPart = value  -- Update the AimPart for targeting
            camlock.AimPart = value -- Ensure camlock uses the same AimPart
        end
    }
)

assist:AddToggle(
    "Enable TargetAim",
    {
        Text = "Enable Target Aim",
        Default = false,
        Tooltip = "Enable",
        Callback = function(state)
            targetaim.enabled = state
        end
    }
)


local scriptEnabled = false
local connection

local function onHeartbeat()
    for _, Target in pairs(Players:GetPlayers()) do
        if Target ~= localPlayer and Target.Character then
            for _, Part in pairs(Target.Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.Velocity = Target.Character.Humanoid.MoveDirection * 16
                    Part.AssemblyLinearVelocity = Target.Character.Humanoid.MoveDirection * 16
                end
            end
        end
    end
end

assist:AddToggle(
    "Enable Resolver",
    {
        Text = "Resolver",
        Default = false,
        Tooltip = "Resolver!",
        Callback = function(state)
            scriptEnabled = state
        end
    }
)

air:AddToggle(
    "Enable Auto Air",
    {
        Text = "Auto Air",
        Default = false,
        Tooltip = "Toggle Auto Air",
        Callback = function(state)
            venus.AutoAirEnabled = state
        end
    }
)

air:AddInput(
    "JumpOffset",
    {
        Default = "Air Offset",
        Numeric = true,
        Finished = false,
        Text = "Offset",
        Tooltip = "Change Air Offset for Target and Camlock",
        Placeholder = "0",
        Callback = function(value)
            venus.JumpOffset = tonumber(value) or 0
        end
    }
)

cframe:AddToggle(
    "Enable cframe",
    {
        Text = "cframe",
        Default = false,
        Tooltip = "Enable CFrame Speed",
        Callback = function(state)
            venus.cframe.enabled = state
            if venus.cframe.enabled then
                -- If CFrame is enabled, start moving the character with speed
                while venus.cframe.enabled do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * venus.cframe.speed
                    end
                    game:GetService("RunService").Stepped:Wait()
                end
            end
        end
    }
)

cframe:AddSlider(
    "cframe speed",
    {
        Text = "CFrame Speed",
        Default = 0,
        Min = 0,
        Max = 50,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
            venus.cframe.speed = Value
        end
    }
)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        venus.cframe.speed = venus.cframe.speed + 0.01
        print("Speed: " .. venus.cframe.speed)
    elseif input.KeyCode == Enum.KeyCode.RightBracket then
        venus.cframe.speed = venus.cframe.speed - 0.01
        print("Speed: " .. venus.cframe.speed)
    end
end)



-- Highest Roblox velocity is 128^2 or 16384
local velMax = (128 ^ 2)

-- Time to release and choke the replication packets
local timeRelease, timeChoke = 0.015, 0.105

-- Function aliases
local Property, Wait = sethiddenproperty, wait
local Radian, Random, Ceil = math.rad, math.random, math.ceil
local Angle = CFrame.Angles
local Vector = Vector3.new
local Service = game.GetService

-- Services
local Run = Service(game, 'RunService')
local statPing = Service(game, 'Stats').PerformanceStats.Ping
local Root = Service(game, 'Players').LocalPlayer.Character:WaitForChild("HumanoidRootPart")

-- Connections
local runRen, runBeat = Run.RenderStepped, Run.Heartbeat
local runRenWait, runRenCon = runRen.Wait, runRen.Connect
local runBeatCon = runBeat.Connect

-- Ping function
local Ping = statPing.GetValue

-- Client replication choking/sleeping
local function Sleep()
    Property(Root, 'NetworkIsSleeping', true)
end

-- Initialization function
local function Init()
    local rootVel = Root.Velocity
    local rootAng = Random(-180, 180)
    local rootOffset = Vector(
        Random(-velMax, velMax),
        -Random(0, velMax),
        Random(-velMax, velMax)
    )

    Root.CFrame *= Angle(0, Radian(rootAng), 0)
    Root.Velocity = rootOffset

    runRenWait(runRen) -- Sync velocity smoothly with render
    Root.CFrame *= Angle(0, Radian(-rootAng), 0)
    Root.Velocity = rootVel
end

-- Toggle control
local desyncEnabled = false
local desyncLoop

-- Function to toggle desync
local function toggleDesync(state)
    desyncEnabled = state
    if desyncEnabled then
        -- Start desync loop
        desyncLoop = Run.Heartbeat:Connect(function()
            Init()
            Wait(timeRelease)
            
            local chokeClient, chokeServer = runBeatCon(runBeat, Sleep), runRenCon(runRen, Sleep)
            Wait(Ceil(Ping(statPing)) / 1000)
            
            chokeClient:Disconnect()
            chokeServer:Disconnect()
        end)
    else
        -- Stop desync loop
        if desyncLoop then
            desyncLoop:Disconnect()
            desyncLoop = nil
        end
    end
end

-- Toggle button setup
anti:AddToggle(
    "Enable Desync",
    {
        Text = "Invisible Desync",
        Default = false,
        Tooltip = "Enable or Disable the desync feature",
        Callback = function(state)
            toggleDesync(state)  -- Enable or disable desync based on button state
        end
    }
)

setreadonly(mt, true)

while task.wait() do
    if venus.Enabled and venus.AutoPred then
        local pingValue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local ping = tonumber((pingValue:match("%d+")))

        if ping then
            if ping > 225 then
                venus.Prediction = 0.166547
            elseif ping > 215 then
                venus.Prediction = 0.15692
            elseif ping > 205 then
                venus.Prediction = 0.165732
            elseif ping > 190 then
                venus.Prediction = 0.1690
            elseif ping > 185 then
                venus.Prediction = 0.1235666
            elseif ping > 180 then
                venus.Prediction = 0.16779123
            elseif ping > 175 then
                venus.Prediction = 0.165455312399999
            elseif ping > 170 then
                venus.Prediction = 0.16
            elseif ping > 165 then
                venus.Prediction = 0.15
            elseif ping > 160 then
                venus.Prediction = 0.1223333
            elseif ping > 155 then
                venus.Prediction = 0.125333
            elseif ping > 150 then
                venus.Prediction = 0.1652131
            elseif ping > 145 then
                venus.Prediction = 0.129934
            elseif ping > 140 then
                venus.Prediction = 0.1659921
            elseif ping > 135 then
                venus.Prediction = 0.1659921
            elseif ping > 130 then
                venus.Prediction = 0.12399
            elseif ping > 125 then
                venus.Prediction = 0.15465
            elseif ping > 110 then
                venus.Prediction = 0.142199
            elseif ping > 105 then
                venus.Prediction = 0.141199
            elseif ping > 100 then
                venus.Prediction = 0.134143
            elseif ping > 90 then
                venus.Prediction = 0.1433333333392
            elseif ping > 80 then
                venus.Prediction = 0.143214443
            elseif ping > 70 then
                venus.Prediction = 0.14899911
            elseif ping > 60 then
                venus.Prediction = 0.148325
            elseif ping > 50 then
                venus.Prediction = 0.128643
            elseif ping > 40 then
                venus.Prediction = 0.12766
            elseif ping > 30 then
                venus.Prediction = 0.124123
            elseif ping > 20 then
                venus.Prediction = 0.12435
            elseif ping > 10 then
                venus.Prediction = 0.1234555
            elseif ping < 10 then
                venus.Prediction = 0.1332
            else
                venus.Prediction = 0.1342
            end
        end
    end
end






if desync.sky == true then
    getgenv().VenusSky = true 
    getgenv().SkyAmount = 90

    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().VenusSky then 
            local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().SkyAmount, 0) 
            game:GetService("RunService").RenderStepped:Wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel
        end
    end)
end

if desync.jump == true then
    getgenv().jumpanti = true
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().jumpanti then    
            local CurrentVelocity = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(1000, 1000, 1000)
            game:GetService("RunService").RenderStepped:Wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = CurrentVelocity
        end
    end)
end

if desync.jump == true then

-- Maximum Roblox velocity (128^2 or 16384)
local velMax = (128 ^ 2)

local timeRelease, timeChoke = 0.015, 0.105

local Property, Wait = sethiddenproperty, task.wait
local Radian, Random, Ceil = math.rad, math.random, math.ceil
local Angle = CFrame.Angles
local Vector = Vector3.new
local Service = game.GetService

local Run = Service(game, 'RunService')
local Stats = Service(game, 'Stats')
local Players = Service(game, 'Players')
local LocalPlayer = Players.LocalPlayer
local statPing = Stats.PerformanceStats.Ping
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()

local runRen, runBeat = Run.RenderStepped, Run.Heartbeat
local runRenWait, runRenCon = runRen.Wait, runRen.Connect
local runBeatCon = runBeat.Connect

local function Ping()
    return statPing:GetValue()
end

local function Sleep()
    Property(Root, 'NetworkIsSleeping', true)
end

local function FireGun()
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Shoot") then
        local ShootEvent = tool.Shoot
        ShootEvent:FireServer(Mouse.Hit.Position)
    end
end

local function Init()
    if not Root then return end

    local rootVel = Root.Velocity
    local rootCFrame = Root.CFrame

   
    local rootAng = Random(-180, 180)
    local rootOffset do
        local X = Random(-velMax, velMax)
        local Y = Random(0, velMax)
        local Z = Random(-velMax, velMax)
        rootOffset = Vector(X, -Y, Z)
    end

    Root.CFrame = Angle(0, Radian(rootAng), 0)
    Root.Velocity = rootOffset

   
    FireGun()


    runRenWait(runRen)
    Root.CFrame = rootCFrame
    Root.Velocity = rootVel
end

runBeatCon(runBeat, Init)

-- Main loop for choking replication
while Wait(timeRelease) do
    -- Stable replication packets
    local chokeClient, chokeServer = runBeatCon(runBeat, Sleep), runRenCon(runRen, Sleep)

    Wait(Ceil(Ping()) / 1000)

    chokeClient:Disconnect()
    chokeServer:Disconnect()

end
end

if desync.network == true then
local RunService = game:GetService("RunService")

local function onHeartbeat()
    setfflag("S2PhysicsSenderRate", 1)
end

RunService.Heartbeat:Connect(onHeartbeat)
end

if Misc.LowGfx == true then
game:GetService("CorePackages").Packages:Destroy()
end
