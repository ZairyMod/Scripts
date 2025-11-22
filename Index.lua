getgenv().hvh = {
    Main = {
        Type = "FOV",
        TargetAim = false,
        Part = "Head",
        Keybinds = "C",
        Predictions = 0;
        Resolver = false;
        RemoveFireRate = false;
        View = false;
        Aimbot = false;
        AimbotPred = 0.12;
        AimbotParts = "HumanoidRootPart";
        Smoothness = 1;
        AimbotKeybind = "C";
        LookAt = false;
        Aug = true;
    };

    Visuals = {
        Circle = false;
        CircleColor = Color3.fromRGB(255, 255, 255);
        Tracer = false;
        TracerColor = Color3.fromRGB(255, 255, 255);
    };

    HitDetections = {
        Info = false;
    };

    CustomSounds = {
        Method = "Damage"; -- Damage, Ammo
        Enabled = false;
        Type = "Neverlose";
        Volume = 100;
    };

    World = {};

    HitChams = {
        Method = "BasePart"; --// Clone
        Enabled = false;
        Rainbow = false;
        Duration = 5;
        Color = Color3.fromRGB(111, 111, 111);
    };

    Desyncs = {};

    Player = {
        Enabled = false;
        CFrameMethod = "Flight"; -- Flight, Speed
        CFrameSpeed = 1;
        Keybind = "V";
        
        ForceField = false;
        ForceFieldColor = Color3.fromRGB(255,255,255)
    };

    Esp = {
        Enabled = false;
        ShowBox = false;
        ShowName = false;
        ShowHealth = false;
        ShowArmor = false;
        ShowDistance = false;
        ShowTool = false;
        SelfEsp = false;
    };

    Checks = {
        AntiStomp = false;
        AntiStompKeybind = "Z";
        AntiStompDelay = 2

    };
};

if (not LPH_OBFUSCATED) then
    LPH_NO_VIRTUALIZE = function(...) return (...) end;
    LPH_JIT_MAX = function(...) return (...) end;
    LPH_JIT_ULTRA = function(...) return (...) end;
end

setfpscap(25000)


local HeartbeatConn

local PreSimulationConn

local PostSimulationConn

local cloneref = getgenv().cloneref or function(...) return ... end

local Game = cloneref(Game)

local Players = Game:GetService("Players");

local Camera = Game:GetService("Workspace").CurrentCamera;

local UserInputService = Game:GetService("UserInputService");

local LocalPlayer = Players.LocalPlayer;

local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();

local LocalHumanoid = LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid", 1e9);

local LocalRootPart = LocalHumanoid and LocalHumanoid.RootPart or LocalCharacter:WaitForChild("HumanoidRootPart", 1e9);

local Mouse = LocalPlayer:GetMouse();

local r_s = Game:GetService("RunService");

local Workspace = Game:GetService("Workspace")

local renderStepped = r_s.RenderStepped;

local vector3 = Vector3;

local vector2 = Vector2;

LocalPlayer.CharacterAdded:Connect(function(Character)
    LocalCharacter = Character
    LocalHumanoid = LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid", 1e9)
    LocalRootPart = LocalHumanoid and LocalHumanoid.RootPart or LocalCharacter:WaitForChild("HumanoidRootPart", 1e9)
end)

Utility = {
    Aimbot = nil;
    Target = nil;
    func = {};
    connect = {};
    draw = {};
    connections={};
    prevammo = {};
    prevhealth = {};
    MaxDistances = {};
    SpeedKeybindhandling = false;
    AntiStomp = false;
    firing = false;
};


local blunt = Drawing.new("Circle")
blunt.Radius = 500
blunt.Transparency = 1
blunt.Thickness = 0.2
blunt.Visible =true
blunt.Color = Color3.new(1.000000, 1.000000, 1.000000)
blunt.ZIndex = 999999
blunt.Filled = false

