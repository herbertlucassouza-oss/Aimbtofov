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
local TargetPart = "Head" -- "Head", "UpperTorso", "HumanoidRootPart"
local FOVRadius = 120

-- [[ DESENHO DO CÍRCULO FOV (COM TRATAMENTO DE ERRO) ]]
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 0, 127)
    FOVCircle.Thickness = 1.5
    FOVCircle.Transparency = 1
    FOVCircle.Visible = FOVVisible
end)

-- [[ TABELAS DE ESP / ANTENA ]]
local ESPBoxes = {}
local ESPAntennas = {}

local function RemoveESP(player)
    if ESPBoxes[player] then
        pcall(function() ESPBoxes[player]:Remove() end)
        ESPBoxes[player] = nil
    end
    if ESPAntennas[player] then
        pcall(function() ESPAntennas[player]:Remove() end)
        ESPAntennas[player] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

-- [[ DESTRUIR PAINEL ANTERIOR ]]
if game:GetService("CoreGui"):FindFirstChild("PinkMenu_LK7") then
    game:GetService("CoreGui")["PinkMenu_LK7"]:Destroy()
end

-- [[ INTERFACE PRINCIPAL (SCREEN GUI) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PinkMenu_LK7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 280)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- BOTÃO FLUTUANTE DE ABRIR
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
OpenBtn.Text = "🌸"
OpenBtn.TextSize = 20
OpenBtn.Visible = false
OpenBtn.ZIndex = 10
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

-- BARRA DE CONTROLE (FECHAR / MINIMIZAR)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 5
TopBar.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 127)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.ZIndex = 6
CloseBtn.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -54, 0, 4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 10
MinimizeBtn.ZIndex = 6
MinimizeBtn.Parent = TopBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

CloseBtn.MouseButton1Click:Connect(function()
    if FOVCircle then pcall(function() FOVCircle:Remove() end) end
    for plr, box in pairs(ESPBoxes) do pcall(function() box:Remove() end) end
    for plr, ant in pairs(ESPAntennas) do pcall(function() ant:Remove() end) end
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- MENU LATERAL (SIDEBAR)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 4)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Parent = SideBar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.Parent = SideBar

local abas = {
    {Nome = "Principal", Icone = "🏠"},
    {Nome = "Aimbot", Icone = "💀"},
    {Nome = "Gelo", Icone = "❄️"},
    {Nome = "Game", Icone = "🎮"},
    {Nome = "Clear", Icone = "⚙️"},
    {Nome = "Info", Icone = "ℹ️"}
}

for order, abaData in ipairs(abas) do
    local AbaBtn = Instance.new("TextButton")
    AbaBtn.Size = UDim2.new(0, 110, 0, 32)
    AbaBtn.LayoutOrder = order
    AbaBtn.BackgroundColor3 = (order == 1) and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(18, 18, 22)
    AbaBtn.Text = "  " .. abaData.Icone .. "   " .. abaData.Nome
    AbaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AbaBtn.Font = Enum.Font.GothamBold
    AbaBtn.TextSize = 11
    AbaBtn.TextXAlignment = Enum.TextXAlignment.Left
    AbaBtn.Parent = SideBar
    local AbaCorner = Instance.new("UICorner")
    AbaCorner.CornerRadius = UDim.new(0, 6)
    AbaCorner.Parent = AbaBtn
end

-- DIVISOR ROSA
local VerticalDivider = Instance.new("Frame")
VerticalDivider.Size = UDim2.new(0, 3, 0, 240)
VerticalDivider.Position = UDim2.new(0, 128, 0, 20)
VerticalDivider.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
VerticalDivider.BorderSizePixel = 0
VerticalDivider.Parent = MainFrame

-- ÁREA DE CONTEÚDO
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -145, 1, -20)
ContentFrame.Position = UDim2.new(0, 140, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 127)
ContentFrame.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 8)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = ContentFrame

-- CRIAR BOTÃO TOGGLE
local function CreateToggle(title, defaultState, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.95, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ContentFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = title
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -45, 0.5, -11)
    ToggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(30, 30, 35)
    ToggleBtn.Text = defaultState and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 10
    ToggleBtn.Parent = Frame
    
    local TogCorner = Instance.new("UICorner")
    TogCorner.CornerRadius = UDim.new(0, 11)
    TogCorner.Parent = ToggleBtn

    local state = defaultState
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(30, 30, 35)
        ToggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- CONTROLES TOGGLES
CreateToggle("ATIVAR AIMBOT", AimbotEnabled, function(val) AimbotEnabled = val end)
CreateToggle("EXIBIR CÍRCULO FOV", FOVVisible, function(val) 
    FOVVisible = val 
    if FOVCircle then FOVCircle.Visible = val end
end)
CreateToggle("QUADRADO PAREDE (ESP)", ESPEnabled, function(val) ESPEnabled = val end)
CreateToggle("ANTENA NOS INIMIGOS", AntennaEnabled, function(val) AntennaEnabled = val end)

