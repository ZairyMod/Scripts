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
