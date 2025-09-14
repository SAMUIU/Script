-- Script para teletransportar a la base en Steal a Brainrot
-- Funciona en ejecutores como Delta o KRNL

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Esperar a que el personaje cargue
local function onCharacterAdded(character)
    wait(1) -- Pequeña espera para asegurar que todo esté listo
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local baseCFrame = humanoidRootPart.CFrame -- Almacena la posición de la base (spawn)
    
    -- Crear GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TPBaseGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Name = "TPButton"
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.Text = "TP a Base"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui
    
    -- Función del botón
    button.MouseButton1Click:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") and baseCFrame then
            character.HumanoidRootPart.CFrame = baseCFrame
            print("¡Teletransportado a la base!")
        else
            print("Error: Personaje no encontrado. Respawnea e intenta de nuevo.")
        end
    end)
    
    -- Limpiar GUI si el personaje muere y se recrea
    character.AncestryChanged:Connect(function()
        if not character.Parent then
            screenGui:Destroy()
        end
    end)
end

-- Conectar al evento de carga del personaje
if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)