-- SELETOR DEFINA O HS
local TitleHS = Instance.new("TextLabel")
TitleHS.Size = UDim2.new(1, 0, 0, 20)
TitleHS.Text = "DEFINA O HS:"
TitleHS.TextColor3 = Color3.fromRGB(255, 0, 127)
TitleHS.Font = Enum.Font.GothamBold
TitleHS.TextSize = 12
TitleHS.TextXAlignment = Enum.TextXAlignment.Left
TitleHS.BackgroundTransparency = 1
TitleHS.Parent = ContentFrame

local opcoesHS = {
    {Texto = "Cabeça", Part = "Head"},
    {Texto = "Pescoço", Part = "UpperTorso"},
    {Texto = "Corpo", Part = "HumanoidRootPart"}
}

local RadioButtons = {}
for _, opt in ipairs(opcoesHS) do
    local OptionFrame = Instance.new("Frame")
    OptionFrame.Size = UDim2.new(0.95, 0, 0, 25)
    OptionFrame.BackgroundTransparency = 1
    OptionFrame.Parent = ContentFrame

    local CircleOuter = Instance.new("TextButton")
    CircleOuter.Size = UDim2.new(0, 18, 0, 18)
    CircleOuter.Position = UDim2.new(0, 0, 0.5, -9)
    CircleOuter.BackgroundColor3 = (TargetPart == opt.Part) and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(25, 25, 30)
    CircleOuter.Text = ""
    CircleOuter.Parent = OptionFrame
    
    local RadCorner = Instance.new("UICorner")
    RadCorner.CornerRadius = UDim.new(1, 0)
    RadCorner.Parent = CircleOuter

    local Label = Instance.new("TextButton")
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Position = UDim2.new(0, 25, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = opt.Texto
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = OptionFrame

    RadioButtons[opt.Part] = CircleOuter

    local function Selecionar()
        TargetPart = opt.Part
        for p, btn in pairs(RadioButtons) do
            btn.BackgroundColor3 = (p == TargetPart) and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(25, 25, 30)
        end
    end
    CircleOuter.MouseButton1Click:Connect(Selecionar)
    Label.MouseButton1Click:Connect(Selecionar)
end

-- ARRASTO LIVRE DA TELA
local Dragging, DragStart, StartPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

-- AIMBOT
local function GetClosestTarget()
    local ClosestPart = nil
    local ShortestDistance = FOVRadius
    local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
            local Hum = v.Character:FindFirstChildOfClass("Humanoid")
            if Hum.Health > 0 then
                local TargetNode = v.Character:FindFirstChild(TargetPart) or v.Character:FindFirstChild("Head")
                if TargetNode then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetNode.Position)
                    if OnScreen then
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                        if Distance <= ShortestDistance then
                            ShortestDistance = Distance
                            ClosestPart = TargetNode
                        end
                    end
                end
            end
        end
    end
    return ClosestPart
end

-- LOOP DE ATUALIZAÇÃO
RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Visible = FOVVisible
    end

    if AimbotEnabled then
        local Target = GetClosestTarget()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end

    -- DESENHAR ESP BOX E ANTENA
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local head = char:FindFirstChild("Head")
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    -- QUADRADO (BOX ESP)
                    if ESPEnabled then
                        pcall(function()
                            if not ESPBoxes[plr] then
                                local box = Drawing.new("Square")
                                box.Color = Color3.fromRGB(255, 0, 127)
                                box.Thickness = 1.5
                                box.Filled = false
                                ESPBoxes[plr] = box
                            end

                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            local height = math.abs(headPos.Y - legPos.Y)
                            local width = height / 1.5

                            ESPBoxes[plr].Size = Vector2.new(width, height)
                            ESPBoxes[plr].Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                            ESPBoxes[plr].Visible = true
                        end)
                    elseif ESPBoxes[plr] then
                        pcall(function() ESPBoxes[plr].Visible = false end)
                    end

                    -- ANTENA (TRACER)
                    if AntennaEnabled and head then
                        pcall(function()
                            if not ESPAntennas[plr] then
                                local line = Drawing.new("Line")
                                line.Color = Color3.fromRGB(255, 0, 127)
                                line.Thickness = 1.5
                                ESPAntennas[plr] = line
                            end

                            local headPos = Camera:WorldToViewportPoint(head.Position)
                            ESPAntennas[plr].From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                            ESPAntennas[plr].To = Vector2.new(headPos.X, headPos.Y)
                            ESPAntennas[plr].Visible = true
                        end)
                    elseif ESPAntennas[plr] then
                        pcall(function() ESPAntennas[plr].Visible = false end)
                    end
                else
                    if ESPBoxes[plr] then pcall(function() ESPBoxes[plr].Visible = false end) end
                    if ESPAntennas[plr] then pcall(function() ESPAntennas[plr].Visible = false end) end
                end
            else
                if ESPBoxes[plr] then pcall(function() ESPBoxes[plr].Visible = false end) end
                if ESPAntennas[plr] then pcall(function() ESPAntennas[plr].Visible = false end) end
            end
        end
    end
end)
