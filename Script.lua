-- [[ SERVIÇOS DO ROBLOX ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ VARIÁVEIS DE CONFIGURAÇÃO ]]
local AimbotEnabled = false
local FOVVisible = true
local ESPEnabled = true
local AntennaEnabled = true
local TargetPart = "Head"
local FOVRadius = 120

-- [[ DESTROY ANTERIOR ]]
local parentGui = game:GetService("CoreGui")
if not pcall(function() local _ = game:GetService("CoreGui").Name end) then
    parentGui = LocalPlayer:WaitForChild("PlayerGui")
end

if parentGui:FindFirstChild("PinkMenu_LK7") then
    parentGui["PinkMenu_LK7"]:Destroy()
end

-- [[ INTERFACE PRINCIPAL ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PinkMenu_LK7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 260)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- CÍRCULO DO FOV (GUI NATIVO)
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = FOVVisible
FOVFrame.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 0, 127)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

-- BOTÃO ABRIR / FECHAR
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
OpenBtn.Text = "🌸"
OpenBtn.TextSize = 18
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 127)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -50, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- PAINEL ESQUERDO
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 110, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 3)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.Parent = SideBar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 10)
SidePad.Parent = SideBar

local abas = {"Principal", "Aimbot", "Gelo", "Game", "Clear", "Info"}
for i, name in ipairs(abas) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 100, 0, 28)
    Btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(25, 25, 30)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.Parent = SideBar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
end

-- CONTEÚDO DIREITO
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -125, 1, -10)
Content.Position = UDim2.new(0, 120, 0, 5)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 0, 280)
Content.ScrollBarThickness = 2
Content.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 6)
ContentList.Parent = Content

local function CreateToggle(txt, state, cb)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(0.95, 0, 0, 25)
    F.BackgroundTransparency = 1
    F.Parent = Content

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.Text = txt
    L.TextColor3 = Color3.fromRGB(220, 220, 220)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 10
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 40, 0, 18)
    B.Position = UDim2.new(1, -40, 0.5, -9)
    B.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(35, 35, 40)
    B.Text = state and "ON" or "OFF"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 9
    B.Parent = F
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 9)

    B.MouseButton1Click:Connect(function()
        state = not state
        B.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(35, 35, 40)
        B.Text = state and "ON" or "OFF"
        cb(state)
    end)
end

CreateToggle("ATIVAR AIMBOT", AimbotEnabled, function(v) AimbotEnabled = v end)
CreateToggle("EXIBIR CÍRCULO FOV", FOVVisible, function(v) FOVVisible = v FOVFrame.Visible = v end)
CreateToggle("QUADRADO PAREDE (ESP)", ESPEnabled, function(v) ESPEnabled = v end)
CreateToggle("ANTENA NOS INIMIGOS", AntennaEnabled, function(v) AntennaEnabled = v end)

-- SISTEMA DE ARRASTO
local Drag, Start, Pos
MainFrame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        Drag = true Start = inp.Position Pos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if Drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local Delta = inp.Position - Start
        MainFrame.Position = UDim2.new(Pos.X.Scale, Pos.X.Offset + Delta.X, Pos.Y.Scale, Pos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then Drag = false end
end)

-- SISTEMA ESP QUADRADO (HIGHLIGHT NATIVO) E ANTENA
RunService.RenderStepped:Connect(function()
    -- AIMBOT
    if AimbotEnabled then
        local Target = nil
        local Dist = FOVRadius
        local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local Part = v.Character:FindFirstChild(TargetPart) or v.Character:FindFirstChild("Head")
                if Part then
                    local SPos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                    if OnScreen then
                        local M = (Vector2.new(SPos.X, SPos.Y) - Center).Magnitude
                        if M <= Dist then Dist = M Target = Part end
                    end
                end
            end
        end
        if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position) end
    end

    -- ESP & ANTENA
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")

            -- QUADRADO ESP PAREDE
            local hl = char:FindFirstChild("LK7_ESP")
            if ESPEnabled and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "LK7_ESP"
                    hl.FillTransparency = 0.6
                    hl.FillColor = Color3.fromRGB(255, 0, 127)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.AlwaysOnTop = true -- Permite ver através da parede
                    hl.Parent = char
                end
                hl.Enabled = true
            elseif hl then
                hl.Enabled = false
            end

            -- ANTENA
            local ant = char:FindFirstChild("LK7_Antenna")
            if AntennaEnabled and head and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if not ant then
                    local a0 = Instance.new("Attachment", head)
                    local a1 = Instance.new("Attachment", head)
                    a1.Position = Vector3.new(0, 10, 0) -- Linha apontando para cima

                    local b = Instance.new("Beam")
                    b.Name = "LK7_Antenna"
                    b.Attachment0 = a0
                    b.Attachment1 = a1
                    b.Width0 = 0.2
                    b.Width1 = 0.2
                    b.Color = ColorSequence.new(Color3.fromRGB(255, 0, 127))
                    b.FaceCamera = true
                    b.AlwaysOnTop = true
                    b.Parent = char
                end
            elseif ant then
                ant:Destroy()
            end
        end
    end
end)