Utility.func.ForceField = function()
    if not LocalCharacter or not LocalHumanoid or not LocalRootPart then return end
    for i, v in pairs(LocalCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            if getgenv().hvh.Player.ForceField then
                v.Material = Enum.Material.ForceField
                v.Color = getgenv().hvh.Player.ForceFieldColor
            else
                v.Material = Enum.Material.SmoothPlastic
                v.Color = getgenv().hvh.Player.ForceFieldColor
            end
        end
    end
end



Utility.activation = function(tool)
    tool:Activate()
end

UserInputService.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        local tool = LocalCharacter:FindFirstChildWhichIsA("Tool") 
        if getgenv().hvh.Main.Aug and tool and not Utility.firing then
            Utility.firing = true

            while Utility.firing do
                Utility.activation(tool)
                task.wait(0)
            end
        end
    end
end)


UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Utility.firing = false
    end
end)


Utility.func.AntiStomp = function()
    if not LocalCharacter or not LocalHumanoid or not LocalRootPart then return end
    if getgenv().hvh.Checks.AntiStomp and Utility.AntiStomp then
        for _, retard in pairs(LocalCharacter:GetDescendants()) do
            if retard:IsA("BasePart") then
                task.delay(getgenv().hvh.Checks.AntiStompDelay, function()
                    retard:Destroy()
                end)
            end
        end
    end
end





Utility.func.Movement = function()
    if not LocalCharacter and not LocalHumanoid and not LocalRootPart then return end
    if getgenv().hvh.Player.Enabled and Utility.SpeedKeybindhandling then
        if getgenv().hvh.Player.CFrameMethod == "Speed" then
            LocalRootPart.CFrame = LocalRootPart.CFrame + (LocalHumanoid.MoveDirection * getgenv().hvh.Player.CFrameSpeed)
        elseif getgenv().hvh.Player.CFrameMethod == "Flight" then
            local direction = vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction + vector3.new(0, -1, 0)
            end

            LocalRootPart.CFrame = LocalRootPart.CFrame + (direction * getgenv().hvh.Player.CFrameSpeed)
            LocalRootPart.Velocity = direction * getgenv().hvh.Player.CFrameSpeed
        end
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode[getgenv().hvh.Player.Keybind] then
        Utility.SpeedKeybindhandling = not Utility.SpeedKeybindhandling
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode[getgenv().hvh.Checks.AntiStompKeybind] then
        Utility.AntiStomp = not Utility.AntiStomp
    end
end)




Utility.func.get_closest = LPH_NO_VIRTUALIZE(function()
    local Target
    local Closest = math.huge
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local PartPos, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            local MouseLocation = UserInputService:GetMouseLocation()
            local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - MouseLocation).Magnitude
            if Magnitude < Closest and Magnitude <= blunt.Radius and OnScreen then
                Target = Player
                Closest = Magnitude
            end
        end
    end
    return Target
end)

Utility.func.Future = function()
    local Target

    if getgenv().hvh.Main.Type == "FOV" then
        Target = Utility.func.get_closest()
    elseif getgenv().hvh.Main.Type == "Target" then
        Target = Utility.Target
    end

    if getgenv().hvh.Main.TargetAim and Target and Target.Character then
        local character = Target.Character
        local bodyEffects = character:FindFirstChild("BodyEffects")
        local KOd = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid then
            local Part = tostring(getgenv().hvh.Main.Part)
            local TargetPart = Target.Character:FindFirstChild(Part)
            local Prediction = tonumber(getgenv().hvh.Main.Predictions)

            if Part and TargetPart and TargetPart.Position and TargetPart.Velocity and Prediction then
                return TargetPart.Position + TargetPart.Velocity * Prediction
            end
        end
    end
end




