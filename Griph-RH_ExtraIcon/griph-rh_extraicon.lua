local name, addon = ...
GriphExtra = true
GriphExtraVer = 01102018
local safeColor = true
local tostring, tonumber, print = tostring, tonumber, print

local function round2(num, idp)
    mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function roundscale(num, idp)
    mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

GriphRH.topIcons = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
GriphRH.topIcons:SetBackdrop(nil)
GriphRH.topIcons:SetFrameStrata("TOOLTIP")
GriphRH.topIcons:SetToplevel(true)
GriphRH.topIcons:SetSize(240, 30) 
GriphRH.topIcons:SetPoint("TOPLEFT", -29, 12) 
GriphRH.topIcons.texture = GriphRH.topIcons:CreateTexture(nil, "OVERLAY")
GriphRH.topIcons.texture:SetAllPoints(true)
GriphRH.topIcons.texture:SetColorTexture(0, 0, 0, 0)

if safeColor then
    GriphRH.topIcons.texture:SetColorTexture(0, 0, 0, 1)
end

GriphRH.topIcons:SetScale(1)
GriphRH.topIcons:Show(1)

GriphRH.ccIcon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate") -- was missed
GriphRH.ccIcon:SetBackdrop(nil)
GriphRH.ccIcon:SetSize(1, 1)
GriphRH.ccIcon:SetPoint("TOPLEFT", GriphRH.topIcons, 0, 0)
GriphRH.ccIcon.texture = GriphRH.ccIcon:CreateTexture(nil, "OVERLAY")
GriphRH.ccIcon.texture:SetAllPoints(true)
GriphRH.ccIcon.texture:SetColorTexture(0, 1, 1, 0)
GriphRH.ccIcon:SetScale(1)
GriphRH.ccIcon:Show(1)

GriphRH.kickIcon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.kickIcon:SetBackdrop(nil)
GriphRH.kickIcon:SetSize(1, 1)
GriphRH.kickIcon:SetPoint("TOPLEFT", GriphRH.topIcons, 30, 0)
GriphRH.kickIcon.texture = GriphRH.kickIcon:CreateTexture(nil, "OVERLAY")
GriphRH.kickIcon.texture:SetAllPoints(true)
GriphRH.kickIcon.texture:SetColorTexture(0, 1, 1, 0)
GriphRH.kickIcon:SetScale(1)
GriphRH.kickIcon:Show(1)

GriphRH.stIcon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.stIcon:SetBackdrop(nil)
GriphRH.stIcon:SetSize(30, 30)
GriphRH.stIcon:SetPoint("TOPLEFT", GriphRH.topIcons, 60, 0) 
GriphRH.stIcon.texture = GriphRH.stIcon:CreateTexture(nil, "OVERLAY")
GriphRH.stIcon.texture:SetAllPoints(true)
GriphRH.stIcon.texture:SetColorTexture(0, 1, 0, 0)
GriphRH.stIcon:SetScale(1)
GriphRH.stIcon:Show(1)

GriphRH.aoeIcon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.aoeIcon:SetBackdrop(nil)
GriphRH.aoeIcon:SetSize(30, 30)
GriphRH.aoeIcon:SetPoint("TOPLEFT", GriphRH.topIcons, 90, 0) 
GriphRH.aoeIcon.texture = GriphRH.aoeIcon:CreateTexture(nil, "OVERLAY")
GriphRH.aoeIcon.texture:SetAllPoints(true)
GriphRH.aoeIcon.texture:SetColorTexture(1, 1, 0, 0)
GriphRH.aoeIcon:SetScale(1)
GriphRH.aoeIcon:Show(1)

GriphRH.gladiatorIcon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.gladiatorIcon:SetBackdrop(nil)
GriphRH.gladiatorIcon:SetSize(30, 30)
GriphRH.gladiatorIcon:SetPoint("TOPLEFT", GriphRH.topIcons, 120, 0) 
GriphRH.gladiatorIcon.texture = GriphRH.gladiatorIcon:CreateTexture(nil, "OVERLAY")
GriphRH.gladiatorIcon.texture:SetAllPoints(true)
GriphRH.gladiatorIcon.texture:SetColorTexture(0, 0, 1, 0)
GriphRH.gladiatorIcon:SetScale(1)
GriphRH.gladiatorIcon:Show(1)

GriphRH.passiveIcon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.passiveIcon:SetBackdrop(nil)
GriphRH.passiveIcon:SetSize(30, 30)
GriphRH.passiveIcon:SetPoint("TOPLEFT", GriphRH.topIcons, 150, 0) 
GriphRH.passiveIcon.texture = GriphRH.passiveIcon:CreateTexture(nil, "OVERLAY")
GriphRH.passiveIcon.texture:SetAllPoints(true)
GriphRH.passiveIcon.texture:SetColorTexture(1, 0, 0, 0)
GriphRH.passiveIcon:SetScale(1)
GriphRH.passiveIcon:Show(1)

