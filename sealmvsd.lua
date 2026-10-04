-- Loading screen (persists until GUI is loaded)
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
    title.Size = UDim2.new(1, 0, 0, 140)
    title.Position = UDim2.new(0, 0, 0.5, -70)
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
    loading.Size = UDim2.new(1, 0, 0, 30)
    loading.Position = UDim2.new(0, 0, 0.5, 75)
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
    FlickOn = false, FlickSmoothness = 0.9, FlickLastShot = 0, FlickShotCD = 2,
}

local AnchorRelease = false
local function dbg(m) warn("[SealDev] " .. tostring(m)) end
local function Notify(m) pcall(function() Hub:Notify({ Title = "SealDev", Content = tostring(m), Duration = 2.5, Icon = LOGO }) end) end
dbg("Services loaded")

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
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return false end
    local dir = targetHead.Position - fromPart.Position
    local res = WorkspaceService:Raycast(fromPart.Position, dir, params)
    if res then
        if res.Instance:IsDescendantOf(targetChar) then return true end
        return false
    end
    return true
end

local function isTeammate(other)
    if not other or other == MyPlayer then return true end
    if other.Team and MyPlayer.Team and other.Team == MyPlayer.Team then return true end
    local myTC = MyPlayer.TeamColor
    local otherTC = other.TeamColor
    if myTC and otherTC and myTC == otherTC then
        if myTC ~= BrickColor.new("Medium stone grey") and myTC ~= BrickColor.new("White") then
            return true
        end
    end
    for _, attr in ipairs({"Team", "team", "Side", "side"}) do
        local myV = MyPlayer:GetAttribute(attr)
        local otherV = other:GetAttribute(attr)
        if myV ~= nil and otherV ~= nil and myV == otherV then
            return true
        end
    end
    return false
end

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
        if #list ~= #S.EnemyList then
            S.EnemyList = list
            local set = {} for _, p in ipairs(list) do set[p.UserId] = true end
            S.EnemySet = set
        else
            local same = true
            for i = 1, #list do
                if list[i] ~= S.EnemyList[i] then same = false; break end
            end
            if not same then
                S.EnemyList = list
                local set = {} for _, p in ipairs(list) do set[p.UserId] = true end
                S.EnemySet = set
            end
        end
    end
end)

local CD_KEYS = { "Cooldown", "FireRate", "FireCooldown", "ReloadCooldown", "ReloadTime" }
local function WipeCD(t)
    for _, k in ipairs(CD_KEYS) do
        if t:GetAttribute(k) ~= nil then
            local tag = tostring(t) .. "@" .. k
            if S.CooldownSaves[tag] == nil then
                S.CooldownSaves[tag] = { obj = t, key = k, val = t:GetAttribute(k) }
            end
            pcall(function() t:SetAttribute(k, 0) end)
        end
    end
end
local function RestoreCD()
    for _, e in pairs(S.CooldownSaves) do
        if e.obj and e.obj.Parent then pcall(function() e.obj:SetAttribute(e.key, e.val) end) end
    end
    S.CooldownSaves = {}
end