do
    Utility.func.ViewTarget = function()
        if getgenv().hvh.Main.View and Utility.Target and Utility.Target.Character then
            Camera.CameraSubject = Utility.Target.Character.Humanoid
        else
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end

    Utility.func.lookat = function()
        local Target

        if getgenv().hvh.Main.Type == "FOV" then
            Target = Utility.func.get_closest()
        elseif getgenv().hvh.Main.Type == "Target" then
            Target = Utility.Target
        end

        if Target and Target.Character then
            if getgenv().hvh.Main.LookAt then
                LocalRootPart.CFrame = CFrame.new(
                    LocalRootPart.CFrame.Position,
                    Vector3.new(
                        Target.Character.HumanoidRootPart.Position.X,
                        LocalRootPart.CFrame.Position.Y,
                        Target.Character.HumanoidRootPart.Position.Z
                    )
                )
                LocalHumanoid.AutoRotate = false
            else
                LocalRootPart.CFrame = LocalRootPart.CFrame
                LocalHumanoid.AutoRotate = true
            end
        end
    end
end





UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return; end;
   local keybind = getgenv().hvh.Main.AimbotKeybind
   if getgenv().hvh.Main.Aimbot and Enum.KeyCode[keybind] and input.KeyCode == Enum.KeyCode[keybind] then
        if Utility.Aimbot then
            Utility.Aimbot = nil;
        else
            local Target = Utility.func.get_closest();
            if Target then
                Utility.Aimbot = Target;
            end;
        end;
    end;
end);


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return; end;
    local keybind = getgenv().hvh.Main.Keybinds
    if Enum.KeyCode[keybind] and input.KeyCode == Enum.KeyCode[keybind] then
        if Utility.Target then
            Utility.Target = nil;
        else
            local Target = Utility.func.get_closest();
            if Target then
                Utility.Target = Target;
            end;
        end;
    end;
end);


Utility.draw.c = Drawing.new("Circle");
Utility.draw.c.Thickness = 2;
Utility.draw.c.NumSides = 100000;
Utility.draw.c.Radius = 50;
Utility.draw.c.Filled = false;
Utility.draw.c.Color = Color3.fromRGB(1,1,1);
Utility.draw.c.Visible = false;

Utility.draw.t = Drawing.new("Line");
Utility.draw.t.Thickness = 2;
Utility.draw.t.Color = Color3.fromRGB(1,1,1);
Utility.draw.t.Visible = false;
Utility.draw.t.Transparency = 1



Utility.func.AimBotFormula = function()
    if Utility.Aimbot and Utility.Aimbot.Character then
        local a = getgenv().hvh.Main.AimbotParts
        local mainparts = Utility.Aimbot.Character:FindFirstChild(a)

        if getgenv().hvh.Main.Aimbot and mainparts then
            local endpoint = mainparts.Position + mainparts.Velocity * getgenv().hvh.Main.AimbotPred

            local stuff = CFrame.new(Camera.CFrame.Position, endpoint)
            Camera.CFrame = Camera.CFrame:Lerp(stuff, getgenv().hvh.Main.Smoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut) 
        end
    end
end

Utility.func.lerp = function(v1, v2, alpha)
    return v1 + (v2 - v1) * alpha;
end;


if game.PlaceId == 9825515356 then
    r_s.PostSimulation:Connect(function()
        local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
        local framework = playerGui:WaitForChild("Framework", math.huge)
        
        if framework then
            local env = getsenv(framework)
            if env and env._G then
                local BIGNIGGER = Utility.func.Future()
                if BIGNIGGER then
                    env._G.MOUSE_POSITION = BIGNIGGER
                end
            end
        end
    end)
end


if game.PlaceId ~= 9825515356 and not string.find(identifyexecutor(), "Solara") and not string.find(identifyexecutor(), "Wave") and not string.find(identifyexecutor(), "Xeno") and not string.find(identifyexecutor(), "Synapse Z") then
    local grm = getrawmetatable(game)
    local MousePosChanger2 = nil
    setreadonly(grm, false)
    MousePosChanger2 = grm.__index
    grm.__index = function(self, Index)
        if not checkcaller() and self == Mouse then
            if Index == "Hit" then
                local EndPoint = Utility.func.Future()
                if EndPoint then
                    return CFrame.new(EndPoint)
                end
            elseif Index == "Target" and game.PlaceId == 2788229376 then
                local EndPoint = Utility.func.Future()
                if EndPoint then
                    return CFrame.new(EndPoint)
                end
            end
        end
        return MousePosChanger2(self, Index)
    end
