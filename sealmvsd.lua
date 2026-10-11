local loadingGui = nil
do
    local lp = game:GetService("Players").LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")
    local ts = game:GetService("TweenService")

    loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "SealDevLoading"
    loadingGui.ResetOnSpawn = false
    loadingGui.IgnoreGuiInset = true
    loadingGui.DisplayOrder = 999999
    loadingGui.Parent = pg

    local bg = Instance.new("Frame")
    bg.Name = "bg"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = loadingGui

    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Size = UDim2.new(1, 0, 0, 140)
    title.Position = UDim2.new(0.5, 0, 0.5, -70)
    title.BackgroundTransparency = 1
    title.RichText = true
    title.Text = '<font color="rgb(80,150,255)">Seal</font><font color="rgb(255,60,60)">Dev</font>'
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SciFi
    title.TextSize = 110
    title.TextTransparency = 1
    title.Parent = loadingGui

    local loading = Instance.new("TextLabel")
    loading.Name = "loading"
    loading.AnchorPoint = Vector2.new(0.5, 0.5)
    loading.Size = UDim2.new(1, 0, 0, 30)
    loading.Position = UDim2.new(0.5, 0, 0.5, 75)
    loading.BackgroundTransparency = 1
    loading.Text = "Loading..."
    loading.TextColor3 = Color3.fromRGB(180, 180, 180)
    loading.Font = Enum.Font.Gotham
    loading.TextSize = 18
    loading.TextTransparency = 1
    loading.Parent = loadingGui

    ts:Create(bg, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
    task.wait(0.2)
    ts:Create(title, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
    ts:Create(loading, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { TextTransparency = 0.15 }):Play()
end

local function hideLoadingGui()
    if not loadingGui or not loadingGui.Parent then return end
    local ts = game:GetService("TweenService")
    local bg = loadingGui:FindFirstChild("bg")
    local title = loadingGui:FindFirstChild("title")
    local loading = loadingGui:FindFirstChild("loading")
    if title then
        ts:Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { TextTransparency = 1 }):Play()
    end
    if loading then
        ts:Create(loading, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { TextTransparency = 1 }):Play()
    end
    if bg then
        ts:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
    end
    task.delay(0.6, function()
        pcall(function() if loadingGui then loadingGui:Destroy() end end)
    end)
end

if _G.SealDevV27Loaded then
    warn("[SealDev] Already loaded. Set _G.SealDevV27Loaded = nil to reload")
    hideLoadingGui()
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
    hideLoadingGui()
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
        hideLoadingGui()
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
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGuiRef          = game:GetService("CoreGui")
local MyPlayer            = PlayersService.LocalPlayer

local DANCE_R15 = "rbxassetid://507776879"
local DANCE_R6  = "rbxassetid://182435998"
local FLAGS_MULTIPLIER = 4.5
local JUMP_SOUND_NEW   = "rbxassetid://2428506580"

local S = {
    InMatch = false, EnemyList = {}, EnemySet = {},
    CooldownOff = false, CooldownSaves = {},
    HitboxOn = false, HitboxShow = false, HitboxSize = 8,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    CharmESP = false, TracerESP = false, NameESP = false,
    MateColor = Color3.fromRGB(255, 255, 255), FoeColor = Color3.fromRGB(0, 0, 0),
    GuiHidden = false, NoclipOn = false, SpeedOn = false, SpeedValue = 16,
    FlagsOn = false, FarmOn = false, FarmWalkSpeed = 40, LastDance = 0,
    DanceTrack = nil, DanceAnimObj = nil,
    AntiExploiterOn = false, AntiExploiterForce = 3,
    FlickOn = false, FlickSmoothness = 0.9, FlickLastShot = 0, FlickShotCD = 0.7,
    TriggerOn = false, TriggerCD = 0.03, TriggerLastShot = 0,
    AimbotOn = false, AimbotFOV = 200, AimbotShowFOV = false,
    AimbotSmoothness = 0.35,
}

local AnchorRelease = false

local function dbg(m) warn("[SealDev] " .. tostring(m)) end
local function Notify(m) pcall(function() Hub:Notify({ Title = "SealDev", Content = tostring(m), Duration = 2.5, Icon = LOGO }) end) end
dbg("loaded")

local function FindKnife()
    for _, c in ipairs({ MyPlayer:FindFirstChildOfClass("Backpack"), MyPlayer.Character }) do
        if c then
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t:GetAttribute("EquipAnimation") == "Knife_Equip" then return t end
            end
        end
    end
end

local function EquipTool(t)
    if not t then return end
    local b = MyPlayer.Character
    local h = b and b:FindFirstChildOfClass("Humanoid")
    if h and h.Health > 0 then pcall(function() h:EquipTool(t) end) end
end

local RemoteFolder = RS:WaitForChild("Remotes", 10)

local function ThrowKnife(tb)
    local r = tb and tb:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local rem = RemoteFolder and RemoteFolder:FindFirstChild("ThrowHit")
    if not rem then return end
    pcall(function() rem:FireServer(r, r.Position) end)
end

local function hasClearLOS(fromPart, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { MyPlayer.Character, targetChar }
    params.IgnoreWater = true
    local th = targetChar:FindFirstChild("Head")
    if not th then return false end
    local res = WorkspaceService:Raycast(fromPart.Position, th.Position - fromPart.Position, params)
    if res then
        return res.Instance:IsDescendantOf(targetChar)
    end
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

RunServiceRef.RenderStepped:Connect(function()
    if not S.AimbotOn or S.GuiHidden or not S.InMatch then return end
    if not UserInputServiceRef:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local target = getClosestEnemyInFOV()
    if not target then return end
    local cam = WorkspaceService.CurrentCamera
    if not cam then return end
    local goal = CFrame.new(cam.CFrame.Position, target.Position)
    cam.CFrame = cam.CFrame:Lerp(goal, S.AimbotSmoothness)
end)

local function isFirstPerson()
    local cam = WorkspaceService.CurrentCamera
    if not cam then return false end
    local myChar = MyPlayer.Character
    if not myChar then return false end
    local head = myChar:FindFirstChild("Head")
    if not head then return false end
    return (cam.CFrame.Position - head.Position).Magnitude < 1.2
end

local function simulateMouseClick()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
    pcall(function()
        VirtualUserService:CaptureController()
        VirtualUserService:ClickButton1(Vector2.new())
    end)
end



local TriggerMouse = MyPlayer:GetMouse()
local TriggerClicked = false
local TriggerInitialized = false

local function initTriggerbot()
    if TriggerInitialized then return end
    TriggerInitialized = true

    UserInputServiceRef.InputBegan:Connect(function(Input, GameProcessedEvent)
        if GameProcessedEvent then return end
        if Input.KeyCode == Enum.KeyCode.E then
            S.TriggerOn = not S.TriggerOn
            Notify(S.TriggerOn and "TriggerBot ON (E)" or "TriggerBot OFF (E)")
        end
    end)

    RunServiceRef.RenderStepped:Connect(function()
        if not S.TriggerOn or S.GuiHidden then
            if TriggerClicked then
                pcall(function() TriggerMouse:__unlockMouse() end)
                TriggerClicked = false
            end
            return
        end

        local target = TriggerMouse.Target
        if not target then return end

        local parent = target.Parent
        local humanoid = parent and (parent:FindFirstChildOfClass("Humanoid") or (parent.Parent and parent.Parent:FindFirstChildOfClass("Humanoid")))
        local ownerModel = humanoid and humanoid.Parent

        if humanoid and ownerModel and ownerModel.Name ~= MyPlayer.Name and humanoid.Health >= 1 then
            local ownerPlayer = PlayersService:GetPlayerFromCharacter(ownerModel)
            if ownerPlayer and not isTeammate(ownerPlayer) then
                pcall(function()
                    TriggerMouse:__unlockMouse()
                    TriggerMouse.Button1Down:Fire()
                end)
                pcall(function() mouse1press() end)
                TriggerClicked = false
            end
        elseif not TriggerClicked then
            pcall(function() mouse1release() end)
            TriggerClicked = true
        end
    end)
end

initTriggerbot()


MyPlayer.CharacterAdded:Connect(function(body)
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

local flickBindName = "SealDevFlick"
pcall(function() RunServiceRef:UnbindFromRenderStep(flickBindName) end)

local shiftlockFrames = 0
local SHIFTLOCK_REQUIRED_FRAMES = 3
local flickState = "idle"
local flickOriginalCF = nil
local flickOriginalHRP = nil
local flickReturnProgress = 0
local flickAimFrames = 0
local flickOvershootTarget = nil
local flickOvershootDone = false
local flickWobblePhase = 0
local flickWobbleSpeed = 0
local flickWobbleAmp = 0

local function checkShiftlockRaw()
    local mb = UserInputServiceRef.MouseBehavior
    local mouseLocked = (mb == Enum.MouseBehavior.LockCenter) or (mb == Enum.MouseBehavior.LockCurrentPosition)
    if not mouseLocked then return false end
    local cam = WorkspaceService.CurrentCamera
    if not cam then return false end
    local subject = cam.CameraSubject
    if not subject then return false end
    local myChar = MyPlayer.Character
    if not myChar then return false end
    local ok = subject == myChar or subject:IsDescendantOf(myChar) or subject.Parent == myChar
    if not ok then return false end
    if MyPlayer.DevEnableMouseLock == false then return false end
    local m = UserInputServiceRef:GetMouseLocation()
    local vp = cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    if math.abs(m.X - cx) > 8 or math.abs(m.Y - cy) > 8 then return false end
    return true
end

local function easeOutCubic(t)
    t = math.clamp(t, 0, 1)
    return 1 - (1 - t) ^ 3
end

local function humanLerp(fromCF, toCF, baseAlpha, wobblePhase, wobbleAmp)
    local variance = 0.88 + math.random() * 0.24
    local a = math.clamp(baseAlpha * variance, 0.03, 1)
    local result = fromCF:Lerp(toCF, a)
    local wx = math.sin(wobblePhase) * wobbleAmp
    local wy = math.cos(wobblePhase * 1.3) * wobbleAmp * 0.7
    wx = wx + (math.random() - 0.5) * wobbleAmp * 0.6
    wy = wy + (math.random() - 0.5) * wobbleAmp * 0.6
    return result * CFrame.Angles(wx, wy, 0)
end

RunServiceRef:BindToRenderStep(flickBindName, Enum.RenderPriority.Camera.Value + 1, function()
    if not S.FlickOn or S.GuiHidden or not S.InMatch then
        if flickState == "aiming" or flickState == "returning" then
            local char = MyPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
        shiftlockFrames = 0
        flickState = "idle"
        flickOriginalCF = nil
        flickOriginalHRP = nil
        return
    end
    if checkShiftlockRaw() then
        shiftlockFrames = math.min(shiftlockFrames + 1, SHIFTLOCK_REQUIRED_FRAMES)
    else
        shiftlockFrames = 0
    end
    local cam = WorkspaceService.CurrentCamera
    if not cam then return end
    local shiftlockOk = shiftlockFrames >= SHIFTLOCK_REQUIRED_FRAMES
    local rmb = UserInputServiceRef:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local myChar = MyPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myHead = myChar and myChar:FindFirstChild("Head")
    local bestHead = nil
    if shiftlockOk and rmb and myChar and myHRP and myHum and myHead then
        local bestDist = math.huge
        local camPos = cam.CFrame.Position
        for _, other in ipairs(S.EnemyList) do
            if not isTeammate(other) then
                local char = other.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    local hp = char:FindFirstChildOfClass("Humanoid")
                    if head and hp and hp.Health > 0 then
                        local d = (head.Position - camPos).Magnitude
                        if d < bestDist and hasClearLOS(myHead, char) then
                            bestDist = d
                            bestHead = head
                        end
                    end
                end
            end
        end
    end
    if bestHead and shiftlockOk and rmb and myHRP and myHum and myHead then
        if flickState ~= "aiming" then
            if flickState == "idle" or not flickOriginalCF then
                flickOriginalCF = cam.CFrame
                flickOriginalHRP = myHRP.CFrame
            end
            flickAimFrames = 0
            flickOvershootTarget = nil
            flickOvershootDone = false
            flickWobblePhase = math.random() * math.pi * 2
            flickWobbleSpeed = 0.15 + math.random() * 0.15
            flickWobbleAmp = 0.0015 + math.random() * 0.002
            myHum.AutoRotate = false
        end
        flickState = "aiming"
        flickAimFrames = flickAimFrames + 1
        flickWobblePhase = flickWobblePhase + flickWobbleSpeed
        local camPos = cam.CFrame.Position
        local hrpPos = myHRP.Position
        local targetPos = bestHead.Position
        local distToTarget = (camPos - targetPos).Magnitude
        if flickAimFrames <= 2 then
            local flat = Vector3.new(targetPos.X, hrpPos.Y, targetPos.Z)
            myHRP.CFrame = CFrame.lookAt(hrpPos, flat)
            return
        end
        if not flickOvershootTarget and not flickOvershootDone then
            if distToTarget > 30 then
                local overAmount = 1 + (0.005 + math.random() * 0.01)
                local dir = (targetPos - camPos)
                flickOvershootTarget = CFrame.new(camPos, camPos + dir * overAmount)
            else
                flickOvershootDone = true
            end
        end
        local targetCF
        if flickOvershootTarget and not flickOvershootDone then
            targetCF = flickOvershootTarget
        else
            targetCF = CFrame.new(camPos, targetPos)
        end
        local speedCurve
        if flickAimFrames <= 12 then speedCurve = easeOutCubic(flickAimFrames / 12)
        else speedCurve = 1 end
        local alpha = S.FlickSmoothness * speedCurve
        local currentWobble = flickWobbleAmp * (1 - math.min(flickAimFrames / 30, 0.8))
        local flatTarget = Vector3.new(targetPos.X, hrpPos.Y, targetPos.Z)
        local bodyGoalCF = CFrame.lookAt(hrpPos, flatTarget)
        myHRP.CFrame = myHRP.CFrame:Lerp(bodyGoalCF, math.clamp(alpha * 1.4, 0, 1))
        cam.CFrame = humanLerp(cam.CFrame, targetCF, alpha, flickWobblePhase, currentWobble)
        if flickOvershootTarget and not flickOvershootDone then
            local curLook = cam.CFrame.LookVector
            local realDir = (targetPos - cam.CFrame.Position).Unit
            if curLook:Dot(realDir) > 0.995 then flickOvershootDone = true end
        end
        local now = tick()
        local jitterCD = S.FlickShotCD * (0.85 + math.random() * 0.3)
        if now - S.FlickLastShot >= jitterCD then
            local tool = myChar:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Fire") and tool:FindFirstChild("Reload") then
                local sg = RemoteFolder and RemoteFolder:FindFirstChild("ShootGun")
                if sg then
                    local origin = myHead.Position
                    local offset = Vector3.new(
                        (math.random() - 0.5) * 0.05,
                        (math.random() - 0.5) * 0.05,
                        (math.random() - 0.5) * 0.05
                    )
                    local shotPos = targetPos + offset
                    pcall(function() sg:FireServer(origin, shotPos, bestHead, shotPos) end)
                    S.FlickLastShot = now
                end
            end
        end
    elseif flickState == "aiming" then
        flickState = "returning"
        flickReturnProgress = 0
        flickOriginalCF = flickOriginalCF or cam.CFrame
        flickOriginalHRP = flickOriginalHRP or (myHRP and myHRP.CFrame)
    end
    if flickState == "returning" then
        flickReturnProgress = math.min(flickReturnProgress + 0.07, 1)
        local eased = easeOutCubic(flickReturnProgress)
        if flickOriginalCF then cam.CFrame = cam.CFrame:Lerp(flickOriginalCF, eased) end
        if flickOriginalHRP and myHRP then myHRP.CFrame = myHRP.CFrame:Lerp(flickOriginalHRP, eased) end
        if flickReturnProgress >= 1 then
            flickState = "idle"
            flickOriginalCF = nil
            flickOriginalHRP = nil
            local hum = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end
end)

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
            for _, o in ipairs(PlayersService:GetPlayers()) do
                if o ~= MyPlayer and o.Character then
                    local r = o.Character:FindFirstChild("HumanoidRootPart")
                    if r then r.Size = Vector3.new(2, 2, 1) end
                end
            end
            for _, b in ipairs(HitboxFolder:GetChildren()) do b:Destroy() end
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

local KillPage = Hub:Tab({ Title = "Kill All", Icon = "skull", Locked = false })

KillPage:Button({
    Title = "Kill everyone once",
    Callback = function()
        if not S.InMatch then Notify("Not in match") return end
        EquipTool(FindKnife())
        for _, o in ipairs(PlayersService:GetPlayers()) do
            if o ~= MyPlayer and not isTeammate(o) and o.Character then
                local h = o.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then ThrowKnife(o.Character) end
            end
            task.wait(0.001)
        end
        Notify("Knife burst sent")
    end,
})

local KnifeLoopOn = false
KillPage:Toggle({
    Title = "Auto kill (Knife)", Default = false,
    Callback = function(v)
        KnifeLoopOn = v
        if v then
            task.spawn(function()
                while KnifeLoopOn do
                    if S.InMatch and not S.GuiHidden then
                        EquipTool(FindKnife())
                        for _, o in ipairs(S.EnemyList) do
                            if not isTeammate(o) then
                                local c = o.Character
                                if c then
                                    local h = c:FindFirstChildOfClass("Humanoid")
                                    if h and h.Health > 0 then
                                        ThrowKnife(c)
                                        task.wait(0.001)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.001)
                end
            end)
        end
    end,
})

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

local FarmPage = Hub:Tab({ Title = "Farm", Icon = "wheat", Locked = false })
FarmPage:Toggle({
    Title = "Auto Farm", Desc = "Pad + walk + auto-kill + dance + anti-afk", Default = false,
    Callback = function(v)
        S.FarmOn = v
        if v then
            currentFarmPad = nil; S.LastDance = 0
            enableAntiAfk(); Notify("Farm ON + Anti-AFK")
        else
            Notify("Farm OFF"); currentFarmPad = nil
            stopDance(); disableAntiAfk()
        end
    end,
})
FarmPage:Slider({
    Title = "Walk Speed to Pad", Step = 1,
    Value = { Min = 16, Max = 100, Default = 40 },
    Callback = function(v) S.FarmWalkSpeed = v end,
})
task.spawn(function()
    while task.wait(0.15) do
        if S.FarmOn and not S.GuiHidden then
            if S.InMatch then
                currentFarmPad = nil
                if tick() - S.LastDance >= 2 then playDance(); S.LastDance = tick() end
                EquipTool(FindKnife())
                for _, o in ipairs(S.EnemyList) do
                    if not isTeammate(o) then
                        local c = o.Character
                        if c then
                            local h = c:FindFirstChildOfClass("Humanoid")
                            if h and h.Health > 0 then
                                ThrowKnife(c)
                                task.wait(0.001)
                            end
                        end
                    end
                end
            else
                if S.DanceTrack then stopDance() end
                if not currentFarmPad or not currentFarmPad.Parent then
                    currentFarmPad = farmFindPad()
                end
                if currentFarmPad then farmWalkTo(currentFarmPad) end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if S.FarmOn and S.InMatch and not S.GuiHidden then
            if not S.DanceTrack or not S.DanceTrack.IsPlaying then playDance() end
        end
    end
end)

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

local MovePage = Hub:Tab({ Title = "Movement", Icon = "footprints", Locked = false })
MovePage:Toggle({
    Title = "Noclip", Default = false,
    Callback = function(v)
        S.NoclipOn = v
        if v then
            task.spawn(function()
                while S.NoclipOn do
                    local b = MyPlayer.Character
                    if b then
                        for _, p in ipairs(b:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})
MovePage:Toggle({
    Title = "Speed Changer", Default = false,
    Callback = function(v)
        S.SpeedOn = v
        if v then
            task.spawn(function()
                while S.SpeedOn do
                    local h = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.WalkSpeed ~= S.SpeedValue then h.WalkSpeed = S.SpeedValue end
                    task.wait(0.2)
                end
            end)
        else
            local h = MyPlayer.Character and MyPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 16 end
        end
    end,
})
MovePage:Slider({
    Title = "Walk Speed", Step = 1,
    Value = { Min = 16, Max = 250, Default = 16 },
    Callback = function(v) S.SpeedValue = v end,
})

local FlickPage = Hub:Tab({ Title = "Flick", Icon = "crosshair", Locked = false })
FlickPage:Toggle({
    Title = "Flick Mode",
    Desc = "Shiftlock + RMB → full body + camera flick + auto-shoot",
    Default = false,
    Callback = function(v)
        S.FlickOn = v
        Notify(v and "Flick Mode ON" or "Flick Mode OFF")
    end,
})
FlickPage:Slider({
    Title = "Flick Smoothness", Step = 0.05,
    Value = { Min = 0.1, Max = 1, Default = 0.9 },
    Callback = function(v) S.FlickSmoothness = v end,
})

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
    Callback = function(v)
        S.AimbotFOV = v
        updateFovCircle()
    end,
})
AimbotPage:Slider({
    Title = "Aimbot Smoothness", Step = 0.01,
    Value = { Min = 0.05, Max = 1, Default = 0.35 },
    Callback = function(v) S.AimbotSmoothness = v end,
})
AimbotPage:Toggle({
    Title = "Show FOV Circle",
    Default = false,
    Callback = function(v)
        S.AimbotShowFOV = v
        updateFovCircle()
    end,
})

AimbotPage:Section({ Title = "TriggerBot" })
AimbotPage:Toggle({
    Title = "TriggerBot",
    Desc = "Press E to toggle. Uses mouse.Target hit detection.",
    Default = false,
    Callback = function(v)
        S.TriggerOn = v
        Notify(v and "TriggerBot ON" or "TriggerBot OFF")
    end,
})
AimbotPage:Slider({
    Title = "TriggerBot Cooldown", Step = 0.005,
    Value = { Min = 0.01, Max = 0.5, Default = 0.03 },
    Callback = function(v) S.TriggerCD = v end,
})

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

local antiLagConnection = nil
local antiLagActive = false
local antiLagSeen = setmetatable({}, { __mode = "k" })
local antiLagTracked = setmetatable({}, { __mode = "k" })

local SHOT_NAME_HINTS = {
    "muzzle", "flash", "shot", "fire", "gun", "bullet", "impact",
    "hit", "spark", "shell", "casing", "trail", "beam", "tracer"
}

local KNIFE_NAME_HINTS = {
    "knife", "dagger", "blade", "thrown", "throw", "projectile",
    "cleaver", "tomahawk", "shuriken", "kunai", "shank"
}

local function nameHasHint(n, hints)
    for i = 1, #hints do
        if string.find(n, hints[i], 1, true) then return true end
    end
    return false
end

local function isShotEffect(obj)
    if not obj then return false end
    if obj:GetAttribute("IsBullet") == true
       or obj:GetAttribute("BulletOwner") ~= nil
       or obj:GetAttribute("ShotBy") ~= nil then
        return true
    end
    local n = string.lower(obj.Name)
    if nameHasHint(n, SHOT_NAME_HINTS) then return true end
    local p = obj.Parent
    if p then
        local pn = string.lower(p.Name)
        if nameHasHint(pn, SHOT_NAME_HINTS) then return true end
        local pp = p.Parent
        if pp then
            local ppn = string.lower(pp.Name)
            if nameHasHint(ppn, SHOT_NAME_HINTS) then return true end
        end
    end
    return false
end

local function isInsideCharacterOrToolOrBackpack(obj)
    if not obj then return false end
    local p = obj
    while p do
        if p:IsA("Tool") then return true end
        if p:IsA("Accessory") then return true end
        if p:IsA("Model") and PlayersService:GetPlayerFromCharacter(p) then return true end
        if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
        if p == MyPlayer then return true end
        p = p.Parent
    end
    return false
end

local function isCharacterPart(obj)
    if not obj then return false end
    if obj:IsA("Accessory") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors")
       or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Decal")
       or obj:IsA("Humanoid") or obj:IsA("Animator") then
        return true
    end
    return false
end

local function hasKnifeAttribute(obj)
    if not obj then return false end
    if obj:GetAttribute("IsKnife") == true then return true end
    if obj:GetAttribute("ProjectileOwner") ~= nil then return true end
    if obj:GetAttribute("KnifeOwner") ~= nil then return true end
    if obj:GetAttribute("ThrownBy") ~= nil then return true end
    return false
end

local function hasKnifeName(obj)
    if not obj then return false end
    local n = string.lower(obj.Name)
    return nameHasHint(n, KNIFE_NAME_HINTS)
end

local function isKnifeObject(obj)
    if not obj then return false end
    if not obj.Parent then return false end
    if obj:IsA("Tool") then return false end
    if isShotEffect(obj) then return false end
    if isInsideCharacterOrToolOrBackpack(obj) then return false end
    if isCharacterPart(obj) then return false end
    if obj:IsA("Sound") or obj:IsA("Folder") or obj:IsA("Configuration")
       or obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")
       or obj:IsA("BindableEvent") or obj:IsA("BindableFunction")
       or obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript")
       or obj:IsA("Attachment") or obj:IsA("Motor6D")
       or obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("JointInstance") then
        return false
    end
    if not (obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("MeshPart")
            or obj:IsA("UnionOperation") or obj:IsA("Part")) then
        return false
    end
    if hasKnifeAttribute(obj) then return true end
    if hasKnifeName(obj) then return true end
    if obj:IsA("BasePart") then
        local p = obj.Parent
        if p and (p:IsA("Model") or p:IsA("Folder")) then
            if hasKnifeName(p) then return true end
            for _, c in ipairs(p:GetChildren()) do
                if c:IsA("BasePart") and (string.lower(c.Name) == "handle") then return true end
            end
        end
    end
    if obj:IsA("Model") then
        local pp = obj.PrimaryPart
        if pp and hasKnifeName(pp) then return true end
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") and hasKnifeName(d) then return true end
        end
    end
    return false
end

local function hideKnifeVisual(obj)
    if not obj or not obj.Parent then return end
    if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
        pcall(function()
            obj.LocalTransparencyModifier = 1
            obj.Transparency = 1
            obj.CanCollide = false
            obj.CanTouch = false
            obj.CanQuery = false
            obj.CastShadow = false
        end)
        for _, c in ipairs(obj:GetChildren()) do
            if c:IsA("Decal") or c:IsA("Texture") then
                pcall(function() c.Transparency = 1 end)
            end
            if c:IsA("ParticleEmitter") or c:IsA("Trail") or c:IsA("Beam") then
                pcall(function() c.Enabled = false end)
            end
            if c:IsA("SpecialMesh") then
                pcall(function() c.Transparency = 1 end)
            end
        end
    elseif obj:IsA("Model") then
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") or d:IsA("MeshPart") or d:IsA("UnionOperation") then
                pcall(function()
                    d.LocalTransparencyModifier = 1
                    d.Transparency = 1
                    d.CanCollide = false
                    d.CanTouch = false
                    d.CanQuery = false
                    d.CastShadow = false
                end)
            elseif d:IsA("Decal") or d:IsA("Texture") then
                pcall(function() d.Transparency = 1 end)
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") then
                pcall(function() d.Enabled = false end)
            elseif d:IsA("SpecialMesh") then
                pcall(function() d.Transparency = 1 end)
            end
        end
    end
end

local function trackKnife(obj)
    if antiLagTracked[obj] then return end
    antiLagTracked[obj] = true
    task.spawn(function()
        while antiLagActive and obj and obj.Parent do
            hideKnifeVisual(obj)
            task.wait(0.05)
        end
        antiLagTracked[obj] = nil
    end)
end

local function antiLagProcess(obj)
    if not antiLagActive then return end
    if not obj or not obj.Parent then return end
    if antiLagSeen[obj] then return end
    antiLagSeen[obj] = true

    if isShotEffect(obj) then return end
    if isInsideCharacterOrToolOrBackpack(obj) then return end
    if isCharacterPart(obj) then return end

    if isKnifeObject(obj) then
        hideKnifeVisual(obj)
        trackKnife(obj)
        return
    end

    if obj:IsA("BasePart") then
        local p = obj.Parent
        if p and not (p:IsA("Model") and (p:FindFirstChildOfClass("Humanoid") or PlayersService:GetPlayerFromCharacter(p))) then
            if not isInsideCharacterOrToolOrBackpack(p) then
                if (string.lower(obj.Name) == "handle") then
                    local model = obj:FindFirstAncestorOfClass("Model")
                    if model and not (model:FindFirstChildOfClass("Humanoid") or PlayersService:GetPlayerFromCharacter(model)) then
                        hideKnifeVisual(model)
                        trackKnife(model)
                        return
                    end
                end
            end
        end
    end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
       obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        if isShotEffect(obj) then return end
        pcall(function() obj.Enabled = false end)
        return
    end

    if obj:IsA("Sound") then
        local n = string.lower(obj.Name)
        if nameHasHint(n, {"shot", "gun", "bullet", "muzzle"}) then return end
        if nameHasHint(n, {"knife", "throw", "slash", "stab", "dagger", "blade"}) then
            pcall(function() obj.Volume = 0 end)
        end
        return
    end

    if obj:IsA("BasePart") then
        local model = obj:FindFirstAncestorOfClass("Model")
        if not (model and (model:FindFirstChildOfClass("Humanoid") or PlayersService:GetPlayerFromCharacter(model))) then
            pcall(function()
                obj.CastShadow = false
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end)
        end
    end
end

local function antiLagOn()
    if antiLagActive then return end
    antiLagActive = true
    if antiLagConnection then
        pcall(function() antiLagConnection:Disconnect() end)
    end
    antiLagConnection = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("MeshPart")
           or obj:IsA("UnionOperation") or obj:IsA("ParticleEmitter")
           or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Sound")
           or obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SpecialMesh") then
            task.defer(function() antiLagProcess(obj) end)
        end
    end)
    task.spawn(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not antiLagActive then return end
            antiLagProcess(obj)
        end
    end)
    task.spawn(function()
        while antiLagActive do
            task.wait(1)
            for _, obj in ipairs(workspace:GetChildren()) do
                if not antiLagActive then return end
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    antiLagProcess(obj)
                end
            end
        end
    end)
end

local function antiLagOff()
    antiLagActive = false
    if antiLagConnection then
        pcall(function() antiLagConnection:Disconnect() end)
        antiLagConnection = nil
    end
    antiLagSeen = setmetatable({}, { __mode = "k" })
    antiLagTracked = setmetatable({}, { __mode = "k" })
end

pcall(function()
    getgenv().SealDevAntiLagOff = antiLagOff
end)

local antiLagToggle = MiscPage:Toggle({
    Title = "Anti-Lag",
    Default = false,
    Callback = function(v)
        if v then
            antiLagOn()
            Notify("Anti-Lag ON")
        else
            antiLagOff()
            Notify("Anti-Lag OFF")
        end
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

pcall(function()
    Hub:OnDestroy(function()
        _G.SealDevV27Loaded = nil
        pcall(function() RunServiceRef:UnbindFromRenderStep(flickBindName) end)
        pcall(function() antiLagOff() end)
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

hideLoadingGui()

dbg("ready")
Notify("seal is le goat it took me 2 days to make this script 🦭💀💀😮😭💦🤔👍")
