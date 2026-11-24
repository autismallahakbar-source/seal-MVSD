local loadingGui = nil
local loadingConnections = {}
local loadingActive = true
local loadingFinished = false

local function finishLoading()
    if loadingFinished then return end
    loadingFinished = true
    if not loadingGui or not loadingGui.Parent then return end

    local ts = game:GetService("TweenService")
    local bg = loadingGui:FindFirstChild("bg")
    local logoImage = loadingGui:FindFirstChild("logoImage")
    local logoFrame = loadingGui:FindFirstChild("logoFrame")

    local fadeOutInfo = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

    if bg then ts:Create(bg, fadeOutInfo, { BackgroundTransparency = 1 }):Play() end
    if logoImage then ts:Create(logoImage, fadeOutInfo, { ImageTransparency = 1 }):Play() end

    if logoFrame then
        local sealText = logoFrame:FindFirstChild("sealText")
        local devBox = logoFrame:FindFirstChild("devBox")
        local author = logoFrame:FindFirstChild("author")
        if sealText then ts:Create(sealText, fadeOutInfo, { TextTransparency = 1 }):Play() end
        if author then ts:Create(author, fadeOutInfo, { TextTransparency = 1 }):Play() end
        if devBox then
            local devText = devBox:FindFirstChild("devText")
            if devText then ts:Create(devText, fadeOutInfo, { TextTransparency = 1 }):Play() end
            ts:Create(devBox, fadeOutInfo, { BackgroundTransparency = 1 }):Play()
        end
    end

    task.delay(0.4, function()
        loadingActive = false
        for _, conn in ipairs(loadingConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                pcall(function() conn:Disconnect() end)
            end
        end
        loadingConnections = {}
        if loadingGui then loadingGui:Destroy() end
    end)
end

do
    local lp = game:GetService("Players").LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")
    local ts = game:GetService("TweenService")
    local rs = game:GetService("RunService")

    loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "SealDevLoading"
    loadingGui.ResetOnSpawn = false
    loadingGui.IgnoreGuiInset = true
    loadingGui.DisplayOrder = 999999
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingGui.Parent = pg

    local bg = Instance.new("Frame")
    bg.Name = "bg"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.ZIndex = 1
    bg.Parent = loadingGui

    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    bgGradient.Rotation = 45
    bgGradient.Parent = bg

    local particleLayer = Instance.new("Frame")
    particleLayer.Name = "particles"
    particleLayer.Size = UDim2.new(1, 0, 1, 0)
    particleLayer.BackgroundTransparency = 1
    particleLayer.ZIndex = 2
    particleLayer.ClipsDescendants = true
    particleLayer.Parent = loadingGui

    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "logoImage"
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.Position = UDim2.new(0.5, 0, 0.5, -180)
    logoImage.Size = UDim2.new(0, 150, 0, 150)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://131261307870420"
    logoImage.ImageTransparency = 1
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.ZIndex = 5
    logoImage.Parent = loadingGui

    local logoFrame = Instance.new("Frame")
    logoFrame.Name = "logoFrame"
    logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    logoFrame.Position = UDim2.new(0.5, 0, 0.5, -30)
    logoFrame.Size = UDim2.new(0, 900, 0, 200)
    logoFrame.BackgroundTransparency = 1
    logoFrame.ZIndex = 5
    logoFrame.Parent = loadingGui

    local TEXT_SIZE = 120
    local BOX_PADDING_Y = 8
    local BOX_HEIGHT = TEXT_SIZE + BOX_PADDING_Y * 2

    local sealText = Instance.new("TextLabel")
    sealText.Name = "sealText"
    sealText.AnchorPoint = Vector2.new(1, 0.5)
    sealText.Position = UDim2.new(0.5, -6, 0.5, 0)
    sealText.Size = UDim2.new(0, 320, 0, BOX_HEIGHT)
    sealText.BackgroundTransparency = 1
    sealText.Text = "Seal"
    sealText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sealText.Font = Enum.Font.GothamBold
    sealText.TextSize = TEXT_SIZE
    sealText.TextXAlignment = Enum.TextXAlignment.Right
    sealText.TextYAlignment = Enum.TextYAlignment.Center
    sealText.TextTransparency = 1
    sealText.ZIndex = 5
    sealText.Parent = logoFrame

    local devBox = Instance.new("Frame")
    devBox.Name = "devBox"
    devBox.AnchorPoint = Vector2.new(0, 0.5)
    devBox.Position = UDim2.new(0.5, 6, 0.5, 0)
    devBox.Size = UDim2.new(0, 230, 0, BOX_HEIGHT)
    devBox.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    devBox.BorderSizePixel = 0
    devBox.BackgroundTransparency = 1
    devBox.ZIndex = 5
    devBox.Parent = logoFrame

    local devBoxCorner = Instance.new("UICorner")
    devBoxCorner.CornerRadius = UDim.new(0, 8)
    devBoxCorner.Parent = devBox

    local devText = Instance.new("TextLabel")
    devText.Name = "devText"
    devText.Size = UDim2.new(1, 0, 1, 0)
    devText.BackgroundTransparency = 1
    devText.Text = "Dev"
    devText.TextColor3 = Color3.fromRGB(0, 0, 0)
    devText.Font = Enum.Font.GothamBold
    devText.TextSize = TEXT_SIZE
    devText.TextTransparency = 1
    devText.ZIndex = 6
    devText.Parent = devBox

    local author = Instance.new("TextLabel")
    author.Name = "author"
    author.AnchorPoint = Vector2.new(0.5, 0.5)
    author.Position = UDim2.new(0.5, 0, 0.5, 100)
    author.Size = UDim2.new(0, 400, 0, 30)
    author.BackgroundTransparency = 1
    author.Text = "by SealDev"
    author.TextColor3 = Color3.fromRGB(160, 160, 200)
    author.Font = Enum.Font.Gotham
    author.TextSize = 16
    author.TextTransparency = 1
    author.ZIndex = 5
    author.Parent = logoFrame

    local function spawnParticle()
        if not loadingActive then return end
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
        p.BackgroundColor3 = Color3.fromRGB(
            math.random(200, 255),
            math.random(120, 200),
            math.random(0, 100)
        )
        p.BorderSizePixel = 0
        p.BackgroundTransparency = 0.3
        p.Position = UDim2.new(math.random(), 0, 1.1, 0)
        p.ZIndex = 2

        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(1, 0)
        pCorner.Parent = p
        p.Parent = particleLayer

        local duration = math.random(3, 6)
        local targetY = -0.1
        local drift = (math.random() - 0.5) * 0.15

        local tween = ts:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.new(p.Position.X.Scale + drift, 0, targetY, 0),
            BackgroundTransparency = 1,
        })
        tween:Play()
        tween.Completed:Connect(function()
            p:Destroy()
        end)
    end

    local particleThread = task.spawn(function()
        while loadingActive do
            spawnParticle()
            task.wait(0.04)
        end
    end)
    table.insert(loadingConnections, particleThread)

    local FADE_FAST = TweenInfo.new(0.27, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    ts:Create(bg, FADE_FAST, { BackgroundTransparency = 0 }):Play()
    task.wait(0.33)

    ts:Create(logoImage, FADE_FAST, { ImageTransparency = 0 }):Play()
    task.wait(0.33)

    ts:Create(sealText, FADE_FAST, { TextTransparency = 0 }):Play()
    ts:Create(devBox, FADE_FAST, { BackgroundTransparency = 0 }):Play()
    ts:Create(devText, FADE_FAST, { TextTransparency = 0 }):Play()
    ts:Create(author, FADE_FAST, { TextTransparency = 0.2 }):Play()

    local pulseConn = rs.Heartbeat:Connect(function()
        if not loadingActive then return end
        local t = tick()
        local scale = 1 + math.sin(t * 2) * 0.03
        logoImage.Size = UDim2.new(0, 150 * scale, 0, 150 * scale)
    end)
    table.insert(loadingConnections, pulseConn)
end

if _G.SealDevV27Loaded then
    warn("[SealDev] Already loaded. Set _G.SealDevV27Loaded = nil to reload")
    finishLoading()
    return
end
_G.SealDevV27Loaded = true
for i = 0, 26 do _G["SealDevV" .. i .. "Loaded"] = nil end
_G.SealDevLoaded = nil

pcall(function()
    if getgenv().SealDevAntiLagOff then
        pcall(getgenv().SealDevAntiLagOff)
        getgenv().SealDevAntiLagOff = nil
    end
end)

pcall(function()
    local cg = game:GetService("CoreGui")
    for _, ch in ipairs(cg:GetChildren()) do
        if ch.Name == "SealDevConfigs" or ch.Name:find("SealDevConfig") then
            pcall(function() ch:Destroy() end)
        end
    end
    local plr = game:GetService("Players").LocalPlayer
    for _, ch in ipairs(plr:GetChildren()) do
        if ch.Name == "SealDevConfigs" or ch.Name:find("SealDevConfig") then
            pcall(function() ch:Destroy() end)
        end
    end
end)

local LOGO = "rbxassetid://131261307870420"
local DISCORD_LINK = "https://discord.gg/xhn6WaHzs5"

local ok, UI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not ok or not UI then
    warn("[SealDev] WindUI load failed:", UI)
    finishLoading()
    return
end

local Hub
do
    local ok2, res = pcall(function()
        return UI:CreateWindow({
            Title = "SealDev", Icon = LOGO, Author = "SealDev",
            Folder = "SealDevConfigs", Size = UDim2.fromOffset(560, 440),
            ToggleKey = Enum.KeyCode.LeftControl, Theme = "Dark",
            Transparent = false, Resizable = true, SideBarWidth = 180,
            User = { Enabled = true, Anonymous = true },
        })
    end)
    if not ok2 or not res then
        warn("[SealDev] CreateWindow failed:", res)
        _G.SealDevV27Loaded = nil
        finishLoading()
        return
    end
    Hub = res
end

pcall(function()
    Hub:EditOpenButton({
        Title = "Open SealDev", Icon = LOGO, CornerRadius = UDim.new(0, 10),
        Color = ColorSequence.new(Color3.fromHex("#8a63ff"), Color3.fromHex("#cfe6ff")),
        Enabled = true, Draggable = true,
    })
end)

pcall(function()
    Hub:Tag({ Title = "V27", Icon = "sparkles", Color = Color3.fromHex("#8a63ff"), Radius = 4 })
end)

local PlayersService      = game:GetService("Players")
local RS                  = game:GetService("ReplicatedStorage")
local WorkspaceService    = game:GetService("Workspace")
local RunServiceRef       = game:GetService("RunService")
local UserInputServiceRef = game:GetService("UserInputService")
local VirtualUserService  = game:GetService("VirtualUser")
local CoreGuiRef          = game:GetService("CoreGui")
local TweenServiceRef     = game:GetService("TweenService")
local DebrisService       = game:GetService("Debris")
local CollectionServiceRef = game:GetService("CollectionService")
local MyPlayer            = PlayersService.LocalPlayer

local DANCE_R15 = "rbxassetid://507776879"
local DANCE_R6  = "rbxassetid://182435998"
local FLAGS_MULTIPLIER = 4.5
local JUMP_SOUND_NEW   = "rbxassetid://2428506580"
local DEFAULT_WALKSPEED = 32

local S = {
    InMatch = false, EnemyList = {}, EnemySet = {},
    CooldownOff = false, CooldownSaves = {},
    HitboxOn = false, HitboxShow = false, HitboxSize = 8,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    CharmESP = false, TracerESP = false, NameESP = false,
    MateColor = Color3.fromRGB(255, 255, 255), FoeColor = Color3.fromRGB(0, 0, 0),
    GuiHidden = false, NoclipOn = false, SpeedOn = false, SpeedValue = DEFAULT_WALKSPEED,
    FlagsOn = false, FarmOn = false, FarmWalkSpeed = 40, LastDance = 0,
    DanceTrack = nil, DanceAnimObj = nil,
    AntiExploiterOn = false, AntiExploiterForce = 3,
    TriggerOn = false, TriggerCD = 1, TriggerFiring = false,
    AimbotOn = false, AimbotFOV = 200, AimbotShowFOV = false,
    AimbotSmoothness = 0.35,
    FarmRoundStart = 0, FarmLastMatchState = false, FarmTeleported = false, CachedKnife = nil,
}

local AnchorRelease = false

local SavedState = {
    WalkSpeed = nil, JumpPower = nil, JumpHeight = nil, AutoRotate = nil,
    DefaultWalkSpeed = DEFAULT_WALKSPEED, DefaultJumpPower = 50, DefaultJumpHeight = 7.2,
}

local function dbg(m) warn("[SealDev] " .. tostring(m)) end
local function Notify(m) pcall(function() Hub:Notify({ Title = "SealDev", Content = tostring(m), Duration = 2.5, Icon = LOGO }) end) end
dbg("loaded")

local function rememberHumanoidDefaults()
    local char = MyPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if SavedState.WalkSpeed == nil then SavedState.WalkSpeed = hum.WalkSpeed end
    if SavedState.JumpPower == nil then SavedState.JumpPower = hum.JumpPower end
    if SavedState.JumpHeight == nil then SavedState.JumpHeight = hum.UseJumpPower and nil or hum.JumpHeight end
    if SavedState.AutoRotate == nil then SavedState.AutoRotate = hum.AutoRotate end
end

local function restoreHumanoidDefaults()
    local char = MyPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.WalkSpeed = SavedState.DefaultWalkSpeed
        if hum.UseJumpPower then
            hum.JumpPower = SavedState.DefaultJumpPower
        else
            hum.JumpHeight = SavedState.DefaultJumpHeight
        end
        if SavedState.AutoRotate ~= nil then hum.AutoRotate = SavedState.AutoRotate end
    end)