task.spawn(function()
    while task.wait(0.25) do
        if S.CooldownOff and not S.GuiHidden then
            for _, c in ipairs({ MyPlayer:FindFirstChildOfClass("Backpack"), MyPlayer.Character }) do
                if c then
                    for _, i in ipairs(c:GetChildren()) do
                        if i:IsA("Tool") and i:FindFirstChild("Fire") then WipeCD(i) end
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
    local a = h:FindFirstChildOfClass("Animator") or (function() local x = Instance.new("Animator"); x.Parent = h; return x end)()
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
local flickReturnProgress = 0
local flickAimFrames = 0
local flickPauseTimer = 0
local flickOvershootTarget = nil
local flickOvershootDone = false
local flickWobblePhase = 0
local flickWobbleSpeed = 0
local flickWobbleAmp = 0
local flickLastTargetPos = nil

local function checkShiftlockRaw()
    local mb = UserInputServiceRef.MouseBehavior
    local mouseLocked = (mb == Enum.MouseBehavior.LockCenter)
                     or (mb == Enum.MouseBehavior.LockCurrentPosition)
    if not mouseLocked then return false end
    local cam = WorkspaceService.CurrentCamera
    if not cam then return false end
    local subject = cam.CameraSubject
    if not subject then return false end
    local myChar = MyPlayer.Character
    if not myChar then return false end
    local subjectOk = false
    if subject == myChar then subjectOk = true
    elseif subject:IsDescendantOf(myChar) then subjectOk = true
    elseif subject.Parent == myChar then subjectOk = true end
    if not subjectOk then return false end
    if MyPlayer.DevEnableMouseLock == false then return false end
    local mouse = UserInputServiceRef:GetMouseLocation()
    local vp = cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    if math.abs(mouse.X - cx) > 8 or math.abs(mouse.Y - cy) > 8 then
        return false
    end
    return true
end

local function smoothstep(t)
    t = math.clamp(t, 0, 1)
    return t * t * (3 - 2 * t)
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
        shiftlockFrames = 0
        flickState = "idle"
        flickOriginalCF = nil
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

    local bestHead = nil
    if shiftlockOk and rmb then
        local myChar = MyPlayer.Character
        if myChar then
            local myHead = myChar:FindFirstChild("Head")
            if myHead then
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
                                if d < bestDist then
                                    if hasClearLOS(myHead, char) then
                                        bestDist = d
                                        bestHead = head
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if bestHead and shiftlockOk and rmb then
        if flickState ~= "aiming" then
            if flickState == "idle" or not flickOriginalCF then
                flickOriginalCF = cam.CFrame
            end
            flickAimFrames = 0
            flickPauseTimer = 0
            flickOvershootTarget = nil
            flickOvershootDone = false
            flickWobblePhase = math.random() * math.pi * 2
            flickWobbleSpeed = 0.15 + math.random() * 0.15
            flickWobbleAmp = 0.0015 + math.random() * 0.002
        end
        flickState = "aiming"
        flickAimFrames = flickAimFrames + 1
        flickWobblePhase = flickWobblePhase + flickWobbleSpeed

        local camPos = cam.CFrame.Position
        local distToTarget = (camPos - bestHead.Position).Magnitude

        if flickAimFrames <= 2 then
            return
        end

        if not flickOvershootTarget and not flickOvershootDone then
            if distToTarget > 30 then
                local overAmount = 1 + (0.005 + math.random() * 0.01)
                local dir = (bestHead.Position - camPos)
                flickOvershootTarget = CFrame.new(camPos, camPos + dir * overAmount)
            else
                flickOvershootDone = true
            end
        end

        local targetCF
        if flickOvershootTarget and not flickOvershootDone then
            targetCF = flickOvershootTarget
        else
            targetCF = CFrame.new(camPos, bestHead.Position)
        end

        local speedCurve
        if flickAimFrames <= 12 then
            speedCurve = easeOutCubic(flickAimFrames / 12)
        else
            speedCurve = 1
        end

        local alpha = S.FlickSmoothness * speedCurve
        local currentWobble = flickWobbleAmp * (1 - math.min(flickAimFrames / 30, 0.8))

        cam.CFrame = humanLerp(cam.CFrame, targetCF, alpha, flickWobblePhase, currentWobble)

        if flickOvershootTarget and not flickOvershootDone then
            local curLook = cam.CFrame.LookVector
            local realDir = (bestHead.Position - cam.CFrame.Position).Unit
            if curLook:Dot(realDir) > 0.995 then
                flickOvershootDone = true
            end
        end

        local now = tick()
        local jitterCD = S.FlickShotCD * (0.85 + math.random() * 0.3)
        if now - S.FlickLastShot >= jitterCD then
            local myChar = MyPlayer.Character
            local tool = myChar and myChar:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Fire") and tool:FindFirstChild("Reload") then
                local sg = RemoteFolder and RemoteFolder:FindFirstChild("ShootGun")
                if sg then
                    local myHead = myChar:FindFirstChild("Head")
                    local origin = myHead and myHead.Position or camPos
                    local offset = Vector3.new(
                        (math.random() - 0.5) * 0.05,
                        (math.random() - 0.5) * 0.05,
                        (math.random() - 0.5) * 0.05
                    )
                    local shotPos = bestHead.Position + offset
                    pcall(function()
                        sg:FireServer(origin, shotPos, bestHead, shotPos)
                    end)
                    S.FlickLastShot = now
                end
            end
        end
    elseif flickState == "aiming" then
        flickState = "returning"
        flickReturnProgress = 0
        flickOriginalCF = flickOriginalCF or cam.CFrame
    end

    if flickState == "returning" and flickOriginalCF then
        flickReturnProgress = math.min(flickReturnProgress + 0.07, 1)
        local eased = easeOutCubic(flickReturnProgress)
        cam.CFrame = cam.CFrame:Lerp(flickOriginalCF, eased)
        if flickReturnProgress >= 1 then
            flickState = "idle"
            flickOriginalCF = nil
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
    if n == "Jumping" or n == "JumpSound" or n == "Jump" then r = true
    else
        local l = string.lower(n)
        if string.find(l, "jump", 1, true) then r = true
        else
            local s = o.SoundId
            if s == "rbxasset://sounds/action_jump.mp3" or s == "rbxasset://sounds/action_jump_land.mp3"
                or s == "rbxassetid://4657753130" or s == "rbxassetid://5171086877" then r = true end
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
        o.SoundId = JUMP_SOUND_NEW; o.Name = "SealDevJump"; o.Volume = 0.5
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
    for _, p in ipairs(PlayersService:GetPlayers()) do if p.Character then scanJumpSounds(p.Character) end end

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
                s.SoundId = o.id; s.Name = o.name; s.Volume = o.volume
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
            local hp = body:FindFirstChild("Humanoid")
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
        if v then S.CooldownSaves = {}; Notify("Cooldown stripper ON")
        else RestoreCD(); Notify("Cooldown stripper OFF") end
    end,
})