end




local hitsounds = {
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bubble"] = "rbxassetid://9102092728",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Cod"] = "rbxassetid://160432334",
    ["Bameware"] = "rbxassetid://6565367558",
    ["Neverlose"] = "rbxassetid://6565370984",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"] = "rbxassetid://6565371338",
    ["UWU"] = "rbxassetid://8323804973",
    ["Bat"] = "rbxassetid://4529474217",
    ["Lazer"] = "rbxassetid://1624609598"
}

Utility.func.Sounds = function()
    local soundId = hitsounds[getgenv().hvh.CustomSounds.Type]
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = getgenv().hvh.CustomSounds.Volume
        sound.Parent = Workspace
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

Utility.func.TrackPlayersAmmo = function()
    local Player = game.Players.LocalPlayer
    
    local Guns = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
    if Guns and Guns:FindFirstChild("Ammo") then
        Utility.prevammo[Guns.Name] = Utility.prevammo[Guns.Name] or Guns.Ammo.Value

        local newammo = Guns.Ammo.Value
        local prevammo = Utility.prevammo[Guns.Name]

        if newammo < prevammo then
            if getgenv().hvh.CustomSounds.Enabled and getgenv().hvh.CustomSounds.Method == "Ammo" then
                Utility.func.Sounds()
            end

            Utility.prevammo[Guns.Name] = newammo
        end
    end
end


function Utility:GAYFLAG()
local tick = tick()
return Color3.fromHSV((tick % 1), 1, 1)
end

function Utility:Hitchams(Player)
    for _, Index in pairs(Player.Character:GetChildren()) do
        if Index.Name ~= "HumanoidRootPart" and Index:IsA("BasePart") then
            local Part = Instance.new("Part")
            Part.Name = Index.Name .. "Grah"
            Part.Parent = Workspace
            Part.Material = Enum.Material.Neon
            Part.Transparency = 0
            Part.Anchored = true
            Part.Size = Index.Size
            Part.CFrame = Index.CFrame
            Part.CanCollide = false
            
            if getgenv().hvh.HitChams.Enabled then
                if getgenv().hvh.HitChams.Rainbow then
                    Part.Color = Utility:GAYFLAG()
                else
                    Part.Color = getgenv().hvh.HitChams.Color
                end
            end
            
            task.delay(getgenv().hvh.HitChams.Duration, function()
                Part:Destroy()
            end)
        end
    end
end

function Utility:Clone(player)
    player.Character.Archivable = true
    local latest_character = player.Character:Clone()
    latest_character.Parent = Workspace
    player.Character.Archivable = false

    for _, Parts in pairs(latest_character:GetChildren()) do
        if Parts:IsA("MeshPart") then
            Parts.Anchored = true
            Parts.CanCollide = false
            Parts.Transparency = 0
            Parts.Material = Enum.Material.Neon

            if getgenv().hvh.HitChams.Rainbow then
                Parts.Color = Utility:GAYFLAG()
            else
                Parts.Color = getgenv().hvh.HitChams.Color
            end
        else
            if Parts.Name ~= "HumanoidRootPart" then
                Parts:Destroy()
            end
        end

        if Parts.Name == "Head" then
            local faces = Parts:FindFirstChild("face")
            if faces then
                faces:Destroy()
            end
        end
    end

    task.delay(getgenv().hvh.HitChams.Duration, function()
        if latest_character and latest_character.Parent then
            latest_character:Destroy()
        end
    end)
end


Utility.autostomp = function()
Game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
end

local HitText = Drawing.new("Text")
HitText.Visible = false
HitText.Center = true
HitText.Outline = true
HitText.Size = 20
HitText.Color = Color3.new(1, 1, 1)
HitText.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 230)
HitText.Font = 1

