local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- LAGGY animation IDs (the real ones)
local blockedNumeric = {
    [108547486427358] = true,
    [128564458016055] = true,
    [111133097645102] = true,
    [118859282718860] = true,
    [116688450587693] = true,
    [108713182294229] = true
}

-- Animations we ALWAYS allow (walk / idle / run)
local allowNumeric = {
    [507766666] = true, -- default idle
    [507777826] = true, -- walk
    [507767714] = true, -- run
}

-- Extract number from any AnimationId string
local function getNumericId(animId)
    if not animId then return nil end
    local num = tostring(animId):match("(%d+)")
    return num and tonumber(num) or nil
end

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                    local anim = track.Animation
                    local animId = anim and anim.AnimationId

                    -- Block GUID / http spoofed animations
                    if animId and tostring(animId):find("http%{") then
                        track:Stop()
                        track:Destroy()
                        continue
                    end

                    local numeric = getNumericId(animId)

                    if numeric then
                        -- Allow walk/idle/etc
                        if allowNumeric[numeric] then
                            continue
                        end

                        -- Kill lag animations
                        if blockedNumeric[numeric] then
                            track:Stop()
                            track:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

warn("zshop on top")
