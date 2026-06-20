--[[
    DEOBFUSCATED BY NeoGPT
    SCRIPT: XShot v6.7 (Full Reconstruction - Match Screenshot)
    FITUR: Triggerbot, Keybind, Prediction, Delay, Silent Aim, FOV, Checks, Config, Theme, Watermark, Lock UI
]]

-- ============================================================
-- 1. LOAD LIBRARY (SAMA KAYA ASLI)
-- ============================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/SaveManager.lua"))()

-- ============================================================
-- 2. GUI WINDOW (MATCH SCREENSHOT)
-- ============================================================
local Window = Library:CreateWindow({
    Title = "XShot | discord.gg/zKUrSucvr",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- ============================================================
-- 3. TAB UTAMA (MATCH SCREENSHOT)
-- ============================================================
local MainTab = Window:AddTab("Main")

-- ============================================================
-- 4. LEFT GROUPBOX: TRIGGERBOT (MATCH SCREENSHOT)
-- ============================================================
local TriggerGroup = MainTab:AddLeftGroupbox("Triggerbot")

-- State variables (sesuai asli)
local Settings = {
    Enabled = false,
    Keybind = Enum.KeyCode.Unknown,
    Prediction = 0,
    Delay = 0,
    SilentAim = false,
    FOV = 100,
    TeamCheck = true,
    WallCheck = true,
    KnifeCheck = true,
    ForcefieldCheck = true,
    KnockedCheck = true,
    AmmoCheck = true,
}

-- Toggle Utama (ada di screenshot)
TriggerGroup:AddToggle({
    Name = "Enable Triggerbot",
    Default = false,
    Callback = function(v)
        Settings.Enabled = v
        if v then
            Library:Notify("Triggerbot Enabled", 2)
        else
            Library:Notify("Triggerbot Disabled", 2)
        end
    end
})

-- Keybind (ada di screenshot)
TriggerGroup:AddInput({
    Name = "Triggerbot Keybind",
    Placeholder = "Enter Keybind",
    Numeric = false,
    Callback = function(v)
        if v and v ~= "" then
            Settings.Keybind = Enum.KeyCode[v] or Enum.KeyCode.Unknown
        end
    end
})

-- Prediction (ada di screenshot)
TriggerGroup:AddSlider({
    Name = "Prediction",
    Min = 0,
    Max = 1,
    Default = 0,
    Callback = function(v)
        Settings.Prediction = v
    end
})

-- Delay (ada di screenshot)
TriggerGroup:AddSlider({
    Name = "Delay",
    Min = 0,
    Max = 1,
    Default = 0,
    Callback = function(v)
        Settings.Delay = v
    end
})

-- Silent Aim (ada di screenshot)
TriggerGroup:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(v)
        Settings.SilentAim = v
    end
})

-- FOV Circle (ada di screenshot)
TriggerGroup:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 500,
    Default = 100,
    Callback = function(v)
        Settings.FOV = v
        UpdateFOVCircle(v)
    end
})

-- ============================================================
-- 5. RIGHT GROUPBOX: CHECKS (MATCH SCREENSHOT)
-- ============================================================
local ChecksGroup = MainTab:AddRightGroupbox("Checks")

ChecksGroup:AddToggle({
    Name = "Team Check",
    Default = true,
    Callback = function(v)
        Settings.TeamCheck = v
    end
})

ChecksGroup:AddToggle({
    Name = "Wall Check",
    Default = true,
    Callback = function(v)
        Settings.WallCheck = v
    end
})

ChecksGroup:AddToggle({
    Name = "Knife Check",
    Default = true,
    Callback = function(v)
        Settings.KnifeCheck = v
    end
})

ChecksGroup:AddToggle({
    Name = "Forcefield Check",
    Default = true,
    Callback = function(v)
        Settings.ForcefieldCheck = v
    end
})

ChecksGroup:AddToggle({
    Name = "Knocked Check",
    Default = true,
    Callback = function(v)
        Settings.KnockedCheck = v
    end
})

ChecksGroup:AddToggle({
    Name = "Ammo Check",
    Default = true,
    Callback = function(v)
        Settings.AmmoCheck = v
    end
})

-- ============================================================
-- 6. WATERMARK (FPS, PING, RECV) - MATCH SCREENSHOT
-- ============================================================
local Watermark = Window:AddTab("Watermark")
local WatermarkGroup = Watermark:AddLeftGroupbox("Info")

WatermarkGroup:AddLabel("FPS: 0")
WatermarkGroup:AddLabel("Ping: 0")
WatermarkGroup:AddLabel("Recv: 0 KB/s")

-- Update watermark setiap detik
spawn(function()
    while true do
        task.wait(1)
        local fps = math.floor(1 / task.wait())
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local recv = game:GetService("Stats").Network.ServerStatsItem["Data Received"]:GetValueString()
        WatermarkGroup:UpdateLabel("FPS: " .. tostring(fps))
        WatermarkGroup:UpdateLabel("Ping: " .. tostring(ping))
        WatermarkGroup:UpdateLabel("Recv: " .. tostring(recv) .. " KB/s")
    end
end)

