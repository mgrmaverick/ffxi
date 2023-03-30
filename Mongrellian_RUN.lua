-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+H ]           Toggle Charm Defense Mods
--              [ WIN+D ]           Toggle Death Defense Mods
--              [ WIN+K ]           Toggle Knockback Defense Mods
--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Use current Rune
--              [ CTRL+- ]          Rune element cycle forward.
--              [ CTRL+= ]          Rune element cycle backward.
--              [ CTRL+` ]          Use current Rune
--
--              [ CTRL+Numpad/ ]    Berserk/Meditate/Souleater
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki/Arcane Circle
--              [ CTRL+Numpad- ]    Aggressor/Third Eye/Weapon Bash
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+G ]          Cycles between available greatswords
--              [ CTRL+W ]          Toggle Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Resolution
--              [ CTRL+Numpad8 ]    Upheaval
--              [ CTRL+Numpad9 ]    Dimidiation
--              [ CTRL+Numpad5 ]    Ground Strike
--              [ CTRL+Numpad6 ]    Full Break
--              [ CTRL+Numpad1 ]    Herculean Slash
--              [ CTRL+Numpad2 ]    Shockwave
--              [ CTRL+Numpad3 ]    Armor Break
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------


--  gs c rune                       Uses current rune
--  gs c cycle Runes                Cycles forward through rune elements
--  gs c cycleback Runes            Cycles backward through rune elements


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end

-- Setup vars that are user-independent.
function job_setup()

    -- /BLU Spell Maps
    blue_magic_maps = {'Sheep Song', 'Geist Wall', 'Frightful Roar' }

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

    rayke_duration = 35
    rayke_duration2 = 20
    gambit_duration = 94
    gambit_duration2 = 64
  

    lockstyleset = 001

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'STP',  'LowAcc', 'MidAcc', 'HighAcc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT', 'Refresh')
    state.PhysicalDefenseMode:options('PDT','HP')
    state.MagicalDefenseMode:options('MDT','HP')


    state.Knockback = M(false, 'Knockback')

    state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'GreatAxe'}
    state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}
    state.CP = M(false, "Capacity Points Mode")
    state.WeaponLock = M(false, 'Weapon Lock')

    state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}

    send_command('bind ^` input //gs c rune')
    send_command('bind !` input /ja "Vivacious Pulse" <me>')
    send_command('bind ^insert gs c cycleback Runes')
    send_command('bind ^delete gs c cycle Runes')
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind @a gs c cycle AttackMode')
    send_command('bind @c gs c toggle CP')
    send_command('bind @e gs c cycleback WeaponSet')
    send_command('bind @r gs c cycle WeaponSet')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @k gs c toggle Knockback')
    send_command('bind !q input /ma "Temper" <me>')

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^f11')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind @a')
    send_command('unbind @c')
    send_command('unbind @d')
    send_command('unbind !q')
    send_command('unbind @w')
    send_command('unbind @e')
    send_command('unbind @r')
    send_command('unbind !o')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind @w')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind @numpad*')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity sets
    sets.Enmity = {
        ammo="Sapience Orb",
        head="Halitus Helm",
        body="Emet Harness +1",
        hands="Kurys Gloves",
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Platinum moogle belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Cryptic Earring",
        left_ring="Supershear Ring",
        right_ring="Eihwaz Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
    }


    sets.Enmity.HP = {
        ammo="Sapience Orb",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Platinum moogle belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Cryptic Earring",
        left_ring="Supershear Ring",
        right_ring="Eihwaz Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
        }


    sets.precast.JA['Vallation'] = {body="Runeist's Coat +3", legs="futhark trousers +3",}
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = {feet="Runeist's Bottes +2"}
    sets.precast.JA['Battuta'] = {head="Fu. Bandeau +3"}
    sets.precast.JA['Liement'] = {body="Futhark Coat +3"}

    sets.precast.JA['Lunge'] = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet={ name="Agwu's Pigaches", augments={'Path: A',}},
        neck="Sibyl Scarf",
        waist="Eschan Stone",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Friomisi Earring",
        left_ring="Mujin Band",
        right_ring="Locus Ring",
        back="Izdubar Mantle",
        }

    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = {hands="Runeist's Mitons +2"}
    sets.precast.JA['Rayke'] = {feet="Futhark Boots +1"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat +3"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons +1"}
    sets.precast.JA['Vivacious Pulse'] = {
        head="Erilaz Galea +2", 
        neck="Incanter's Torque",
        back="Altruistic cape",  
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
    }


    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Sapience Orb",
    head="Rune. Bandeau +3",
    body="Erilaz surcoat +2",
    hands="Agwu's Gages",
    legs="Agwu's Slops",
    feet="Agwu's Pigaches",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Platinum moogle belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Loquac. Earring",
    right_ring="Moonlight ring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-4%',}},
}

    sets.precast.FC.HP = set_combine(sets.precast.FC, {
        ammo="Sapience Orb",
        head="Rune. Bandeau +3",
        body="Erilaz Surcoat +2",
        hands="Agwu's Gages",
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Platinum moogle belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Loquac. Earring",
        right_ring="Moonlight Ring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-4%',}},
})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        legs="futhark trousers +3",
        waist="Siegel sash",
        })

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
    })

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS =  {ammo="Yamarang",
    head="Nyame Helm",
    body="Nyame mail",
    hands="Meg. Gloves +2",
    legs="Nyame flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Regal Ring",
    right_ring="Karieyh Ring",
    back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
       -- ammo="Seeth. Bomblet +1",
        --body=gear.Adhemar_B_body,
        })

    sets.precast.WS.Uncapped = set_combine(sets.precast.WS, {
        --ammo="Seeth. Bomblet +1",
        })  

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, 
    {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
        legs="Meg. Chausses +2",
        feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Sherida Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Regal Ring",
        back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}},

})

    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {
      
        })

    sets.precast.WS['Resolution'].Uncapped = set_combine(sets.precast.WS['Resolution'], {
  
        })

    sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, {ammo="Knobkierrie",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Nyame gauntlets",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Rep. Plat. Medal",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
})


    sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'], {
        })

    sets.precast.WS['Dimidiation'].Uncapped = set_combine(sets.precast.WS['Dimidiation'], {

        })

    sets.precast.WS['Herculean Slash'] = sets.precast.JA['Lunge']

    sets.precast.WS['Shockwave'] = {
        }
    sets.precast.WS['Ground Strike'] = {ammo="Yamarang",
    head="Nyame Helm",
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Regal Ring",
    right_ring="Karieyh Ring",
    back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
}
    

    sets.precast.WS['Savage Blade'] = {
        ammo="Aurgelmir orb",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        body={ name="Herculean Vest", augments={'Weapon skill damage +4%','"Mag.Atk.Bns."+18','Quadruple Attack +1','Accuracy+13 Attack+13','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
        hands="Meg. Gloves +2",
        legs="Meg. Chausses +2",
        feet={ name="Herculean Boots", augments={'Attack+24','Weapon skill damage +4%','Accuracy+2',}},
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Sherida Earring",
        left_ring="Epona's Ring",
        right_ring="Petrov ring",
        back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}},
    }
  

    sets.precast.WS['Requiescat'] = {
        ammo="staunch tathlum +1",
        head="Meghanada Visor +2",
        body="Meg. Cuirie +2",
        hands="Meg. Gloves +2",
        legs="Meg. Chausses +2",
        feet="Meg. Jam. +1",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Sherida Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+5','"Dbl.Atk."+10','Damage taken-2%',}},
    }


    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
        })

    sets.precast.WS['Upheaval'] = sets.precast.WS['Resolution']
    sets.precast.WS['Full Break'] = sets.precast.WS['Shockwave']

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="staunch tathlum +1",
        head="Erilaz Galea +2",
        body={ name="Taeon Tabard", augments={'Spell interruption rate down -9%','"Regen" potency+3',}},
        hands="Regal Gauntlets",
        legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},
        feet={ name="Taeon Boots", augments={'Spell interruption rate down -10%','"Regen" potency+3',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Audumbla Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Magnetic Earring",
        right_ring="Moonlight ring",
        left_ring="Gelatinous ring +1",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
}

    sets.midcast.Cure = {
        ammo="Sapience Orb",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck="Sacro Gorget",
        waist="Sroda Belt",
        left_ear="Mendi. Earring",
        right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
        left_ring="Eihwaz Ring",
        right_ring="Moonlight Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Parrying rate+5%',}},
        }

    sets.midcast['Enhancing Magic'] = { ammo="staunch tathlum +1",
    head="Erilaz Galea +2",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Runeist's Mitons +2",
    legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Mimir Earring",
    right_ear="Andoaa Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe2"},
    ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back="Moonbeam Cape",
}

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'],{
        head="Erilaz Galea +2",
        legs="futhark trousers +3",
        hands="Regal gauntlets",
        })

    sets.midcast['Phalanx'] = set_combine(sets.midcast.SpellInterrupt, {ammo="staunch tathlum +1",
    head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
    body={ name="Herculean Vest", augments={'"Triple Atk."+1','"Store TP"+4','Phalanx +4',}},
    hands={ name="Taeon Gloves", augments={'Accuracy+18 Attack+18','"Dual Wield"+4','Phalanx +3',}},
    legs={ name="Taeon Tights", augments={'Accuracy+17 Attack+17','"Dual Wield"+3','Phalanx +3',}},
    feet={ name="Taeon Boots", augments={'Weapon Skill Acc.+20','Phalanx +3',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    right_ear="Mimir Earring",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ring="Moonlight ring",
    left_ring="Stikini Ring +1",
    back="Moonbeam Cape",
})

    sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], sets.midcast.SpellInterrupt, {
    
        })

    sets.midcast['Regen'] = {   ammo="staunch tathlum +1",
    head="Rune. Bandeau +3",
    body={ name="Taeon Tabard", augments={'Spell interruption rate down -9%','"Regen" potency+3',}},
    hands="Regal Gauntlets",
    legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
    feet={ name="Taeon Boots", augments={'Spell interruption rate down -10%','"Regen" potency+3',}},
    neck="Sacro gorget",
    waist="Sroda belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Erilaz earring +1",
    right_ring="Moonlight ring",
    left_ring="Defending Ring",
    back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10',}},
}
    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {head="Erilaz Galea +2", waist="Gishdubar Sash"})
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'])
    sets.midcast.Shell = sets.midcast.Protect

    sets.midcast['Divine Magic'] = {
        ammo="Yamarang",
        legs="Runeist's Trousers +1",
        neck="Incanter's Torque",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        }

    sets.midcast.Flash = sets.Enmity
    sets.midcast.Foil = sets.Enmity
    sets.midcast.Stun = sets.Enmity
    sets.midcast.Poisonga = sets.midcast.SpellInterrupt
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Blue Magic'] = sets.midcast.SpellInterrupt
    sets.midcast['Blue Magic'].Enmity = sets.Enmity
    sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
    sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        ammo="staunch tathlum +1",
        head="Nyame helm",
        body="Erilaz Surcoat +2",
        hands="Turms Mittens +1",
        legs="Carmine Cuisses +1",
        feet="Erilaz Greaves +2",
        neck="Futhark Torque +2",
        right_ear="Erilaz earring +1",
        ear1="Odnowa Earring +1",
        ring2="Moonlight ring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
        waist="Platinum moogle belt",
        }

    sets.idle.DT = {  
        ammo="staunch tathlum +1",
        head="Nyame Helm",
        body="Erilaz Surcoat +2",
        hands="Nyame Gauntlets",
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Platinum moogle belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Erilaz earring +1",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="moonlight ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
}

    sets.idle.Town = set_combine(sets.idle, {
        hands="Regal gauntlets",
        })

    sets.idle.Weak = sets.idle.DT

    sets.idle.Refresh = {
        ammo="Homiliary",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Runeist's Coat +3",
        hands="Regal Gauntlets",
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Futhark Torque +2", augments={'Path: A',}},
        waist="Fucho-no-Obi",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},

    }

    sets.Kiting = {legs="Carmine Cuisses +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Erilaz Surcoat +2",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Futhark Torque +2", augments={'Path: A',}},
        waist="Platinum moogle belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
        left_ring="Gelatinous ring +1",
        right_ring="Moonlight Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Parrying rate+5%',}},
    }

    sets.defense.MDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck="Warder's Charm +1",
        waist="Engraved Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
        right_ring="Moonlight Ring",
        left_ring="Purity Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
    }

    sets.defense.HP = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Erilaz Surcoat +2",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Futhark Torque +2", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
        left_ring="Gelatinous ring +1",
        right_ring="Moonlight Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Parrying rate+5%',}},
        }

    sets.defense.Parry = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Erilaz Surcoat +2",
        hands="Turms Mittens +1",
        legs="Eri. Leg Guards +2",
        feet="Turms Leggings +1",
        neck={ name="Futhark Torque +2", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Hermodr Earring",
        left_ring="Gelatinous ring +1",
        right_ring="Moonlight Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Parrying rate+5%',}},
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
        ammo="Yamarang",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Anu Torque",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Sherida Earring",
        right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
        right_ring="Moonlight Ring",
        left_ring="Chirich Ring +1",
        back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}},
    }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
      
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
       
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
      
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        body="Ayanmo Corazza +2",
        hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet="Nyame Sollerets",
        neck="Anu Torque",
        waist="Ioskeha belt +1",
        left_ear="Crep. Earring",
        right_ear="Sherida Earring",
        right_ring="moonlight ring",
        left_ring="Niqmaddu Ring",
        back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}},
    })

    sets.engaged.Aftermath = {
    
        }


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.Hybrid = {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        body="Ayanmo Corazza +2",
        hands={ name="Herculean Gloves", augments={'Accuracy+5 Attack+5','"Triple Atk."+3','Accuracy+10','Attack+15',}},
        legs="Meg. Chausses +2",
        feet="Turms Leggings +1",
        neck={ name="Futhark Torque +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Mache Earring +1",
        right_ear="Sherida Earring",
        left_ring="Defending Ring",
        right_ring="moonlight ring",
        back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}},
    }

    sets.engaged.DT = set_combine(sets.engaged, sets.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.Hybrid)


    sets.engaged.Aftermath.DT = {
        
        }    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's necklace",
        ring1="Eshmun's Ring",
        ring2="Purity Ring",
        waist="Gishdubar Sash", --10
        }

    sets.Embolden = set_combine(sets.midcast.EnhancingDuration, {back="Evasionist's Cape"})
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
 

    sets.Epeolatry = {main="Epeolatry"}
    sets.Lionheart = {main="Lionheart"}
    sets.Aettir = {main="Aettir"}
    sets.GreatAxe = {main="Lycurgos"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
        add_to_chat(167, 'Stopped due to status.')
        eventArgs.cancel = true
        return
    end
    if (state.PhysicalDefenseMode.value == 'HP' or state.MagicalDefenseMode.value == 'HP') then
        currentSpell = spell.english
        eventArgs.handled = true
        if spell.action_type == 'Magic' then
            equip(sets.precast.FC.HP)
        elseif spell.action_type == 'Ability' and (spell.name ~= 'Ignis' and spell.name ~= 'Gelus' and spell.name ~= 'Flabra' and spell.name ~= 'Tellus' and spell.name ~= 'Sulpor' and spell.name ~= 'Unda' and spell.name ~= 'Lux' and spell.name ~= 'Tenebrae') then
            equip(sets.Enmity.HP)
			equip(sets.precast.JA[currentSpell])
        end
	else
        if spell.action_type == 'Ability' and (spell.name ~= 'Ignis' and spell.name ~= 'Gelus' and spell.name ~= 'Flabra' and spell.name ~= 'Tellus' and spell.name ~= 'Sulpor' and spell.name ~= 'Unda' and spell.name ~= 'Lux' and spell.name ~= 'Tenebrae') then
            equip(sets.Enmity)
			equip(sets.precast.JA[spell])
        end
    end
    if spell.english == 'Lunge' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Swipe" <t>')
--            add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
            eventArgs.cancel = true
            return
        end
    end
    if spell.english == 'Valiance' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Vallation" <me>')
            eventArgs.cancel = true
            return
        elseif spell.english == 'Valiance' and buffactive['vallation'] then
            cast_delay(0.2)
            send_command('cancel Vallation') -- command requires 'cancel' add-on to work
        end
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if (state.PhysicalDefenseMode.value == 'HP' or state.MagicalDefenseMode.value == 'HP') and spell.english ~= "Phalanx" then
        eventArgs.handled = true
        if spell.action_type == 'Magic' then
            equip(sets.Enmity.HP)
        elseif spell.skill == 'Enhancing Magic' then
                equip(sets.midcast.EnhancingDuration)
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if state.DefenseMode.value == 'None' then
        if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
            end
		end
        if spell.english == 'Phalanx' and buffactive['Embolden'] then
            equip(sets.midcast.EnhancingDuration)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if spell.name == 'Rayke' and not spell.interrupted then
        send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
        send_command('@input /p [Rayke] ON;')
        send_command('wait '..rayke_duration2..';input /p [Rayke] Wearing off in 15 sec.;')
        send_command('wait '..rayke_duration..';input /p [Rayke] OFF;')

    elseif spell.name == 'Gambit' and not spell.interrupted then
        send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
        send_command('@input /p [Gambit] ON;')
        send_command('wait '..gambit_duration2..';input /p [Gambit] Wearing off in 30 sec.;')
        send_command('wait '..gambit_duration..';input /p [Gambit] OFF;')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.Charm.current)
    classes.CustomDefenseGroups:append(state.Knockback.current)
    classes.CustomDefenseGroups:append(state.Death.current)

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.Charm.current)
    classes.CustomMeleeGroups:append(state.Knockback.current)
    classes.CustomMeleeGroups:append(state.Death.current)
