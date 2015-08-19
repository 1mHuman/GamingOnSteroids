PrintChat("ImHuman's Auto Leveller Loaded!")
First = scriptConfig("FLVlUP", "LVlUp First:")
First.addParam("Q", "Full Q", SCRIPT_PARAM_ONOFF, false)
First.addParam("W", "Full W", SCRIPT_PARAM_ONOFF, false)
First.addParam("E", "Full E", SCRIPT_PARAM_ONOFF, false)
Second = scriptConfig("SLVlUP", "LVlUp Second:")
Second.addParam("Q", "Full Q", SCRIPT_PARAM_ONOFF, false)
Second.addParam("W", "Full W", SCRIPT_PARAM_ONOFF, false)
Second.addParam("E", "Full E", SCRIPT_PARAM_ONOFF, false)
Third = scriptConfig("TLVlUP", "LVlUp Third:")
Third.addParam("Q", "Full Q", SCRIPT_PARAM_ONOFF, false)
Third.addParam("W", "Full W", SCRIPT_PARAM_ONOFF, false)
Third.addParam("E", "Full E", SCRIPT_PARAM_ONOFF, false)

OnLoop(function(myHero)

if GetLevel(myHero) == 6 or GetLevel(myHero) == 11 or GetLevel(myHero) == 16 then
		LevelSpell(_R)
	end

	if GetLevel(myHero) == 3 then
	if Third.Q then
	LevelSpell(_Q);
	elseif Third.W then
	LevelSpell(_W);
	else
	LevelSpell(_E);
	end
	end

local fir = nil
local sec = nil
local thir = nil
if GetLevel(myHero) >= 2 then
if First.Q then
 lvlq = LevelSpell(_Q);
 fir = q
elseif First.W then
lvlw = LevelSpell(_W);
fir = w
	else
	lvle = LevelSpell(_E);
	fir = e
	end

    if fir == q and lvlq == false then
	if Second.W then
	LevelSpell(_W);
	sec = w
	else
	LevelSpell(_E);
	sec = e
	end
	end

	if fir == w and lvlw == false then
	if Second.Q then
	LevelSpell(_Q);
	sec = q
	else
	LevelSpell(_E);
	sec = e
	end
	end

	if fir == e and lvle == false then
	if Second.Q then
	LevelSpell(_Q);
	sec = q
	else
	LevelSpell(_W);
	sec = w
	end
	end


	if sec == q and lvlq == false then
	if Third.W then
	LevelSpell(_W);
	thir = w
	else
	LevelSpell(_E)
	thir = e
	end
	end


	if sec == w and lvlw == false then
	if Third.Q then
	LevelSpell(_Q);
	thir = q
	else
	LevelSpell(_E)
	thir = e
	end
	end

	if sec == e and lvle == false then
	if Third.Q then
	LevelSpell(_Q);
	thir = q
	else
	LevelSpell(_W)
	thir = w
	end
	end


	end
end)