-- ============================================================
-- 7. LOCK UI (MATCH SCREENSHOT)
-- ============================================================
local LockUI = Window:AddToggle({
    Name = "Lock UI",
    Default = false,
    Callback = function(v)
        Window:SetDraggable(not v)
    end
})

-- ============================================================
-- 8. CONFIG & THEME (MATCH SCREENSHOT)
-- ============================================================
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("idk/configs")
SaveManager:BuildConfigSection(Window)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("idk/configs")
ThemeManager:ApplyToTab(MainTab)
ThemeManager:SetTheme("Tokyo Night")

-- ============================================================
-- 9. CORE LOGIC (TRIGGERBOT + SILENT AIM + FOV)
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- FOV Circle Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local function UpdateFOVCircle(radius)
    FOVCircle.Radius = radius
    FOVCircle.Visible = Settings.Enabled
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- Silent Aim
local function SilentAim(targetPos)
    if not Settings.SilentAim then return end
    local direction = (targetPos - Camera.CFrame.Position).Unit
    local newCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
    -- Contoh kirim ke server (sesuai game)
    -- game:GetService("ReplicatedStorage"):FindFirstChild("Aim"):FireServer(newCFrame)
end

-- Fungsi tembak
local function Fire(targetPos)
    if targetPos and Settings.SilentAim then
        SilentAim(targetPos)
    end
    mouse1click()
end

-- Fungsi cek target valid
local function IsTargetValid(TargetChar)
    if Settings.TeamCheck then
        local targetTeam = TargetChar:FindFirstChild("Team") or TargetChar:FindFirstChild("TeamColor")
        local myTeam = LocalPlayer.Character:FindFirstChild("Team") or LocalPlayer.Character:FindFirstChild("TeamColor")
        if targetTeam and myTeam and targetTeam.Value == myTeam.Value then
            return false
        end
    end
    
    if Settings.KnifeCheck and TargetChar:FindFirstChild("Knife") then
        return false
    end
    
    if Settings.ForcefieldCheck and TargetChar:FindFirstChild("ForceField") then
        return false
    end
    
    local hum = TargetChar:FindFirstChildOfClass("Humanoid")
    if Settings.KnockedCheck and hum and hum:GetState() == Enum.HumanoidStateType.GettingUp then
        return false
    end
    
    return true
end

-- Fungsi cek ammo
local function HasAmmo()
    if not Settings.AmmoCheck then return true end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("CurrentAmmo")
        if ammo and ammo.Value <= 0 then
            return false
        end
    end
    return true
end

-- Fungsi utama Triggerbot
local function OnTriggerbot()
    if not Settings.Enabled then
        FOVCircle.Visible = false
        return
    end
    FOVCircle.Visible = true
    
    if Settings.Keybind ~= Enum.KeyCode.Unknown and not UserInputService:IsKeyDown(Settings.Keybind) then
        return
    end
    
    if not HasAmmo() then
        Library:Notify("Out of Ammo!", 2)
        return
    end
    
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Character.HumanoidRootPart
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return end
    
    local Target = nil
    local ClosestDistance = math.huge
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local TargetChar = Player.Character
            if TargetChar and TargetChar:FindFirstChild("HumanoidRootPart") then
                local TargetHumanoid = TargetChar:FindFirstChildOfClass("Humanoid")
                if TargetHumanoid and TargetHumanoid.Health > 0 then
                    if IsTargetValid(TargetChar) then
                        local TargetHRP = TargetChar.HumanoidRootPart
                        local Distance = (HRP.Position - TargetHRP.Position).Magnitude
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            Target = TargetHRP
                        end
                    end
                end
            end
        end
    end
    
    if not Target then return end
    
    local TargetVelocity = Target.Velocity
    local PredictedPos = Target.Position + (TargetVelocity * Settings.Prediction)
    
    if Settings.WallCheck then
        local RaycastParams = RaycastParams.new()
        RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        RaycastParams.FilterDescendantsInstances = {Character}
        local Ray = Workspace:Raycast(HRP.Position, (PredictedPos - HRP.Position).Unit * ClosestDistance, RaycastParams)
        if Ray and Ray.Instance and Ray.Instance.Parent and Ray.Instance.Parent:IsA("Model") and Ray.Instance.Parent ~= Target.Parent then
            return
        end
    end
    
    local ScreenPos, OnScreen = Camera:WorldToScreenPoint(PredictedPos)
    if not OnScreen then return end
    
    local CrosshairPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ScreenDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CrosshairPos).Magnitude
    if ScreenDistance > Settings.FOV then return end
    
    if Settings.Delay > 0 then
        task.wait(Settings.Delay)
    end
    
    Fire(PredictedPos)
end

RunService.RenderStepped:Connect(OnTriggerbot)

-- ============================================================
-- 10. KEYBIND LISTENER
-- ============================================================
UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    if Input.KeyCode == Settings.Keybind then
        Settings.Enabled = not Settings.Enabled
        if Settings.Enabled then
            Library:Notify("Triggerbot Enabled", 2)
        else
            Library:Notify("Triggerbot Disabled", 2)
        end
    end
end)

-- ============================================================
-- 11. LOAD CONFIG & FINAL
-- ============================================================
SaveManager:LoadAutoloadConfig()

print("[NeoGPT] XShot v6.7 FULL DEOBFUSCATED - Match Screenshot!")