end

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "terror" then
        if gain then
            equip(sets.defense.PDT)
        end
    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist','neck')
        else
            send_command('@input /p Doom off.')
            enable('ring1','ring2','waist','neck')
            handle_equipping_gear(player.status)
        end
    end

    if buff == "petrification" then
        if gain then
            send_command('@input /p Petrified.')
        else
            send_command('@input /p Petrify off.')
        end
    end

    if buff == 'Embolden' then
        if gain then
            equip(sets.Embolden)
            disable('head','legs','back')
        else
            enable('head','legs','back')
            status_change(player.status)
        end
    end

    if buff:startswith('Aftermath') then
        state.Buff.Aftermath = gain
        customize_melee_set()
        handle_equipping_gear(player.status)
    end

    if buff == 'Battuta' and not gain then
        status_change(player.status)
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_update(cmdParams, eventArgs)
    equip(sets[state.WeaponSet.current])
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Knockback.value == true then
        idleSet = set_combine(idleSet, sets.defense.Knockback)
    end

    --if state.CP.current == 'on' then
    --    equip(sets.CP)
    --    disable('back')
    --else
    --    enable('back')
    --end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"
        and state.DefenseMode.value == 'None' then
        if state.HybridMode.value == "DT" then
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.DT)
        else
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
        end
    end
    if state.Knockback.value == true then
        meleeSet = set_combine(meleeSet, sets.defense.Knockback)
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Battuta'] then
        defenseSet = set_combine(defenseSet, sets.defense.Parry)
    end
    if state.Knockback.value == true then
        defenseSet = set_combine(defenseSet, sets.defense.Knockback)
    end

    return defenseSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local r_msg = state.Runes.current
    local r_color = ''
    if state.Runes.current == 'Ignis' then r_color = 167
    elseif state.Runes.current == 'Gelus' then r_color = 210
    elseif state.Runes.current == 'Flabra' then r_color = 204
    elseif state.Runes.current == 'Tellus' then r_color = 050
    elseif state.Runes.current == 'Sulpor' then r_color = 215
    elseif state.Runes.current == 'Unda' then r_color = 207
    elseif state.Runes.current == 'Lux' then r_color = 001
    elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Knockback.value == true then
        msg = msg .. ' Knockback Resist |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122)
        ..string.char(31,210).. ' Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002).. ' |'
        ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060)
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end

function get_custom_wsmode(spell, action, spellMap)
    if spell.type == 'WeaponSkill' and state.AttackMode.value == 'Uncapped' then
        return "Uncapped"
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'BLU' then
        set_macro_page(2, 6)
    elseif player.sub_job == 'DRK' then
        set_macro_page(3, 6)
    elseif player.sub_job == 'WHM' then
        set_macro_page(4, 6)
    else
        set_macro_page(1, 6)
    end
end

function set_lockstyle()
    send_command('wait 7; input /lockstyle on')
end