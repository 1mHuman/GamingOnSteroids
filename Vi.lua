if GetObjectName(GetMyHero()) ~= "Vi" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

local ViMenu = MenuConfig("Vi", "Vi")
ViMenu:Menu("Combo", "Combo")
ViMenu.Combo:Boolean("Q", "Use Q", true)
ViMenu.Combo:Boolean("E", "Use E", true)
ViMenu.Combo:Boolean("R", "Use R", true)
ViMenu.Combo:Slider("Rhp", "Use R if Target Health % <", 30, 1, 100, 1)

ViMenu:Menu("Harass", "Harass")
ViMenu.Harass:Boolean("Q", "Use Q", true)
ViMenu.Harass:Boolean("E", "Use E", true)

ViMenu:Menu("Killsteal", "Killsteal")
ViMenu.Killsteal:Boolean("R", "Killsteal with R", true)

ViMenu:Menu("JungleClear", "Jungle Clear")
ViMenu.JungleClear:Boolean("Q", "Use Q", true)
ViMenu.JungleClear:Boolean("E", "Use E", false)
ViMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

ViMenu:Menu("Drawings", "Drawings")
ViMenu.Drawings:Boolean("R", "Draw R Range", true)

local InterruptMenu = MenuConfig("Interrupt (Q)", "Interrupt")

CHANELLING_SPELLS = {
    ["CaitlynAceintheHole"]         = {Name = "Caitlyn",      Spellslot = _R},
    ["Drain"]                       = {Name = "FiddleSticks", Spellslot = _W},
    ["Crowstorm"]                   = {Name = "FiddleSticks", Spellslot = _R},
    ["GalioIdolOfDurand"]           = {Name = "Galio",        Spellslot = _R},
    ["FallenOne"]                   = {Name = "Karthus",      Spellslot = _R},
    ["KatarinaR"]                   = {Name = "Katarina",     Spellslot = _R},
    ["LucianR"]                     = {Name = "Lucian",       Spellslot = _R},
    ["AlZaharNetherGrasp"]          = {Name = "Malzahar",     Spellslot = _R},
    ["MissFortuneBulletTime"]       = {Name = "MissFortune",  Spellslot = _R},
    ["AbsoluteZero"]                = {Name = "Nunu",         Spellslot = _R},
    ["Pantheon_GrandSkyfall_Jump"]  = {Name = "Pantheon",     Spellslot = _R},
    ["ShenStandUnited"]             = {Name = "Shen",         Spellslot = _R},
    ["UrgotSwap2"]                  = {Name = "Urgot",        Spellslot = _R},
    ["VarusQ"]                      = {Name = "Varus",        Spellslot = _Q},
    ["InfiniteDuress"]              = {Name = "Warwick",      Spellslot = _R}
}

DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        InterruptMenu:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 1)

local isCastingQ = false
local qTime = 0
local qRangeMin = GetCastRange(myHero,_Q)
local qRangeMax = 800

OnDraw(function(myHero)
if ViMenu.Drawings.R:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_R),3,100,0xff00ff00) end
end)

OnTick(function(myHero)

local target = GetCurrentTarget()
local myHeroPos = myHeroPos()

if IOW:Mode() == "Combo" then
if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, 800) and ViMenu.Combo.Q:Value() then
	if not target then return end
	if IsInDistance(target, qRangeMax) and CanUseSpell(myHero,_Q) == READY then
		local qRange = qRangeMin + (GetGameTimer() - qTime) * 500
		if qRange > qRangeMax then	qRange = qRangeMax end
		if not isCastingQ then
      CastSkillShot(_Q,GetMousePos())
      return
    end
    if IsInDistance(target, qRange) then
    	local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),math.huge,600,qRange,100,false,true)
    	if pred.HitChance == 1 and qRange > 700 then
    		CastSkillShot2(_Q,pred.PredPos)
    	end
		end
	end
    end


if CanUseSpell(myHero,_E) == READY and ValidTarget(target, 175) and ViMenu.Combo.E:Value() then
    CastSpell(_E)
    end

if ViMenu.Combo.R:Value() then
    for _, enemy in pairs(GetEnemyHeroes()) do
	   if CanUseSpell(myHero,_R) == READY and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) <= ViMenu.Combo.Rhp:Value() and ValidTarget(enemy, 800) then
	CastTargetSpell(enemy, _R)
    end
  end
end

end

if IOW:Mode() == "Harass"  then
if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, 800) and ViMenu.Harass.Q:Value() then
	  if not target then return end
	if IsInDistance(target, qRangeMax) and CanUseSpell(myHero,_Q) == READY then
		local qRange = qRangeMin + (GetGameTimer() - qTime) * 500
		if qRange > qRangeMax then	qRange = qRangeMax end
		if not isCastingQ then
      CastSkillShot(_Q,GetMousePos())
      return
    end
    if IsInDistance(target, qRange) then
    	local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),math.huge,600,qRange,100,false,true)
    	if pred.HitChance == 1 then
    		CastSkillShot2(_Q,pred.PredPos)
    	end
		end
	end
    end

if CanUseSpell(myHero,_E) == READY and ValidTarget(target, 175) and ViMenu.Harass.E:Value() then
    CastSpell(_E)
    end
end

	if ViMenu.Killsteal.R:Value() then
    for _, enemy in pairs(GetEnemyHeroes()) do
	   if CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 150*GetCastLevel(myHero,_R) + 1.4*GetBonusDmg(myHero)) and ValidTarget(enemy, 800) then
	CastTargetSpell(enemy, _R)
    end
  end
end

 for i,mobs in pairs(minionManager.objects) do
        if IOW:Mode() == "LaneClear" and GetTeam(mobs) == 300 and GetPercentMP(myHero) >= ViMenu.JungleClear.Mana:Value() then
          if CanUseSpell(myHero,_Q) == READY and ViMenu.JungleClear.Q:Value() and ValidTarget(mobs, 800) then
          if not mobs then return end
	     if IsInDistance(mobs, qRangeMax) and CanUseSpell(myHero,_Q) == READY then
		local qRange = qRangeMin + (GetGameTimer() - qTime) * 500
		if qRange > qRangeMax then	qRange = qRangeMax end
		if not isCastingQ then
      CastSkillShot(_Q,GetMousePos())
      return
    end
    if IsInDistance(mobs, qRange) then
    		CastSkillShot2(_Q,GetOrigin(mobs))
		end
	  end
	end

	  if CanUseSpell(myHero,_E) == READY and ViMenu.JungleClear.E:Value() and ValidTarget(mobs, 175) then
	  CastSpell(_E)
          end
        end
    end
end)

OnProcessSpell(function(unit, spell)
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and CanUseSpell(myHero,_Q) == READY then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 800) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then
        local qRange = qRangeMin + (GetGameTimer() - qTime) * 500
		if qRange > qRangeMax then	qRange = qRangeMax end
		if not isCastingQ then
      CastSkillShot(_Q,GetMousePos())
    end
	if IsInDistance(unit, qRange) then
    	local pred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),math.huge,600,qRange,100,false,true)
    	if pred.HitChance == 1 then
    		CastSkillShot2(_Q,pred.PredPos)
    	end
		end
        end
      end
    end
end)

local qBuffName = "ViQ"
OnUpdateBuff(function(object,buffProc)
if object == myHero then
		local buffName = buffProc.Name
		if buffName == qBuffName then
			isCastingQ = true
			qTime = buffProc.StartTime
		end
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero then
		local buffName = buffProc.Name
		if buffName == qBuffName then
			isCastingQ = false
		end
	end
end)
