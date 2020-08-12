-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent. state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff.Saboteur = buffactive.saboteur or false

	--event_list = L{}
	--event_list:append()
	windower.register_event('time change', time_change)

	include('Mote-TreasureHunter.lua')
	state.TreasureMode:set('Tag')

	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}

	determine_haste_group()
end

-- Setup vars that are user-dependent. Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc')
	state.HybridMode:options('Normal', 'DT')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Acc', 'MB', 'MBAcc')
	state.PhysicalDefenseMode:options('PDT', 'RefreshPDT')

	state.BattleMode = M(false, 'Frontline')
	state.ConserveMP = M(false, 'AF Body')

	MNDPotencySpells = S{'Paralyze', 'Paralyze II', 'Slow', 'Slow II', 'Addle', 'Distract', 'Distract II', 'Frazzle', 'Frazzle II'}
	INTAccuracySpells = S{'Sleep', 'Sleep II', 'Sleepga', 'Sleepga II', 'Break', 'Breakga', 'Bind', 'Dispel', 'Gravity', 'Gravity II'}
	EarthSpells = S{'Stone', 'Stone II', 'Stone III', 'Stone IV', 'Stone V', 'Stonega', 'Stonega II', 'Stonega III', 'Stoneja', 'Stonera', 'Stonera II', 'Geohelix'}
	IceSpells = S{'Blizzard', 'Blizzard II', 'Blizzard III', 'Blizzard IV', 'Blizzard V', 'Blizzaga', 'Blizzaga II', 'Blizzaga III', 'Blizzaja', 'Blizzara', 'Blizzara II', 'Cryohelix'}
	SkillSpells = S{'Temper','Temper II'}
	Shields = S{"Genbu's Shield"}

	update_combat_form()

	send_command('bind ^T input /magic "Diaga" <t>')
	send_command('bind !A input /magic "Aspir" <t>')
	send_command('bind !D input /magic "Blizzard IV" <t>')
	send_command('bind ^D input /magic "Blizzard V" <t>')
	send_command('bind ^!D input /magic "Blizzard III" <t>')
	send_command('bind !L input /magic "Aero IV" <t>')
	send_command('bind ^L input /magic "Aero V" <t>')
	send_command('bind ^!L input /magic "Aero III" <t>')
	send_command('bind !I input /magic "Impact" <t>')
	send_command('bind ^S input /ma Stun <t>')

	send_command('bind !f9 gs c toggle BattleMode')
	send_command('bind !f11 gs c toggle ConserveMP')
	
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^T')
	send_command('unbind !A')
	send_command('unbind !D')
	send_command('unbind ^D')
	send_command('unbind ^!D')
	send_command('unbind !L')
	send_command('unbind ^L')
	send_command('unbind ^!L')
	send_command('unbind !I')
	send_command('unbind ^S')
	send_command('unbind !f9')
	send_command('unbind !f11')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

	--------------------------------------
	-- Augmented Gear
	--------------------------------------

	gear.HagCuffs = {}
	gear.HagCuffs.MAcc = {name="Hagondes Cuffs +1",augments={'Phys. dmg. taken -3%','Mag. Acc.+26'}}
	gear.RDMCape = {}
	gear.RDMCape.TP = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Haste+10',}}
	gear.RDMCape.STRWS = {name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	gear.RDMCape.CritWS = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}}
	gear.RDMCape.MND = {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}
	gear.RDMCape.INT = {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}}
	gear.RDMCape.INTWS = {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Weapon skill damage +10%',}}
	gear.VanyaClogs = {}
	gear.VanyaClogs.Cure = {name="Vanya Clogs",augments={'MP+50','"Cure" potency +7%','Enmity-6',}}
	gear.VanyaClogs.Skill = {name="Vanya Clogs",augments={'MP+50','"Cure" potency +7%','Enmity-6',}}

	--------------------------------------
	-- Idle
	--------------------------------------

	sets.idle.Town = {main="Bolelabunga",sub="Beatific Shield +1",ammo="Homiliary",
		head="Viti. Chapeau +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Councilor's Garb",hands="Serpentes Cuffs",ring1="Defending Ring",ring2="Shneddick Ring",
		back="Kumbira Cape",waist="Flume Belt",legs="Nares Trews",feet="Serpentes Sabots"}

	sets.idle.Field = {main="Bolelabunga",sub="Beatific Shield +1",ammo="Homiliary",
		head="Viti. Chapeau +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Jhakri Robe +1",hands="Serpentes Cuffs",ring1="Defending Ring",ring2="Shneddick Ring",
		back="Kumbira Cape",waist="Flume Belt",legs="Nares Trews",feet="Serpentes Sabots"}

	sets.idle.Weak = {main="Bolelabunga",sub="Beatific Shield +1",ammo="Homiliary",
		head="Viti. Chapeau +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Jhakri Robe +1",hands="Serpentes Cuffs",ring1="Defending Ring",ring2="Shneddick Ring",
		back="Kumbira Cape",waist="Flume Belt",legs="Nares Trews",feet="Serpentes Sabots"}

	--------------------------------------
	-- Defense
	--------------------------------------

	sets.defense.PDT = {main="Shikargar",sub="Genbu's Shield",ammo="Homiliary",
		head="Lithelimb Cap",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Karmesin Vest",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Shneddick Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Osmium Cuisses",feet="Battlecast Gaiters"}

	sets.defense.RefreshPDT = {main="Shikargar",sub="Genbu's Shield",ammo="Homiliary",
		head="Viti. Chapeau +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Lethargy Sayon +1",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Shneddick Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Osmium Cuisses",feet="Battlecast Gaiters"}

	sets.defense.MDT = {main="Shikargar",sub="Beatific Shield +1",ammo="Homiliary",
		head="Atrophy Chapeau +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Lethargy Sayon +1",hands="Vitivation Gloves +1",ring1="Defending Ring",ring2="Shadow Ring",
		back=gear.RDMCape.INT,waist="Channeler's Stone",legs="Atrophy Tights +1",feet="Merlinic Crackows"}

	--------------------------------------
	-- Resting
	--------------------------------------

	sets.resting = {main="Bolelabunga",sub="Genbu's Shield",ammo="Homiliary",
		head="Viti. Chapeau +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Ethereal Earring",
		body="Lethargy Sayon +1",hands="Serpentes Cuffs",ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Nares Trews",feet="Serpentes Sabots"}

	--------------------------------------
	-- Engaged
	--------------------------------------

	sets.engaged = {main="Excalibur", sub="Beatific Shield +1",ammo="Paeapua",
		head="Jhakri Coronal +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Karmesin Vest",hands="Chironic Gloves",ring1="K'ayres Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Windbuffet Belt",legs="Carmine Cuisses +1",feet="Jhakri Pigaches +1"}

	sets.engaged.Acc = set_combine(sets.engaged, {ammo="Jukukik Feather",neck="Iqabi Necklace"})

	sets.engaged.Acc.Daytime = set_combine(sets.engaged.Acc, {ammo="Tengu-no-Hane"})

	sets.engaged.DW = set_combine(sets.engaged, {ear1="Dudgeon Earring",ear2="Heartseeker Earring",waist="Shetal Stone",feet="Taeon Boots"})

	sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {ear1="Dudgeon Earring",ear2="Heartseeker Earring",waist="Shetal Stone"})

	sets.engaged.DW.Acc.Daytime = set_combine(sets.engaged.Acc.Daytime, {ear1="Dudgeon Earring",ear2="Heartseeker Earring",waist="Shetal Stone"})

	-- Defensive melee group

	sets.engaged.DT = set_combine(sets.engaged, {head="Lithelimb Cap",neck="Twilight Torque",
		hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",legs="Osmium Cuisses",feet="Battlecast Gaiters"})

	sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, {head="Lithelimb Cap",neck="Twilight Torque",
		hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",legs="Osmium Cuisses",feet="Battlecast Gaiters"})

	sets.engaged.Acc.DT.Daytime = set_combine(sets.engaged.Acc.Daytime, {head="Lithelimb Cap",neck="Twilight Torque",
		hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",legs="Osmium Cuisses",feet="Battlecast Gaiters"})

	sets.engaged.DW.DT = set_combine(sets.engaged.DW, {head="Lithelimb Cap",neck="Twilight Torque",
		hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",legs="Osmium Cuisses",feet="Battlecast Gaiters"})

	sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, {head="Lithelimb Cap",neck="Twilight Torque",
		hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",legs="Osmium Cuisses",feet="Battlecast Gaiters"})

	sets.engaged.DW.Acc.DT.Daytime = set_combine(sets.engaged.DW.Acc.Daytime, {head="Lithelimb Cap",neck="Twilight Torque",
		hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",legs="Osmium Cuisses",feet="Battlecast Gaiters"})

	-- Sets for MaxHaste with less DW.

	sets.engaged.MaxHaste = set_combine(sets.engaged, {})
	sets.engaged.Acc.MaxHaste = set_combine(sets.engaged.Acc, {})
	sets.engaged.Acc.Daytime.MaxHaste = set_combine(sets.engaged.Acc.Daytime, {})
	sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {ear1="Brutal Earring",ear2="Suppanomimi",waist="Windbuffet Belt",feet="Jhakri Pigaches +1"})
	sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc, {ear1="Brutal Earring",ear2="Suppanomimi",waist="Windbuffet Belt",feet="Jhakri Pigaches +1"})
	sets.engaged.DW.Acc.Daytime.MaxHaste = set_combine(sets.engaged.DW.Acc.Daytime, {ear1="Brutal Earring",ear2="Suppanomimi",waist="Windbuffet Belt",feet="Jhakri Pigaches +1"})

	sets.FrontlineWeapons = {main="Excalibur", sub="Beatific Shield +1"}
	sets.FrontlineWeapons.DW = {main="Excalibur", sub="Demersal Degen"}

	--------------------------------------
	-- Job Abilities
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Chainspell'] = {body="Viti. Tabard +1"}

	if player.sub_job == 'DNC' then
		-- Waltz set (chr and vit)
		sets.precast.Waltz = {ammo="Homiliary",
			head="Lethargy Chappel +1",neck="Twilight Torque",ear1="Brutal Earring",ear2="Ethereal Earring",
			body="Lethargy Sayon +1",hands="Viti. Gloves +1",ring1="Aqua Ring",ring2="Asklepian Ring",
			back="Kumbira Cape",waist="Flume Belt",legs="Atrophy Tights +1",feet="Jhakri Pigaches +1"}

		sets.precast.Waltz['Healing Waltz'] = {}
	end

	--------------------------------------
	-- Weaponskills
	--------------------------------------

	sets.precast.WS = {ammo="Cheruski Needle",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Aqua Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Jukukik Feather"})
	sets.precast.WS.DaytimeAcc = set_combine(sets.precast.WS.Acc, {ammo="Tengu-no-Hane"})

	-- Specific weaponskill sets. Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Savage Blade'] = {ammo="Cheruski Needle",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Aqua Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {ammo="Jukukik Feather"})
	sets.precast.WS['Savage Blade'].DaytimeAcc = set_combine(sets.precast.WS['Savage Blade'].Acc, {ammo="Tengu-no-Hane"})

	sets.precast.WS['Requiescat'] = {ammo="Oreiad's Tathlum",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Aqua Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {ammo="Jukukik Feather"})
	sets.precast.WS['Requiescat'].DaytimeAcc = set_combine(sets.precast.WS['Requiescat'].Acc, {ammo="Tengu-no-Hane"})

	sets.precast.WS['Knights of Round'] = {ammo="Cheruski Needle",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Aqua Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS['Knights of Round'].Acc = set_combine(sets.precast.WS['Knights of Round'], {ammo="Jukukik Feather"})
	sets.precast.WS['Knights of Round'].DaytimeAcc = set_combine(sets.precast.WS['Knights of Round'].Acc, {ammo="Tengu-no-Hane"})

	sets.precast.WS['Death Blossom'] = {ammo="Cheruski Needle",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Aqua Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS['Death Blossom'].Acc = set_combine(sets.precast.WS['Death Blossom'], {ammo="Jukukik Feather"})
	sets.precast.WS['Death Blossom'].DaytimeAcc = set_combine(sets.precast.WS['Death Blossom'].Acc, {ammo="Tengu-no-Hane"})

	sets.precast.WS['Chant du Cygne'] = {ammo="Yetshila",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Thundersoul Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {ammo="Jukukik Feather"})
	sets.precast.WS['Chant du Cygne'].DaytimeAcc = set_combine(sets.precast.WS['Chant du Cygne'].Acc, {ammo="Tengu-no-Hane"})

	sets.precast.WS['Sanguine Blade'] = {ammo="Witchstone",
		head="Pixie Hairpin +1",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Crematio Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Archon Ring",ring2="Diamond Ring",
		back=gear.RDMCape.INTWS,waist="Channeler's Stone",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}

	sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {head="Jhakri Coronal +1",waist="Chaac Belt"})
	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Sanguine Blade'], {head="Jhakri Coronal +1",waist="Chaac Belt"})
	sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS['Sanguine Blade'], {head="Jhakri Coronal +1"})
	sets.precast.WS['Evisceration'] = sets.precast.WS['Chant du Cygne']
	sets.precast.WS['Evisceration'].Acc = sets.precast.WS['Chant du Cygne'].Acc
	sets.precast.WS['Evisceration'].DaytimeAcc = sets.precast.WS['Chant du Cygne'].DaytimeAcc
	sets.precast.WS['True Strike'] = {ammo="Yetshila",
		head="Jhakri Coronal +1",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Spiral Ring",ring2="Rajas Ring",
		back=gear.RDMCape.TP,waist="Fotia Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"}
	sets.precast.WS['True Strike'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {ammo="Jukukik Feather"})
	sets.precast.WS['True Strike'].DaytimeAcc = set_combine(sets.precast.WS['True Strike'].Acc, {ammo="Tengu-no-Hane"})

	--------------------------------------
	-- Fast Cast
	--------------------------------------

	-- 80% Fast Cast (including trait) for all spells, plus 5% quick cast. No other FC sets necessary.
	sets.precast.FC = {ammo="Impatiens",
		head="Atro. Chapeau +1",neck="Orunmila's Torque",ear1="Estq. Earring",ear2="Enchntr. Earring +1",
		body="Viti. Tabard +1",hands="Gende. Gages +1",ring1="Lebeche Ring",ring2="Prolix Ring",
		back="Ogapepo Cape +1",waist="Witful Belt",legs="Psycloth Lappas",feet="Battlecast Gaiters"}

	sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})

	--------------------------------------
	-- Midcast
	--------------------------------------

	sets.midcast.FastRecast = {
		head="Atro. Chapeau +1",neck="Orunmila's Torque",ear1="Estq. Earring",ear2="Ethereal Earring",
		body="Viti. Tabard +1",hands="Umuthi Gloves",ring1="Lebeche Ring",ring2="Prolix Ring",
		back="Shadow Mantle",waist="Pya'ekue Belt",legs="Psycloth Lappas",feet="Battlecast Gaiters"}

	sets.midcast.Flash = set_combine(sets.midcast.FastRecast, {ammo="Paeapua",
		ear1="Friomisi Earring"})

	--------------------------------------
	-- Dark magic
	--------------------------------------

	sets.midcast['Dark Magic'] = {main="Rubicundity",sub="Mephitis Grip",ammo="Kalboron Stone",
		head="Lethargy Chappel +1",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Jhakri Robe +1",hands=gear.HagCuffs.MAcc,ring1="Sangoma Ring",ring2="Archon Ring",
		back=gear.RDMCape.INT,waist="Channeler's Stone",legs="Psycloth Lappas",feet="Jhakri Pigaches +1"}

	sets.midcast.Stun = {main="Twebuliij",sub="Mephitis Grip",ammo="Impatiens",
		head="Atro. Chapeau +1",neck="Orunmila's Torque",ear1="Estq. Earring",ear2="Enchntr. Earring +1",
		body="Viti. Tabard +1",hands="Gende. Gages +1",ring1="Lebeche Ring",ring2="Prolix Ring",
		back=gear.RDMCape.INT,waist="Witful Belt",legs="Psycloth Lappas",feet="Battlecast Gaiters"}

	sets.midcast['Drain'] = set_combine(sets.midcast.INTAccuracy, {belt="Fucho-no-Obi",feet="Merlinic Crackows"})
	sets.midcast['Aspir'] = set_combine(sets.midcast.INTAccuracy, {belt="Fucho-no-Obi",feet="Merlinic Crackows"})

	--------------------------------------
	-- Elemental magic
	--------------------------------------

	sets.midcast['Elemental Magic'] = {main="Lehbrailg +2",sub="Mephitis Grip",ammo="Witchstone",
		head="Jhakri Coronal +1",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Crematio Earring",
		body="Jhakri Robe +1",hands="Amalric Gages",ring1="Acumen Ring",ring2="Diamond Ring",
		back=gear.RDMCape.INT,waist="Channeler's Stone",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

	sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {ammo="Kalboron Stone",
		head="Jhakri Coronal +1",neck="Imbodla Necklace",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Jhakri Robe +1",ring1="Sangoma Ring",
		back=gear.RDMCape.INT,waist="Channeler's Stone"})

	sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {
		ring2="Mujin Band",back="Seshaw Cape",legs="Merlinic Shalwar",feet="Merlinic Crackows"})

	sets.midcast['Elemental Magic'].MBAcc = set_combine(sets.midcast['Elemental Magic'].Acc, {
		ring2="Mujin Band",back="Seshaw Cape",legs="Merlinic Shalwar",feet="Merlinic Crackows"})

	sets.midcast.Stone = set_combine(sets.midcast['Elemental Magic'], {neck="Quanpur Necklace"})
	sets.midcast.Stone.Acc = set_combine(sets.midcast['Elemental Magic'].Acc, {neck="Quanpur Necklace"})
	sets.midcast.Blizzard = set_combine(sets.midcast['Elemental Magic'], {main="Ngqoqwanb"})
	sets.midcast.Blizzard.Acc = set_combine(sets.midcast['Elemental Magic'].Acc, {main="Ngqoqwanb"})

	sets.midcast.ElementalEnfeeble = {main="Twebuliij",sub="Mephitis Grip",ammo="Kalboron Stone",
		head="Jhakri Coronal +1",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Sangoma Ring",ring2="Perception Ring",
		back=gear.RDMCape.INT,waist="Channeler's Stone",legs="Psycloth Lappas",feet="Jhakri Pigaches +1"}

	sets.midcast.Impact = set_combine(sets.midcast['ElementalEnfeeble'], {head=empty,body="Twilight Cloak"})

	sets.ConserveMP = {body="Seidr Cotehardie"}
	sets.ConserveMP.Weather = {body="Seidr Cotehardie",back="Twilight Cape",waist="Hachirin-no-Obi"}

	--------------------------------------
	-- Enfeebling magic
	--------------------------------------

	sets.midcast['Enfeebling Magic'] = {main="Twebuliij",sub="Mephitis Grip",ammo="Kalboron Stone",
		head="Befouled Crown",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Jhakri Robe +1",hands="Lethargy Gantherots +1",ring1="Sangoma Ring",ring2="Perception Ring",
		back=gear.RDMCape.MND,waist="Porous Rope",legs="Psycloth Lappas",feet="Jhakri Pigaches +1"}

	sets.midcast['Break'] = sets.midcast['Enfeebling Magic']

	sets.midcast['Dia III'] = set_combine(sets.midcast.FastRecast, {head="Viti. Chapeau +1", waist="Chaac Belt"})

	sets.midcast['Diaga'] = set_combine(sets.midcast.FastRecast, {waist="Chaac Belt"})

	sets.midcast.MNDAccuracy = {main="Twebuliij",sub="Mephitis Grip",ammo="Kalboron Stone",
		head="Befouled Crown",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Jhakri Robe +1",hands="Lethargy Gantherots +1",ring1="Sangoma Ring",ring2="Perception Ring",
		back=gear.RDMCape.MND,waist="Rumination Sash",legs="Psycloth Lappas",feet="Jhakri Pigaches +1"}

	sets.midcast.MNDPotency = {main="Twebuliij",sub="Mephitis Grip",ammo="Oreiad's Tathlum",
		head="Befouled Crown",neck="Phalaina Locket",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Lethargy Sayon +1",hands="Lethargy Gantherots +1",ring1="Aqua Ring",ring2="Sirona's Ring",
		back=gear.RDMCape.MND,waist="Porous Rope",legs="Psycloth Lappas",feet="Uk'uxkaj Boots"}

	sets.midcast.MNDPotency.Acc = set_combine(sets.midcast.MNDAccuracy, {body="Lethargy Sayon +1",feet="Uk'uxkaj Boots"})

	sets.midcast.INTAccuracy = {main="Rubicundity",sub="Mephitis Grip",ammo="Kalboron Stone",
		head="Jhakri Coronal +1",neck="Orunmila's Torque",ear1="Estq. Earring",ear2="Enchntr. Earring +1",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Perception Ring",ring2="Prolix Ring",
		back=gear.RDMCape.INT,waist="Witful Belt",legs="Psycloth Lappas",feet="Jhakri Pigaches +1"}

	sets.midcast.INTPotency = {main="Rubicundity",sub="Mephitis Grip",ammo="Oreiad's Tathlum",
		head="Jhakri Coronal +1",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
		body="Lethargy Sayon +1",hands="Jhakri Cuffs +1",ring1="Spiral Ring",ring2="Diamond Ring",
		back=gear.RDMCape.MND,waist="Channeler's Stone",legs="Psycloth Lappas",feet="Uk'uxkaj Boots"}

	sets.midcast.INTPotency.Acc = set_combine(sets.midcast.INTAccuracy, {body="Lethargy Sayon +1",feet="Uk'uxkaj Boots"})

	--------------------------------------
	-- Enhancing magic
	--------------------------------------

	--Set for casting on others with Composure active.
	sets.midcast.EnhancingDuration = {ammo="Homiliary",
		head="Lethargy Chappe +1",neck="Orunmila's Torque",ear1="Estq. Earring",ear2="Ethereal Earring",
		body="Lethargy Sayon +1",hands="Atrophy Gloves +1",ring1="Defending Ring",ring2="Prolix Ring",
		back=gear.RDMCape.MND,waist="Pya'ekue Belt",legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}

	--Enhancing Skill set for spells like temper. To add spells to this list see the list in user_setup.
	sets.midcast.EnhancingSkill = {ammo="Homiliary",
		head="Befouled Crown",neck="Colossus's Torque",ear1="Estq. Earring",ear2="Enchntr. Earring +1",
		body="Viti. Tabard +1",hands="Atrophy Gloves +1",ring1="Defending Ring",ring2="Prolix Ring",
		back=gear.RDMCape.MND,waist="Pya'ekue Belt",legs="Shedir Seraweels",feet="Lethargy Houseaux +1"}

	--Base duration set for spells cast on self that don't require skill
	sets.midcast['Enhancing Magic'] = sets.midcast.EnhancingDuration

	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {waist="Emphatikos Rope",legs="Shedir Seraweels"})

	sets.midcast.BarElement = sets.midcast.EnhancingSkill
	sets.midcast.Enspell = sets.midcast.EnhancingSkill
	sets.midcast.Gain = sets.midcast.EnhancingSkill
	sets.midcast.Phalanx = sets.midcast.EnhancingSkill

	sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {legs="Lethargy Fuseau +1"})

	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {main="Bolelabunga",
		body="Telchine Chasuble"})

	sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
		neck="Stone Gorget",ear2="Earthcry Earring",waist="Siegel Sash",legs="Shedir Seraweels"})

	sets.ComposureOther = {head="Lethargy Chappel +1",
		body="Lethargy Sayon +1",hands="Lethargy Gantherots +1",
		back=gear.RDMCape.MND,legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}

	--------------------------------------
	-- Healing magic, .Self sets are for self cures, .Weather sets are for cures during Light Weather.
	--------------------------------------

	sets.midcast.FrontlineCure = {ammo="Quartz Tathlum +1",
		head="Vanya Hood",neck="Lasaia Pendant",ear1="Mendi. Earring",ear2="Novia Earring",
		body="Viti. Tabard +1",hands="Thrift Gloves +1",ring1="Mediator's Ring",ring2="Lebeche Ring",
		back="Tempered Cape +1",waist="Channeler's Stone",legs="Atrophy Tights +1",feet=gear.VanyaClogs.Cure}
	sets.midcast.FrontlineCure.Self = set_combine(sets.midcast.FrontlineCure, {ammo="Esper Stone +1",
		neck="Phalaina Locket",
		body="Vanya Robe",hands="Buremte Gloves",ring1="Kunaji Ring",
		back="Sucellos's Cape",waist="Gishdubar Sash",feet=gear.VanyaClogs.Skill})
	sets.midcast.FrontlineCure.Weather = set_combine(sets.midcast.FrontlineCure, {ammo="Esper Stone +1",
		ear2="Roundel Earring",
		back="Twilight Cape",waist="Hachirin-no-Obi"})
	sets.midcast.FrontlineCure.Self.Weather = set_combine(sets.midcast.FrontlineCure, {
		neck="Phalaina Locket",
		hands="Buremte Gloves",ring1="Kunaji Ring",
		back="Twilight Cape",waist="Hachirin-no-Obi"})

	sets.midcast.BacklineCure = {main="Tamaxchi",sub="Genbu's Shield",ammo="Quartz Tathlum +1",
		head="Vanya Hood",neck="Lasaia Pendant",ear1="Beatific Earring",
		body="Viti. Tabard +1",hands="Thrift Gloves +1",ring1="Mediator's Ring",ring2="Lebeche Ring",
		back=gear.RDMCape.MND,legs="Vanya Slops",feet=gear.VanyaClogs.Skill}
	sets.midcast.BacklineCure.Self = set_combine(sets.midcast.BacklineCure, {main="Sanus Ensis",ammo="Esper Stone +1",
		neck="Incanter's Torque",ear1="Mendi. Earring",
		hands="Buremte Gloves",
		back="Tempered Cape +1",waist="Gishdubar Sash"})
	sets.midcast.BacklineCure.Weather = set_combine(sets.midcast.BacklineCure, {main="Chatoyant Staff",sub="Achaq Grip",ammo="Esper Stone +1",
		ear1="Mendi. Earring",
		hands="Thrift Gloves +1",
		back="Twilight Cape",waist="Hachirin-no-Obi",legs="Atrophy Tights +1"})
	sets.midcast.BacklineCure.Self.Weather = set_combine(sets.midcast.BacklineCure, {main="Chatoyant Staff",sub="Achaq Grip",ammo="Esper Stone +1",
		neck="Phalaina Locket",ear1="Mendi. Earring",
		hands="Buremte Gloves",ring1="Kunaji Ring",
		back="Twilight Cape",waist="Hachirin-no-Obi",legs="Atrophy Tights +1"})

	sets.midcast.StatusRemoval = sets.midcast.FastRecast

	--------------------------------------
	-- Active Buffs
	--------------------------------------

	sets.buff.Saboteur = {hands="Lethargy Gantherots +1"}
	sets.latent_refresh = {waist="Fucho-no-obi"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		-- Default base equipment layer of fast recast.
		equip(sets.midcast.FastRecast)
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Enfeebling Magic' and state.Buff.Saboteur then
		equip(sets.buff.Saboteur)
	elseif spell.element == world.weather_element or spell_element == world.day_element then
		if spell.skill == 'Healing Magic' then
			if state.BattleMode.value then
				if spell.target.type ~= 'SELF' then
					equip(sets.midcast.FrontlineCure.Weather)
				else
					equip(sets.midcast.FrontlineCure.Self.Weather)
				end
			else
				if spell.target.type ~= 'SELF' then
					equip(sets.midcast.BacklineCure.Weather)
				else
					equip(sets.midcast.BacklineCure.Self.Weather)
				end
			end
		elseif spell.skill == 'Elemental Magic' and state.ConserveMP.value then
			equip(sets.ConserveMP.Weather)
		elseif spell.skill == 'Elemental Magic' then
			equip({back="Twilight Cape",waist="Hachirin-no-Obi"})
		end
	elseif spell.skill == 'Elemental Magic' and state.ConserveMP.value then
		equip(sets.ConserveMP.Weather)
	elseif spell.skill == 'Enhancing Magic' then
		if buffactive.composure and spell.target.type ~= 'SELF' then
			equip(sets.ComposureOther)		equip(sets.midcast.EnhancingDuration)
		end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if state.Buff[spell.english] ~= nil then
			state.Buff[spell.english] = true
		elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
			send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
		elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
			send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
	--RDM can cap delay reduction with nothing more than Haste II provided it has /NIN & +31% Dual Wield.
	--With capped Magic Haste, meaning Haste II & 1 other form of Magic Haste, you need only +11%.
	--Optimally, engaged should have +31 DW, MaxHaste should have +11.

	classes.CustomMeleeGroups:clear()

	if buffactive.embrava then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive[580] then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive[604] then
		classes.CustomMeleeGroups:append('MaxHaste')
	end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') then
			if state.BattleMode.value then
				if spell.target.type ~= 'SELF' then
					equip(sets.midcast.FrontlineCure)
				else
					equip(sets.midcast.FrontlineCure.Self)
				end
			else
				if spell.target.type ~= 'SELF' then
					equip(sets.midcast.BacklineCure)
				else
					equip(sets.midcast.BacklineCure.Self)
				end
			end
		elseif MNDPotencySpells:contains(spell.english) then
			return 'MNDPotency'
		elseif spell.english == 'Silence' then
			return 'MNDAccuracy'
		elseif spell.english == 'Blind' then
			return 'INTPotency'
		elseif INTAccuracySpells:contains(spell.english) then
			return 'INTAccuracy'
		elseif spell.english:startswith('En') then
			return 'Enspell'
		elseif spell.english:startswith('Gain') then
			return 'Gain'
		elseif EarthSpells:contains(spell.english) then
			return 'Stone'
		elseif IceSpells:contains(spell.english) then
			return 'Blizzard'
		elseif SkillSpells:contains(spell.english) then
			return 'EnhancingSkill'
		end
	end
end

function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
	end
	return idleSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	elseif state.Buff[buff] ~= nil then
		handle_equipping_gear(player.status)
	end
end

function get_custom_wsmode(spell, action, spellMap, default_wsmode)
	if default_wsmode == 'Acc' and classes.Daytime then
		return 'DaytimeAcc'
	end
end

function job_time_change(new_time, old_time)
	classes.CustomMeleeGroups:clear()
	if classes.Daytime then
		classes.CustomMeleeGroups:append('Daytime')
	end
	handle_equipping_gear(player.status)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	update_combat_form()
	determine_haste_group()
	th_update(cmdParams, eventArgs)
end

function job_state_change(stateField, newValue, oldValue)
	if state.BattleMode.value then
		if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
			equip(sets.FrontlineWeapons.DW)
		else
			equip(sets.FrontlineWeapons)
		end
		disable('main','sub','range')
	else
		enable('main','sub','range')
	end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = 'Melee'

	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end

	msg = msg .. ': '

	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ', WS: ' .. state.WeaponskillMode.value

	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
	end

	if state.Kiting.value == true then
		msg = msg .. ', Kiting'
	end

	if state.PCTargetMode.value ~= 'default' then
		msg = msg .. ', Target PC: '..state.PCTargetMode.value
	end

	if state.SelectNPCTargets.value == true then
		msg = msg .. ', Target NPCs'
	end

	msg = msg .. ', TH: ' .. state.TreasureMode.value

	if state.BattleMode.value == true then
		msg = msg .. ', Frontline '
	end

	add_to_chat(122, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select DW combat form as appropriate
function update_combat_form()
	if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
		if player.equipment.sub == 'empty' or Shields:contains(player.equipment.sub) then
			state.CombatForm:reset()
		else
			state.CombatForm:set('DW')
		end
	else
		state.CombatForm:reset()
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	if player.sub_job == 'BLM' then
		set_macro_page(2, 5)
	elseif player.sub_job == 'NIN' then
		set_macro_page(4, 5)
	elseif player.sub_job == 'DNC' then
		set_macro_page(5, 5)
	elseif player.sub_job == 'DRK' then
		set_macro_page(7, 5)
	elseif player.sub_job == 'PLD' then
		set_macro_page(8, 5)
	else
		set_macro_page(1, 5)
	end
end