end

local function FindKnife()
    if S.CachedKnife and S.CachedKnife.Parent then return S.CachedKnife end
    for _, c in ipairs({ MyPlayer:FindFirstChildOfClass("Backpack"), MyPlayer.Character }) do
        if c then
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t:GetAttribute("EquipAnimation") == "Knife_Equip" then
                    S.CachedKnife = t
                    return t
                end
            end
        end
    end
    S.CachedKnife = nil
    return nil
end

local function FindGun()
    for _, c in ipairs({ MyPlayer:FindFirstChildOfClass("Backpack"), MyPlayer.Character }) do
        if c then
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t:FindFirstChild("Fire") and t:FindFirstChild("Reload") then
                    return t
                end
            end
        end
    end
    return nil
end

-- [НОВОЕ] Только пушка В РУКАХ (Character, НЕ Backpack)
local function getEquippedGun()
    local char = MyPlayer.Character
    if not char then return nil end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t:FindFirstChild("Fire") and t:FindFirstChild("Reload") then
            return t
        end
    end
    return nil
end

local function EquipTool(t)
    if not t then return end
    local b = MyPlayer.Character
    local h = b and b:FindFirstChildOfClass("Humanoid")
    if h and h.Health > 0 then pcall(function() h:EquipTool(t) end) end
end

local function equipGun()
    local char = MyPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local gun = FindGun()
    if gun then pcall(function() hum:EquipTool(gun) end) end
end

local RemoteFolder = RS:WaitForChild("Remotes", 10)
local BulletRendererColor = Color3.fromRGB(255, 255, 255)

local function BulletRenderer(origin, targetPos)
    local function CreatePseudoPart(cf)
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.1, 0.1, 0.1)
        p.Transparency = 1
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.Anchored = true
        p.CFrame = cf
        p.Parent = WorkspaceService
        return p
    end
    local startPart = CreatePseudoPart(CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -1))
    local endPart = CreatePseudoPart(CFrame.new(targetPos))
    local beam = Instance.new("Beam")
    beam.Texture = ""
    beam.TextureLength = 1
    beam.TextureMode = Enum.TextureMode.Stretch
    beam.TextureSpeed = 0
    beam.Color = ColorSequence.new(BulletRendererColor)
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Brightness = 5
    beam.Width0 = 0
    beam.Width1 = 0
    local att0 = Instance.new("Attachment", startPart)
    local att1 = Instance.new("Attachment", endPart)
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Parent = startPart
    startPart:SetAttribute("SealDevMine", true)
    endPart:SetAttribute("SealDevMine", true)
    local fadeIn = TweenServiceRef:Create(beam, TweenInfo.new(0.05, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
        Width0 = 0.3, Width1 = 0.6
    })
    local fadeOut = TweenServiceRef:Create(beam, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Width0 = 0, Width1 = 0
    })
    fadeIn:Play()
    fadeIn.Completed:Connect(function() fadeOut:Play() end)
    DebrisService:AddItem(startPart, 0.3)
    DebrisService:AddItem(endPart, 0.3)
end