-- For what these frames here? They have wrong SetPoint anyway
function GriphRH.Arena1Icon(texture)
    GriphRH.class1Icon.texture:SetTexture(texture)
end

function GriphRH.Arena2Icon(texture)
    GriphRH.class2Icon.texture:SetTexture(texture)
end

function GriphRH.Arena3Icon(texture)
    GriphRH.class3Icon.texture:SetTexture(texture)
end
GriphRH.class1Icon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.class1Icon:SetBackdrop(nil)
GriphRH.class1Icon:SetFrameStrata("TOOLTIP")
GriphRH.class1Icon:SetSize(30, 30)
GriphRH.class1Icon:SetPoint("TOPLEFT", GriphRH.topIcons, 121, 0) --12
GriphRH.class1Icon.texture = GriphRH.class1Icon:CreateTexture(nil, "OVERLAY")
GriphRH.class1Icon.texture:SetAllPoints(true)
GriphRH.class1Icon.texture:SetColorTexture(1, 0, 0, 0)
GriphRH.class1Icon:SetScale(1)
GriphRH.class1Icon:Show(1)

GriphRH.class2Icon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.class2Icon:SetBackdrop(nil)
GriphRH.class2Icon:SetFrameStrata("TOOLTIP")
GriphRH.class2Icon:SetSize(30, 30)
GriphRH.class2Icon:SetPoint("TOPLEFT", GriphRH.topIcons, 151, 0) --12
GriphRH.class2Icon.texture = GriphRH.class2Icon:CreateTexture(nil, "OVERLAY")
GriphRH.class2Icon.texture:SetAllPoints(true)
GriphRH.class2Icon.texture:SetColorTexture(1, 0, 0, 0)
GriphRH.class2Icon:SetScale(1)
GriphRH.class2Icon:Show(1)

GriphRH.class3Icon = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.class3Icon:SetBackdrop(nil)
GriphRH.class3Icon:SetFrameStrata("TOOLTIP")
GriphRH.class3Icon:SetSize(30, 30)
GriphRH.class3Icon:SetPoint("TOPLEFT", GriphRH.topIcons, 181, 0) --12
GriphRH.class3Icon.texture = GriphRH.class3Icon:CreateTexture(nil, "OVERLAY")
GriphRH.class3Icon.texture:SetAllPoints(true)
GriphRH.class3Icon.texture:SetColorTexture(1, 0, 0, 0)
GriphRH.class3Icon:SetScale(1)
GriphRH.class3Icon:Show(1)

--GriphRH.arena1.texture:SetColorTexture(0, 0.56, 0) -- Interrupt
--GriphRH.arena1.texture:SetColorTexture(0.56, 0, 0) -- Interrupt
GriphRH.arena1 = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.arena1:SetBackdrop(nil)
GriphRH.arena1:SetFrameStrata("TOOLTIP")
GriphRH.arena1:SetSize(175, 8)
GriphRH.arena1:SetPoint("TOPLEFT", GriphRH.topIcons, 213, -12) --12
GriphRH.arena1.texture = GriphRH.arena1:CreateTexture(nil, "OVERLAY")
GriphRH.arena1.texture:SetAllPoints(true)
GriphRH.arena1:SetScale(1)
GriphRH.arena1:Show(1)

GriphRH.arena12 = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.arena12:SetBackdrop(nil)
GriphRH.arena12:SetFrameStrata("TOOLTIP")
GriphRH.arena12:SetSize(8, 8)
GriphRH.arena12:SetPoint("TOPLEFT", GriphRH.topIcons, 213, -20) --12
GriphRH.arena12.texture = GriphRH.arena12:CreateTexture(nil, "OVERLAY")
GriphRH.arena12.texture:SetAllPoints(true)
GriphRH.arena12.texture:SetColorTexture(0, 0, 0, 0)
GriphRH.arena12:SetScale(1)
GriphRH.arena12:Show(1)

GriphRH.arena2 = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.arena2:SetBackdrop(nil)
GriphRH.arena2:SetFrameStrata("TOOLTIP")
GriphRH.arena2:SetSize(175, 8)
GriphRH.arena2:SetPoint("TOPLEFT", GriphRH.topIcons, 387, -12) --12
GriphRH.arena2.texture = GriphRH.arena2:CreateTexture(nil, "OVERLAY")
GriphRH.arena2.texture:SetAllPoints(true)
GriphRH.arena2:SetScale(1)
GriphRH.arena2:Show(1)