Utility.func.TrackPlayerHealth = LPH_NO_VIRTUALIZE(function()
    local Target = nil

    if getgenv().hvh.Main.Type == "FOV" then
        Target = Utility.func.get_closest()
    elseif getgenv().hvh.Main.Type == "Target" then
        Target = Utility.Target
    end

    if Target and Target.Character then
        local humanoid = Target.Character:FindFirstChild("Humanoid")
        local distance = (Target.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

        if humanoid and distance <= 150 then
            local currentHealth = humanoid.Health

            if not Utility.prevhealth[Target.Name] then
                Utility.prevhealth[Target.Name] = currentHealth
            end

            local prevHealth = Utility.prevhealth[Target.Name]

            if currentHealth < prevHealth then
                if getgenv().hvh.HitChams.Enabled then
                    if getgenv().hvh.HitChams.Method == "Clone" then
                        Utility:Clone(Target)
                    elseif getgenv().hvh.HitChams.Method == "BasePart" then
                        Utility:Hitchams(Target)
                    end
                end

                if getgenv().hvh.CustomSounds.Enabled and getgenv().hvh.CustomSounds.Method == "Damage" then
                    Utility.func.Sounds()
                end

                if getgenv().hvh.HitDetections.Info then
                    local dmg = prevHealth - currentHealth
                    HitText.Text = "[Index] (Hit Detected) > " .. tostring(dmg)
                    HitText.Transparency = 1
                    HitText.Visible = true

                    task.spawn(function()
                        wait(0.5)
                        for i = 1, 10 do
                            HitText.Transparency = Hitlocal LocalRootPart = LocalHumanoid and LocalHumanoid.RootPart or LocalCharacter:WaitForChild("HumanoidRootPart", 1e9);

local Mouse = LocalPlayer:GetMouse();

local r_s = Game:GetService("RunService");

local Workspace = Game:GetService("Workspace")

local renderStepped = r_s.RenderStepped;

local vector3 = Vector3;

local vector2 = Vector2;

LocalPlayer.CharacterAdded:Connect(function(Character)
    LocalCharacter = Character
    LocalHumanoid = LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid", 1e9)
    LocalRootPart = LocalHumanoid and LocalHumanoid.RootPart or LocalCharacter:WaitForChild("HumanoidRootPart", 1e9)
end)

Utility = {
    Aimbot = nil;
    Target = nil;
    func = {};
    connect = {};
    draw = {};
    connections={};
    prevammo = {};
    prevhealth = {};
    MaxDistances = {};
    SpeedKeybindhandling = false;
    AntiStomp = false;
    firing = false;
};


local blunt = Drawing.new("Circle")
blunt.Radius = 500
blunt.Transparency = 1
blunt.Thickness = 0.2
blunt.Visible =true
blunt.Color = Color3.new(1.000000, 1.000000, 1.000000)
blunt.ZIndex = 999999
blunt.Filled = false

Utility.func.ForceField = function()
    if not LocalCharacter or not LocalHumanoid or not LocalRootPart then return end
    for i, v in pairs(LocalCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            if getgenv().hvh.Player.ForceField then
                v.Material = Enum.Material.ForceField
                v.Color = getgenv().hvh.Player.ForceFieldColor
            else
                v.Material = Enum.Material.SmoothPlastic
                v.Color = getgenv().hvh.Player.ForceFieldColor
            end
        end
    end
end



Utility.activation = function(tool)
    tool:Activate()
end

UserInputService.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        local tool = LocalCharacter:FindFirstChildWhichIsA("Tool") 
        if getgenv().hvh.Main.Aug and tool and not Utility.firing then
            Utility.firing = true

            while Utility.firing do
                Utility.activation(tool)
                task.wait(0)
            end
        end
    end
end)


UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Utility.firing = false
    end
end)


Utility.func.AntiStomp = function()
    if not LocalCharacter or not LocalHumanoid or not LocalRootPart then return end
    if getgenv().hvh.Checks.AntiStomp and Utility.AntiStomp then
        for _, retard in pairs(LocalCharacter:GetDescendants()) do
            if retard:IsA("BasePart") then
                task.delay(getgenv().hvh.Checks.AntiStompDelay, function()
                    retard:Destroy()
                end)
            end
        end
    end
end





Utility.func.Movement = function()
    if not LocalCharacter and not LocalHumanoid and not LocalRootPart then return end
    if getgenv().hvh.Player.Enabled and Utility.SpeedKeybindhandling then
        if getgenv().hvh.Player.CFrameMethod == "Speed" then
            LocalRootPart.CFrame = LocalRootPart.CFrame + (LocalHumanoid.MoveDirection * getgenv().hvh.Player.CFrameSpeed)
        elseif getgenv().hvh.Player.CFrameMethod == "Flight" then
            local direction = vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction + vector3.new(0, -1, 0)
            end

            LocalRootPart.CFrame = LocalRootPart.CFrame + (direction * getgenv().hvh.Player.CFrameSpeed)
            LocalRootPart.Velocity = direction * getgenv().hvh.Player.CFrameSpeed
        end
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode[getgenv().hvh.Player.Keybind] then
        Utility.SpeedKeybindhandling = not Utility.SpeedKeybindhandling
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode[getgenv().hvh.Checks.AntiStompKeybind] then
        Utility.AntiStomp = not Utility.AntiStomp
    end
end)




Utility.func.get_closest = LPH_NO_VIRTUALIZE(function()
    local Target
    local Closest = math.huge
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local PartPos, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            local MouseLocation = UserInputService:GetMouseLocation()
            local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - MouseLocation).Magnitude
            if Magnitude < Closest and Magnitude <= blunt.Radius and OnScreen then
                Target = Player
                Closest = Magnitude
            end
        end
    end
    return Target
end)

