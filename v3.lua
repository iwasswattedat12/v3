local PainUI = {}
PainUI.__index = PainUI
PainUI.Version = "3.2.0"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
if not Player then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    Player = Players.LocalPlayer
end

local function getSafeGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and coreGui then
        local canAccess, _ = pcall(function() return coreGui.Name end)
        if canAccess then
            local test = Instance.new("Folder")
            local parentOk, _ = pcall(function() test.Parent = coreGui end)
            pcall(function() test:Destroy() end)
            if parentOk then
                return coreGui
            end
        end
    end
    return Player:WaitForChild("PlayerGui")
end

local PresetThemes = {
    Orange = {
        Background = Color3.fromRGB(18, 18, 18),
        Sidebar = Color3.fromRGB(22, 22, 22),
        SidebarActive = Color3.fromRGB(35, 35, 35),
        Card = Color3.fromRGB(28, 28, 28),
        CardHeader = Color3.fromRGB(32, 32, 32),
        CardBorder = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(230, 126, 34),
        AccentDark = Color3.fromRGB(180, 95, 20),
        AccentGlow = Color3.fromRGB(255, 160, 50),
        Text = Color3.fromRGB(225, 225, 225),
        TextDim = Color3.fromRGB(145, 145, 145),
        TextDark = Color3.fromRGB(90, 90, 90),
        ToggleOff = Color3.fromRGB(55, 55, 55),
        ToggleKnob = Color3.fromRGB(210, 210, 210),
        SliderTrack = Color3.fromRGB(50, 50, 50),
        SliderFill = Color3.fromRGB(230, 126, 34),
        DropdownBg = Color3.fromRGB(34, 34, 34),
        BottomBar = Color3.fromRGB(24, 24, 24),
        Separator = Color3.fromRGB(45, 45, 45),
        InputBg = Color3.fromRGB(38, 38, 38),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(52, 152, 219),
    },
    Purple = {
        Background = Color3.fromRGB(16, 15, 22),
        Sidebar = Color3.fromRGB(20, 19, 28),
        SidebarActive = Color3.fromRGB(32, 30, 45),
        Card = Color3.fromRGB(25, 24, 35),
        CardHeader = Color3.fromRGB(30, 28, 42),
        CardBorder = Color3.fromRGB(48, 44, 65),
        Accent = Color3.fromRGB(155, 89, 182),
        AccentDark = Color3.fromRGB(120, 60, 150),
        AccentGlow = Color3.fromRGB(185, 120, 215),
        Text = Color3.fromRGB(230, 230, 240),
        TextDim = Color3.fromRGB(150, 145, 165),
        TextDark = Color3.fromRGB(95, 90, 110),
        ToggleOff = Color3.fromRGB(50, 48, 65),
        ToggleKnob = Color3.fromRGB(220, 215, 230),
        SliderTrack = Color3.fromRGB(48, 45, 62),
        SliderFill = Color3.fromRGB(155, 89, 182),
        DropdownBg = Color3.fromRGB(30, 28, 40),
        BottomBar = Color3.fromRGB(22, 20, 30),
        Separator = Color3.fromRGB(45, 42, 60),
        InputBg = Color3.fromRGB(34, 32, 46),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(155, 89, 182),
    },
    Blue = {
        Background = Color3.fromRGB(15, 18, 24),
        Sidebar = Color3.fromRGB(18, 22, 30),
        SidebarActive = Color3.fromRGB(28, 35, 48),
        Card = Color3.fromRGB(22, 28, 38),
        CardHeader = Color3.fromRGB(26, 34, 46),
        CardBorder = Color3.fromRGB(40, 52, 70),
        Accent = Color3.fromRGB(52, 152, 219),
        AccentDark = Color3.fromRGB(35, 115, 175),
        AccentGlow = Color3.fromRGB(85, 180, 245),
        Text = Color3.fromRGB(225, 235, 245),
        TextDim = Color3.fromRGB(140, 155, 175),
        TextDark = Color3.fromRGB(85, 100, 120),
        ToggleOff = Color3.fromRGB(45, 55, 72),
        ToggleKnob = Color3.fromRGB(215, 230, 245),
        SliderTrack = Color3.fromRGB(42, 54, 70),
        SliderFill = Color3.fromRGB(52, 152, 219),
        DropdownBg = Color3.fromRGB(26, 34, 46),
        BottomBar = Color3.fromRGB(18, 22, 30),
        Separator = Color3.fromRGB(40, 52, 70),
        InputBg = Color3.fromRGB(30, 40, 54),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(52, 152, 219),
    },
    Emerald = {
        Background = Color3.fromRGB(15, 22, 18),
        Sidebar = Color3.fromRGB(18, 28, 22),
        SidebarActive = Color3.fromRGB(26, 44, 34),
        Card = Color3.fromRGB(22, 36, 28),
        CardHeader = Color3.fromRGB(26, 42, 32),
        CardBorder = Color3.fromRGB(40, 65, 50),
        Accent = Color3.fromRGB(46, 204, 113),
        AccentDark = Color3.fromRGB(32, 155, 85),
        AccentGlow = Color3.fromRGB(80, 230, 145),
        Text = Color3.fromRGB(225, 245, 230),
        TextDim = Color3.fromRGB(140, 175, 150),
        TextDark = Color3.fromRGB(85, 115, 95),
        ToggleOff = Color3.fromRGB(42, 65, 50),
        ToggleKnob = Color3.fromRGB(215, 245, 225),
        SliderTrack = Color3.fromRGB(40, 62, 48),
        SliderFill = Color3.fromRGB(46, 204, 113),
        DropdownBg = Color3.fromRGB(26, 42, 32),
        BottomBar = Color3.fromRGB(18, 28, 22),
        Separator = Color3.fromRGB(40, 65, 50),
        InputBg = Color3.fromRGB(28, 46, 36),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(52, 152, 219),
    },
    Red = {
        Background = Color3.fromRGB(20, 15, 15),
        Sidebar = Color3.fromRGB(26, 18, 18),
        SidebarActive = Color3.fromRGB(42, 28, 28),
        Card = Color3.fromRGB(32, 22, 22),
        CardHeader = Color3.fromRGB(38, 26, 26),
        CardBorder = Color3.fromRGB(60, 40, 40),
        Accent = Color3.fromRGB(231, 76, 60),
        AccentDark = Color3.fromRGB(180, 50, 40),
        AccentGlow = Color3.fromRGB(255, 110, 95),
        Text = Color3.fromRGB(245, 225, 225),
        TextDim = Color3.fromRGB(175, 140, 140),
        TextDark = Color3.fromRGB(115, 85, 85),
        ToggleOff = Color3.fromRGB(65, 45, 45),
        ToggleKnob = Color3.fromRGB(245, 215, 215),
        SliderTrack = Color3.fromRGB(60, 42, 42),
        SliderFill = Color3.fromRGB(231, 76, 60),
        DropdownBg = Color3.fromRGB(36, 25, 25),
        BottomBar = Color3.fromRGB(24, 17, 17),
        Separator = Color3.fromRGB(55, 38, 38),
        InputBg = Color3.fromRGB(42, 30, 30),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(52, 152, 219),
    },
    Dark = {
        Background = Color3.fromRGB(14, 14, 14),
        Sidebar = Color3.fromRGB(18, 18, 18),
        SidebarActive = Color3.fromRGB(28, 28, 28),
        Card = Color3.fromRGB(24, 24, 24),
        CardHeader = Color3.fromRGB(28, 28, 28),
        CardBorder = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(200, 200, 200),
        AccentDark = Color3.fromRGB(140, 140, 140),
        AccentGlow = Color3.fromRGB(240, 240, 240),
        Text = Color3.fromRGB(235, 235, 235),
        TextDim = Color3.fromRGB(145, 145, 145),
        TextDark = Color3.fromRGB(85, 85, 85),
        ToggleOff = Color3.fromRGB(48, 48, 48),
        ToggleKnob = Color3.fromRGB(220, 220, 220),
        SliderTrack = Color3.fromRGB(45, 45, 45),
        SliderFill = Color3.fromRGB(180, 180, 180),
        DropdownBg = Color3.fromRGB(30, 30, 30),
        BottomBar = Color3.fromRGB(20, 20, 20),
        Separator = Color3.fromRGB(40, 40, 40),
        InputBg = Color3.fromRGB(32, 32, 32),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(180, 180, 180),
    }
}