GriphRH.arena22 = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.arena22:SetBackdrop(nil)
GriphRH.arena22:SetFrameStrata("TOOLTIP")
GriphRH.arena22:SetSize(8, 8)
GriphRH.arena22:SetPoint("TOPLEFT", GriphRH.topIcons, 387, -20) --12
GriphRH.arena22.texture = GriphRH.arena22:CreateTexture(nil, "OVERLAY")
GriphRH.arena22.texture:SetAllPoints(true)
GriphRH.arena22.texture:SetColorTexture(0, 0, 0, 0)
GriphRH.arena22:SetScale(1)
GriphRH.arena22:Show(1)

GriphRH.arena3 = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.arena3:SetBackdrop(nil)
GriphRH.arena3:SetFrameStrata("TOOLTIP")
GriphRH.arena3:SetSize(175, 8)
GriphRH.arena3:SetPoint("TOPLEFT", GriphRH.topIcons, 561, -12) --12
GriphRH.arena3.texture = GriphRH.arena3:CreateTexture(nil, "OVERLAY")
GriphRH.arena3.texture:SetAllPoints(true)
GriphRH.arena3:SetScale(1)
GriphRH.arena3:Show(1)

GriphRH.arena32 = CreateFrame("Frame", nil, GriphRH.topIcons, "BackdropTemplate")
GriphRH.arena32:SetBackdrop(nil)
GriphRH.arena32:SetFrameStrata("TOOLTIP")
GriphRH.arena32:SetSize(8, 8)
GriphRH.arena32:SetPoint("TOPLEFT", GriphRH.topIcons, 561, -20) --12
GriphRH.arena32.texture = GriphRH.arena32:CreateTexture(nil, "OVERLAY")
GriphRH.arena32.texture:SetAllPoints(true)
GriphRH.arena32.texture:SetColorTexture(1, 0, 0, 0)
GriphRH.arena32:SetScale(1)
GriphRH.arena32:Show(1)

TargetColor = CreateFrame("Frame", "TargetColor", GriphRH.topIcons, "BackdropTemplate")
TargetColor:SetBackdrop(nil)
TargetColor:SetFrameStrata("TOOLTIP")
TargetColor:SetSize(1, 1)
TargetColor:SetScale(1)
TargetColor:SetPoint("TOPLEFT", GriphRH.topIcons, 737, -12)
TargetColor.texture = TargetColor:CreateTexture(nil, "OVERLAY")
TargetColor.texture:SetAllPoints(true)
TargetColor.texture:SetColorTexture(0, 0, 0, 1.0)

local showedOnce = false
local function ScaleFix()
	local resolution
	local DPI = GetScreenDPIScale()
    if GetCVar("gxMaximize") == "1" then 
		-- Fullscreen (only 8.2+)
		resolution = tonumber(strmatch(GetScreenResolutions(), "%dx(%d+)")) --tonumber(string.match(GetCVar("gxFullscreenResolution"), "%d+x(%d+)"))
	else 
		-- Windowed 
		resolution = select(2, GetPhysicalScreenSize()) --tonumber(string.match(GetCVar("gxWindowedResolution"), "%d+x(%d+)")) 
		
		-- Regarding Windows DPI
		-- Note: Full HD 1920x1080 offsets (100% X8 Y31 / 125% X9 Y38)
		-- You might need specific thing to get truth relative graphic area, so just contact me if you see this and can't find fix for DPI > 1 e.g. 100%
		if not showedOnce and GetScreenDPIScale() ~= 1 then 
			message("You use not 100% Windows DPI and this can may apply conflicts. Set own X and Y offsets in source.")
		end 
	end 	
	
	local myscale1 = 0.42666670680046 * (1080 / resolution)

    GriphRH.topIcons:SetParent(nil)
    GriphRH.topIcons:SetScale(myscale1) 
	GriphRH.topIcons:SetFrameStrata("TOOLTIP")
	GriphRH.topIcons:SetToplevel(true)
	
    if TargetColor then
        if not TargetColor:IsShown() then
            TargetColor:Show()
        end
        TargetColor:SetScale((0.71111112833023 * (1080 / resolution)) / (TargetColor:GetParent() and TargetColor:GetParent():GetEffectiveScale() or 1))
    end    
end

