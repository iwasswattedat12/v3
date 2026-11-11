local PainUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/iwasswattedat12/v3/main/v3.lua"))()

local Window = PainUI:CreateWindow({
    Title = "pain v3",
    Size = UDim2.new(0, 780, 0, 520),
})
Window:SetToggleKey(Enum.KeyCode.RightControl)

local CombatTab = Window:CreateTab("combat", "aimbot")
local VisualsTab = Window:CreateTab("visuals", "visuals")
local MovementTab = Window:CreateTab("movement", "movement")
local SettingsTab = Window:CreateTab("settings", "settings")

local AimbotPage = CombatTab:CreatePage("aimbot", "aimbot")
local SilentPage = CombatTab:CreatePage("silent aim", "target")
local TriggerPage = CombatTab:CreatePage("trigger bot", "zap")

local AimbotSec = AimbotPage:CreateSection("aimbot", "left", "aimbot")
AimbotSec:CreateToggle("Aimbot", false, function(v) end, Enum.KeyCode.X)
AimbotSec:CreateDropdown("Method", {"Mouse", "Camera", "Silent"}, "Mouse", function(v) end)
AimbotSec:CreateToggle("Instant Aim", false, function(v) end)
AimbotSec:CreateToggle("Center Head", false, function(v) end)
AimbotSec:CreateDropdown("Target Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", function(v) end)
AimbotSec:CreateDropdown("Priority", {"Crosshair", "Distance", "Health"}, "Crosshair", function(v) end)
AimbotSec:CreateToggle("Closest Point", false, function(v) end)

local FOVSec = AimbotPage:CreateSection("fov", "right", "target")
FOVSec:CreateToggle("FOV Circle", true, function(v) end, true)
FOVSec:CreateSlider("FOV Size", 10, 360, 180, "px", function(v) end)
FOVSec:CreateToggle("Ignore FOV Lock", false, function(v) end)
FOVSec:CreateToggle("Target Indicator", true, function(v) end, true)
FOVSec:CreateToggle("Aim Line", false, function(v) end)
FOVSec:CreateToggle("Target Info", false, function(v) end)

local TargetSec = AimbotPage:CreateSection("target", "left", "players")
TargetSec:CreateToggle("Sticky Aim", true, function(v) end)
TargetSec:CreateToggle("Team Check", true, function(v) end)

local PredSec = AimbotPage:CreateSection("prediction", "right", "wave")
PredSec:CreateToggle("Prediction", true, function(v) end)
PredSec:CreateSlider("Prediction X", 0, 50, 12, "", function(v) end)

local SilentSec = SilentPage:CreateSection("silent aim", "left", "target")
SilentSec:CreateToggle("Enable Silent Aim", false, function(v) end, Enum.KeyCode.E)
SilentSec:CreateSlider("Hit Chance", 1, 100, 100, "%", function(v) end)
SilentSec:CreateDropdown("Target Bone", {"Head", "Torso", "Random"}, "Head", function(v) end)
SilentSec:CreateKeybind("Silent Aim Key", Enum.KeyCode.E, function(k) end)

local SilentChecks = SilentPage:CreateSection("checks", "right", "players")
SilentChecks:CreateToggle("Wall Check", true, function(v) end)
SilentChecks:CreateToggle("Visible Only", true, function(v) end)

local TriggerSec = TriggerPage:CreateSection("trigger bot", "left", "zap")
TriggerSec:CreateToggle("Enable Triggerbot", false, function(v) end, Enum.KeyCode.V)
TriggerSec:CreateSlider("Reaction Delay", 0, 500, 50, "ms", function(v) end)
TriggerSec:CreateKeybind("Trigger Key", Enum.KeyCode.V, function(k) end)

local PlayersPage = VisualsTab:CreatePage("players", "players")
local WorldPage = VisualsTab:CreatePage("world", "visuals")

local VisSec = PlayersPage:CreateSection("chams", "left", "visuals")
VisSec:CreateToggle("Player ESP", true, function(v) end, true)
VisSec:CreateColorPicker("ESP Color", Color3.fromRGB(245, 125, 30), function(v) end)
VisSec:CreateToggle("Name Tags", true, function(v) end)
VisSec:CreateSlider("Render Distance", 100, 2500, 1000, "m", function(v) end)

local WorldSec = WorldPage:CreateSection("environment", "left", "visuals")
WorldSec:CreateToggle("Fullbright", false, function(v) end, Enum.KeyCode.B)
WorldSec:CreateToggle("No Fog", true, function(v) end)

local SpeedPage = MovementTab:CreatePage("movement", "movement")
local MoveSec = SpeedPage:CreateSection("movement", "left", "movement")
MoveSec:CreateToggle("Speed Boost", false, function(v) end, Enum.KeyCode.C)
MoveSec:CreateSlider("Speed Value", 16, 200, 32, " studs", function(v) end)
MoveSec:CreateKeybind("Fly Keybind", Enum.KeyCode.F, function(k) end)

local SettingsPage = SettingsTab:CreatePage("menu", "settings")
local SetSec = SettingsPage:CreateSection("menu settings", "left", "settings")
SetSec:CreateKeybind("Menu Toggle", Enum.KeyCode.RightControl, function(k)
    Window:SetToggleKey(k)
end)
SetSec:CreateButton("Unload UI", function()
    Window:Destroy()
end)
