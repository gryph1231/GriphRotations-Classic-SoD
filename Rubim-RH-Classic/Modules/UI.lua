local HL = HeroLibEx;
local Cache = HeroCache;
local StdUi = LibStub('StdUi')
local AceGUI = LibStub("AceGUI-3.0")

function AllMenu(selectedTab, point, relativeTo, relativePoint, xOfs, yOfs)
    local window = StdUi:Window(UIParent, 'Class Config', 450, 500);

    window:SetPoint('CENTER');

    if point ~= nil then
        window:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end

    local tabs = {
        {
            name = 'firstTab',
            title = 'General',
        },
        {
            name = 'secondTab',
            title = 'Class'
        },
        {
            name = 'thirdTab',
            title = 'Spells',
        },
        {
            name = 'forthTab',
            title = 'Interrupt',
        },
        {
            name = 'fiftyTab',
            title = 'Extra Info',
        },
    }
    local tabFrame = StdUi:TabPanel(window, nil, nil, tabs);
    StdUi:GlueAcross(tabFrame, window, 10, -40, -10, 20);

    if selectedTab ~= nil then
        tabFrame:SelectTab(selectedTab)
    end

    tabFrame:EnumerateTabs(function(tab)
        if tab.title == "General" then
            local gn_title = StdUi:FontString(tab.frame, 'Interface');
            StdUi:GlueTop(gn_title, tab.frame, 0, -10);
            local gn_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(gn_separator, gn_title, 0, -12);

            local config1_0 = StdUi:Checkbox(tab.frame, 'Glow Action Bar');
            StdUi:GlueTop(config1_0, gn_separator, -100, -24, 'LEFT');
            config1_0:SetChecked(RubimRH.db.profile.mainOption.glowactionbar)
            function config1_0:OnValueChanged(self, state, value)
                RubimRH.GlowActionBarToggle()
            end

            local config1_1 = StdUi:Checkbox(tab.frame, 'Mute Sounds');
            StdUi:GlueTop(config1_1, gn_separator, 100, -24, 'RIGHT');
            config1_1:SetChecked(RubimRH.db.profile.mainOption.mute)
            function config1_1:OnValueChanged(self, state, value)
                RubimRH.MuteToggle()
            end

            local config2_0 = StdUi:Checkbox(tab.frame, 'Debug Verbose');
            StdUi:GlueTop(config2_0, config1_0, 0, -24, 'LEFT');
            config2_0:SetChecked(RubimRH.db.profile.mainOption.debug)
            function config2_0:OnValueChanged(self, state, value)
                RubimRH.DebugToggle()
            end

            local ic_title = StdUi:FontString(tab.frame, 'Icon');
            StdUi:GlueTop(ic_title, tab.frame, 0, -110);
            local ic_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(ic_separator, ic_title, 0, -12);

            local ic_1_0 = StdUi:Checkbox(tab.frame, 'Lock Icon');
            StdUi:GlueTop(ic_1_0, ic_separator, -100, -24, 'LEFT');
            ic_1_0:SetChecked(RubimRH.db.profile.mainOption.mainIconLock)
            function ic_1_0:OnValueChanged(self, state, value)
                RubimRH.MainIconLockToggle()
            end

            local ic_1_1 = StdUi:Checkbox(tab.frame, 'Enable Icon');
            StdUi:GlueTop(ic_1_1, ic_separator, 100, -24, 'RIGHT');
            ic_1_1:SetChecked(RubimRH.db.profile.mainOption.mainIcon)
            function ic_1_1:OnValueChanged(self, state, value)
                RubimRH.MainIconToggle()
            end

            local ic_2_0 = StdUi:Checkbox(tab.frame, 'Hide Texture');
            StdUi:GlueTop(ic_2_0, ic_1_0, 0, -24, 'LEFT');
            ic_2_0:SetChecked(RubimRH.db.profile.mainOption.hidetexture)
            function ic_2_0:OnValueChanged(self, state, value)
                RubimRH.HideTextureToggle()
            end

            local ic_2_1 = StdUi:Checkbox(tab.frame, 'Debug Verbose');
            StdUi:GlueTop(ic_2_1, ic_1_1, 0, -24, 'RIGHT');
            ic_2_1:SetChecked(RubimRH.db.profile.mainOption.glowactionbar)
            function ic_2_1:OnValueChanged(self, state, value)
                RubimRH.GlowActionBarToggle()
            end

            ic_2_1:Hide()

            local ic_3_0 = StdUi:Slider(tab.frame, 125, 16, RubimRH.db.profile.mainOption.mainIconOpacity, false, 0, 100)
            StdUi:GlueBelow(ic_3_0, ic_2_0, 0, -24, 'LEFT');
            local config3_1Label = StdUi:FontString(tab.frame, "Icon Opacity: " .. RubimRH.db.profile.mainOption.mainIconOpacity)
            StdUi:GlueTop(config3_1Label, ic_3_0, 0, 16);
            StdUi:FrameTooltip(ic_3_0, "Controls the opacity of the main icon", 'TOPLEFT', 'TOPRIGHT', true);
            function ic_3_0:OnValueChanged(value)
                value = (math.floor((value * ((100) + 0.5)) / (100)))
                RubimRH.db.profile.mainOption.mainIconOpacity = value
                ic_3_0 = value
                config3_1Label:SetText("Icon Opacity: " .. RubimRH.db.profile.mainOption.mainIconOpacity)
            end

            local ic_3_1 = StdUi:Slider(tab.frame, 125, 16, RubimRH.db.profile.mainOption.mainIconScale / 10, false, 5, 75)
            StdUi:GlueBelow(ic_3_1, ic_2_1, 0, -24, 'RIGT');
            local config3_1Label = StdUi:FontString(tab.frame, "Icon Size: " .. RubimRH.db.profile.mainOption.mainIconScale)
            StdUi:GlueTop(config3_1Label, ic_3_1, 0, 16);
            StdUi:FrameTooltip(ic_3_1, "Controls the opacity of the main icon", 'TOPLEFT', 'TOPRIGHT', true);
            function ic_3_1:OnValueChanged(value)
                local value = math.floor(value) * 10
                RubimRH.db.profile.mainOption.mainIconScale = value
                ic_3_1 = value
                config3_1Label:SetText("Icon Size: " .. RubimRH.db.profile.mainOption.mainIconScale)
            end

            local ex_title = StdUi:FontString(tab.frame, 'Extra');
            StdUi:GlueTop(ex_title, tab.frame, 0, -250);
            local ex_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(ex_separator, ex_title, 0, -12);

            local ex_title = StdUi:FontString(tab.frame, 'Keybind section was moved to the WoW Keybind interface.\nESC -> KEY BINDING > RUBIMRH');
            StdUi:GlueBelow(ex_title, ex_separator, 0, -25, "CENTER");


        end
        if tab.title == 'Class' then
        end
        if tab.title == "Spells" then
            local spellBlocker_title = StdUi:FontString(tab.frame, 'Spell Blocker');
            StdUi:GlueTop(spellBlocker_title, tab.frame, 0, -10, 'CENTER');

            local function showTooltip(frame, show, spellId)
                if show then
                    GameTooltip:SetOwner(frame);
                    GameTooltip:SetPoint('RIGHT');
                    GameTooltip:SetSpellByID(spellId)
                else
                    GameTooltip:Hide();
                end

            end

            local data = {};
            local cols = {

                {
                    name = 'Enabled',
                    width = 60,
                    align = 'LEFT',
                    index = 'enabled',
                    format = 'string',
                    color = function(table, value, rowData, columnData)
                        if value == "True" then
                            return { r = 0, g = 1, b = 0, a = 1 }
                        end
                        if value == "False" then
                            return { r = 1, g = 0, b = 0, a = 1 }
                        end
                    end
                },

                {
                    name = 'Spell ID',
                    width = 60,
                    align = 'LEFT',
                    index = 'spellId',
                    format = 'number',
                    color = function(table, value)
                        --local x = value / 200000;
                        --return { r = x, g = 1 - x, b = 0, a = 1 };
                    end
                },
                {
                    name = 'Spell Name',
                    width = 160,
                    align = 'LEFT',
                    index = 'name',
                    format = 'string',
                },

                {
                    name = 'Icon',
                    width = 40,
                    align = 'LEFT',
                    index = 'icon',
                    format = 'icon',
                    sortable = false,
                    events = {
                        OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            local cellData = rowData[columnData.index];
                            showTooltip(cellFrame, true, rowData.spellId);
                            return false;
                        end,
                        OnLeave = function(rowFrame, cellFrame)
                            showTooltip(cellFrame, false);
                            return false;
                        end,
                    },
                },
            }

            local st = StdUi:ScrollTable(tab.frame, cols, 12, 20);
            st:EnableSelection(true);
            StdUi:GlueTop(st, tab.frame, 0, -60);

            local function addSpell(spellID)
                local name = nil;
                local icon, castTime, minRange, maxRange, spellId;

                name, _, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID);
                local enabled = "True"
                if RubimRH.db.profile.mainOption.disabledSpells[spellID] == true then
                    enabled = "False"
                end

                return {
                    enabled = enabled,
                    name = name,
                    icon = icon,
                    castTime = castTime,
                    minRange = minRange,
                    maxRange = maxRange,
                    spellId = spellId;
                };
            end

            local data = {};

            for key, spell in pairs(HeroCache.Persistent.SpellLearned.Player) do
                if IsPassiveSpell(key) == false then
                    tinsert(data, addSpell(key));
                end
            end

            for key, spell in pairs(HeroCache.Persistent.SpellLearned.Pet) do
                if IsPassiveSpell(key) == false then
                    tinsert(data, addSpell(key));
                end
            end

            -- update scroll table data
            st:SetData(data);

            local function btn_blockSpell()
                if data[st:GetSelection()] ~= nil then
                    local spellID = data[st:GetSelection()].spellId
                    if RubimRH.db.profile.mainOption.disabledSpells[spellID] ~= nil then
                        RubimRH.db.profile.mainOption.disabledSpells[spellID] = nil
                        data[st:GetSelection()].enabled = "True"
                        print("Removed: " .. GetSpellLink(spellID))
                    else
                        RubimRH.db.profile.mainOption.disabledSpells[spellID] = true
                        print("Added: " .. GetSpellLink(spellID))
                        data[st:GetSelection()].enabled = "False"
                    end
                    RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                    st:ClearSelection()
                    --window:Hide()
                    --local point, relativeTo, relativePoint, xOfs, yOfs = window:GetPoint()
                    --AllMenu("thirdTab", point, relativeTo, relativePoint, xOfs, yOfs)
                    --RubimRH.SpellBlocker(nil, point, relativeTo, relativePoint, xOfs, yOfs)
                    --

                    return
                end
                print("No Spell Selected")
            end

            local function btn_createMacro()
                if data[st:GetSelection()] ~= nil then
                    local SpellDATA = data[st:GetSelection()]
                    local SpellVAR = nil

                    for key, Spell in pairs(RubimRH.Spell[RubimRH.playerClass]) do
                        if Spell:ID() == SpellDATA.spellId then
                            SpellVAR = key
                        end
                    end
                    RubimRH.print("Macro for: " .. GetSpellLink(SpellDATA.spellId) .. " was created. Check your Character Macros.")
                    CreateMacro(SpellDATA.name, SpellDATA.icon, "#showtooltip " .. GetSpellInfo(SpellDATA.spellId) .. "\n/run HeroLib.Spell(" .. tostring(SpellDATA.spellId) .. "):Queue()", 1)
                    RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                    st:ClearSelection()
                    return
                end
                print("No Spell Selected")
            end

            local btn = StdUi:Button(tab.frame, 125, 24, 'Block Spell');
            StdUi:GlueBelow(btn, st, 0, -24, "LEFT");
            btn:SetScript('OnClick', btn_blockSpell);
            StdUi:FrameTooltip(btn, 'This will block the spell from the spellist of the rotation aka it will never cast it.', 'TOPLEFT', 'TOPRIGHT', true);

            local btn2 = StdUi:Button(tab.frame, 125, 24, 'Create Macro');
            StdUi:GlueBelow(btn2, st, 0, -24, "RIGHT");
            btn2:SetScript('OnClick', btn_createMacro);
            StdUi:FrameTooltip(btn2, 'This will create a Queue macro :).', 'TOPLEFT', 'TOPRIGHT', true);

            --local blockingTip = StdUi:FontString(tab.frame, 'You can macro the spell blocker by using:\n/run RubimRH.SpellBlocker(spellID)');
            --StdUi:GlueTop(blockingTip, btn, 0, -30);
        end
        if tab.title == "Interrupt" then
            local interruptList_title = StdUi:FontString(tab.frame, 'Custom Interrupt');
            StdUi:GlueTop(interruptList_title, tab.frame, 0, -10, 'CENTER');

            local function showTooltip(frame, show, spellId)
                if show then
                    GameTooltip:SetOwner(frame);
                    GameTooltip:SetPoint('RIGHT');
                    GameTooltip:SetSpellByID(spellId)
                else
                    GameTooltip:Hide();
                end

            end
            local selectedSpell = {}
            local data = {};
            local cols = {

                {
                    name = 'Spell ID',
                    width = 60,
                    align = 'LEFT',
                    index = 'spellId',
                    format = 'number',
                    color = function(table, value)
                        --local x = value / 200000;
                        --return { r = x, g = 1 - x, b = 0, a = 1 };
                    end,
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,
                    }
                },
                {
                    name = 'Spell Name',
                    width = 160,
                    align = 'LEFT',
                    index = 'name',
                    format = 'string',
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,
                    }
                },

                {
                    name = 'Icon',
                    width = 35,
                    align = 'LEFT',
                    index = 'icon',
                    format = 'icon',
                    sortable = false,
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,

                        OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            local cellData = rowData[columnData.index];
                            showTooltip(cellFrame, true, rowData.spellId);
                            return false;
                        end,
                        OnLeave = function(rowFrame, cellFrame)
                            showTooltip(cellFrame, false);
                            return false;
                        end,
                    },
                },
            }

            local st = StdUi:ScrollTable(tab.frame, cols, 12, 20);
            st:EnableSelection(true);
            StdUi:GlueTop(st, tab.frame, 0, -60);

            local function addSpell(spellID)
                local name = nil;
                local icon, castTime, minRange, maxRange, spellId;

                name, _, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID);

                return {
                    name = name,
                    icon = icon,
                    castTime = castTime,
                    minRange = minRange,
                    maxRange = maxRange,
                    spellId = spellId;
                };
            end

            local data = {};

            for i, spell in pairs(RubimRH.db.profile.mainOption.interruptList) do
                table.insert(data, addSpell(i));
            end

            -- update scroll table data
            st:SetData(data);

            local tempAddSpell = 0
            local function btn_addSpell()

                if not GetSpellInfo(tempAddSpell) then
                    return
                end

                if tempAddSpell ~= 0 and RubimRH.db.profile.mainOption.interruptList[tempAddSpell] == nil then
                    RubimRH.db.profile.mainOption.interruptList[tempAddSpell] = true
                end

                local data = {};
                for i, spell in pairs(RubimRH.db.profile.mainOption.interruptList) do
                    table.insert(data, addSpell(i));
                end
                st:SetData(data);
            end

            function RubimRH.RefreshList()
                local data = {};
                for i, spell in pairs(RubimRH.db.profile.mainOption.interruptList) do
                    table.insert(data, addSpell(i));
                end
                st:SetData(data);
                st:ClearSelection()
            end
            local function btn_delSpell()
                if selectedSpell ~= nil then
                    RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                    RubimRH.db.profile.mainOption.interruptList[selectedSpell] = nil
                    selectedSpell = nil

                    local data = {};
                    for i, spell in pairs(RubimRH.db.profile.mainOption.interruptList) do
                        table.insert(data, addSpell(i));
                    end
                    st:SetData(data);
                    st:ClearSelection()
                    return
                end
                print("No Spell Selected")
            end

            local btn = StdUi:Button(tab.frame, 125, 24, 'Add Spell');
            StdUi:GlueBelow(btn, st, 0, -24, "LEFT");
            btn:SetScript('OnClick', btn_addSpell);
            StdUi:FrameTooltip(btn, 'Add spell to the White or Black list.', 'TOPLEFT', 'TOPRIGHT', true);

            local btn_num = StdUi:NumericBox(tab.frame, 125, 24, 1);
            btn_num:SetMaxValue(9999999);
            btn_num:SetMinValue(0);
            StdUi:GlueBelow(btn_num, btn, 0, -20, 'LEFT');
            btn_num:SetScript("OnTextChanged", function(self, bool, value)
                showTooltip(self, true, self:GetNumber())
                tempAddSpell = self:GetNumber()
            end)

            btn_num:SetScript("OnEnterPressed", function(self, bool, value)
                showTooltip(self, false)
                tempAddSpell = self:GetNumber()
                btn_addSpell()
            end)

            local btn2 = StdUi:Button(tab.frame, 125, 24, 'Delete Spell');
            StdUi:GlueBelow(btn2, st, 0, -24, "RIGHT");
            btn2:SetScript('OnClick', btn_delSpell);
            StdUi:FrameTooltip(btn2, 'Delete a Spell.', 'TOPLEFT', 'TOPRIGHT', true);

            local whiteListOptions = {
                { text = 'Whitelist', value = "Whitelist" },
                { text = 'Blacklist', value = "Blacklist" },
            }

            local whiteListText = (RubimRH.db.profile.mainOption.whiteList == true and 'Whitelist' or 'Blacklist')

            local gn_2_1 = StdUi:Dropdown(tab.frame, 125, 20, whiteListOptions, nil, nil);
            gn_2_1:SetPlaceholder(whiteListText);
            gn_2_1.OnValueChanged = function(self, val)
                RubimRH.db.profile.mainOption.whiteList = (val == "Whitelist" and true or false)
                whiteListText = (RubimRH.db.profile.mainOption.whiteList == true and 'Whitelist' or 'Blacklist')
                gn_2_1:SetText(whiteListText);
            end
            StdUi:GlueBelow(gn_2_1, btn2, 0, -24, 'RIGHT');


            local ic_2_1 = StdUi:Checkbox(tab.frame, 'Whitelist');
            StdUi:GlueBelow(ic_2_1, btn2, 0, -24, 'RIGHT');
            ic_2_1:SetChecked(RubimRH.db.profile.mainOption.whiteList)
            function ic_2_1:OnValueChanged(self, state, value)
                if RubimRH.db.profile.mainOption.whiteList then
                    RubimRH.db.profile.mainOption.whiteList = false
                else
                    RubimRH.db.profile.mainOption.whiteList = true
                end
            end
        end


    end);
end

function RubimRH.SpellBlocker(spellID, point, relativeTo, relativePoint, xOfs, yOfs)
    if spellID ~= nil then
        if RubimRH.db.profile.mainOption.disabledSpells[spellID] ~= nil then
            RubimRH.db.profile.mainOption.disabledSpells[spellID] = nil
            print("Removed: " .. GetSpellLink(spellID))
        else
            RubimRH.db.profile.mainOption.disabledSpells[spellID] = true
            print("Added: " .. GetSpellLink(spellID))
        end
        return
    end
end

function RubimRH.ClassConfig(specID)
    AllMenu('secondTab')
end