Utility.func.Future = function()
    local Target

    if getgenv().hvh.Main.Type == "FOV" then
        Target = Utility.func.get_closest()
    elseif getgenv().hvh.Main.Type == "Target" then
        Target = Utility.Target
    end

    if getgenv().hvh.Main.TargetAim and Target and Target.Character then
        local character = Target.Character
        local bodyEffects = character:FindFirstChild("BodyEffects")
        local KOd = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid then
            local Part = tostring(getgenv().hvh.Main.Part)
            local TargetPart = Target.Character:FindFirstChild(Part)
            local Prediction = tonumber(getgenv().hvh.Main.Predictions)

            if Part and TargetPart and TargetPart.Position and TargetPart.Velocity and Prediction then
                return TargetPart.Position + TargetPart.Velocity * Prediction
            end
        end
    end
end




do
    Utility.func.ViewTarget = function()
        if getgenv().hvh.Main.View and Utility.Target and Utility.Target.Character then
            Camera.CameraSubject = Utility.Target.Character.Humanoid
        else
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end

    Utility.func.lookat = function()
        local Target

        if getgenv().hvh.Main.Type == "FOV" then
            Target = Utility.func.get_closest()
        elseif getgenv().hvh.Main.Type == "Target" then
            Target = Utility.Target
        end

        if Target and Target.Character then
            if getgenv().hvh.Main.LookAt then
                LocalRootPart.CFrame = CFrame.new(
                    LocalRootPart.CFrame.Position,
                    Vector3.new(
                        Target.Character.HumanoidRootPart.Position.X,
                        LocalRootPart.CFrame.Position.Y,
                        Target.Character.HumanoidRootPart.Position.Z
                    )
                )
                LocalHumanoid.AutoRotate = false
            else
                LocalRootPart.CFrame = LocalRootPart.CFrame
                LocalHumanoid.AutoRotate = true
            end
        end
    end
end





UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return; end;
   local keybind = getgenv().hvh.Main.AimbotKeybind
   if getgenv().hvh.Main.Aimbot and Enum.KeyCode[keybind] and input.KeyCode == Enum.KeyCode[keybind] then
        if Utility.Aimbot then
            Utility.Aimbot = nil;
        else
            local Target = Utility.func.get_closest();
            if Target then
                Utility.Aimbot = Target;
            end;
        end;
    end;
end);


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return; end;
    local keybind = getgenv().hvh.Main.Keybinds
    if Enum.KeyCode[keybind] and input.KeyCode == Enum.KeyCode[keybind] then
        if Utility.Target then
            Utility.Target = nil;
        else
            local Target = Utility.func.get_closest();
            if Target then
                Utility.Target = Target;
            end;
        end;
    end;