MainPage:Toggle({
    Title = "Hitbox Expander", Default = false,
    Callback = function(v)
        S.HitboxOn = v
        if v then Notify("Hitbox ON")
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
                                b.Name = o.Name; b.Adornee = r
                                b.AlwaysOnTop = true; b.ZIndex = 10
                                b.Color3 = S.HitboxColor; b.Transparency = 0.7
                                b.Visible = S.HitboxShow; b.Size = s
                                b.Parent = HitboxFolder
                            else
                                b.Adornee = r; b.Size = s; b.Visible = S.HitboxShow
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

local EspPage = Hub:Tab({ Title = "ESP", Icon = "eye", Locked = false })

EspPage:Toggle({
    Title = "Chams", Default = false,
    Callback = function(v)
        S.CharmESP = v
        if not v then for _, c in ipairs(CharmFolder:GetChildren()) do c:Destroy() end; return end
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
                            m.FillColor = t; m.OutlineColor = t; m.Adornee = o.Character
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
        if not v then for _, c in ipairs(NameFolder:GetChildren()) do c:Destroy() end; return end
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
                                    l.Name = "name"; l.BackgroundTransparency = 1
                                    l.Size = UDim2.new(1, 0, 1, 0)
                                    l.Font = Enum.Font.GothamBold; l.TextScaled = true
                                    l.TextStrokeTransparency = 0.3
                                    l.TextColor3 = Color3.new(1, 1, 1)
                                    l.Parent = t
                                end
                                t.Adornee = b.Head
                                local tint = (o.Team == MyPlayer.Team) and S.MateColor or S.FoeColor
                                local l = t:FindFirstChild("name")
                                if l then l.Text = o.Name; l.TextColor3 = tint end
                            elseif t then t:Destroy() end
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
        if not v then for _, c in ipairs(TracerFolder:GetChildren()) do c:Destroy() end; return end
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
                            l.Name = o.Name; l.Thickness = 1.5; l.ZIndex = 10
                            l.AlwaysOnTop = true; l.Parent = TracerFolder
                        end
                        local tint = (o.Team == MyPlayer.Team) and S.MateColor or S.FoeColor
                        l.Color3 = tint; l.Adornee = WorkspaceService.Terrain
                        l.CFrame = CFrame.lookAt(r.Position, b.HumanoidRootPart.Position)
                        l.Length = (r.Position - b.HumanoidRootPart.Position).Magnitude
                    elseif l then l:Destroy() end
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
    Title = "Anti-Exploiter Force (studs)",
    Step = 0.5,
    Value = { Min = 1, Max = 8, Default = 3 },
    Callback = function(v) S.AntiExploiterForce = v end,
})

MiscPage:Toggle({
    Title = "Flick Mode",
    Desc = "Shiftlock + RMB → human-like flick + auto-return",
    Default = false,
    Callback = function(v)
        S.FlickOn = v
        Notify(v and "Flick Mode ON" or "Flick Mode OFF")
    end,
})

MiscPage:Slider({
    Title = "Flick Smoothness",
    Step = 0.05,
    Value = { Min = 0.1, Max = 1, Default = 0.9 },
    Callback = function(v) S.FlickSmoothness = v end,
})

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

dbg("Loaded successfully")
Notify("Loaded")