local AnimConfig = {
    Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
}

local function Tween(obj, info, props)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function CreateInstance(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return CreateInstance("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

local function AddPadding(parent, t, b, l, r)
    return CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 10),
        PaddingRight = UDim.new(0, r or 10),
        Parent = parent
    })
end

local function AddShadow(parent)
    return CreateInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        ZIndex = -1,
        Parent = parent
    })
end

local function Ripple(button)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = button
    })
    AddCorner(ripple, 999)

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }).Completed:Connect(function()
        ripple:Destroy()
    end)
end

local GlobalNotifContainer = nil

local function EnsureGlobalNotif(guiParent, theme)
    if GlobalNotifContainer and GlobalNotifContainer.Parent then
        return GlobalNotifContainer
    end

    local notifGui = guiParent:FindFirstChild("PainUI_Notifications")
    if not notifGui then
        notifGui = CreateInstance("ScreenGui", {
            Name = "PainUI_Notifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
            Parent = guiParent
        })
    end

    GlobalNotifContainer = CreateInstance("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 270, 1, -20),
        Position = UDim2.new(1, -280, 0, 10),
        Parent = notifGui
    })

    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = GlobalNotifContainer
    })

    return GlobalNotifContainer
end

function PainUI:Notify(configOrTitle, message, duration, notifType)
    local title = "Notification"
    local dur = 3
    local nType = "Info"

    if type(configOrTitle) == "table" then
        title = configOrTitle.Title or title
        message = configOrTitle.Message or configOrTitle.Content or ""
        dur = configOrTitle.Duration or dur
        nType = configOrTitle.Type or nType
    else
        title = configOrTitle or title
        message = message or ""
        dur = duration or dur
        nType = notifType or nType
    end

    local theme = PresetThemes.Orange
    local container = EnsureGlobalNotif(getSafeGuiParent(), theme)

    local typeColor = theme.Accent
    if nType == "Success" then typeColor = theme.Success
    elseif nType == "Warning" then typeColor = theme.Warning
    elseif nType == "Error" then typeColor = theme.Error
    elseif nType == "Info" then typeColor = theme.Info
    end

    local Notif = CreateInstance("Frame", {
        Name = "Notif",
        BackgroundColor3 = theme.Card,
        Size = UDim2.new(1, 0, 0, 64),
        ClipsDescendants = true,
        Parent = container
    })
    AddCorner(Notif, 8)
    AddStroke(Notif, typeColor, 1, 0.4)
    AddShadow(Notif)

    CreateInstance("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = typeColor,
        Size = UDim2.new(0, 4, 1, 0),
        BorderSizePixel = 0,
        Parent = Notif
    })

    local iconText = (nType == "Success" and "✓") or (nType == "Warning" and "⚠") or (nType == "Error" and "✕") or "ℹ"
    CreateInstance("TextLabel", {
        Name = "Icon",
        Text = iconText,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = typeColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 20),
        Position = UDim2.new(0, 14, 0, 8),
        Parent = Notif
    })

    CreateInstance("TextLabel", {
        Name = "Title",
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -38, 0, 20),
        Position = UDim2.new(0, 34, 0, 8),
        Parent = Notif
    })

    CreateInstance("TextLabel", {
        Name = "Message",
        Text = message,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 28),
        Position = UDim2.new(0, 14, 0, 28),
        Parent = Notif
    })

    Notif.Position = UDim2.new(1, 60, 0, 0)
    Tween(Notif, AnimConfig.Bounce, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(dur, function()
        if Notif and Notif.Parent then
            local t = Tween(Notif, AnimConfig.Medium, {
                Position = UDim2.new(1, 60, 0, 0),
                BackgroundTransparency = 1
            })
            t.Completed:Connect(function()
                Notif:Destroy()
            end)
        end
    end)
end

function PainUI:CreateWindow(options)
    local config = {}
    if type(options) == "string" then
        config.Title = options
    elseif type(options) == "table" then
        config = options
    end

    local title = config.Title or "pain v3"
    local subTitle = config.SubTitle or ""
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local windowSize = config.Size or UDim2.new(0, 780, 0, 520)
    local guiParent = config.Parent or getSafeGuiParent()

    local Theme = PresetThemes.Orange
    if type(config.Theme) == "string" and PresetThemes[config.Theme] then
        Theme = PresetThemes[config.Theme]
    elseif type(config.Theme) == "table" then
        Theme = config.Theme
    end

    if type(config.CustomTheme) == "table" then
        local merged = {}
        for k, v in pairs(Theme) do merged[k] = v end
        for k, v in pairs(config.CustomTheme) do merged[k] = v end
        Theme = merged
    end

    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Visible = true
    Window.Minimized = false
    Window.Connections = {}
    Window.AllElements = {}

    local existingGui = guiParent:FindFirstChild("PainUI")
    if existingGui then
        existingGui:Destroy()
    end

    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "PainUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = guiParent
    })

    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Theme.Background,
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.CardBorder, 1, 0.4)
    AddShadow(MainFrame)

    MainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
    MainFrame.BackgroundTransparency = 1
    task.defer(function()
        Tween(MainFrame, AnimConfig.Bounce, {
            Size = windowSize,
            BackgroundTransparency = 0
        })
    end)

    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 45),
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    local Logo = CreateInstance("Frame", {
        Name = "Logo",
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = TopBar
    })
    AddCorner(Logo, 6)

    CreateInstance("TextLabel", {
        Name = "LogoLetter",
        Text = "P",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Logo
    })

    local TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 160, 1, 0),
        Position = UDim2.new(0, 48, 0, 0),
        Parent = TopBar
    })

    if subTitle ~= "" then
        CreateInstance("TextLabel", {
            Name = "SubTitle",
            Text = subTitle,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = Theme.AccentGlow,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 48 + TitleLabel.TextBounds.X + 8, 0, 0),
            Parent = TopBar
        })
    end

    local ControlsContainer = CreateInstance("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 260, 0, 32),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = TopBar
    })

    local ControlsLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ControlsContainer
    })

    local SearchBox = CreateInstance("TextBox", {
        Name = "SearchBox",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Theme.TextDark,
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 0, 0, 28),
        ClipsDescendants = true,
        Visible = false,
        LayoutOrder = 1,
        Parent = ControlsContainer
    })
    AddCorner(SearchBox, 6)
    AddStroke(SearchBox, Theme.CardBorder, 1)
    AddPadding(SearchBox, 0, 0, 8, 8)

    local SearchBtn = CreateInstance("TextButton", {
        Name = "SearchBtn",
        Text = "🔍",
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Theme.TextDim,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 28, 0, 28),
        LayoutOrder = 2,
        Parent = ControlsContainer
    })
    AddCorner(SearchBtn, 6)
    AddStroke(SearchBtn, Theme.CardBorder, 1)

    local MinimizeBtn = CreateInstance("TextButton", {
        Name = "MinimizeBtn",
        Text = "—",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 28, 0, 28),
        LayoutOrder = 3,
        Parent = ControlsContainer
    })
    AddCorner(MinimizeBtn, 6)
    AddStroke(MinimizeBtn, Theme.CardBorder, 1)

    local CloseBtn = CreateInstance("TextButton", {
        Name = "CloseBtn",
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 28, 0, 28),
        LayoutOrder = 4,
        Parent = ControlsContainer
    })
    AddCorner(CloseBtn, 6)
    AddStroke(CloseBtn, Theme.CardBorder, 1)

    CreateInstance("Frame", {
        Name = "TopSep",
        BackgroundColor3 = Theme.Separator,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = TopBar
    })

    local searchOpen = false
    SearchBtn.MouseButton1Click:Connect(function()
        searchOpen = not searchOpen
        if searchOpen then
            SearchBox.Visible = true
            Tween(SearchBox, AnimConfig.Fast, {Size = UDim2.new(0, 140, 0, 28)})
            SearchBox:CaptureFocus()
            Tween(SearchBtn, AnimConfig.Fast, {TextColor3 = Theme.Accent})
        else
            SearchBox.Text = ""
            Tween(SearchBox, AnimConfig.Fast, {Size = UDim2.new(0, 0, 0, 28)}).Completed:Connect(function()
                if not searchOpen then SearchBox.Visible = false end
            end)
            Tween(SearchBtn, AnimConfig.Fast, {TextColor3 = Theme.TextDim})
            for _, item in ipairs(Window.AllElements) do
                if item.Row then item.Row.Visible = true end
            end
        end
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _, item in ipairs(Window.AllElements) do
            if item.Row and item.Name then
                if query == "" or string.find(item.Name:lower(), query) then
                    item.Row.Visible = true
                else
                    item.Row.Visible = false
                end
            end
        end
    end)

    for _, btn in ipairs({SearchBtn, MinimizeBtn, CloseBtn}) do
        btn.MouseEnter:Connect(function()
            Tween(btn, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive, TextColor3 = Theme.Text})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, AnimConfig.Fast, {BackgroundColor3 = Theme.Card, TextColor3 = Theme.TextDim})
        end)
    end

    local Sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 52, 1, -90),
        Position = UDim2.new(0, 0, 0, 45),
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    CreateInstance("Frame", {
        Name = "SidebarSep",
        BackgroundColor3 = Theme.Separator,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        Parent = Sidebar
    })

    local SidebarLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Sidebar
    })
    AddPadding(Sidebar, 10, 10, 0, 0)

    local SidebarIndicator = CreateInstance("Frame", {
        Name = "Indicator",
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0.5, 0, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = 0,
        Parent = Sidebar
    })
    AddCorner(SidebarIndicator, 10)

    local ContentArea = CreateInstance("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -52, 1, -90),
        Position = UDim2.new(0, 52, 0, 45),
        ClipsDescendants = true,
        Parent = MainFrame
    })

    local BottomBar = CreateInstance("Frame", {
        Name = "BottomBar",
        BackgroundColor3 = Theme.BottomBar,
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 1, -45),
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    CreateInstance("Frame", {
        Name = "BottomSep",
        BackgroundColor3 = Theme.Separator,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Parent = BottomBar
    })

    local BottomTabsContainer = CreateInstance("Frame", {
        Name = "BottomTabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = BottomBar
    })

    local BottomTabsLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = BottomTabsContainer
    })

    local dragging = false
    local dragStart, startPos

    local dragConn1 = TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    table.insert(Window.Connections, dragConn1)

    local dragConn2 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(Window.Connections, dragConn2)

    local dragConn3 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    table.insert(Window.Connections, dragConn3)

    MinimizeBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Sidebar.Visible = false
            ContentArea.Visible = false
            BottomBar.Visible = false
            MinimizeBtn.Text = "□"
            Tween(MainFrame, AnimConfig.Medium, {Size = UDim2.new(0, windowSize.X.Offset, 0, 45)})
        else
            MinimizeBtn.Text = "—"
            local t = Tween(MainFrame, AnimConfig.Medium, {Size = windowSize})
            t.Completed:Connect(function()
                if not Window.Minimized then
                    Sidebar.Visible = true
                    ContentArea.Visible = true
                    BottomBar.Visible = true
                end
            end)
        end
    end)

    function Window:Toggle(state)
        if state ~= nil then
            Window.Visible = state
        else
            Window.Visible = not Window.Visible
        end

        if Window.Visible then
            MainFrame.Visible = true
            Tween(MainFrame, AnimConfig.Bounce, {
                Size = Window.Minimized and UDim2.new(0, windowSize.X.Offset, 0, 45) or windowSize,
                BackgroundTransparency = 0
            })
        else
            local t = Tween(MainFrame, AnimConfig.Medium, {
                Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
                BackgroundTransparency = 1
            })
            t.Completed:Connect(function()
                if not Window.Visible then
                    MainFrame.Visible = false
                end
            end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function()
        Window:Toggle(false)
        PainUI:Notify("PainUI", "Press [" .. toggleKey.Name .. "] to reopen the interface", 3, "Info")
    end)

    local toggleConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == toggleKey then
            Window:Toggle()
        end
    end)
    table.insert(Window.Connections, toggleConn)

    if UserInputService.TouchEnabled or config.MobileToggle then
        local MobileToggleBtn = CreateInstance("TextButton", {
            Name = "PainUI_MobileToggle",
            Text = "P",
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 44, 0, 44),
            Position = UDim2.new(0, 15, 0.5, -22),
            Parent = ScreenGui
        })
        AddCorner(MobileToggleBtn, 22)
        AddStroke(MobileToggleBtn, Theme.CardBorder, 2)
        AddShadow(MobileToggleBtn)

        local mDragging = false
        local mDragStart, mStartPos

        MobileToggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                mDragging = true
                mDragStart = input.Position
                mStartPos = MobileToggleBtn.Position
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                mDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if mDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local delta = input.Position - mDragStart
                MobileToggleBtn.Position = UDim2.new(
                    mStartPos.X.Scale, mStartPos.X.Offset + delta.X,
                    mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y
                )
            end
        end)

        MobileToggleBtn.MouseButton1Click:Connect(function()
            Window:Toggle()
        end)
    end

    local tabIndex = 0
    local sidebarButtons = {}
    local bottomButtons = {}

    function Window:CreateTab(name, icon)
        tabIndex = tabIndex + 1
        local Tab = {}
        Tab.Name = name
        Tab.Sections = {}
        Tab.LayoutOrder = tabIndex

        local SidebarBtn = CreateInstance("TextButton", {
            Name = "Tab_" .. name,
            Text = icon or "⚙",
            Font = Enum.Font.GothamMedium,
            TextSize = 18,
            TextColor3 = Theme.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 36, 0, 36),
            LayoutOrder = tabIndex,
            ZIndex = 2,
            Parent = Sidebar
        })
        AddCorner(SidebarBtn, 10)

        local TabPage = CreateInstance("ScrollingFrame", {
            Name = "Page_" .. name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ClipsDescendants = true,
            Parent = ContentArea
        })
        AddPadding(TabPage, 10, 10, 10, 10)

        local ColumnsContainer = CreateInstance("Frame", {
            Name = "Columns",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = TabPage
        })

        local LeftColumn = CreateInstance("Frame", {
            Name = "Left",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -6, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = ColumnsContainer
        })

        local LeftLayout = CreateInstance("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = LeftColumn
        })

        local RightColumn = CreateInstance("Frame", {
            Name = "Right",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -6, 0, 0),
            Position = UDim2.new(0.5, 6, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = ColumnsContainer
        })

        local RightLayout = CreateInstance("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = RightColumn
        })

        local BottomBtn = CreateInstance("TextButton", {
            Name = "BTab_" .. name,
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 30),
            AutomaticSize = Enum.AutomaticSize.X,
            LayoutOrder = tabIndex,
            ZIndex = 2,
            Parent = BottomTabsContainer
        })
        AddCorner(BottomBtn, 8)
        AddPadding(BottomBtn, 0, 0, 12, 12)

        local BottomBtnLayout = CreateInstance("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = BottomBtn
        })

        local BottomBtnIcon = CreateInstance("TextLabel", {
            Name = "Icon",
            Text = icon or "⚙",
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = Theme.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 14, 0, 14),
            LayoutOrder = 1,
            Parent = BottomBtn
        })

        local BottomBtnLabel = CreateInstance("TextLabel", {
            Name = "Label",
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = Theme.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.X,
            LayoutOrder = 2,
            Parent = BottomBtn
        })

        table.insert(sidebarButtons, {Button = SidebarBtn, Tab = Tab, Page = TabPage})
        table.insert(bottomButtons, {Button = BottomBtn, Tab = Tab, Page = TabPage, Icon = BottomBtnIcon, Label = BottomBtnLabel})

        local function selectTab()
            for _, info in ipairs(sidebarButtons) do
                Tween(info.Button, AnimConfig.Fast, {TextColor3 = Theme.TextDim})
                info.Page.Visible = false
            end
            for _, info in ipairs(bottomButtons) do
                Tween(info.Icon, AnimConfig.Fast, {TextColor3 = Theme.TextDim})
                Tween(info.Label, AnimConfig.Fast, {TextColor3 = Theme.TextDim})
                Tween(info.Button, AnimConfig.Fast, {BackgroundTransparency = 1})
            end

            Tween(SidebarBtn, AnimConfig.Fast, {TextColor3 = Theme.Text})
            TabPage.Visible = true

            local btnPos = SidebarBtn.AbsolutePosition
            local sidebarPos = Sidebar.AbsolutePosition
            Tween(SidebarIndicator, AnimConfig.Bounce, {
                Position = UDim2.new(0.5, 0, 0, (btnPos.Y - sidebarPos.Y)),
                Size = UDim2.new(0, 36, 0, 36)
            })

            Tween(BottomBtnIcon, AnimConfig.Fast, {TextColor3 = Theme.Accent})
            Tween(BottomBtnLabel, AnimConfig.Fast, {TextColor3 = Theme.Accent})
            Tween(BottomBtn, AnimConfig.Fast, {BackgroundTransparency = 0.5})

            for _, section in ipairs(Tab.Sections) do
                if section.Frame then
                    section.Frame.BackgroundTransparency = 1
                    section.Frame.Position = section.Frame.Position + UDim2.new(0, 0, 0, 14)
                    task.delay(section.AnimDelay or 0, function()
                        if section.Frame then
                            Tween(section.Frame, AnimConfig.Medium, {
                                BackgroundTransparency = 0,
                                Position = section.OrigPos
                            })
                        end
                    end)
                end
            end

            Window.ActiveTab = Tab
        end

        SidebarBtn.MouseButton1Click:Connect(selectTab)
        SidebarBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(SidebarBtn, AnimConfig.Fast, {TextColor3 = Theme.AccentGlow})
            end
        end)
        SidebarBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(SidebarBtn, AnimConfig.Fast, {TextColor3 = Theme.TextDim})
            end
        end)

        BottomBtn.MouseButton1Click:Connect(selectTab)
        BottomBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(BottomBtn, AnimConfig.Fast, {BackgroundTransparency = 0.8})
            end
        end)
        BottomBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(BottomBtn, AnimConfig.Fast, {BackgroundTransparency = 1})
            end
        end)

        if tabIndex == 1 then
            task.defer(selectTab)
        end

        local sectionIndex = 0

        function Tab:CreateSection(name, side, sectionIcon)
            sectionIndex = sectionIndex + 1
            local Section = {}
            Section.Elements = {}

            local parentColumn = (side == "right") and RightColumn or LeftColumn

            local Card = CreateInstance("Frame", {
                Name = "Section_" .. name,
                BackgroundColor3 = Theme.Card,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = sectionIndex,
                ClipsDescendants = false,
                Parent = parentColumn
            })
            AddCorner(Card, 10)
            AddStroke(Card, Theme.CardBorder, 1)

            Section.Frame = Card
            Section.OrigPos = Card.Position
            Section.AnimDelay = sectionIndex * 0.05

            local Header = CreateInstance("Frame", {
                Name = "Header",
                BackgroundColor3 = Theme.CardHeader,
                Size = UDim2.new(1, 0, 0, 34),
                BorderSizePixel = 0,
                LayoutOrder = 0,
                Parent = Card
            })
            AddCorner(Header, 10)

            CreateInstance("Frame", {
                Name = "HeaderFix",
                BackgroundColor3 = Theme.CardHeader,
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 1, -10),
                BorderSizePixel = 0,
                Parent = Header
            })

            CreateInstance("Frame", {
                Name = "HeaderSep",
                BackgroundColor3 = Theme.Separator,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                Parent = Header
            })

            CreateInstance("TextLabel", {
                Name = "Label",
                Text = name,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                Parent = Header
            })

            CreateInstance("TextLabel", {
                Name = "Icon",
                Text = sectionIcon or "⚙",
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = Header
            })

            local ElementsContainer = CreateInstance("Frame", {
                Name = "Elements",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 34),
                AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
                Parent = Card
            })

            CreateInstance("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = ElementsContainer
            })
            AddPadding(ElementsContainer, 4, 8, 0, 0)

            table.insert(Tab.Sections, Section)

            function Section:CreateToggle(labelText, default, callback)
                local toggled = default or false
                callback = callback or function() end
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Toggle_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = toggled and Theme.Text or Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -70, 1, 0),
                    Position = UDim2.new(0, 14, 0, 0),
                    Parent = Row
                })

                local ToggleTrack = CreateInstance("Frame", {
                    Name = "Track",
                    BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff,
                    Size = UDim2.new(0, 38, 0, 20),
                    Position = UDim2.new(1, -48, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = Row
                })
                AddCorner(ToggleTrack, 10)

                local Knob = CreateInstance("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Theme.ToggleKnob,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = ToggleTrack
                })
                AddCorner(Knob, 8)

                local Glow = CreateInstance("Frame", {
                    Name = "Glow",
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = toggled and 0.7 or 1,
                    Size = UDim2.new(1, 6, 1, 6),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = -1,
                    Parent = ToggleTrack
                })
                AddCorner(Glow, 12)

                local ToggleBtn = CreateInstance("TextButton", {
                    Name = "ToggleBtn",
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 5,
                    Parent = Row
                })

                local function applyState(animate)
                    if animate then
                        Tween(ToggleTrack, AnimConfig.Smooth, {
                            BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff
                        })
                        Tween(Knob, AnimConfig.Bounce, {
                            Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                        })
                        Tween(Label, AnimConfig.Fast, {
                            TextColor3 = toggled and Theme.Text or Theme.TextDim
                        })
                        Tween(Glow, AnimConfig.Medium, {
                            BackgroundTransparency = toggled and 0.7 or 1
                        })
                    else
                        ToggleTrack.BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff
                        Knob.Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                        Label.TextColor3 = toggled and Theme.Text or Theme.TextDim
                        Glow.BackgroundTransparency = toggled and 0.7 or 1
                    end
                end

                ToggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    applyState(true)
                    callback(toggled)
                end)

                ToggleBtn.MouseEnter:Connect(function()
                    Tween(Row, AnimConfig.Fast, {BackgroundTransparency = 0.9})
                end)
                ToggleBtn.MouseLeave:Connect(function()
                    Tween(Row, AnimConfig.Fast, {BackgroundTransparency = 1})
                end)

                local toggleObj = {
                    Set = function(_, val)
                        toggled = val
                        applyState(true)
                        callback(toggled)
                    end,
                    Get = function() return toggled end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, toggleObj)
                table.insert(Window.AllElements, toggleObj)
                return toggleObj
            end

            function Section:CreateSlider(labelText, min, max, default, suffix, callback)
                callback = callback or function() end
                suffix = suffix or ""
                local value = default or min
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Slider_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 42),
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 0, 18),
                    Position = UDim2.new(0, 14, 0, 2),
                    Parent = Row
                })

                local ValueLabel = CreateInstance("TextLabel", {
                    Name = "Value",
                    Text = tostring(math.floor(value)) .. suffix,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 60, 0, 18),
                    Position = UDim2.new(1, -14, 0, 2),
                    AnchorPoint = Vector2.new(1, 0),
                    Parent = Row
                })

                local SliderTrack = CreateInstance("Frame", {
                    Name = "Track",
                    BackgroundColor3 = Theme.SliderTrack,
                    Size = UDim2.new(1, -28, 0, 6),
                    Position = UDim2.new(0, 14, 0, 26),
                    Parent = Row
                })
                AddCorner(SliderTrack, 3)

                local pct = math.clamp((value - min) / (max - min), 0, 1)
                local SliderFill = CreateInstance("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Theme.SliderFill,
                    Size = UDim2.new(pct, 0, 1, 0),
                    BorderSizePixel = 0,
                    Parent = SliderTrack
                })
                AddCorner(SliderFill, 3)

                local SliderKnob = CreateInstance("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Theme.ToggleKnob,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(pct, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 3,
                    Parent = SliderTrack
                })
                AddCorner(SliderKnob, 7)

                local KnobGlow = CreateInstance("Frame", {
                    Name = "KnobGlow",
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 2,
                    Parent = SliderKnob
                })
                AddCorner(KnobGlow, 11)

                local sliderDragging = false

                local SliderInput = CreateInstance("TextButton", {
                    Name = "Input",
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 16),
                    Position = UDim2.new(0, 0, 0, -8),
                    ZIndex = 5,
                    Parent = SliderTrack
                })

                local function updateSlider(input)
                    local trackPos = SliderTrack.AbsolutePosition.X
                    local trackSize = SliderTrack.AbsoluteSize.X
                    local relX = math.clamp((input.Position.X - trackPos) / trackSize, 0, 1)

                    value = math.floor(min + (max - min) * relX)
                    pct = (value - min) / (max - min)

                    Tween(SliderFill, AnimConfig.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
                    Tween(SliderKnob, AnimConfig.Fast, {Position = UDim2.new(pct, 0, 0.5, 0)})
                    ValueLabel.Text = tostring(value) .. suffix

                    callback(value)
                end

                SliderInput.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliderDragging = true
                        Tween(KnobGlow, AnimConfig.Fast, {BackgroundTransparency = 0.6})
                        Tween(SliderKnob, AnimConfig.Bounce, {Size = UDim2.new(0, 16, 0, 16)})
                        updateSlider(input)
                    end
                end)

                local sEndConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if sliderDragging then
                            sliderDragging = false
                            Tween(KnobGlow, AnimConfig.Fast, {BackgroundTransparency = 1})
                            Tween(SliderKnob, AnimConfig.Bounce, {Size = UDim2.new(0, 14, 0, 14)})
                        end
                    end
                end)
                table.insert(Window.Connections, sEndConn)

                local sChangeConn = UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
                table.insert(Window.Connections, sChangeConn)

                local sliderObj = {
                    Set = function(_, val)
                        value = math.clamp(val, min, max)
                        pct = (value - min) / (max - min)
                        Tween(SliderFill, AnimConfig.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
                        Tween(SliderKnob, AnimConfig.Fast, {Position = UDim2.new(pct, 0, 0.5, 0)})
                        ValueLabel.Text = tostring(math.floor(value)) .. suffix
                        callback(value)
                    end,
                    Get = function() return value end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, sliderObj)
                table.insert(Window.AllElements, sliderObj)
                return sliderObj
            end

            function Section:CreateDropdown(labelText, options, default, callback)
                options = options or {}
                callback = callback or function() end
                local selected = default or options[1] or ""
                local opened = false
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Dropdown_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = elementIndex,
                    ClipsDescendants = false,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.45, 0, 0, 36),
                    Position = UDim2.new(0, 14, 0, 0),
                    Parent = Row
                })

                local DropBtn = CreateInstance("TextButton", {
                    Name = "DropBtn",
                    BackgroundColor3 = Theme.InputBg,
                    Size = UDim2.new(0, 120, 0, 26),
                    Position = UDim2.new(1, -14, 0, 5),
                    AnchorPoint = Vector2.new(1, 0),
                    AutoButtonColor = false,
                    Text = "",
                    Parent = Row
                })
                AddCorner(DropBtn, 6)
                AddStroke(DropBtn, Theme.Separator, 1)

                local DropLabel = CreateInstance("TextLabel", {
                    Name = "SelLabel",
                    Text = selected,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -26, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Parent = DropBtn
                })

                local DropArrow = CreateInstance("TextLabel", {
                    Name = "Arrow",
                    Text = "▾",
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 1, 0),
                    Position = UDim2.new(1, -18, 0, 0),
                    Parent = DropBtn
                })

                local DropOptions = CreateInstance("Frame", {
                    Name = "Options",
                    BackgroundColor3 = Theme.DropdownBg,
                    Size = UDim2.new(0, 120, 0, 0),
                    Position = UDim2.new(1, -14, 0, 34),
                    AnchorPoint = Vector2.new(1, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 20,
                    Parent = Row
                })
                AddCorner(DropOptions, 6)
                AddStroke(DropOptions, Theme.Separator, 1)

                local OptionsLayout = CreateInstance("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropOptions
                })
                AddPadding(DropOptions, 4, 4, 0, 0)

                local optionButtons = {}

                local function rebuildOptions(opts)
                    for _, child in ipairs(DropOptions:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    optionButtons = {}

                    for i, opt in ipairs(opts) do
                        local OptBtn = CreateInstance("TextButton", {
                            Name = "Opt_" .. opt,
                            Text = opt,
                            Font = Enum.Font.GothamMedium,
                            TextSize = 11,
                            TextColor3 = (opt == selected) and Theme.Accent or Theme.TextDim,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BackgroundColor3 = Theme.DropdownBg,
                            BackgroundTransparency = 1,
                            AutoButtonColor = false,
                            Size = UDim2.new(1, 0, 0, 24),
                            LayoutOrder = i,
                            ZIndex = 21,
                            Parent = DropOptions
                        })
                        AddPadding(OptBtn, 0, 0, 10, 10)
                        AddCorner(OptBtn, 4)

                        OptBtn.MouseEnter:Connect(function()
                            Tween(OptBtn, AnimConfig.Fast, {
                                BackgroundTransparency = 0.5,
                                TextColor3 = Theme.AccentGlow
                            })
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            Tween(OptBtn, AnimConfig.Fast, {
                                BackgroundTransparency = 1,
                                TextColor3 = (opt == selected) and Theme.Accent or Theme.TextDim
                            })
                        end)

                        OptBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            DropLabel.Text = opt

                            for _, ob in ipairs(optionButtons) do
                                Tween(ob.Btn, AnimConfig.Fast, {
                                    TextColor3 = (ob.Name == opt) and Theme.Accent or Theme.TextDim
                                })
                            end

                            opened = false
                            local t = Tween(DropOptions, AnimConfig.Fast, {Size = UDim2.new(0, 120, 0, 0)})
                            Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 36)})
                            t.Completed:Connect(function()
                                if not opened then DropOptions.Visible = false end
                            end)
                            Tween(DropArrow, AnimConfig.Fast, {Rotation = 0})

                            callback(opt)
                        end)

                        table.insert(optionButtons, {Btn = OptBtn, Name = opt})
                    end
                end

                rebuildOptions(options)

                DropBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        DropOptions.Visible = true
                        local totalHeight = #options * 24 + 8
                        Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 36 + totalHeight)})
                        Tween(DropOptions, AnimConfig.Medium, {Size = UDim2.new(0, 120, 0, totalHeight)})
                        Tween(DropArrow, AnimConfig.Fast, {Rotation = 180})
                    else
                        local t = Tween(DropOptions, AnimConfig.Fast, {Size = UDim2.new(0, 120, 0, 0)})
                        Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 36)})
                        t.Completed:Connect(function()
                            if not opened then DropOptions.Visible = false end
                        end)
                        Tween(DropArrow, AnimConfig.Fast, {Rotation = 0})
                    end
                end)

                DropBtn.MouseEnter:Connect(function()
                    Tween(DropBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive})
                end)
                DropBtn.MouseLeave:Connect(function()
                    Tween(DropBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                end)

                local dropObj = {
                    Set = function(_, val)
                        selected = val
                        DropLabel.Text = val
                        for _, ob in ipairs(optionButtons) do
                            Tween(ob.Btn, AnimConfig.Fast, {
                                TextColor3 = (ob.Name == val) and Theme.Accent or Theme.TextDim
                            })
                        end
                        callback(val)
                    end,
                    Get = function() return selected end,
                    Refresh = function(_, newOpts, keepSelection)
                        options = newOpts or {}
                        if not keepSelection or not table.find(options, selected) then
                            selected = options[1] or ""
                            DropLabel.Text = selected
                        end
                        rebuildOptions(options)
                    end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, dropObj)
                table.insert(Window.AllElements, dropObj)
                return dropObj
            end

            function Section:CreateButton(labelText, callback)
                callback = callback or function() end
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Button_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })

                local Btn = CreateInstance("TextButton", {
                    Name = "Btn",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Theme.Text,
                    BackgroundColor3 = Theme.InputBg,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, -28, 0, 30),
                    Position = UDim2.new(0, 14, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    ClipsDescendants = true,
                    Parent = Row
                })
                AddCorner(Btn, 6)
                AddStroke(Btn, Theme.Separator, 1)

                Btn.MouseButton1Click:Connect(function()
                    Ripple(Btn)
                    Tween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentDark})
                    task.delay(0.15, function()
                        Tween(Btn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                    end)
                    callback()
                end)

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive, TextColor3 = Theme.AccentGlow})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg, TextColor3 = Theme.Text})
                end)

                local btnObj = {
                    Fire = function() callback() end,
                    SetText = function(_, t) Btn.Text = t end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, btnObj)
                table.insert(Window.AllElements, btnObj)
                return btnObj
            end

            function Section:CreateInput(labelText, placeholder, default, callback)
                callback = callback or function() end
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Input_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.45, 0, 1, 0),
                    Position = UDim2.new(0, 14, 0, 0),
                    Parent = Row
                })

                local InputBox = CreateInstance("TextBox", {
                    Name = "InputBox",
                    Text = default or "",
                    PlaceholderText = placeholder or "Type here...",
                    PlaceholderColor3 = Theme.TextDark,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextColor3 = Theme.Text,
                    BackgroundColor3 = Theme.InputBg,
                    Size = UDim2.new(0, 120, 0, 26),
                    Position = UDim2.new(1, -14, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    ClearTextOnFocus = false,
                    Parent = Row
                })
                AddCorner(InputBox, 6)
                AddStroke(InputBox, Theme.Separator, 1)
                AddPadding(InputBox, 0, 0, 8, 8)

                InputBox.Focused:Connect(function()
                    Tween(InputBox, AnimConfig.Fast, {BackgroundColor3 = Theme.SidebarActive})
                end)
                InputBox.FocusLost:Connect(function(enterPressed)
                    Tween(InputBox, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                    callback(InputBox.Text, enterPressed)
                end)

                local inputObj = {
                    Set = function(_, val)
                        InputBox.Text = val
                        callback(val, true)
                    end,
                    Get = function() return InputBox.Text end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, inputObj)
                table.insert(Window.AllElements, inputObj)
                return inputObj
            end

            function Section:CreateKeybind(labelText, default, callback)
                callback = callback or function() end
                local currentKey = default or Enum.KeyCode.Unknown
                local listening = false
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Keybind_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0, 14, 0, 0),
                    Parent = Row
                })

                local KeyBtn = CreateInstance("TextButton", {
                    Name = "KeyBtn",
                    Text = currentKey.Name or "None",
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextColor3 = Theme.Text,
                    BackgroundColor3 = Theme.InputBg,
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 75, 0, 26),
                    Position = UDim2.new(1, -14, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Parent = Row
                })
                AddCorner(KeyBtn, 6)
                AddStroke(KeyBtn, Theme.Separator, 1)

                KeyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeyBtn.Text = "..."
                    Tween(KeyBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.AccentDark})
                end)

                local kbConn = UserInputService.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentKey = input.KeyCode
                        KeyBtn.Text = currentKey.Name
                        Tween(KeyBtn, AnimConfig.Fast, {BackgroundColor3 = Theme.InputBg})
                    elseif not listening and not processed and input.UserInputType == Enum.UserInputType.Keyboard then
                        if currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                            callback(currentKey)
                        end
                    end
                end)
                table.insert(Window.Connections, kbConn)

                local keybindObj = {
                    Set = function(_, val)
                        currentKey = val
                        KeyBtn.Text = val.Name
                    end,
                    Get = function() return currentKey end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, keybindObj)
                table.insert(Window.AllElements, keybindObj)
                return keybindObj
            end

            function Section:CreateColorPicker(labelText, default, callback)
                callback = callback or function() end
                local currentColor = default or Theme.Accent
                local elementIndex = #Section.Elements + 1
                local opened = false

                local Row = CreateInstance("Frame", {
                    Name = "ColorPicker_" .. labelText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = elementIndex,
                    ClipsDescendants = false,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = labelText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 0, 36),
                    Position = UDim2.new(0, 14, 0, 0),
                    Parent = Row
                })

                local ColorPreview = CreateInstance("TextButton", {
                    Name = "Preview",
                    Text = "",
                    BackgroundColor3 = currentColor,
                    Size = UDim2.new(0, 34, 0, 20),
                    Position = UDim2.new(1, -14, 0, 8),
                    AnchorPoint = Vector2.new(1, 0),
                    AutoButtonColor = false,
                    Parent = Row
                })
                AddCorner(ColorPreview, 5)
                AddStroke(ColorPreview, Theme.Separator, 1)

                local PaletteFrame = CreateInstance("Frame", {
                    Name = "Palette",
                    BackgroundColor3 = Theme.DropdownBg,
                    Size = UDim2.new(0, 150, 0, 0),
                    Position = UDim2.new(1, -14, 0, 34),
                    AnchorPoint = Vector2.new(1, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 20,
                    Parent = Row
                })
                AddCorner(PaletteFrame, 6)
                AddStroke(PaletteFrame, Theme.Separator, 1)

                local PaletteGrid = CreateInstance("UIGridLayout", {
                    CellPadding = UDim2.new(0, 4, 0, 4),
                    CellSize = UDim2.new(0, 24, 0, 24),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = PaletteFrame
                })
                AddPadding(PaletteFrame, 6, 6, 6, 6)

                local presetColors = {
                    Color3.fromRGB(230, 126, 34),
                    Color3.fromRGB(231, 76, 60),
                    Color3.fromRGB(46, 204, 113),
                    Color3.fromRGB(52, 152, 219),
                    Color3.fromRGB(155, 89, 182),
                    Color3.fromRGB(241, 196, 15),
                    Color3.fromRGB(26, 188, 156),
                    Color3.fromRGB(236, 240, 241),
                    Color3.fromRGB(149, 165, 166),
                    Color3.fromRGB(52, 73, 94),
                }

                for i, col in ipairs(presetColors) do
                    local Swatch = CreateInstance("TextButton", {
                        Name = "Swatch_" .. i,
                        Text = "",
                        BackgroundColor3 = col,
                        AutoButtonColor = false,
                        ZIndex = 21,
                        Parent = PaletteFrame
                    })
                    AddCorner(Swatch, 4)

                    Swatch.MouseButton1Click:Connect(function()
                        currentColor = col
                        Tween(ColorPreview, AnimConfig.Smooth, {BackgroundColor3 = currentColor})
                        callback(currentColor)
                    end)
                end

                ColorPreview.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        PaletteFrame.Visible = true
                        Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 105)})
                        Tween(PaletteFrame, AnimConfig.Medium, {Size = UDim2.new(0, 150, 0, 68)})
                    else
                        local t = Tween(PaletteFrame, AnimConfig.Fast, {Size = UDim2.new(0, 150, 0, 0)})
                        Tween(Row, AnimConfig.Fast, {Size = UDim2.new(1, 0, 0, 36)})
                        t.Completed:Connect(function()
                            if not opened then PaletteFrame.Visible = false end
                        end)
                    end
                end)

                local cpObj = {
                    Set = function(_, val)
                        currentColor = val
                        Tween(ColorPreview, AnimConfig.Smooth, {BackgroundColor3 = val})
                        callback(val)
                    end,
                    Get = function() return currentColor end,
                    Row = Row,
                    Name = labelText
                }

                table.insert(Section.Elements, cpObj)
                table.insert(Window.AllElements, cpObj)
                return cpObj
            end

            function Section:CreateParagraph(pTitle, pContent)
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Paragraph_" .. pTitle,
                    BackgroundColor3 = Theme.InputBg,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, -28, 0, 0),
                    Position = UDim2.new(0, 14, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })
                AddCorner(Row, 6)
                AddStroke(Row, Theme.Separator, 1)
                AddPadding(Row, 8, 8, 10, 10)

                CreateInstance("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = Row
                })

                local TitleLabel = CreateInstance("TextLabel", {
                    Name = "PTitle",
                    Text = pTitle,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    LayoutOrder = 1,
                    Parent = Row
                })

                local ContentLabel = CreateInstance("TextLabel", {
                    Name = "PContent",
                    Text = pContent or "",
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2,
                    Parent = Row
                })

                local paraObj = {
                    Set = function(_, newTitle, newContent)
                        if newTitle then TitleLabel.Text = newTitle end
                        if newContent then ContentLabel.Text = newContent end
                    end,
                    Row = Row,
                    Name = pTitle
                }

                table.insert(Section.Elements, paraObj)
                table.insert(Window.AllElements, paraObj)
                return paraObj
            end

            function Section:CreateLabel(text)
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Label_" .. text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    LayoutOrder = elementIndex,
                    Parent = ElementsContainer
                })

                local Label = CreateInstance("TextLabel", {
                    Name = "Label",
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextColor3 = Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -28, 1, 0),
                    Position = UDim2.new(0, 14, 0, 0),
                    Parent = Row
                })

                local labelObj = {
                    Set = function(_, val) Label.Text = val end,
                    Row = Row,
                    Name = text
                }

                table.insert(Section.Elements, labelObj)
                table.insert(Window.AllElements, labelObj)
                return labelObj
            end

            function Section:CreateSeparator()
                local elementIndex = #Section.Elements + 1

                local Row = CreateInstance("Frame", {
                    Name = "Sep",
                    BackgroundColor3 = Theme.Separator,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, -28, 0, 1),
                    Position = UDim2.new(0, 14, 0, 0),
                    LayoutOrder = elementIndex,
                    BorderSizePixel = 0,
                    Parent = ElementsContainer
                })

                local sepObj = {Row = Row}
                table.insert(Section.Elements, sepObj)
                return sepObj
            end

            return Section
        end

        return Tab
    end

    function Window:Notify(titleOrConfig, message, duration, nType)
        PainUI:Notify(titleOrConfig, message, duration, nType)
    end

    function Window:Destroy()
        for _, conn in ipairs(Window.Connections) do
            if conn and conn.Disconnect then
                pcall(function() conn:Disconnect() end)
            end
        end
        Window.Connections = {}

        local t = Tween(MainFrame, AnimConfig.Medium, {
            Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
            BackgroundTransparency = 1
        })
        t.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end

    return Window
end

pcall(function()
    if getgenv then
        getgenv().PainUI = PainUI
    end
end)

return PainUI