end);


Utility.draw.c = Drawing.new("Circle");
Utility.draw.c.Thickness = 2;
Utility.draw.c.NumSides = 100000;
Utility.draw.c.Radius = 50;
Utility.draw.c.Filled = false;
Utility.draw.c.Color = Color3.fromRGB(1,1,1);
Utility.draw.c.Visible = false;

Utility.draw.t = Drawing.new("Line");
Utility.draw.t.Thickness = 2;
Utility.draw.t.Color = Color3.fromRGB(1,1,1);
Utility.draw.t.Visible = false;
Utility.draw.t.Transparency = 1



Utility.func.AimBotFormula = function()
    if Utility.Aimbot and Utility.Aimbot.Character then
        local a = getgenv().hvh.Main.AimbotParts
        local mainparts = Utility.Aimbot.Character:FindFirstChild(a)

        if getgenv().hvh.Main.Aimbot and mainparts then
            local endpoint = mainparts.Position + mainparts.Velocity * getgenv().hvh.Main.AimbotPred

            local stuff = CFrame.new(Camera.CFrame.Position, endpoint)
            Camera.CFrame = Camera.CFrame:Lerp(stuff, getgenv().hvh.Main.Smoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut) 
        end
    end
end

Utility.func.lerp = function(v1, v2, alpha)
    return v1 + (v2 - v1) * alpha;
end;


if game.PlaceId == 9825515356 then
    r_s.PostSimulation:Connect(function()
        local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
        local framework = playerGui:WaitForChild("Framework", math.huge)
        
        if framework then
            local env = getsenv(framework)
            if env and env._G then
                local BIGNIGGER = Utility.func.Future()
                if BIGNIGGER then
                    env._G.MOUSE_POSITION = BIGNIGGER
                end
            end
        end
    end)
end


if game.PlaceId ~= 9825515356 and not string.find(identifyexecutor(), "Solara") and not string.find(identifyexecutor(), "Wave") and not string.find(identifyexecutor(), "Xeno") and not string.find(identifyexecutor(), "Synapse Z") then
    local grm = getrawmetatable(game)
    local MousePosChanger2 = nil
    setreadonly(grm, false)
    MousePosChanger2 = grm.__index
    grm.__index = function(self, Index)
        if not checkcaller() and self == Mouse then
            if Index == "Hit" then
                local EndPoint = Utility.func.Future()
                if EndPoint then
                    return CFrame.new(EndPoint)
                end
            elseif Index == "Target" and game.PlaceId == 2788229376 then
                local EndPoint = Utility.func.Future()
                if EndPoint then
                    return CFrame.new(EndPoint)
                end
            end
        end
        return MousePosChanger2(self, Index)
    end
end




local hitsounds = {
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bubble"] = "rbxassetid://9102092728",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Cod"] = "rbxassetid://160432334",
    ["Bameware"] = "rbxassetid://6565367558",
    ["Neverlose"] = "rbxassetid://6565370984",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"] = "rbxassetid://6565371338",
    ["UWU"] = "rbxassetid://8323804973",
    ["Bat"] = "rbxassetid://4529474217",
    ["Lazer"] = "rbxassetid://1624609598"
}

Utility.func.Sounds = function()
    local soundId = hitsounds[getgenv().hvh.CustomSounds.Type]
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = getgenv().hvh.CustomSounds.Volume
        sound.Parent = Workspace
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

Utility.func.TrackPlayersAmmo = function()
    local Player = game.Players.LocalPlayer
    
    local Guns = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
    if Guns and Guns:FindFirstChild("Ammo") then
        Utility.prevammo[Guns.Name] = Utility.prevammo[Guns.Name] or Guns.Ammo.Value

        local newammo = Guns.Ammo.Value
        local prevammo = Utility.prevammo[Guns.Name]

        if newammo < prevammo then
            if getgenv().hvh.CustomSounds.Enabled and getgenv().hvh.CustomSounds.Method == "Ammo" then
                Utility.func.Sounds()
            end

            Utility.prevammo[Guns.Name] = newammo
        end
    end
