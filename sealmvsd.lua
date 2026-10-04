if _G.SealDevLoaded then return end
_G.SealDevLoaded = true

local LOGO = "rbxassetid://131261307870420"
local UI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Hub = UI:CreateWindow({
    Title = (function()
        local ok, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        return ok and info.Name or "SealDev"
    end)(),
    Icon = LOGO,
    Author = "SealDev build",
    Folder = "SealDevConfigs",
    Size = UDim2.fromOffset(540, 420),
    MinSize = Vector2.new(560, 360),
    MaxSize = Vector2.new(860, 560),
    ToggleKey = Enum.KeyCode.LeftControl,
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 180,
    BackgroundImageTransparency = 1,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = true, Callback = function() end },
})

Hub:EditOpenButton({
    Title = "Open SealDev",
    Icon = LOGO,
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 0.6,
    Color = ColorSequence.new(Color3.fromHex("#8a63ff"), Color3.fromHex("#cfe6ff")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Hub:CreateTopbarButton("Community", "users", function()
    pcall(setclipboard, "https://dsc.gg/sealdev")
end, 980)

Hub:Tag({ Title = "MVSD", Icon = "sparkles", Color = Color3.fromHex("#8a63ff"), Radius = 4 })

local P  = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local CS = game:GetService("CollectionService")
local RUN = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG  = game:GetService("CoreGui")
local CAM = WS.CurrentCamera
local LP  = P.LocalPlayer

local state = {
    inMatch   = false,
    enemies   = {},
    knifeAuto = false,
    gunCDOff  = false,
    cdBackup  = {},
    hbOn      = false,
    hbSize    = 13,
    hbColor   = Color3.fromRGB(255, 60, 60),
    espCharm  = false,
    espTracer = false,
    espName   = false,
    colTeam   = Color3.fromRGB(255, 255, 255),
    colEnemy  = Color3.fromRGB(255, 70, 70),
    hidden    = false,
}

task.spawn(function()
    while task.wait(0.15) do
        state.inMatch = LP:GetAttribute("Match") ~= nil
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        local m = LP:GetAttribute("Match")
        local list = {}
        if m then
            for _, plr in ipairs(P:GetPlayers()) do
                if plr ~= LP and plr:GetAttribute("Match") == m then
                    local ch = plr.Character
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        list[#list + 1] = plr
                    end
                end
            end
        end
        state.enemies = list
    end
end)

local function findGun()
    for _, box in ipairs({ LP:FindFirstChildOfClass("Backpack"), LP.Character }) do
        if box then
            for _, t in ipairs(box:GetChildren()) do
                if t:IsA("Tool") and t:FindFirstChild("Fire") and t:FindFirstChild("Reload") then
                    return t
                end
            end
        end
    end
end

local function findKnife()
    for _, box in ipairs({ LP:FindFirstChildOfClass("Backpack"), LP.Character }) do
        if box then
            for _, t in ipairs(box:GetChildren()) do
                if t:IsA("Tool") and t:GetAttribute("EquipAnimation") == "Knife_Equip" then
                    return t
                end
            end
        end
    end
end

local function equipTool(t)
    if not t then return end
    local ch = LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        pcall(function() hum:EquipTool(t) end)
    end
end

local function originPoint(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return (hrp.CFrame * CFrame.new(0, 0, hrp.Size.Z / 2)).Position
end

local remotes = RS:WaitForChild("Remotes", 10)

local function gunHit(target)
    local ch = target.Character
    if not ch then return end
    local part = ch:FindFirstChild("Head")
        or ch:FindFirstChild("UpperTorso")
        or ch:FindFirstChild("LowerTorso")
        or ch:FindFirstChild("HumanoidRootPart")
    if not part then return end
    local my = LP.Character
    local myRoot = my and my:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local sg = remotes and remotes:FindFirstChild("ShootGun")
    if not sg then return end
    pcall(function()
        sg:FireServer(myRoot.Position, part.Position, part, part.Position)
    end)
end

local function knifeHit(targetChar)
    local hrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local th = remotes and remotes:FindFirstChild("ThrowHit")
    if not th then return end
    pcall(function()
        th:FireServer(hrp, hrp.Position)
    end)
end

local function toast(text)
    Hub:Notify({ Title = "SealDev", Content = text, Duration = 2.5, Icon = LOGO })
end

local CD_KEYS = { "Cooldown", "FireRate", "FireCooldown", "ReloadCooldown", "ReloadTime" }

local function stripCD(tool)
    for _, k in ipairs(CD_KEYS) do
        if tool:GetAttribute(k) ~= nil then
            local tag = tostring(tool) .. "@" .. k
            if state.cdBackup[tag] == nil then
                state.cdBackup[tag] = { obj = tool, key = k, val = tool:GetAttribute(k) }
            end
            pcall(function() tool:SetAttribute(k, 0) end)
        end
    end
    for _, child in ipairs(tool:GetChildren()) do
        for _, k in ipairs(CD_KEYS) do
            if child:GetAttribute(k) ~= nil then
                local tag = tostring(child) .. "@" .. k
                if state.cdBackup[tag] == nil then
                    state.cdBackup[tag] = { obj = child, key = k, val = child:GetAttribute(k) }
                end
                pcall(function() child:SetAttribute(k, 0) end)
            end
        end
    end
end

local function restoreCD()
    for _, entry in pairs(state.cdBackup) do
        if entry.obj and entry.obj.Parent then
            pcall(function() entry.obj:SetAttribute(entry.key, entry.val) end)
        end
    end
    state.cdBackup = {}
end

task.spawn(function()
    while task.wait(0.08) do
        if state.gunCDOff and not state.hidden then
            for _, box in ipairs({ LP:FindFirstChildOfClass("Backpack"), LP.Character }) do
                if box then
                    for _, t in ipairs(box:GetChildren()) do
                        if t:IsA("Tool") and t:FindFirstChild("Fire") then
                            stripCD(t)
                        end
                    end
                end
            end
        end
    end
end)

local espCharmFolder = CG:FindFirstChild("SealDevCharm") or Instance.new("Folder")
espCharmFolder.Name = "SealDevCharm"
espCharmFolder.Parent = CG

local espTracerFolder = CG:FindFirstChild("SealDevTracer") or Instance.new("Folder")
espTracerFolder.Name = "SealDevTracer"
espTracerFolder.Parent = CG

local espInfoFolder = CG:FindFirstChild("SealDevInfo") or Instance.new("Folder")
espInfoFolder.Name = "SealDevInfo"
espInfoFolder.Parent = CG

local mainTab = Hub:Tab({ Title = "Main", Icon = "layout-dashboard", Locked = false })
local featSec = mainTab:Section({ Title = "Core", Opened = true })

local unanchorFlag = false
featSec:Toggle({
    Title = "Auto UnAnchor",
    Desc = "Bypasses the pre-match freeze",
    Default = false,
    Callback = function(v)
        unanchorFlag = v
        local function watch(ch)
            local rp = ch:WaitForChild("HumanoidRootPart", 5)
            local hm = ch:WaitForChild("Humanoid", 5)
            if not rp or not hm then return end
            local conn
            conn = RUN.Heartbeat:Connect(function()
                if not ch.Parent or hm.Health <= 0 then conn:Disconnect(); return end
                if unanchorFlag and rp.Anchored then rp.Anchored = false end
            end)
        end
        if LP.Character then task.spawn(watch, LP.Character) end
        LP.CharacterAdded:Connect(watch)
    end,
})

featSec:Toggle({
    Title = "No Gun Cooldown",
    Desc = "Re-equip gun after enabling",
    Icon = "timer-off",
    Default = false,
    Callback = function(v)
        state.gunCDOff = v
        if v then
            state.cdBackup = {}
            toast("Cooldown stripper ON")
        else
            restoreCD()
            toast("Cooldown stripper OFF")
        end
    end,
})

featSec:Space()

featSec:Toggle({
    Title = "Auto Throw Knife",
    Desc = "Throws your knife at nearest enemy",
    Default = false,
    Callback = function(v)
        state.knifeAuto = v
        if v then
            task.spawn(function()
                while state.knifeAuto do
                    if not state.hidden and tick() - (state.lastThrow or 0) >= 2 then
                        local my = LP.Character
                        local myRoot = my and my:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            local best, bestD = nil, 350
                            for _, e in ipairs(state.enemies) do
                                if e ~= LP and e.Character and e.Team ~= LP.Team then
                                    local erh = e.Character:FindFirstChild("HumanoidRootPart")
                                    local ehum = e.Character:FindFirstChildOfClass("Humanoid")
                                    if erh and ehum and ehum.Health > 0 then
                                        local d = (erh.Position - myRoot.Position).Magnitude
                                        local rp = RaycastParams.new()
                                        rp.FilterDescendantsInstances = { my, e.Character }
                                        rp.FilterType = Enum.RaycastFilterType.Exclude
                                        local r = WS:Raycast(myRoot.Position, erh.Position - myRoot.Position, rp)
                                        if d < bestD and not r then best, bestD = e.Character, d end
                                    end
                                end
                            end
                            if best then
                                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                                if tool and tool:FindFirstChild("RightHandle") then
                                    local hrp = best:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        local o = originPoint(LP.Character)
                                        local dir = (hrp.Position - o).Unit
                                        pcall(function() remotes.ThrowStart:FireServer(o, dir) end)
                                        local ok, KPC = pcall(function()
                                            return require(RS.Modules.KnifeProjectileController)
                                        end)
                                        if ok and KPC then
                                            KPC({
                                                Speed = tool:GetAttribute("ThrowSpeed"),
                                                KnifeProjectile = tool.RightHandle:Clone(),
                                                Direction = dir,
                                                Origin = o,
                                            }, function(res)
                                                pcall(function()
                                                    remotes.ThrowHit:FireServer(res and res.Instance, res and res.Position)
                                                end)
                                            end)
                                        end
                                        state.lastThrow = tick()
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

featSec:Space()

featSec:Toggle({
    Title = "Hitbox Expander",
    Desc = "Enlarges enemy hitboxes",
    Default = false,
    Callback = function(v)
        state.hbOn = v
        if v then
            toast("Hitbox ON")
            task.spawn(function()
                while state.hbOn do
                    if not state.hidden then
                        for _, plr in ipairs(P:GetPlayers()) do
                            if plr ~= LP and plr.Character then
                                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    if plr.Team ~= LP.Team then
                                        hrp.Size = Vector3.new(state.hbSize, state.hbSize, state.hbSize)
                                        hrp.CanCollide = true
                                        local box = hrp:FindFirstChild("sealdev_hb")
                                        if not box then
                                            box = Instance.new("BoxHandleAdornment")
                                            box.Name = "sealdev_hb"
                                            box.Adornee = hrp
                                            box.AlwaysOnTop = true
                                            box.ZIndex = 10
                                            box.Size = hrp.Size
                                            box.Color3 = state.hbColor
                                            box.Transparency = 0.75
                                            box.Parent = hrp
                                        else
                                            box.Size = hrp.Size
                                            box.Color3 = state.hbColor
                                        end
                                    else
                                        hrp.Size = Vector3.new(2, 2, 1)
                                        hrp.CanCollide = false
                                        local box = hrp:FindFirstChild("sealdev_hb")
                                        if box then box:Destroy() end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.12)
                end
            end)
        else
            for _, plr in ipairs(P:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.CanCollide = false
                        local box = hrp:FindFirstChild("sealdev_hb")
                        if box then box:Destroy() end
                    end
                end
            end
            toast("Hitbox OFF")
        end
    end,
})

featSec:Slider({
    Title = "Hitbox Size",
    Step = 1,
    Value = { Min = 5, Max = 100, Default = 13 },
    Callback = function(v) state.hbSize = v end,
})

featSec:Colorpicker({
    Title = "Hitbox Color",
    Default = Color3.fromRGB(255, 60, 60),
    Transparency = 0,
    Callback = function(c) state.hbColor = c end,
})

local kaTab = Hub:Tab({ Title = "Kill All", Icon = "skull", Locked = false })
local gunSec = kaTab:Section({ Title = "Gun", Opened = true })

gunSec:Button({
    Title = "Kill everyone once",
    Callback = function()
        if not state.inMatch then toast("Not in match") return end
        equipTool(findGun())
        for _, plr in ipairs(state.enemies) do
            if plr.Team ~= LP.Team then gunHit(plr) end
            task.wait(0.02)
        end
        toast("Burst sent")
    end,
})

gunSec:Toggle({
    Title = "Auto kill (Gun)",
    Default = false,
    Callback = function(v)
        state.gunKillLoop = v
        if v then
            toast("Auto gun kill ON")
            task.spawn(function()
                while state.gunKillLoop do
                    if state.inMatch and not state.hidden then
                        equipTool(findGun())
                        for _, plr in ipairs(state.enemies) do
                            if plr.Team ~= LP.Team then gunHit(plr) end
                        end
                    end
                    task.wait(0.02)
                end
            end)
        else
            toast("Auto gun kill OFF")
        end
    end,
})

local knifeSec = kaTab:Section({ Title = "Knife", Opened = true })

knifeSec:Button({
    Title = "Kill everyone once",
    Callback = function()
        if not state.inMatch then toast("Not in match") return end
        equipTool(findKnife())
        for _, plr in ipairs(P:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then knifeHit(plr.Character) end
            end
            task.wait(0.05)
        end
        toast("Knife burst sent")
    end,
})

knifeSec:Toggle({
    Title = "Auto kill (Knife)",
    Default = false,
    Callback = function(v)
        state.knifeKillLoop = v
        if v then
            task.spawn(function()
                while state.knifeKillLoop do
                    if state.inMatch and not state.hidden then
                        equipTool(findKnife())
                        for _, plr in ipairs(state.enemies) do
                            if plr ~= LP and plr.Character then
                                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health > 0 then knifeHit(plr.Character) end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

local espTab = Hub:Tab({ Title = "Visuals", Icon = "eye", Locked = false })

espTab:Toggle({
    Title = "Chams",
    Default = false,
    Callback = function(v)
        state.espCharm = v
        if not v then
            for _, c in ipairs(espCharmFolder:GetChildren()) do c:Destroy() end
            return
        end
        task.spawn(function()
            while state.espCharm do
                if not state.hidden then
                    for _, e in ipairs(state.enemies) do
                        if e.Character then
                            local hl = espCharmFolder:FindFirstChild(e.Name)
                            if not hl then
                                hl = Instance.new("Highlight")
                                hl.Name = e.Name
                                hl.FillTransparency = 0.55
                                hl.OutlineTransparency = 0.35
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = espCharmFolder
                            end
                            local col = (e.Team == LP.Team) and state.colTeam or state.colEnemy
                            hl.FillColor = col
                            hl.OutlineColor = col
                            hl.Adornee = e.Character
                        end
                    end
                end
                task.wait(0.15)
            end
        end)
    end,
})

espTab:Toggle({
    Title = "Names",
    Default = false,
    Callback = function(v)
        state.espName = v
        if not v then
            for _, c in ipairs(espInfoFolder:GetChildren()) do c:Destroy() end
            return
        end
        task.spawn(function()
            while state.espName do
                if not state.hidden then
                    for _, e in ipairs(state.enemies) do
                        local ch = e.Character
                        local holder = espInfoFolder:FindFirstChild(e.Name)
                        if ch and ch:FindFirstChild("Head") and ch:FindFirstChildOfClass("Humanoid") and ch.Humanoid.Health > 0 then
                            if not holder then
                                holder = Instance.new("BillboardGui")
                                holder.Name = e.Name
                                holder.Size = UDim2.fromOffset(180, 34)
                                holder.StudsOffset = Vector3.new(0, 2.6, 0)
                                holder.AlwaysOnTop = true
                                holder.Parent = espInfoFolder

                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "name"
                                lbl.BackgroundTransparency = 1
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextScaled = true
                                lbl.TextStrokeTransparency = 0.3
                                lbl.TextColor3 = Color3.new(1, 1, 1)
                                lbl.Parent = holder
                            end
                            holder.Adornee = ch.Head
                            local col = (e.Team == LP.Team) and state.colTeam or state.colEnemy
                            local lbl = holder:FindFirstChild("name")
                            if lbl then
                                lbl.Text = e.Name
                                lbl.TextColor3 = col
                            end
                        elseif holder then
                            holder:Destroy()
                        end
                    end
                end
                task.wait(0.15)
            end
        end)
    end,
})

local tracerConn
espTab:Toggle({
    Title = "Tracers",
    Default = false,
    Callback = function(v)
        state.espTracer = v
        if tracerConn then tracerConn:Disconnect() tracerConn = nil end
        if not v then
            for _, c in ipairs(espTracerFolder:GetChildren()) do c:Destroy() end
            return
        end
        tracerConn = RUN.RenderStepped:Connect(function()
            if not state.espTracer or state.hidden then return end
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, e in ipairs(state.enemies) do
                local ch = e.Character
                local tr = espTracerFolder:FindFirstChild(e.Name)
                if ch and ch:FindFirstChild("HumanoidRootPart") and ch:FindFirstChildOfClass("Humanoid") and ch.Humanoid.Health > 0 then
                    if not tr then
                        tr = Instance.new("LineHandleAdornment")
                        tr.Name = e.Name
                        tr.Thickness = 1.5
                        tr.ZIndex = 10
                        tr.AlwaysOnTop = true
                        tr.Parent = espTracerFolder
                    end
                    local col = (e.Team == LP.Team) and state.colTeam or state.colEnemy
                    tr.Color3 = col
                    tr.Adornee = WS.Terrain
                    tr.CFrame = CFrame.lookAt(myRoot.Position, ch.HumanoidRootPart.Position)
                    tr.Length = (myRoot.Position - ch.HumanoidRootPart.Position).Magnitude
                elseif tr then
                    tr:Destroy()
                end
            end
        end)
    end,
})

espTab:Space()

espTab:Colorpicker({
    Title = "Teammate Color",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Callback = function(c) state.colTeam = c end,
})

espTab:Colorpicker({
    Title = "Enemy Color",
    Default = Color3.fromRGB(255, 70, 70),
    Transparency = 0,
    Callback = function(c) state.colEnemy = c end,
})

local mvTab = Hub:Tab({ Title = "Movement", Icon = "footprints", Locked = false })

state.noclip = false
state.speed = 16
state.speedOn = false

mvTab:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(v)
        state.noclip = v
        if v then
            task.spawn(function()
                while state.noclip do
                    local ch = LP.Character
                    if ch then
                        for _, part in ipairs(ch:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})

mvTab:Toggle({
    Title = "Speed Changer",
    Default = false,
    Callback = function(v)
        state.speedOn = v
        if v then
            task.spawn(function()
                while state.speedOn do
                    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.WalkSpeed ~= state.speed then
                        hum.WalkSpeed = state.speed
                    end
                    task.wait(0.1)
                end
            end)
        else
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end,
})

mvTab:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = { Min = 16, Max = 250, Default = 16 },
    Callback = function(v) state.speed = v end,
})

local windGuiCache = {}
local windGuiStates = {}

local function collectWindGuis()
    local list = {}
    for _, obj in ipairs(CG:GetDescendants()) do
        if obj:IsA("ScreenGui") then
            table.insert(list, obj)
        end
    end
    return list
end

local function hideAll()
    windGuiCache = collectWindGuis()
    windGuiStates = {}
    for _, gui in ipairs(windGuiCache) do
        windGuiStates[gui] = gui.Enabled
        pcall(function() gui.Enabled = false end)
    end

    pcall(function() Hub:Close() end)

    for _, obj in ipairs(CG:GetDescendants()) do
        if obj:IsA("GuiObject") then
            local nm = obj.Name
            if nm == "Open SealDev" or nm == "SealDev" or nm:find("SealDev") then
                obj.Visible = false
            end
        end
    end

    for _, f in ipairs({ espCharmFolder, espTracerFolder, espInfoFolder }) do
        for _, obj in ipairs(f:GetChildren()) do
            pcall(function() obj.Enabled = false end)
            pcall(function() obj.Visible = false end)
        end
    end

    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local box = hrp:FindFirstChild("sealdev_hb")
                if box then
                    pcall(function() box.Visible = false end)
                end
            end
        end
    end
end

local function showAll()
    for gui, was in pairs(windGuiStates) do
        if gui and gui.Parent then
            pcall(function() gui.Enabled = was end)
        end
    end
    windGuiStates = {}

    pcall(function() Hub:Open() end)

    for _, obj in ipairs(CG:GetDescendants()) do
        if obj:IsA("GuiObject") then
            local nm = obj.Name
            if nm == "Open SealDev" or nm == "SealDev" or nm:find("SealDev") then
                obj.Visible = true
            end
        end
    end

    for _, f in ipairs({ espCharmFolder, espTracerFolder, espInfoFolder }) do
        for _, obj in ipairs(f:GetChildren()) do
            pcall(function() obj.Enabled = true end)
            pcall(function() obj.Visible = true end)
        end
    end

    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local box = hrp:FindFirstChild("sealdev_hb")
                if box then
                    pcall(function() box.Visible = true end)
                end
            end
        end
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        state.hidden = not state.hidden
        if state.hidden then
            hideAll()
        else
            showAll()
        end
    end
end)

Hub:OnClose(function()
    Hub:Notify({ Title = "Closed", Content = "SealDev terminated", Duration = 2, Icon = LOGO })
end)

Hub:OnDestroy(function()
    _G.SealDevLoaded = false
end)

UI:AddTheme({
    Name = "sealdev",
    Accent = Color3.fromHex("#8a63ff"),
    Background = Color3.fromHex("#0d0d12"),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#1c1c26"),
    Text = Color3.fromHex("#e7eefc"),
    Placeholder = Color3.fromHex("#5a6287"),
    Button = Color3.fromHex("#171722"),
    Icon = Color3.fromHex("#a3b8e8"),
    Hover = Color3.fromHex("#8a63ff"),
    WindowBackground = Color3.fromHex("#0d0d12"),
    WindowShadow = Color3.fromHex("#000000"),
    DialogBackground = Color3.fromHex("#0d0d12"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromHex("#e7eefc"),
    DialogContent = Color3.fromHex("#e7eefc"),
    DialogIcon = Color3.fromHex("#a3b8e8"),
    WindowTopbarButtonIcon = Color3.fromHex("#a3b8e8"),
    WindowTopbarTitle = Color3.fromHex("#e7eefc"),
    WindowTopbarAuthor = Color3.fromHex("#a3b8e8"),
    WindowTopbarIcon = Color3.fromHex("#e7eefc"),
    TabBackground = Color3.fromHex("#121219"),
    TabTitle = Color3.fromHex("#e7eefc"),
    TabIcon = Color3.fromHex("#a3b8e8"),
    ElementBackground = Color3.fromHex("#121219"),
    ElementTitle = Color3.fromHex("#e7eefc"),
    ElementDesc = Color3.fromHex("#a3b8e8"),
    ElementIcon = Color3.fromHex("#a3b8e8"),
    PopupBackground = Color3.fromHex("#0d0d12"),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromHex("#e7eefc"),
    PopupContent = Color3.fromHex("#e7eefc"),
    PopupIcon = Color3.fromHex("#a3b8e8"),
    Toggle = Color3.fromHex("#171722"),
    ToggleBar = Color3.fromHex("#8a63ff"),
    Checkbox = Color3.fromHex("#171722"),
    CheckboxIcon = Color3.fromHex("#8a63ff"),
    Slider = Color3.fromHex("#171722"),
    SliderThumb = Color3.fromHex("#8a63ff"),
})
UI:SetTheme("sealdev")