local function ElvUIFix()
    if not ElvUI then 
        return 
    end
    
    local _G, getmetatable, hooksecurefunc 	= 
          _G, getmetatable, hooksecurefunc
          
    local CreateFrame						= _G.CreateFrame	  
    local EnumerateFrames					= _G.EnumerateFrames
    
    local handled = { ["Frame"] = true }
    local object = CreateFrame("Frame")
    object.t = object:CreateTexture(nil,"BACKGROUND")
    local OldTexelSnappingBias = object.t:GetTexelSnappingBias()
    
    local function Fix(frame)
        if (frame and not frame:IsForbidden()) and frame.PixelSnapDisabled and not frame.PixelSnapTurnedOff then
            if frame.SetSnapToPixelGrid then
                frame:SetTexelSnappingBias(OldTexelSnappingBias)
            elseif frame.GetStatusBarTexture then
                local texture = frame:GetStatusBarTexture()
                if texture and texture.SetSnapToPixelGrid then                
                    texture:SetTexelSnappingBias(OldTexelSnappingBias)
                end
            end
            frame.PixelSnapTurnedOff = true 
        end
    end
    
    local function addapi(object)
        local mt = getmetatable(object).__index
        if mt.DisabledPixelSnap then 
            if mt.SetSnapToPixelGrid then hooksecurefunc(mt, 'SetSnapToPixelGrid', Fix) end
            if mt.SetStatusBarTexture then hooksecurefunc(mt, 'SetStatusBarTexture', Fix) end
            if mt.SetColorTexture then hooksecurefunc(mt, 'SetColorTexture', Fix) end
            if mt.SetVertexColor then hooksecurefunc(mt, 'SetVertexColor', Fix) end
            if mt.CreateTexture then hooksecurefunc(mt, 'CreateTexture', Fix) end
            if mt.SetTexCoord then hooksecurefunc(mt, 'SetTexCoord', Fix) end
            if mt.SetTexture then hooksecurefunc(mt, 'SetTexture', Fix) end
        end
    end
    
    addapi(object)
    addapi(object:CreateTexture())
    addapi(object:CreateFontString())
    addapi(object:CreateMaskTexture())
    object = EnumerateFrames()
    while object do
        if not object:IsForbidden() and not handled[object:GetObjectType()] then
            addapi(object)
            handled[object:GetObjectType()] = true
        end
        
        object = EnumerateFrames(object)
    end
end

local function UpdateCVAR()
    if GetCVar("Contrast")~="50" then 
		SetCVar("Contrast", 50)
		print("Contrast should be 50")		
	end
    if GetCVar("Brightness")~="50" then 
		SetCVar("Brightness", 50) 
		print("Brightness should be 50")			
	end
    if GetCVar("Gamma")~="1.000000" then 
		SetCVar("Gamma", "1.000000") 
		print("Gamma should be 1")	
	end
    if GetCVar("colorblindsimulator")~="0" then SetCVar("colorblindsimulator", 0) end; 
    -- Not neccessary
    if GetCVar("RenderScale")~="1" then SetCVar("RenderScale", 1) end; 
	--[[
    if GetCVar("MSAAQuality")~="0" then SetCVar("MSAAQuality", 0) end;
    -- Could effect bugs if > 0 but FXAA should work, some people saying MSAA working too 
	local AAM = tonumber(GetCVar("ffxAntiAliasingMode"))
    if AAM > 2 and AAM ~= 6 then 		
		SetCVar("ffxAntiAliasingMode", 0) 
		print("You can't set higher AntiAliasing mode than FXAA or not equal to MSAA 8x")
	end
	]]
    if GetCVar("doNotFlashLowHealthWarning")~="1" then SetCVar("doNotFlashLowHealthWarning", 1) end; 
    -- WM removal
    if GetCVar("screenshotQuality")~="10" then SetCVar("screenshotQuality", 10) end;    
    -- UNIT_NAMEPLAYES_AUTOMODE (must be visible)
    if GetCVar("nameplateShowAll")=="0" then
        SetCVar("nameplateShowAll", 1)
		print("All nameplates should be visible")
    end
    if GetCVar("nameplateShowEnemies")~="1" then
        SetCVar("nameplateShowEnemies", 1) 
        print("Enemy nameplates should be enabled")
    end
end

local function ConsoleUpdate()
    UpdateCVAR()  
	ScaleFix()
	ElvUIFix()
end 


GriphRH.Listener:Add('Griph_Events', 'PLAYER_ENTERING_WORLD', ConsoleUpdate)
GriphRH.Listener:Add('Griph_Events', 'UI_SCALE_CHANGED', ConsoleUpdate)
GriphRH.Listener:Add('Griph_Events', 'DISPLAY_SIZE_CHANGED', ConsoleUpdate)
-- VideoOptionsFrame:HookScript("OnHide", ConsoleUpdate)
-- InterfaceOptionsFrame:HookScript("OnHide", UpdateCVAR)