local function CharacterRayOrigin(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return (hrp.CFrame * CFrame.new(0, 0, hrp.Size.Z / 2)).Position
end

local function hasClearLOS(fromPart, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { MyPlayer.Character, targetChar }
    params.IgnoreWater = true
    local th = targetChar:FindFirstChild("Head")
    if not th then return false end
    local res = WorkspaceService:Raycast(fromPart.Position, th.Position - fromPart.Position, params)
    if res then return res.Instance:IsDescendantOf(targetChar) end
    return true
end

local function isTeammate(other)
    if not other or other == MyPlayer then return true end
    if other.Team and MyPlayer.Team and other.Team == MyPlayer.Team then return true end
    local myTC, otherTC = MyPlayer.TeamColor, other.TeamColor
    if myTC and otherTC and myTC == otherTC then
        if myTC ~= BrickColor.new("Medium stone grey") and myTC ~= BrickColor.new("White") then
            return true
        end
    end
    for _, attr in ipairs({"Team","team","Side","side"}) do
        local a, b = MyPlayer:GetAttribute(attr), other:GetAttribute(attr)
        if a ~= nil and b ~= nil and a == b then return true end
    end
    return false
end

-- ============================================================
-- FOV
-- ============================================================
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "SealDevFOV"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 5
fovGui.Parent = CoreGuiRef

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.new(0, S.AimbotFOV * 2, 0, S.AimbotFOV * 2)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = fovGui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3
fovStroke.Parent = fovCircle

local fovAspect = Instance.new("UIAspectRatioConstraint")
fovAspect.AspectRatio = 1
fovAspect.Parent = fovCircle

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local function updateFovCircle()
    fovCircle.Size = UDim2.new(0, S.AimbotFOV * 2, 0, S.AimbotFOV * 2)
    fovCircle.Visible = S.AimbotShowFOV and S.AimbotOn
end
updateFovCircle()

local function getClosestEnemyInFOV()
    local cam = WorkspaceService.CurrentCamera
    if not cam then return nil end
    local myChar = MyPlayer.Character
    if not myChar then return nil end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, minDist = nil, S.AimbotFOV + 1
    for _, o in ipairs(S.EnemyList) do
        if not isTeammate(o) and o.Character then
            local head = o.Character:FindFirstChild("Head")
            local hp = o.Character:FindFirstChildOfClass("Humanoid")
            if head and hp and hp.Health > 0 then
                local pt, onScreen = cam:WorldToScreenPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(pt.X, pt.Y) - center).Magnitude
                    if d < minDist then minDist = d; closest = head end
                end
            end
        end
    end
    return closest
end

local aimbotConn = RunServiceRef.RenderStepped:Connect(function()
    if not S.AimbotOn or S.GuiHidden or not S.InMatch then return end
    if not UserInputServiceRef:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local target = getClosestEnemyInFOV()
    if not target then return end
    local cam = WorkspaceService.CurrentCamera
    if not cam then return end
    local goal = CFrame.new(cam.CFrame.Position, target.Position)
    cam.CFrame = cam.CFrame:Lerp(goal, S.AimbotSmoothness)
end)

-- ============================================================
-- TRIGGERBOT — теперь стреляет ТОЛЬКО когда пест в руках
-- ============================================================
local function getPlayerFromHit(inst)
    local current = inst
    while current and current ~= WorkspaceService do
        if current:FindFirstChildOfClass("Humanoid") then
            local plr = PlayersService:GetPlayerFromCharacter(current)
            if plr then return plr, current end
        end
        current = current.Parent
    end
    return nil, nil
end

-- [ИЗМЕНЕНО] Не ищет пушку сам — принимает уже экипированную
local function VexalShootGun(target, hitPart, gun)
    local myChar = MyPlayer.Character
    if not myChar then return false end
    if not gun or not gun.Parent then return false end
    if gun.Parent ~= myChar then return false end  -- страховка: пушка должна быть в руках

    local origin = CharacterRayOrigin(myChar)
    if not origin then return false end

    if not hitPart or not hitPart:IsA("BasePart") then
        hitPart = target.Character and (
            target.Character:FindFirstChild("UpperTorso")
            or target.Character:FindFirstChild("LowerTorso")
            or target.Character:FindFirstChild("Torso")
            or target.Character:FindFirstChild("Head")
            or target.Character:FindFirstChild("HumanoidRootPart")
        )
    end
    if not hitPart then return false end

    local targetPos = hitPart.Position
    local muzzle = gun:FindFirstChild("Muzzle", true)
    local startPos = (muzzle and muzzle:IsA("BasePart") and muzzle.WorldPosition) or origin
    pcall(BulletRenderer, startPos, targetPos)

    local sg = RemoteFolder and RemoteFolder:FindFirstChild("ShootGun")
    if sg then
        local ok, err = pcall(function() sg:FireServer(origin, targetPos, hitPart, targetPos) end)
        if not ok then warn("[SealDev TriggerBot] FireServer error:", err) end
    end

    local sound = gun:FindFirstChild("Fire")
    if sound and sound:IsA("Sound") then
        pcall(function() sound:Play() end)
    end
    return true
end

local function vexal_triggerbot_valid_enemy(enemy, character)
    if not enemy or enemy == MyPlayer then return false end
    character = character or enemy.Character
    if not character then return false end
    if isTeammate(enemy) then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if CollectionServiceRef:HasTag(character, "Invulnerable") then return false end
    return true
end

local function vexal_triggerbot_shoot(target, targetChar, hitPart, gun)
    local myChar = MyPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then S.TriggerFiring = false; return end

    if not hitPart or not hitPart:IsA("BasePart") then
        hitPart = targetChar:FindFirstChild("UpperTorso")
            or targetChar:FindFirstChild("LowerTorso")
            or targetChar:FindFirstChild("Torso")
            or targetChar:FindFirstChild("Head")
            or targetChar:FindFirstChild("HumanoidRootPart")
    end
    if not hitPart then S.TriggerFiring = false; return end

    VexalShootGun(target, hitPart, gun)
end

local triggerbot_conn = RunServiceRef.Heartbeat:Connect(function()
    if not S.TriggerOn then return end
    if S.GuiHidden then return end
    if not S.InMatch then return end
    if S.TriggerFiring then return end

    -- [НОВОЕ] Триггерится ТОЛЬКО когда пест в руках
    local gun = getEquippedGun()
    if not gun then return end

    local character = MyPlayer.Character
    if not character then return end
    local cam = WorkspaceService.CurrentCamera
    if not cam then return end

    local mousePos = UserInputServiceRef:GetMouseLocation()
    local ray = cam:ViewportPointToRay(mousePos.X, mousePos.Y)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = { character }
    rayParams.IgnoreWater = true
    local result = WorkspaceService:Raycast(ray.Origin, ray.Direction * 2000, rayParams)
    if not result then return end

    local hitPlayer, hitCharacter = getPlayerFromHit(result.Instance)
    if not hitPlayer or not hitCharacter then return end

    if vexal_triggerbot_valid_enemy(hitPlayer, hitCharacter) then
        S.TriggerFiring = true
        vexal_triggerbot_shoot(hitPlayer, hitCharacter, result.Instance, gun)
        task.delay(math.max(S.TriggerCD, 0.01), function()
            S.TriggerFiring = false
        end)
    end
end)

MyPlayer.CharacterAdded:Connect(function(body)
    S.CachedKnife = nil
    SavedState.WalkSpeed = nil
    SavedState.JumpPower = nil
    SavedState.JumpHeight = nil
    SavedState.AutoRotate = nil
    if not AnchorRelease then return end
    local root = body:WaitForChild("HumanoidRootPart", 5)
    local hp = body:WaitForChild("Humanoid", 5)
    if not root or not hp then return end
    local loop
    loop = RunServiceRef.Heartbeat:Connect(function()
        if not body.Parent or hp.Health <= 0 or not AnchorRelease then loop:Disconnect(); return end
        if root.Anchored then root.Anchored = false end
    end)
end)

local antiAfkConn
local function enableAntiAfk()
    if antiAfkConn then return end
    antiAfkConn = MyPlayer.Idled:Connect(function()
        if not S.FarmOn then return end
        pcall(function()
            VirtualUserService:CaptureController()
            VirtualUserService:ClickButton2(Vector2.new())
        end)
    end)
end
local function disableAntiAfk()
    if antiAfkConn then pcall(function() antiAfkConn:Disconnect() end); antiAfkConn = nil end
end

task.spawn(function()
    while task.wait(0.05) do
        if S.AntiExploiterOn and S.InMatch and not S.GuiHidden then
            pcall(function()
                local char = MyPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then return end
                local f = S.AntiExploiterForce
                local offset = Vector3.new(
                    (math.random() * 2 - 1) * f,
                    (math.random() * 2 - 1) * f * 0.5,
                    (math.random() * 2 - 1) * f
                )
                hrp.CFrame = hrp.CFrame + offset
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        local cm = MyPlayer:GetAttribute("Match")
        S.InMatch = cm ~= nil
        local list = {}
        if cm then
            for _, o in ipairs(PlayersService:GetPlayers()) do
                if o ~= MyPlayer and o:GetAttribute("Match") == cm then
                    local b = o.Character
                    local h = b and b:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 and not isTeammate(o) then
                        list[#list + 1] = o
                    end
                end
            end
        end
        local same = #list == #S.EnemyList
        if same then
            for i = 1, #list do
                if list[i] ~= S.EnemyList[i] then same = false; break end
            end
        end
        if not same then
            S.EnemyList = list
            local set = {}
            for _, p in ipairs(list) do set[p.UserId] = true end
            S.EnemySet = set
        end
    end
end)

local CD_KEYS = { "Cooldown", "FireRate", "FireCooldown", "ReloadCooldown", "ReloadTime" }
local function WipeCD(t, saves)
    for _, k in ipairs(CD_KEYS) do
        if t:GetAttribute(k) ~= nil then
            local tag = tostring(t) .. "@" .. k
            if saves[tag] == nil then
                saves[tag] = { obj = t, key = k, val = t:GetAttribute(k) }
            end
            pcall(function() t:SetAttribute(k, 0) end)
        end
    end
end
local function RestoreSaves(saves)
    for _, e in pairs(saves) do
        if e.obj and e.obj.Parent then pcall(function() e.obj:SetAttribute(e.key, e.val) end) end
    end
end
task.spawn(function()
    while task.wait(0.25) do
        if S.CooldownOff and not S.GuiHidden then
            for _, c in ipairs({ MyPlayer:FindFirstChildOfClass("Backpack"), MyPlayer.Character }) do
                if c then
                    for _, i in ipairs(c:GetChildren()) do
                        if i:IsA("Tool") and i:FindFirstChild("Fire") then WipeCD(i, S.CooldownSaves) end
                    end
                end
            end
        end
    end
end)

local function stopDance()
    if S.DanceTrack then pcall(function() S.DanceTrack:Stop(0) end); S.DanceTrack = nil end
    if S.DanceAnimObj then pcall(function() S.DanceAnimObj:Destroy() end); S.DanceAnimObj = nil end
end

local function playDance()
    local c = MyPlayer.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    pcall(function() h:PlayEmote("dance") end)
    stopDance()
    local a = h:FindFirstChildOfClass("Animator")
    if not a then a = Instance.new("Animator"); a.Parent = h end
    local id = (h.RigType == Enum.HumanoidRigType.R6) and DANCE_R6 or DANCE_R15
    S.DanceAnimObj = Instance.new("Animation")
    S.DanceAnimObj.AnimationId = id
    local ok2, tr = pcall(function() return a:LoadAnimation(S.DanceAnimObj) end)
    if ok2 and tr then
        pcall(function()
            tr.Priority = Enum.AnimationPriority.Action
            tr.Looped = true
            tr:Play(0.1)
        end)
        S.DanceTrack = tr
    end
end

local CharmFolder = CoreGuiRef:FindFirstChild("SealDevCharm") or Instance.new("Folder")
CharmFolder.Name = "SealDevCharm"; CharmFolder.Parent = CoreGuiRef

local TracerFolder = CoreGuiRef:FindFirstChild("SealDevTracer") or Instance.new("Folder")
TracerFolder.Name = "SealDevTracer"; TracerFolder.Parent = CoreGuiRef

local NameFolder = CoreGuiRef:FindFirstChild("SealDevInfo") or Instance.new("Folder")
NameFolder.Name = "SealDevInfo"; NameFolder.Parent = CoreGuiRef

local HitboxFolder = CoreGuiRef:FindFirstChild("SealDevHitbox") or Instance.new("Folder")
HitboxFolder.Name = "SealDevHitbox"; HitboxFolder.Parent = CoreGuiRef

local boostedAnimators = setmetatable({}, { __mode = "k" })
local boostedParticles = setmetatable({}, { __mode = "k" })
local savedAnimSpeeds  = setmetatable({}, { __mode = "k" })
local replacedJumpSounds = setmetatable({}, { __mode = "k" })
local flagsWatchers = {}

local function looksLikeJumpSound(o)
    if not o:IsA("Sound") then return false end
    local c = o:GetAttribute("SealDevJump")
    if c ~= nil then return c end
    local n = o.Name
    local r = false
    if n == "Jumping" or n == "JumpSound" or n == "Jump" then
        r = true
    else
        local l = string.lower(n)
        if string.find(l, "jump", 1, true) then
            r = true
        else
            local s = o.SoundId
            if s == "rbxasset://sounds/action_jump.mp3"
               or s == "rbxasset://sounds/action_jump_land.mp3"
               or s == "rbxassetid://4657753130"
               or s == "rbxassetid://5171086877" then
                r = true
            end
        end
    end
    pcall(function() o:SetAttribute("SealDevJump", r) end)
    return r
end

local function boostAnimator(a)
    if boostedAnimators[a] then return end
    boostedAnimators[a] = a.AnimationPlayed:Connect(function(tr)
        if not S.FlagsOn then return end
        if savedAnimSpeeds[tr] == nil then pcall(function() savedAnimSpeeds[tr] = tr.Speed end) end
        pcall(function() tr.Speed = FLAGS_MULTIPLIER end)
    end)
    for _, tr in ipairs(a:GetPlayingAnimationTracks()) do
        if savedAnimSpeeds[tr] == nil then pcall(function() savedAnimSpeeds[tr] = tr.Speed end) end
        pcall(function() tr.Speed = FLAGS_MULTIPLIER end)
    end
end

local function boostParticle(p)
    local m = FLAGS_MULTIPLIER
    if boostedParticles[p] then
        local o = boostedParticles[p]
        pcall(function()
            p.Rate = o.rate * m
            p.Speed = NumberRange.new(o.sMin * m, o.sMax * m)
            p.Lifetime = NumberRange.new(o.lMin / m, o.lMax / m)
        end)
        return
    end
    local o = { rate = p.Rate, sMin = p.Speed.Min, sMax = p.Speed.Max, lMin = p.Lifetime.Min, lMax = p.Lifetime.Max }
    boostedParticles[p] = o
    pcall(function()
        p.Rate = o.rate * m
        p.Speed = NumberRange.new(o.sMin * m, o.sMax * m)
        p.Lifetime = NumberRange.new(o.lMin / m, o.lMax / m)
    end)
end

local function replaceJumpSound(o)
    if not o or not o.Parent or not looksLikeJumpSound(o) then return end
    if replacedJumpSounds[o] == nil then
        replacedJumpSounds[o] = { id = o.SoundId, name = o.Name, volume = o.Volume }
    end
    pcall(function()
        o.SoundId = JUMP_SOUND_NEW
        o.Name = "SealDevJump"
        o.Volume = 0.5
        o:SetAttribute("SealDevJump", true)
    end)
end

local function scanJumpSounds(r)
    if not r then return end
    for _, o in ipairs(r:GetDescendants()) do
        if o:IsA("Sound") and looksLikeJumpSound(o) then replaceJumpSound(o) end
    end
end

local function watch(c) table.insert(flagsWatchers, c); return c end

local function flagsStart()
    if MyPlayer.Character then scanJumpSounds(MyPlayer.Character) end
    for _, p in ipairs(PlayersService:GetPlayers()) do
        if p.Character then scanJumpSounds(p.Character) end
    end
    watch(WorkspaceService.DescendantAdded:Connect(function(o)
        if not S.FlagsOn then return end
        if o:IsA("Animator") then boostAnimator(o)
        elseif o:IsA("ParticleEmitter") then boostParticle(o)
        elseif o:IsA("Sound") and looksLikeJumpSound(o) then replaceJumpSound(o) end
    end))
    watch(MyPlayer.CharacterAdded:Connect(function(c)
        task.wait(0.5); if not S.FlagsOn then return end
        scanJumpSounds(c)
        local a = c:FindFirstChildOfClass("Animator"); if a then boostAnimator(a) end
    end))
    for _, p in ipairs(PlayersService:GetPlayers()) do
        watch(p.CharacterAdded:Connect(function(c)
            task.wait(0.5); if not S.FlagsOn then return end
            scanJumpSounds(c)
            local a = c:FindFirstChildOfClass("Animator"); if a then boostAnimator(a) end
        end))
    end
    watch(PlayersService.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(c)
            task.wait(0.5); if not S.FlagsOn then return end
            scanJumpSounds(c)
            local a = c:FindFirstChildOfClass("Animator"); if a then boostAnimator(a) end
        end)
    end))
    for _, o in ipairs(WorkspaceService:GetDescendants()) do
        if o:IsA("Animator") then boostAnimator(o)
        elseif o:IsA("ParticleEmitter") then boostParticle(o)
        elseif o:IsA("Sound") and looksLikeJumpSound(o) then replaceJumpSound(o) end
    end
    task.spawn(function()
        while S.FlagsOn do
            task.wait(1)
            local c = MyPlayer.Character
            if c then
                for _, o in ipairs(c:GetDescendants()) do
                    if o:IsA("Sound") and looksLikeJumpSound(o) and o.SoundId ~= JUMP_SOUND_NEW then
                        replaceJumpSound(o)
                    end
                end
            end
        end
    end)
end

local function flagsStop()
    for _, c in ipairs(flagsWatchers) do pcall(function() c:Disconnect() end) end
    flagsWatchers = {}
    for a, c in pairs(boostedAnimators) do pcall(function() c:Disconnect() end) end
    boostedAnimators = setmetatable({}, { __mode = "k" })
    for p, o in pairs(boostedParticles) do
        if p and p.Parent then
            pcall(function()
                p.Rate = o.rate
                p.Speed = NumberRange.new(o.sMin, o.sMax)
                p.Lifetime = NumberRange.new(o.lMin, o.lMax)
            end)
        end
    end
    boostedParticles = setmetatable({}, { __mode = "k" })
    for tr, orig in pairs(savedAnimSpeeds) do
        pcall(function() if tr then tr.Speed = orig or 1 end end)
    end
    savedAnimSpeeds = setmetatable({}, { __mode = "k" })
    for s, o in pairs(replacedJumpSounds) do
        if s and s.Parent then
            pcall(function()
                s.SoundId = o.id
                s.Name = o.name
                s.Volume = o.volume
                s:SetAttribute("SealDevJump", nil)
            end)
        end
    end
    replacedJumpSounds = setmetatable({}, { __mode = "k" })
end

local function restoreAllHitboxes()
    for _, o in ipairs(PlayersService:GetPlayers()) do
        if o ~= MyPlayer and o.Character then
            local r = o.Character:FindFirstChild("HumanoidRootPart")
            if r then pcall(function() r.Size = Vector3.new(2, 2, 1) end) end
        end
    end
    for _, b in ipairs(HitboxFolder:GetChildren()) do pcall(function() b:Destroy() end) end
end

-- ============================================================
-- UI: MAIN
-- ============================================================
local MainPage = Hub:Tab({ Title = "Main", Icon = "layout-dashboard", Locked = false })

MainPage:Button({
    Title = "Join Discord",
    Desc = "discord.gg/xhn6WaHzs5",
    Icon = "message-circle",
    Callback = function()
        pcall(setclipboard, DISCORD_LINK)
        Notify("Discord link copied to clipboard!")
    end,
})

MainPage:Toggle({
    Title = "No Match Cooldown", Default = false,
    Callback = function(v)
        AnchorRelease = v
        if v and MyPlayer.Character then
            local body = MyPlayer.Character
            local root = body:FindFirstChild("HumanoidRootPart")
            local hp = body:FindFirstChildOfClass("Humanoid")
            if root and hp then
                local loop
                loop = RunServiceRef.Heartbeat:Connect(function()
                    if not body.Parent or hp.Health <= 0 or not AnchorRelease then loop:Disconnect(); return end
                    if root.Anchored then root.Anchored = false end
                end)
            end
        end
    end,
})

MainPage:Toggle({
    Title = "No Gun Cooldown", Default = false,
    Callback = function(v)
        S.CooldownOff = v
        if v then
            S.CooldownSaves = {}
            Notify("Gun cooldown stripper ON")
        else
            RestoreSaves(S.CooldownSaves)
            S.CooldownSaves = {}
            Notify("Gun cooldown stripper OFF")
        end
    end,
})

MainPage:Toggle({
    Title = "Hitbox Expander", Default = false,
    Callback = function(v)
        S.HitboxOn = v
        if v then
            Notify("Hitbox ON")
        else
            restoreAllHitboxes()
            Notify("Hitbox OFF")
        end
    end,
})

MainPage:Toggle({
    Title = "Show Hitboxes", Icon = "eye", Default = false,
    Callback = function(v)
        S.HitboxShow = v
        for _, b in ipairs(HitboxFolder:GetChildren()) do
            pcall(function() b.Visible = v end)
        end
    end,
})

MainPage:Slider({
    Title = "Hitbox Size", Step = 1,
    Value = { Min = 3, Max = 30, Default = 8 },
    Callback = function(v) S.HitboxSize = v end,
})

MainPage:Colorpicker({
    Title = "Hitbox Color", Default = Color3.fromRGB(255, 0, 0), Transparency = 0,
    Callback = function(c) S.HitboxColor = c end,
})

task.spawn(function()
    while task.wait(0.1) do
        if S.HitboxOn and not S.GuiHidden then
            local s = Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize)
            local es = S.EnemySet
            for _, o in ipairs(PlayersService:GetPlayers()) do
                if o ~= MyPlayer and o.Character then
                    local r = o.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        if es[o.UserId] and not isTeammate(o) then
                            if r.Size ~= s then r.Size = s end
                            local b = HitboxFolder:FindFirstChild(o.Name)
                            if not b then
                                b = Instance.new("BoxHandleAdornment")
                                b.Name = o.Name
                                b.Adornee = r
                                b.AlwaysOnTop = true
                                b.ZIndex = 10
                                b.Color3 = S.HitboxColor
                                b.Transparency = 0.7
                                b.Visible = S.HitboxShow
                                b.Size = s
                                b.Parent = HitboxFolder
                            else
                                b.Adornee = r
                                b.Size = s
                                b.Visible = S.HitboxShow
                            end
                        else
                            if r.Size ~= Vector3.new(2, 2, 1) then r.Size = Vector3.new(2, 2, 1) end
                            local b = HitboxFolder:FindFirstChild(o.Name)
                            if b then b:Destroy() end
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- KILL ALL
-- ============================================================
local KillPage = Hub:Tab({ Title = "Kill All", Icon = "skull", Locked = false })
local GunSection = KillPage:Section({ Title = "Gun", Opened = true })

local GUN_KILL_COOLDOWN = 0.06
local GUN_KILL_INTERVAL = 0.015
local gunKillOn = false
local lastGunShot = {}

local function killAllWithGunOnce()
    if not S.InMatch then Notify("Not in match") return end
    if not FindGun() then Notify("No gun in inventory!") return end
    equipGun()
    lastGunShot = {}
    local targets = {}
    for _, o in ipairs(PlayersService:GetPlayers()) do
        if o ~= MyPlayer and not isTeammate(o) and o.Character then
            local h = o.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                targets[#targets + 1] = o
            end
        end
    end
    for _, plr in ipairs(targets) do
        local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local origin = MyPlayer.Character and MyPlayer.Character:FindFirstChild("HumanoidRootPart")
        if origin and target then
            local sg = RemoteFolder and RemoteFolder:FindFirstChild("ShootGun")
            if sg then
                pcall(function()
                    sg:FireServer(origin.Position, target.Position, target, target.Position)
                end)
            end
        end
    end
    Notify("Gun burst sent (" .. #targets .. ")")
end

GunSection:Button({
    Title = "Kill all players once",
    Callback = function() killAllWithGunOnce() end,
})

GunSection:Toggle({
    Title = "Auto kill players (Gun)",
    Desc = "Fast mode - kills every enemy at 0.015s",
    Default = false,
    Callback = function(v)
        gunKillOn = v
        if v then
            lastGunShot = {}
            task.spawn(function()
                while gunKillOn do
                    if S.InMatch and not S.GuiHidden then
                        equipGun()
                        local origin = MyPlayer.Character and MyPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if origin then
                            for _, o in ipairs(S.EnemyList) do
                                if not isTeammate(o) then
                                    local c = o.Character
                                    if c then
                                        local h = c:FindFirstChildOfClass("Humanoid")
                                        local target = c:FindFirstChild("HumanoidRootPart")
                                        if h and h.Health > 0 and target then
                                            local last = lastGunShot[o]
                                            if not last or tick() - last >= GUN_KILL_COOLDOWN then
                                                lastGunShot[o] = tick()
                                                local sg = RemoteFolder and RemoteFolder:FindFirstChild("ShootGun")
                                                if sg then
                                                    pcall(function()
                                                        sg:FireServer(origin.Position, target.Position, target, target.Position)
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(GUN_KILL_INTERVAL)
                end
            end)
            Notify("Auto Gun Kill ON (fast 0.015s)")
        else
            Notify("Auto Gun Kill OFF")
        end
    end,
})

-- ============================================================
-- KILL MODE (стелс, только пест в руках)
-- ============================================================
local KillModeSection = KillPage:Section({ Title = "Kill Mode", Opened = true })

local killModeOn = false
local killModeCooldown = 0.05
local killModeLastFire = {}

local BODY_PRIORITY = {
    Head = 1, UpperTorso = 2, Torso = 2, LowerTorso = 3,
    HumanoidRootPart = 99,
}

local function getAllBodyParts(char)
    local parts = {}
    for _, p in ipairs(char:GetChildren()) do
        if p:IsA("BasePart") then parts[#parts + 1] = p end
    end
    table.sort(parts, function(a, b)
        return (BODY_PRIORITY[a.Name] or 10) < (BODY_PRIORITY[b.Name] or 10)
    end)
    return parts
end

local function losToPart(fromPos, targetChar, targetPart)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { MyPlayer.Character, targetChar }
    params.IgnoreWater = true
    local dir = targetPart.Position - fromPos
    if dir.Magnitude < 0.1 then return true end
    local res = WorkspaceService:Raycast(fromPos, dir, params)
    return res == nil
end

local function findAnyVisiblePart(myChar, targetChar)
    local myHead = myChar:FindFirstChild("Head")
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHead and not myHRP then return nil end
    for _, part in ipairs(getAllBodyParts(targetChar)) do
        if part and part.Parent then
            if myHead and losToPart(myHead.Position, targetChar, part) then return part end
            if myHRP and losToPart(myHRP.Position, targetChar, part) then return part end
        end
    end
    return nil
end

KillModeSection:Toggle({
    Title = "Kill Mode",
    Desc = "Only fires when YOU hold the gun. Any visible body part — even a finger.",
    Default = false,
    Callback = function(v)
        killModeOn = v
        if v then
            killModeLastFire = {}
            if not getEquippedGun() then
                Notify("Equip the gun in your hands first!")
            end
        end
        Notify(v and "Kill Mode ON" or "Kill Mode OFF")
    end,
})

KillModeSection:Slider({
    Title = "Cooldown (s)", Step = 0.01,
    Value = { Min = 0.01, Max = 1, Default = 0.05 },
    Callback = function(v) killModeCooldown = v end,
})

task.spawn(function()
    while true do
        if killModeOn and S.InMatch and not S.GuiHidden then
            local gun = getEquippedGun()
            if gun then
                local myChar = MyPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    for _, o in ipairs(S.EnemyList) do
                        if not isTeammate(o) then
                            local last = killModeLastFire[o] or 0
                            if tick() - last >= killModeCooldown then
                                local tChar = o.Character
                                if tChar then
                                    local tHum = tChar:FindFirstChildOfClass("Humanoid")
                                    if tHum and tHum.Health > 0 and not CollectionServiceRef:HasTag(tChar, "Invulnerable") then
                                        local part = findAnyVisiblePart(myChar, tChar)
                                        if part then
                                            local sg = RemoteFolder and RemoteFolder:FindFirstChild("ShootGun")
                                            if sg then
                                                pcall(function()
                                                    sg:FireServer(myHRP.Position, part.Position, part, part.Position)
                                                end)
                                                killModeLastFire[o] = tick() + math.random() * 0.01
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)

-- ============================================================
-- FARM
-- ============================================================
local farmGroups = { DuelRing_1v1 = 1, DuelRing_2v2 = 2, DuelRing_3v3 = 3, DuelRing_4v4 = 4 }
local farmLobby, lastJumpTime, currentFarmPad

local function getLobby()
    if farmLobby and farmLobby.Parent then return farmLobby end
    farmLobby = WorkspaceService:FindFirstChild("Lobby")
    return farmLobby
end

local function farmFindPad()
    local lobby = getLobby(); if not lobby then return nil end
    local dg = lobby:FindFirstChild("DuelRingsGroup"); if not dg then return nil end
    for g, mps in pairs(farmGroups) do
        local rf = dg:FindFirstChild(g)
        if rf then
            local tp, mp = 0, mps * 2
            local fp = {}
            for _, mo in ipairs(rf:GetChildren()) do
                if mo:IsA("Model") and mo.Name == "DuelPad" and mo.PrimaryPart then
                    local c = mo:GetAttribute("CharacterCount") or 0
                    tp = tp + c
                    if c < mps then table.insert(fp, { model = mo, count = c }) end
                end
            end
            if tp == mp - 1 and #fp > 0 then
                table.sort(fp, function(a, b) return a.count < b.count end)
                return fp[1].model
            end
        end
    end
    local o = dg:FindFirstChild("DuelRing_1v1")
    if o then
        for _, mo in ipairs(o:GetChildren()) do
            if mo:IsA("Model") and mo.Name == "DuelPad" and mo.PrimaryPart then
                if (mo:GetAttribute("CharacterCount") or 0) == 0 then return mo end
            end
        end
    end
end

local function farmWalkTo(mo)
    if not mo or not mo.PrimaryPart then return false end
    local c = MyPlayer.Character; if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return false end
    local t = mo.PrimaryPart.Position
    if (r.Position - t).Magnitude <= 6 then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
        return true
    end
    h.WalkSpeed = S.FarmWalkSpeed
    h:MoveTo(t)
    if os.clock() - (lastJumpTime or 0) >= 2 then
        pcall(function() h.Jump = true end)
        lastJumpTime = os.clock()
    end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
    return false
end

local function farmDisable()
    currentFarmPad = nil
    stopDance()
    disableAntiAfk()
    local h = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h.WalkSpeed = DEFAULT_WALKSPEED end) end
    for _, p in ipairs((MyPlayer.Character and MyPlayer.Character:GetDescendants()) or {}) do
        if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
    end
end

local FarmPage = Hub:Tab({ Title = "Farm", Icon = "wheat", Locked = false })
FarmPage:Toggle({
    Title = "Auto Farm", Desc = "Kills every 0.01s + tp 600 back", Default = false,
    Callback = function(v)
        S.FarmOn = v
        if v then
            currentFarmPad = nil
            S.LastDance = 0
            S.FarmRoundStart = 0
            S.FarmLastMatchState = false
            S.FarmTeleported = false
            S.CachedKnife = nil
            enableAntiAfk()
            Notify("Farm ON: kill every 0.01s + tp 600")
        else
            farmDisable()
            Notify("Farm OFF")
        end
    end,
})
FarmPage:Slider({
    Title = "Walk Speed to Pad", Step = 1,
    Value = { Min = 16, Max = 100, Default = 40 },
    Callback = function(v) S.FarmWalkSpeed = v end,
})

task.spawn(function()
    while task.wait(0.01) do
        if S.FarmOn and not S.GuiHidden then
            local inMatchNow = S.InMatch
            if inMatchNow and not S.FarmLastMatchState then
                S.FarmRoundStart = tick()
                S.FarmTeleported = false
                S.CachedKnife = nil
            end
            S.FarmLastMatchState = inMatchNow
            if inMatchNow then
                currentFarmPad = nil
                if tick() - S.LastDance >= 5 then
                    playDance(); S.LastDance = tick()
                end
                if not S.FarmTeleported then
                    local hrp = MyPlayer.Character and MyPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local backDir = -hrp.CFrame.LookVector
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        rayParams.FilterDescendantsInstances = { MyPlayer.Character }
                        rayParams.IgnoreWater = true
                        local result = WorkspaceService:Raycast(hrp.Position, backDir * 600, rayParams)
                        local dist = 600
                        if result then
                            dist = math.max(5, (result.Position - hrp.Position).Magnitude - 3)
                        end
                        hrp.CFrame = hrp.CFrame + backDir * dist
                    end
                    S.FarmTeleported = true
                end
                if not S.CachedKnife or not S.CachedKnife.Parent then
                    S.CachedKnife = FindKnife()
                end
                EquipTool(S.CachedKnife)
                for _, o in ipairs(S.EnemyList) do
                    if not isTeammate(o) then
                        local c = o.Character
                        if c then
                            local h = c:FindFirstChildOfClass("Humanoid")
                            if h and h.Health > 0 then
                                local target = c:FindFirstChild("HumanoidRootPart")
                                if target then
                                    local knifeRemote = RemoteFolder and RemoteFolder:FindFirstChild("ThrowHit")
                                    if knifeRemote then
                                        pcall(function() knifeRemote:FireServer(target, target.Position) end)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if S.DanceTrack then stopDance() end
                if not currentFarmPad or not currentFarmPad.Parent then currentFarmPad = farmFindPad() end
                if currentFarmPad then farmWalkTo(currentFarmPad) end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if S.FarmOn and S.InMatch and not S.GuiHidden then
            if not S.DanceTrack or not S.DanceTrack.IsPlaying then playDance() end
        end
    end
end)

-- ============================================================
-- ESP
-- ============================================================
local EspPage = Hub:Tab({ Title = "ESP", Icon = "eye", Locked = false })
EspPage:Toggle({
    Title = "Chams", Default = false,
    Callback = function(v)
        S.CharmESP = v
        if not v then
            for _, c in ipairs(CharmFolder:GetChildren()) do c:Destroy() end
            return
        end
        task.spawn(function()
            while S.CharmESP do
                if not S.GuiHidden then
                    for _, o in ipairs(S.EnemyList) do
                        if o.Character and not isTeammate(o) then
                            local m = CharmFolder:FindFirstChild(o.Name)
                            if not m then
                                m = Instance.new("Highlight")
                                m.Name = o.Name
                                m.FillTransparency = 0.55
                                m.OutlineTransparency = 0.35
                                m.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                m.Parent = CharmFolder
                            end
                            local t = (o.Team == MyPlayer.Team) and S.MateColor or S.FoeColor
                            m.FillColor = t
                            m.OutlineColor = t
                            m.Adornee = o.Character
                        end
                    end
                end
                task.wait(0.25)
            end
        end)
    end,
})
EspPage:Toggle({
    Title = "Names", Default = false,
    Callback = function(v)
        S.NameESP = v
        if not v then
            for _, c in ipairs(NameFolder:GetChildren()) do c:Destroy() end
            return
        end
        task.spawn(function()
            while S.NameESP do
                if not S.GuiHidden then
                    for _, o in ipairs(S.EnemyList) do
                        if not isTeammate(o) then
                            local b = o.Character
                            local t = NameFolder:FindFirstChild(o.Name)
                            if b and b:FindFirstChild("Head") and b:FindFirstChildOfClass("Humanoid") and b.Humanoid.Health > 0 then
                                if not t then
                                    t = Instance.new("BillboardGui")
                                    t.Name = o.Name
                                    t.Size = UDim2.fromOffset(180, 34)
                                    t.StudsOffset = Vector3.new(0, 2.6, 0)
                                    t.AlwaysOnTop = true
                                    t.Parent = NameFolder
                                    local l = Instance.new("TextLabel")
                                    l.Name = "name"
                                    l.BackgroundTransparency = 1
                                    l.Size = UDim2.new(1, 0, 1, 0)
                                    l.Font = Enum.Font.GothamBold
                                    l.TextScaled = true
                                    l.TextStrokeTransparency = 0.3
                                    l.TextColor3 = Color3.new(1, 1, 1)
                                    l.Parent = t
                                end
                                t.Adornee = b.Head
                                local tint = (o.Team == MyPlayer.Team) and S.MateColor or S.FoeColor
                                local l = t:FindFirstChild("name")
                                if l then l.Text = o.Name; l.TextColor3 = tint end
                            elseif t then
                                t:Destroy()
                            end
                        end
                    end
                end
                task.wait(0.25)
            end
        end)
    end,
})
local TracerConn
EspPage:Toggle({
    Title = "Tracers", Default = false,
    Callback = function(v)
        S.TracerESP = v
        if TracerConn then TracerConn:Disconnect(); TracerConn = nil end
        if not v then
            for _, c in ipairs(TracerFolder:GetChildren()) do c:Destroy() end
            return
        end
        TracerConn = RunServiceRef.RenderStepped:Connect(function()
            if not S.TracerESP or S.GuiHidden then return end
            local r = MyPlayer.Character and MyPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not r then return end
            for _, o in ipairs(S.EnemyList) do
                if not isTeammate(o) then
                    local b = o.Character
                    local l = TracerFolder:FindFirstChild(o.Name)
                    if b and b:FindFirstChild("HumanoidRootPart") and b:FindFirstChildOfClass("Humanoid") and b.Humanoid.Health > 0 then
                        if not l then
                            l = Instance.new("LineHandleAdornment")
                            l.Name = o.Name
                            l.Thickness = 1.5
                            l.ZIndex = 10
                            l.AlwaysOnTop = true
                            l.Parent = TracerFolder
                        end
                        local tint = (o.Team == MyPlayer.Team) and S.MateColor or S.FoeColor
                        l.Color3 = tint
                        l.Adornee = WorkspaceService.Terrain
                        l.CFrame = CFrame.lookAt(r.Position, b.HumanoidRootPart.Position)
                        l.Length = (r.Position - b.HumanoidRootPart.Position).Magnitude
                    elseif l then
                        l:Destroy()
                    end
                end
            end
        end)
    end,
})
EspPage:Colorpicker({
    Title = "Teammate Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0,
    Callback = function(c) S.MateColor = c end,
})
EspPage:Colorpicker({
    Title = "Enemy Color", Default = Color3.fromRGB(0, 0, 0), Transparency = 0,
    Callback = function(c) S.FoeColor = c end,
})

-- ============================================================
-- MOVEMENT
-- ============================================================
local noclipConn = nil
local noclipOriginalCollide = {}

local MovePage = Hub:Tab({ Title = "Movement", Icon = "footprints", Locked = false })

MovePage:Toggle({
    Title = "Noclip", Default = false,
    Callback = function(v)
        S.NoclipOn = v
        if v then
            noclipConn = RunServiceRef.Stepped:Connect(function()
                if not S.NoclipOn then return end
                local b = MyPlayer.Character
                if b then
                    for _, p in ipairs(b:GetDescendants()) do
                        if p:IsA("BasePart") then
                            if noclipOriginalCollide[p] == nil then noclipOriginalCollide[p] = p.CanCollide end
                            p.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
            for part, val in pairs(noclipOriginalCollide) do
                if part and part.Parent then pcall(function() part.CanCollide = val end) end
            end
            noclipOriginalCollide = {}
            local b = MyPlayer.Character
            if b then
                for _, p in ipairs(b:GetDescendants()) do
                    if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
                end
            end
        end
    end,
})

MovePage:Toggle({
    Title = "Speed Changer", Default = false,
    Callback = function(v)
        S.SpeedOn = v
        if v then
            rememberHumanoidDefaults()
            task.spawn(function()
                while S.SpeedOn do
                    local h = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.WalkSpeed ~= S.SpeedValue then h.WalkSpeed = S.SpeedValue end
                    task.wait(0.2)
                end
            end)
        else
            local h = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = SavedState.WalkSpeed or DEFAULT_WALKSPEED end
        end
    end,
})

MovePage:Slider({
    Title = "Walk Speed", Step = 1,
    Value = { Min = 16, Max = 250, Default = 32 },
    Callback = function(v)
        S.SpeedValue = v
        if S.SpeedOn then
            local h = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = v end
        end
    end,
})

-- ============================================================
-- AIMBOT + TRIGGERBOT UI
-- ============================================================
local AimbotPage = Hub:Tab({ Title = "Aimbot", Icon = "crosshair", Locked = false })

AimbotPage:Section({ Title = "Aimbot" })
AimbotPage:Toggle({
    Title = "Aimbot (RMB)",
    Desc = "Hold RMB to lock camera onto nearest enemy inside FOV",
    Default = false,
    Callback = function(v)
        S.AimbotOn = v
        updateFovCircle()
        Notify(v and "Aimbot ON" or "Aimbot OFF")
    end,
})
AimbotPage:Slider({
    Title = "Aimbot FOV", Step = 1,
    Value = { Min = 65, Max = 1000, Default = 200 },
    Callback = function(v) S.AimbotFOV = v; updateFovCircle() end,
})
AimbotPage:Slider({
    Title = "Aimbot Smoothness", Step = 0.01,
    Value = { Min = 0.05, Max = 1, Default = 0.35 },
    Callback = function(v) S.AimbotSmoothness = v end,
})
AimbotPage:Toggle({
    Title = "Show FOV Circle",
    Default = false,
    Callback = function(v) S.AimbotShowFOV = v; updateFovCircle() end,
})

AimbotPage:Section({ Title = "TriggerBot" })
AimbotPage:Toggle({
    Title = "TriggerBot",
    Desc = "Only works when YOU hold the gun. Shoots any part of an enemy.",
    Default = false,
    Callback = function(v)
        S.TriggerOn = v
        if v and not getEquippedGun() then
            Notify("Equip the gun in your hands first!")
        end
        Notify(v and "TriggerBot ON" or "TriggerBot OFF")
    end,
})
AimbotPage:Slider({
    Title = "TriggerBot Cooldown", Step = 0.1,
    Value = { Min = 0, Max = 3, Default = 1 },
    Callback = function(v) S.TriggerCD = v end,
})

-- ============================================================
-- MISC
-- ============================================================
local MiscPage = Hub:Tab({ Title = "Misc", Icon = "wrench", Locked = false })

MiscPage:Toggle({
    Title = "Flags", Desc = "Kill Effect Speed x4.5 + custom jump sound", Default = false,
    Callback = function(v)
        S.FlagsOn = v
        if v then flagsStart(); Notify("Flags ON")
        else flagsStop(); Notify("Flags OFF") end
    end,
})

MiscPage:Toggle({
    Title = "Anti-Exploiter",
    Desc = "Random position shifts to break enemy hit-reg (match only)",
    Default = false,
    Callback = function(v)
        S.AntiExploiterOn = v
        Notify(v and "Anti-Exploiter ON" or "Anti-Exploiter OFF")
    end,
})

MiscPage:Slider({
    Title = "Anti-Exploiter Force (studs)", Step = 0.5,
    Value = { Min = 1, Max = 8, Default = 3 },
    Callback = function(v) S.AntiExploiterForce = v end,
})

-- Anti-Lag
local antiLagConnection = nil
local antiLagActive = false
local antiLagProcessed = setmetatable({}, { __mode = "k" })

local KNIFE_NAMES = {
    "knife", "thrownknife", "projectile", "dagger", "throw",
    "cleaver", "tomahawk", "shuriken", "snowball", "arrow",
    "spear", "axe", "hatchet", "kunai", "shank", "blade"
}
local GUN_EFFECT_NAMES = {
    "muzzle", "flash", "muzzleflash", "bullet", "tracer",
    "gun", "revolver", "pistol", "shot", "impact", "hit",
    "beam", "ray", "casing", "shell"
}

local function lower(s) return string.lower(s) end

local function isGunEffectByName(name)
    name = lower(name)
    for i = 1, #GUN_EFFECT_NAMES do
        if string.find(name, GUN_EFFECT_NAMES[i], 1, true) then return true end
    end
    return false
end

local function isKnife(inst)
    if not inst or not inst.Parent then return false end
    local name = lower(inst.Name)
    if isGunEffectByName(name) then return false end
    for i = 1, #KNIFE_NAMES do
        if string.find(name, KNIFE_NAMES[i], 1, true) then return true end
    end
    if inst:GetAttribute("IsKnife") == true then return true end
    if inst:GetAttribute("ProjectileOwner") ~= nil then return true end
    return false
end

local function isMine(obj)
    if not obj then return false end
    if obj:GetAttribute("SealDevMine") == true then return true end
    local myChar = MyPlayer.Character
    if myChar and obj:IsDescendantOf(myChar) then return true end
    local backpack = MyPlayer:FindFirstChildOfClass("Backpack")
    if backpack and obj:IsDescendantOf(backpack) then return true end
    local owner = obj:GetAttribute("ProjectileOwner") or obj:GetAttribute("Owner")
    if owner == MyPlayer or owner == MyPlayer.UserId or owner == MyPlayer.Name then return true end
    return false
end

local function isGunSoundOrEffect(obj)
    if not obj then return false end
    if obj:IsA("Sound") then
        local n = lower(obj.Name)
        if n == "fire" or n == "shot" or n == "shoot" or n == "gunshot"
           or string.find(n, "fire", 1, true)
           or string.find(n, "shot", 1, true)
           or string.find(n, "shoot", 1, true)
           or string.find(n, "gun", 1, true)
           or string.find(n, "reload", 1, true) then
            return true
        end
    end
    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
        if isGunEffectByName(obj.Name) then return true end
    end
    return false
end

local function processOne(obj)
    if not antiLagActive then return end
    if not obj or not obj.Parent then return end
    if antiLagProcessed[obj] then return end
    antiLagProcessed[obj] = true
    if isMine(obj) then return end
    if isGunSoundOrEffect(obj) then return end
    if isKnife(obj) then
        if not isMine(obj) then pcall(function() obj:Destroy() end) end
        return
    end
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        pcall(function() obj.Enabled = false end)
        return
    end
    if obj:IsA("BasePart") then
        local model = obj:FindFirstAncestorOfClass("Model")
        if not (model and model:FindFirstChildOfClass("Humanoid")) then
            pcall(function()
                if obj.CastShadow then obj.CastShadow = false end
                if obj.Material ~= Enum.Material.SmoothPlastic then obj.Material = Enum.Material.SmoothPlastic end
                if obj.Reflectance > 0 then obj.Reflectance = 0 end
            end)
        end
    end
end

local function antiLagOn()
    if antiLagActive then return end
    antiLagActive = true
    if antiLagConnection then pcall(function() antiLagConnection:Disconnect() end) end
    antiLagConnection = WorkspaceService.DescendantAdded:Connect(function(obj)
        if not antiLagActive then return end
        task.defer(function() processOne(obj) end)
    end)
    task.spawn(function()
        task.wait(0.5)
        if not antiLagActive then return end
        local count = 0
        for _, obj in ipairs(WorkspaceService:GetDescendants()) do
            if not antiLagActive then return end
            processOne(obj)
            count = count + 1
            if count % 500 == 0 then task.wait() end
        end
    end)
end

local function antiLagOff()
    antiLagActive = false
    if antiLagConnection then
        pcall(function() antiLagConnection:Disconnect() end)
        antiLagConnection = nil
    end
    antiLagProcessed = setmetatable({}, { __mode = "k" })
end

pcall(function()
    getgenv().SealDevAntiLagOff = antiLagOff
end)

local antiLagToggle = MiscPage:Toggle({
    Title = "Anti-Lag",
    Desc = "Blocks enemy lag/crash. Your gun & knife effects stay visible.",
    Default = false,
    Callback = function(v)
        if v then antiLagOn(); Notify("Anti-Lag ON")
        else antiLagOff(); Notify("Anti-Lag OFF") end
    end,
})

task.spawn(function()
    task.wait(1.5)
    pcall(function()
        if antiLagToggle and typeof(antiLagToggle) == "table" and antiLagToggle.Set then
            antiLagToggle:Set(false)
        end
    end)
    antiLagOff()
end)

-- ============================================================
-- HIDE GUI (J)
-- ============================================================
local savedGuiStates = {}
local function GatherGuis()
    local l = {}
    for _, o in ipairs(CoreGuiRef:GetDescendants()) do
        if o:IsA("ScreenGui") then table.insert(l, o) end
    end
    return l
end
local function WipeVisuals()
    savedGuiStates = {}
    for _, g in ipairs(GatherGuis()) do
        savedGuiStates[g] = g.Enabled
        pcall(function() g.Enabled = false end)
    end
    for _, o in ipairs(CoreGuiRef:GetDescendants()) do
        if o:IsA("GuiObject") then
            local n = o.Name
            if n == "Open SealDev" or n == "SealDev" or n:find("SealDev") then o.Visible = false end
        end
    end
    for _, f in ipairs({ CharmFolder, TracerFolder, NameFolder, HitboxFolder }) do
        for _, o in ipairs(f:GetChildren()) do
            pcall(function() o.Enabled = false end)
            pcall(function() o.Visible = false end)
        end
    end
end
local function RestoreVisuals()
    for g, w in pairs(savedGuiStates) do
        if g and g.Parent then pcall(function() g.Enabled = w end) end
    end
    savedGuiStates = {}
    for _, o in ipairs(CoreGuiRef:GetDescendants()) do
        if o:IsA("GuiObject") then
            local n = o.Name
            if n == "Open SealDev" or n == "SealDev" or n:find("SealDev") then o.Visible = true end
        end
    end
    for _, f in ipairs({ CharmFolder, TracerFolder, NameFolder }) do
        for _, o in ipairs(f:GetChildren()) do
            pcall(function() o.Enabled = true end)
            pcall(function() o.Visible = true end)
        end
    end
    for _, o in ipairs(HitboxFolder:GetChildren()) do
        pcall(function() o.Visible = S.HitboxShow end)
    end
end

UserInputServiceRef.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.J then
        S.GuiHidden = not S.GuiHidden
        if S.GuiHidden then WipeVisuals() else RestoreVisuals() end
    end
end)

-- ============================================================
-- DESTROY
-- ============================================================
pcall(function()
    Hub:OnDestroy(function()
        _G.SealDevV27Loaded = nil
        gunKillOn = false
        killModeOn = false
        S.FarmOn = false
        S.SpeedOn = false
        S.NoclipOn = false
        S.FlagsOn = false
        S.AimbotOn = false
        S.TriggerOn = false
        S.HitboxOn = false
        S.CooldownOff = false
        S.AntiExploiterOn = false
        S.CharmESP = false
        S.TracerESP = false
        S.NameESP = false
        AnchorRelease = false
        pcall(function() antiLagOff() end)
        pcall(function() farmDisable() end)
        pcall(function() restoreAllHitboxes() end)
        pcall(function() restoreHumanoidDefaults() end)
        pcall(function()
            if noclipConn then noclipConn:Disconnect() end
            for part, val in pairs(noclipOriginalCollide) do
                if part and part.Parent then part.CanCollide = val end
            end
        end)
        pcall(function()
            for _, f in ipairs({ CharmFolder, TracerFolder, NameFolder, HitboxFolder }) do
                f:ClearAllChildren()
            end
        end)
        pcall(function() if TracerConn then TracerConn:Disconnect() end end)
        pcall(function() if aimbotConn then aimbotConn:Disconnect() end end)
        pcall(function() if antiAfkConn then antiAfkConn:Disconnect() end end)
        pcall(function() if triggerbot_conn then triggerbot_conn:Disconnect() end end)
        pcall(function() stopDance() end)
        pcall(function() fovGui:Destroy() end)
    end)
end)

pcall(function()
    UI:AddTheme({
        Name = "sealdev",
        Accent = Color3.fromHex("#8a63ff"),
        Background = Color3.fromHex("#0d0d12"),
        Text = Color3.fromHex("#e7eefc"),
        Button = Color3.fromHex("#171722"),
        Icon = Color3.fromHex("#a3b8e8"),
        Hover = Color3.fromHex("#8a63ff"),
        Toggle = Color3.fromHex("#171722"),
        ToggleBar = Color3.fromHex("#8a63ff"),
        Slider = Color3.fromHex("#171722"),
        SliderThumb = Color3.fromHex("#8a63ff"),
    })
    UI:SetTheme("sealdev")
end)

finishLoading()

dbg("ready")
Notify("seal is le goat it took me 2132312 days to make this script 🦭💀💀😮😭💦🤔👍")
