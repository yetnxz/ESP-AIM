-- Configurações de cor
local colourTable = {
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Red = Color3.fromRGB(255, 0, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Orange = Color3.fromRGB(255, 165, 0),
    Purple = Color3.fromRGB(128, 0, 128)
}
local colourChosen = colourTable.Red -- Escolha a cor desejada

-- Variável para ativar/desativar o ESP
_G.ESPToggle = false

-- Configurações do Aimbot
local aimbotKey = Enum.KeyCode.E -- Tecla padrão para ativar o aimbot
local aimbotFOV = 100 -- Campo de visão do aimbot

-- Serviços e jogador local
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Função para adicionar destaque aos jogadores
local function addHighlightToCharacter(player, character)
    if player == LocalPlayer then return end -- Ignorar o jogador local
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = Instance.new("Highlight")
        highlightClone.Name = "Highlight"
        highlightClone.Adornee = character
        highlightClone.Parent = humanoidRootPart
        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlightClone.FillColor = colourChosen
        highlightClone.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlightClone.FillTransparency = 0.5
    end
end

-- Função para remover destaque dos jogadores
local function removeHighlightFromCharacter(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local highlightInstance = humanoidRootPart:FindFirstChild("Highlight")
        if highlightInstance then
            highlightInstance:Destroy()
        end
    end
end

-- Função para atualizar os destaques com base no valor de _G.ESPToggle
local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            if _G.ESPToggle then
                addHighlightToCharacter(player, character)
            else
                removeHighlightFromCharacter(character)
            end
        end
    end
end

-- Atualização contínua do ESP
RunService.RenderStepped:Connect(function()
    updateHighlights()
end)

-- Comando para ativar/desativar o ESP
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.H then
        _G.ESPToggle = not _G.ESPToggle
    end
end)

-- Função para verificar se o alvo está dentro do FOV
local function isInFOV(target)
    local camera = Workspace.CurrentCamera
    local screenPoint = camera:WorldToViewportPoint(target.Position)
    local mouse = LocalPlayer:GetMouse()
    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
    return distance <= aimbotFOV
end

-- Aimbot simples
local function aimAt(target)
    local camera = Workspace.CurrentCamera
    local targetPos = target.Position
    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == aimbotKey then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") and isInFOV(target) then
            aimAt(target)
        end
    end
end)