end


function Utility:GAYFLAG()
local tick = tick()
return Color3.fromHSV((tick % 1), 1, 1)
end

function Utility:Hitchams(Player)
    for _, Index in pairs(Player.Character:GetChildren()) do
        if Index.Name ~= "HumanoidRootPart" and Index:IsA("BasePart") then
            local Part = Instance.new("Part")
            Part.Name = Index.Name .. "Grah"
            Part.Parent = Workspace
            Part.Material = Enum.Material.Neon
            Part.Transparency = 0
            Part.Anchored = true
            Part.Size = Index.Size
            Part.CFrame = Index.CFrame
            Part.CanCollide = false
            
            if getgenv().hvh.HitChams.Enabled then
                if getgenv().hvh.HitChams.Rainbow then
                    Part.Color = Utility:GAYFLAG()
                else
                    Part.Color = getgenv().hvh.HitChams.Color
                end
            end
            
            task.delay(getgenv().hvh.HitChams.Duration, function()
                Part:Destroy()
            end)
        end
    end
end

function Utility:Clone(player)
    player.Character.Archivable = true
    local latest_character = player.Character:Clone()
    latest_character.Parent = Workspace
    player.Character.Archivable = false

    for _, Parts in pairs(latest_character:GetChildren()) do
        if Parts:IsA("MeshPart") then
            Parts.Anchored = true
            Parts.CanCollide = false
            Parts.Transparency = 0
            Parts.Material = Enum.Material.Neon

            if getgenv().hvh.HitChams.Rainbow then
                Parts.Color = Utility:GAYFLAG()
            else
                Parts.Color = getgenv().hvh.HitChams.Color
            end
        else
            if Parts.Name ~= "HumanoidRootPart" then
                Parts:Destroy()
            end
        end

        if Parts.Name == "Head" then
            local faces = Parts:FindFirstChild("face")
            if faces then
                faces:Destroy()
            end
        end
    end

    task.delay(getgenv().hvh.HitChams.Duration, function()
        if latest_character and latest_character.Parent then
            latest_character:Destroy()
        end
    end)
end


Utility.autostomp = function()
Game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
end

local HitText = Drawing.new("Text")
HitText.Visible = false
HitText.Center = true
HitText.Outline = true
HitText.Size = 20
HitText.Color = Color3.new(1, 1, 1)
HitText.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 230)
HitText.Font = 1

Utility.func.TrackPlayerHealth = LPH_NO_VIRTUALIZE(function()
    local Target = nil

    if getgenv().hvh.Main.Type == "FOV" then
        Target = Utility.func.get_closest()
    elseif getgenv().hvh.Main.Type == "Target" then
        Target = Utility.Target
    end

    if Target and Target.Character then
        local humanoid = Target.Character:FindFirstChild("Humanoid")
        local distance = (Target.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

        if humanoid and distance <= 150 then
            local currentHealth = humanoid.Health

            if not Utility.prevhealth[Target.Name] then
                Utility.prevhealth[Target.Name] = currentHealth
            end

            local prevHealth = Utility.prevhealth[Target.Name]

            if currentHealth < prevHealth then
                if getgenv().hvh.HitChams.Enabled then
                    if getgenv().hvh.HitChams.Method == "Clone" then
                        Utility:Clone(Target)
                    elseif getgenv().hvh.HitChams.Method == "BasePart" then
                        Utility:Hitchams(Target)
                    end
                end

                if getgenv().hvh.CustomSounds.Enabled and getgenv().hvh.CustomSounds.Method == "Damage" then
                    Utility.func.Sounds()
                end

                if getgenv().hvh.HitDetections.Info then
                    local dmg = prevHealth - currentHealth
                    HitText.Text = "[Index] (Hit Detected) > " .. tostring(dmg)
                    HitText.Transparency = 1
                    HitText.Visible = true

                    task.spawn(function()
                        wait(0.5)
                        for i = 1, 10 do
                            HitText.Transparency = Hit
