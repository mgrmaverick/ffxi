--[[     
=== Features ===
If you want auto Reive detection for Ygnas Resolve+1, and Gavialis Helm for some of your WS, then you will need my User-Globals.lua
Otherwise, you might be able to get away without it.  (not tested)
If you don't use organizer, then remove the include('organizer-lib') in get_sets() and remove sets.Organizer
This lua has a few MODES you can toggle with hotkeys or macros, and there's a few situational RULES that activate without hotkeys
::MODES::
SouleaterMode 
Status: OFF by default. 
Hotkey: Toggle this with @F9 (window key + F9). 
Macro: /console gs c togggle SouleaterMode
Notes: This mode makes it possible to use Souleater in situations where you would normally avoid using it. When SouleaterMode 
is ON, Souleater will be canceled automatically after the first Weaponskill used. CAVEAT -. If Bloodweapon 
is active, or if Drain's HP Boost buff is active, then Souleater will remain active until the next WS used after 
either buff wears off. 
CapacityMode
Status: OFF by default. 
Hotkey: with ALT + = 
Macro: /console cs c toggle CapacityMode
Notes: It will full-time whichever piece of gear you specify in sets.CapacityMantle 
Extra Info: You can change the default (true|false) status of any MODE by changing their values in job_setup()
::RULES::
Gavialis helm
Status: enabled
Setting: set use_gavialis = true below in job_setup. 
Notes: wslist defines weaponskills uused with Gavialis helm. This is a recent change Jan/2020, as it 
used to be the opposite, where you defined ws's that you didn't want to use it.
Ygna's Resolve +1 
Status: enabled in Reive
Setting: n/a
Notes: Will automatically be used when you're in a reive. If you have my User-Globals.lua this will work
with all your jobs that use mote's includes. Not just this one! 
Moonshade earring
Status: Not used for WS's at 3000 TP. 
Setting: n/a
You can hit F12 to display custom MODE status as well as the default stuff. 
Single handed weapons are handled in the sets.engaged.SW set. (sword + shield, etc.)
::NOTES::
My sets have a specific order, or they will not function correctly. 
sets.engaged.[CombatForm][CombatWeapon][Offense or HybridMode][CustomMeleeGroups or CustomClass]
CombatForm = Haste, DW, SW
CombatWeapon = GreatSword, Scythe, Apocalypse, Ragnarok, Caladbolg, Liberator, Anguta
OffenseMode = Mid, Acc
HybridMode = PDT
CustomMeleeGroups = AM3, AM, Haste
CustomClass = OhShit 
CombatForm Haste is used when Last Resort + Hasso AND either Haste, March, Indi-Haste Geo-Haste is on you.
CombatForm DW will activate with /dnc or /nin AND a weapon listed in drk_sub_weapons equipped offhand. 
SW is active with an empty sub-slot, or a shield listed in the shields = S{} list.  
CombatWeapon GreatSword will activate when you equip a GS listed in gsList in job_setup(). 
CombatWeapon Scythe will activate when you equip a Scythe listed in scytheList in job_setup(). 
Weapons that do not fall into these groups, or have sets by weapon name, will use default sets.engaged
most gear sets derrive themselves from sets.engaged, so try to keep it updated. It's much smarter to derrive sets than to 
completely re-invent each gear set for every weapon. Let your gear inherit. Less code written means less errors. 
CustomMeleeGroups AM3 will activate when Aftermath lvl 3 is up, and CustomMeleeGroups AM will activate when relic Aftermath is up.
There are no empy AM sets for now.
--]]
--
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end


-- Setup vars that are user-independent.
function job_setup()
    state.CapacityMode = M(false, 'Capacity Point Mantle')

    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')

    state.Buff.Souleater = buffactive.souleater or false
    state.Buff['Last Resort'] = buffactive['Last Resort'] or false
    -- Set the default to false if you'd rather SE always stay acitve
    state.SouleaterMode = M(true, 'Soul Eater Mode')
    -- state.LastResortMode = M(false, 'Last Resort Mode')
    -- Use Gavialis helm?
    use_gavialis = false

    -- Weaponskills you want Gavialis helm used with (only considered if use_gavialis = true)
    wsList = S{'Entropy', 'Resolution'}
    -- Greatswords you use. 
    gsList = S{'Malfeasance', 'Macbain', 'Kaquljaan', 'Mekosuchus Blade', 'Ragnarok', 'Raetic Algol', 'Raetic Algol +1', 'Caladbolg', 'Montante +1', 'Albion' }
    scytheList = S{'Liberator', 'Apocalypse', 'Anguta', 'Raetic Scythe', 'Deathbane', 'Twilight Scythe' }
    remaWeapons = S{'Apocalypse', 'Anguta', 'Liberator', 'Caladbolg', 'Ragnarok', 'Redemption'}

    shields = S{'Rinda Shield'}
    -- Mote has capitalization errors in the default Absorb mappings, so we use our own
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-ACC', 'Absorb-TP'}
    -- Offhand weapons used to activate DW mode
    swordList = S{"Sangarius", "Sangarius +1", "Usonmunku", "Perun +1", "Tanmogayi"}

    get_combat_form()
    get_combat_weapon()
    update_melee_groups()
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Mid', 'Acc', 'SB')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'Mid', 'Acc')
    state.CastingMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Sphere')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.MagicalDefenseMode:options('MDT')

    war_sj = player.sub_job == 'WAR' or false

    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c toggle SouleaterMode')
    send_command('bind !- gs equip sets.crafting')
    --send_command('bind ^` gs c toggle LastResortMode')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^`')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind @f9')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    -- Augmented gear
 

    sets.TreasureHunter = { 
        waist="Chaac Belt",
     }
 
    sets.Organizer = {
    }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Diabolic Eye'] = {hands="Fallen's Finger Gauntlets +3"}
    sets.precast.JA['Nether Void']  = {legs="Heathen's Flanchard +2"}
    sets.precast.JA['Dark Seal']    = {head="Fallen's burgeonet +2"}
    sets.precast.JA['Souleater']    = {head="Ig. Burgeonet +3"}
    sets.precast.JA['Weapn Bash']   = {hands="Ignominy Gauntlets +1"}
    sets.precast.JA['Blood Weapon'] = {body="Fallen's Cuirass +1"}
    sets.precast.JA['Last Resort']  = {back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
    sets.precast.JA['Jump'] = sets.Jump
    sets.precast.JA['High Jump'] = sets.Jump

    sets.Jump = { feet="Ostro Greaves" }

    
    -- Earring considerations, given Lugra's day/night stats 
    sets.BrutalLugra     = { ear1="Brutal Earring", ear2="Lugra Earring +1" }
    sets.IshvaraLugra     = { ear1="Ishvara Earring", ear2="Lugra Earring +1" }
    sets.Lugra           = { ear1="Lugra Earring +1" }
    sets.Brutal          = { ear1="Brutal Earring" }
    sets.Ishvara          = { ear1="Ishvara Earring" }

    -- Waltz set (chr and vit) 
    -- sets.precast.Waltz = {}

    -- Fast cast sets for spells
    sets.precast.FC = {
     
        head="Carmine Mask +1",
        body="Sacro Breastplate",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Voltsurge torque",
        waist="Eschan Stone",
        left_ear="Malignance Earring",
        right_ear="Loquac. Earring",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Niht Mantle", augments={'Attack+6','Dark magic skill +10','"Drain" and "Aspir" potency +20',}},
    }
    sets.precast.FC['Drain'] = set_combine(sets.precast.FC, {
    })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, { 

    })
    sets.precast.FC['Enfeebling Magic'] = set_combine(sets.precast.FC, {

    })
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
      
    })

    -- Midcast Sets
    sets.midcast.FastRecast = {
   
    }

    sets.midcast["Apururu (UC)"] = set_combine(sets.midcast.Trust, {
    })

    -- Specific spells
    sets.midcast.Utsusemi = {
        ammo="Impatiens",
        hands="Leyline Gloves",
    }

    sets.midcast['Dark Magic'] = {
        ammo="Pemphredo tathlum",
        head="Ig. Burgeonet +3",
        body="Carm. Scale Mail",
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        legs="Heathen's Flanchard +2",
        feet="ratri sollerets +1",
        neck="Erra Pendant",
        waist="Eschan Stone",
        left_ear="Malignance Earring",
        right_ear="Crep. Earring",
        left_ring="Evanescence Ring",
        right_ring="Stikini Ring +1",
        back={ name="Niht Mantle", augments={'Attack+6','Dark magic skill +10','"Drain" and "Aspir" potency +20',}},
    }
    sets.midcast.Endark = set_combine(sets.midcast['Dark Magic'], {
        
    })

    sets.midcast['Dark Magic'].Acc = set_combine(sets.midcast['Dark Magic'], {
    })

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Dark Magic'], {
        ammo="Pemphredo tathlum",
        head="Carmine Mask +1",
        body="Ignominy Cuirass +3",
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Erra Pendant",
        waist="Eschan Stone",
        left_ear="Malignance Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Kishar ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })

    sets.midcast['Elemental Magic'] = {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Carm. Scale Mail", augments={'MP+60','INT+10','MND+10',}},
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Eschan Stone",
        left_ear="Malignance Earring",
        right_ear="Friomisi Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
        back="Izdubar Mantle",
    }

    -- Mix of HP boost, -Spell interruption%, and Dark Skill
    sets.midcast['Dread Spikes'] = set_combine(sets.midcast['Dark Magic'], {
        ammo="Egoist's tathlum",
        head="Ratri Sallet",
        body="Heath. Cuirass +2",
        hands="Ratri Gadlings +1",
        legs="Ratri Cuisses",
        feet="ratri sollerets +1",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Platinum moogle belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="moonlight ring",
        back="Moonbeam Cape",
    })
    sets.midcast['Dread Spikes'].Acc = set_combine(sets.midcast['Dark Magic'], {
    })

    -- Drain spells 
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        ammo="Pemphredo tathlum",
        head="Ig. Burgeonet +3",
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        legs="Heathen's Flanchard +2",
        feet="ratri sollerets +1",
        neck="Erra Pendant",
        waist="Eschan Stone",
        left_ear="Malignance Earring",
        right_ear="Hirudinea Earring",
        left_ring="Evanescence Ring",
        right_ring="Stikini Ring +1",
        back={ name="Niht Mantle", augments={'Attack+6','Dark magic skill +10','"Drain" and "Aspir" potency +20',}},
    })
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Drain.Acc = set_combine(sets.midcast.Drain, {
    })
    sets.midcast.Aspir.Acc = sets.midcast.Drain.Acc

    sets.midcast.Drain.OhShit = set_combine(sets.midcast.Drain, {
        feet="ratri sollerets +1"
    })

    -- Absorbs
    sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'], {
        head="Ig. Burgeonet +3", -- 17
        neck="Erra pendant",
        ring1="Evanescence Ring", -- 10
        ring2="Kishar Ring",
    })

    sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, {
        hands="Heathen's Gauntlets +1",
    })

    sets.midcast['Absorb-TP'].Acc = set_combine(sets.midcast.Absorb.Acc, {
    })
    sets.midcast.Absorb.Acc = set_combine(sets.midcast['Dark Magic'].Acc, {
    })

    sets.midcast['Blue Magic'] = set_combine(sets.midcast['Dark Magic'], {
    
    })
    -- Ranged for xbow
    sets.precast.RA = {

    }
    sets.midcast.RA = {
   
    }

    -- WEAPONSKILL SETS
    -- General sets
    sets.precast.WS = {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Ignominy Cuirass +3",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Heathen's Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.precast.WS.Mid = set_combine(sets.precast.WS, {
    })
    sets.precast.WS.Acc = set_combine(sets.precast.WS.Mid, {

 
    })

    -- RESOLUTION
    -- 86-100% STR
    sets.precast.WS.Resolution = set_combine(sets.precast.WS, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Schere Earring", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS.Resolution.Mid = set_combine(sets.precast.WS.Resolution, {
    })
    sets.precast.WS.Resolution.Acc = set_combine(sets.precast.WS.Resolution.Mid, {
    }) 

    -- TORCLEAVER 
    -- VIT 80%
    sets.precast.WS.Torcleaver = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Ignominy Cuirass +3",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Abyssal Beads +2", augments={'Path: A',}},
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear={ name="Heathen's Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
    )
    sets.precast.WS.Torcleaver.Mid = set_combine(sets.precast.WS.Torcleaver, {ammo="Knobkierrie",
    head="Sakpata's Helm",
    body="Ignominy Cuirass +3",
    hands="Sakpata's Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Sulev. Leggings +2",
    neck={ name="Abyssal Beads +2", augments={'Path: A',}},
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear={ name="Heathen's Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},

    })
    sets.precast.WS.Torcleaver.Acc = set_combine(sets.precast.WS.Torcleaver.Mid, {
    })

    -- INSURGENCY
    -- 20% STR / 20% INT 
    -- Base set only used at 3000TP to put AM3 up
    sets.precast.WS.Insurgency = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Regal Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    })
    sets.precast.WS.Insurgency.Mid = set_combine(sets.precast.WS.Insurgency, {
    })
    sets.precast.WS.Insurgency.Acc = set_combine(sets.precast.WS.Insurgency.Mid, {
    })

    sets.precast.WS.Catastrophe = set_combine(sets.precast.WS, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Ratri Sallet",
        body="Ignominy Cuirass +3",
        hands="Rat. Gadlings +1",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sulev. Leggings +2",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ring="Karieyh ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    })
    sets.precast.WS.Catastrophe.Mid = set_combine(sets.precast.WS.Catastrophe, {})
    sets.precast.WS.Catastrophe.Acc = set_combine(sets.precast.WS.Catastrophe.Mid, {
    })

    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS.Catastrophe, {
        ammo="Knobkierrie",
        left_ring="Regal Ring",
    
    })

    -- CROSS REAPER
    -- 60% STR / 60% MND
    sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Ratri Sallet",
        body="Ignominy Cuirass +3",
        hands="Rat. Gadlings +1",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sulev. Leggings +2",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    })
    sets.precast.WS['Cross Reaper'].Mid = set_combine(sets.precast.WS['Cross Reaper'], {

    })
    sets.precast.WS['Cross Reaper'].Acc = set_combine(sets.precast.WS['Cross Reaper'].Mid, {
        ammo="Seething Bomblet +1",
    })
    -- ENTROPY
    -- 86-100% INT 
    sets.precast.WS.Entropy = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Nyame Sollerets",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist="Fotia Belt",
        left_ear="Lugra Earring +1",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Metamor. Ring +1",
        right_ring="Regal Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    })
    sets.precast.WS.Entropy.Mid = set_combine(sets.precast.WS.Entropy, {
        head="Hjarrandi Helm",
    })
    sets.precast.WS.Entropy.Acc = set_combine(sets.precast.WS.Entropy.Mid, {
        ammo="Seething Bomblet +1",
    })

    -- Quietus
    -- 60% STR / MND 
    sets.precast.WS.Quietus = set_combine(sets.precast.WS, {
        head="Ratri Sallet",
        neck="Abyssal Bead Necklace +1",
        body="Ignominy Cuirass +3",
        hands="Ratri Gadlings +1",
        waist="Caudata Belt",
        feet="Ratri Cuisses +1",
        feet="ratri sollerets +1"
    })
    sets.precast.WS.Quietus.Mid = set_combine(sets.precast.WS.Quietus, {
    })
    sets.precast.WS.Quietus.Acc = set_combine(sets.precast.WS.Quietus.Mid, {
        body="Fallen's Cuirass +1",
        ammo="Seething Bomblet +1",
      
    })

    -- SPIRAL HELL
    -- 50% STR / 50% INT 
    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS['Entropy'], {

    })
    sets.precast.WS['Spiral Hell'].Mid = set_combine(sets.precast.WS['Spiral Hell'], sets.precast.WS.Mid, { })
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS['Spiral Hell'], sets.precast.WS.Acc, { })

    -- SHADOW OF DEATH
    -- 40% STR 40% INT - Darkness Elemental
    sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS['Entropy'], {
        ammo="Knobkierrie",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
        waist="Eschan Stone",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Karieyh Ring",
        right_ring="Regal Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    })

    sets.precast.WS['Shadow of Death'].Mid = set_combine(sets.precast.WS['Shadow of Death'], sets.precast.WS.Mid, {
    })
    sets.precast.WS['Shadow of Death'].Acc = set_combine(sets.precast.WS['Shadow of Death'], sets.precast.WS.Acc, {
    })

    -- DARK HARVEST 
    -- 40% STR 40% INT - Darkness Elemental
    sets.precast.WS['Dark Harvest'] = sets.precast.WS['Shadow of Death']
    sets.precast.WS['Dark Harvest'].Mid = set_combine(sets.precast.WS['Shadow of Death'], {})
    sets.precast.WS['Dark Harvest'].Acc = set_combine(sets.precast.WS['Shadow of Death'], {})

    -- Sword WS's
    -- SANGUINE BLADE
    -- 50% MND / 50% STR Darkness Elemental
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
        waist="Eschan Stone",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Karieyh Ring",
        right_ring="Regal Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},

    })
    sets.precast.WS['Sanguine Blade'].Mid = set_combine(sets.precast.WS['Sanguine Blade'], sets.precast.WS.Mid)
    sets.precast.WS['Sanguine Blade'].Acc = set_combine(sets.precast.WS['Sanguine Blade'], sets.precast.WS.Acc)

    -- REQUISCAT
    -- 73% MND - breath damage
    sets.precast.WS.Requiescat = set_combine(sets.precast.WS, {
        head="Flamma Zucchetto +2",
        neck="Abyssal Bead Necklace +1",
        body="Ignominy Cuirass +3",
        hands="Odyssean Gauntlets",
        waist="Fotia Belt",
    })
    sets.precast.WS.Requiescat.Mid = set_combine(sets.precast.WS.Requiscat, sets.precast.WS.Mid)
    sets.precast.WS.Requiescat.Acc = set_combine(sets.precast.WS.Requiscat, sets.precast.WS.Acc)

    sets.precast.WS['Savage Blade'] = {
        ammo="Knobkierrie",
        head="Sakpata's Helm",
        body="Ignominy Cuirass +3",
        hands="Sakpata's Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sulev. Leggings +2",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Regal Ring",
        right_ring="Karieyh ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}
    sets.precast.WS['Judgment'] = {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Ignominy Cuirass +3",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Heathen's Earring",
        left_ring="Regal Ring",
        right_ring="Karieyh Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }

    sets.precast.WS['Judgment'].Mid = set_combine(sets.precast.WS['Judgment'], {
        ammo="Knobkierrie",
        head="Sakpata's Helm",
        body="Ignominy Cuirass +3",
        hands="Sakpata's Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Heathen's Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
        left_ring="Regal Ring",
        right_ring="Karieyh Ring",
        back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},

    })

    -- Idle sets
    sets.idle =  {ammo="staunch tathlum +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Sakpata's Leggings",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
    sets.idle.Town = set_combine(sets.idle, {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},
        feet="Sakpata's Leggings",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal Earring",
        right_ear={ name="Heathen's Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
        left_ring="Chirich Ring +1",
        right_ring="Regal Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })

    sets.idle.Field = set_combine(sets.idle, { 
    
    })
    sets.idle.Regen = set_combine(sets.idle.Field, {
    })
    sets.idle.Refresh = set_combine(sets.idle.Regen, {

    })

    sets.idle.Weak = set_combine(sets.defense.PDT, {
        head="Hjarrandi Helm",
        ring2="Defending Ring",
        waist="Flume Belt +1",
        legs="Sulevia's Cuisses +2",
        feet="Volte Sollerets"
    })
    sets.idle.Sphere = set_combine(sets.idle, { body="Makora Meikogai"  })

    -- Defense sets
    sets.defense.PDT = {
        ammo="Coiste bodhar",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Crep. Earring",
        right_ear="Cessance Earring",
        left_ring="moonlight ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
    sets.defense.Reraise = sets.idle.Weak

    sets.defense.MDT = set_combine(sets.defense.PDT, {
    })

    sets.Kiting = {
        legs="Carmine Cuisses +1",
    }

    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}


    -- Defensive sets to combine with various weapon-specific sets below
    -- These allow hybrid acc/pdt sets for difficult content
    -- do not specify a cape so that DA/STP capes are used appropriately
    sets.Defensive = {
  
    }
    sets.Defensive_Mid = {
     
    }
    -- Higher DT, less haste
    sets.DefensiveHigh = set_combine(sets.Defensive, {
     
    })
    sets.Defensive_Acc = set_combine(sets.Defensive_Mid, sets.DefensiveHigh)

    -- Base set (global catch-all set)
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Ig. Flanchard +3",
        feet="Flam. Gambieras +2",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal earring",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
    sets.engaged.Mid = set_combine(sets.engaged, {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal Earring",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })


    sets.engaged.Acc = set_combine(sets.engaged.Mid, {
        ammo="Seeth. Bomblet +1",
        head="Flam. Zucchetto +2",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Ig. Flanchard +3",
        feet="Flam. Gambieras +2",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist="ioskeha belt +1",
        left_ear="Crep. Earring",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })

    sets.engaged.SB = set_combine(sets.engaged, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Sakpata's Helm",
        body="Sacro Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Bathy Choker +1",
        waist="Ioskeha Belt +1",
        left_ear="Crep. Earring",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })

    -- These only apply when delay is capped.
    sets.engaged.Haste = set_combine(sets.engaged, {
        waist="Sailfi Belt +1",
    })
    sets.engaged.Haste.Mid = set_combine(sets.engaged.Mid, {
        waist="Sailfi Belt +1",
    })
    sets.engaged.Haste.Acc = set_combine(sets.engaged.Acc, {})

    -- Hybrid
    sets.engaged.PDT = set_combine(sets.engaged, sets.Defensive)
    sets.engaged.Mid.PDT = set_combine(sets.engaged.Mid, sets.Defensive_Mid)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.Defensive_Acc)

    -- Hybrid with capped delay
    sets.engaged.Haste.PDT = set_combine(sets.engaged.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Mid.PDT = set_combine(sets.engaged.Mid.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DefensiveHigh)

    -- Liberator
    sets.engaged.Liberator = sets.engaged
    sets.engaged.Liberator.Mid = sets.engaged.Mid
    sets.engaged.Liberator.Acc = set_combine(sets.engaged.Acc, {
    })

    -- Liberator AM3
    sets.engaged.Liberator.AM3 = set_combine(sets.engaged.Liberator, {
    

    })
    sets.engaged.Liberator.Mid.AM3 = set_combine(sets.engaged.Liberator.AM3, {
        
    })
    sets.engaged.Liberator.Acc.AM3 = set_combine(sets.engaged.Liberator.Mid.AM3, {
    
    })
    sets.engaged.Haste.Liberator = set_combine(sets.engaged.Liberator, {
   
    })
    sets.engaged.Haste.Liberator.Mid = set_combine(sets.engaged.Liberator.Mid, {
    
    })
    sets.engaged.Haste.Liberator.Acc = sets.engaged.Liberator.Acc
    
    sets.engaged.Haste.Liberator.AM3 = set_combine(sets.engaged.Liberator.AM3, {

    })
    sets.engaged.Haste.Liberator.Mid.AM3 = sets.engaged.Liberator.Mid.AM3
    sets.engaged.Haste.Liberator.Acc.AM3 = sets.engaged.Liberator.Acc.AM3
    
    -- Hybrid
    sets.engaged.Liberator.PDT = set_combine(sets.engaged.Liberator, {
    })
    sets.engaged.Liberator.Mid.PDT = set_combine(sets.engaged.Liberator.PDT, {
    })
    sets.engaged.Liberator.Acc.PDT = set_combine(sets.engaged.Liberator.Acc, sets.DefensiveHigh)
    -- Hybrid with AM3 up
    sets.engaged.Liberator.PDT.AM3 = set_combine(sets.engaged.Liberator.AM3, sets.Defensive)
    sets.engaged.Liberator.Mid.PDT.AM3 = set_combine(sets.engaged.Liberator.Mid.AM3, sets.Defensive_Mid)
    sets.engaged.Liberator.Acc.PDT.AM3 = set_combine(sets.engaged.Liberator.Acc.AM3, sets.DefensiveHigh)
    -- Hybrid with capped delay
    sets.engaged.Haste.Liberator.PDT = set_combine(sets.engaged.Liberator.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Liberator.Mid.PDT = set_combine(sets.engaged.Liberator.Mid.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Liberator.Acc.PDT = set_combine(sets.engaged.Liberator.Acc.PDT, sets.DefensiveHigh)
    -- Hybrid with capped delay + AM3 up
    sets.engaged.Haste.Liberator.PDT.AM3 = set_combine(sets.engaged.Liberator.PDT.AM3, sets.Defensive)
    sets.engaged.Haste.Liberator.Mid.PDT.AM3 = set_combine(sets.engaged.Liberator.Mid.PDT.AM3, sets.Defensive_Mid)
    sets.engaged.Haste.Liberator.Acc.PDT.AM3 = set_combine(sets.engaged.Liberator.Acc.PDT.AM3, sets.DefensiveHigh)

    -- Apocalypse
    sets.engaged.Apocalypse = set_combine(sets.engaged, {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head="Flam. Zucchetto +2",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Ig. Flanchard +3",
        feet="Flam. Gambieras +2",
        neck={ name="Abyssal Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal Earring",
        right_ear={ name="Schere Earring", augments={'Path: A',}},
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},

    })
    sets.engaged.Apocalypse.Mid = set_combine(sets.engaged.Mid, {
      
    })
    sets.engaged.Apocalypse.Acc = set_combine(sets.engaged.Acc, {
       
    })
    
    -- sets.engaged.Apocalypse.AM = set_combine(sets.engaged.Apocalypse, {})
    -- sets.engaged.Apocalypse.Mid.AM = set_combine(sets.engaged.Apocalypse.AM, {})
    -- sets.engaged.Apocalypse.Acc.AM = set_combine(sets.engaged.Apocalypse.Mid.AM, {
    --     ring2="Cacoethic Ring +1",
    --     waist="ioskeha belt +1"
    -- })
    sets.engaged.Haste.Apocalypse = set_combine(sets.engaged.Apocalypse, {
        waist="Sailfi Belt +1",
    })
    sets.engaged.Haste.Apocalypse.Mid = sets.engaged.Apocalypse.Mid
    sets.engaged.Haste.Apocalypse.Acc = sets.engaged.Apocalypse.Acc

    -- Hybrid
    sets.engaged.Apocalypse.PDT = set_combine(sets.engaged.Apocalypse, {
        head="Hjarrandi Helm",
        neck="Abyssal Bead Necklace +1",
        body="Tartarus Platemail",
        hands="Volte Moufles",
        ring2="Defending Ring",
        waist="Sailfi Belt +1",
        feet="Volte Sollerets" 
    })
    sets.engaged.Apocalypse.Mid.PDT = set_combine(sets.engaged.Apocalypse.Mid, sets.Defensive_Mid)
    sets.engaged.Apocalypse.Acc.PDT = set_combine(sets.engaged.Apocalypse.Acc, sets.Defensive_Acc)
    -- Hybrid with relic AM 
    -- sets.engaged.Apocalypse.PDT.AM = set_combine(sets.engaged.Apocalypse, sets.Defensive)
    -- sets.engaged.Apocalypse.Mid.PDT.AM = set_combine(sets.engaged.Apocalypse.Mid, sets.Defensive_Mid)
    -- sets.engaged.Apocalypse.Acc.PDT.AM = set_combine(sets.engaged.Apocalypse.Acc, sets.Defensive_Acc)
    -- Hybrid with capped delay
    sets.engaged.Haste.Apocalypse.PDT = set_combine(sets.engaged.Apocalypse.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Apocalypse.Mid.PDT = set_combine(sets.engaged.Apocalypse.Mid.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Apocalypse.Acc.PDT = set_combine(sets.engaged.Apocalypse.Acc.PDT, sets.DefensiveHigh)
    -- Hybrid with capped delay + AM3 up
    -- sets.engaged.Haste.Apocalypse.PDT.AM3 = set_combine(sets.engaged.Apocalypse.PDT.AM3, sets.DefensiveHigh)
    -- sets.engaged.Haste.Apocalypse.Mid.PDT.AM3 = set_combine(sets.engaged.Apocalypse.Mid.PDT.AM3, sets.DefensiveHigh)
    -- sets.engaged.Haste.Apocalypse.Acc.PDT.AM3 = set_combine(sets.engaged.Apocalypse.Acc.PDT.AM3, sets.DefensiveHigh)

    -- generic scythe
    sets.engaged.Scythe = set_combine(sets.engaged, {})
    sets.engaged.Scythe.Mid = set_combine(sets.engaged.Mid, {})
    sets.engaged.Scythe.Acc = set_combine(sets.engaged.Acc, {})

    sets.engaged.Scythe.PDT = set_combine(sets.engaged.Scythe, sets.Defensive)
    sets.engaged.Scythe.Mid.PDT = set_combine(sets.engaged.Scythe.Mid, sets.Defensive_Mid)
    sets.engaged.Scythe.Acc.PDT = set_combine(sets.engaged.Scythe.Acc, sets.Defensive_Acc)

    sets.engaged.Haste.Scythe = set_combine(sets.engaged.Haste, {})
    sets.engaged.Haste.Scythe.Mid = set_combine(sets.engaged.Haste.Mid, {})
    sets.engaged.Haste.Scythe.Acc = set_combine(sets.engaged.Haste.Acc, {})

    sets.engaged.Haste.Scythe.PDT = set_combine(sets.engaged.Scythe.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Scythe.Mid.PDT = set_combine(sets.engaged.Scythe.Mid.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Scythe.Acc.PDT = set_combine(sets.engaged.Scythe.Acc.PDT, sets.DefensiveHigh)

    -- generic great sword
    sets.engaged.GreatSword = set_combine(sets.engaged, {

    })
    sets.engaged.GreatSword.Mid = set_combine(sets.engaged.Mid, {})
    sets.engaged.GreatSword.Acc = set_combine(sets.engaged.Acc, {
    })

    sets.engaged.GreatSword.PDT = set_combine(sets.engaged.GreatSword, sets.Defensive)
    sets.engaged.GreatSword.Mid.PDT = set_combine(sets.engaged.GreatSword.Mid, sets.Defensive_Mid)
    sets.engaged.GreatSword.Acc.PDT = set_combine(sets.engaged.GreatSword.Acc, sets.Defensive_Acc)

    sets.engaged.Haste.GreatSword = set_combine(sets.engaged.Haste, {})
    sets.engaged.Haste.GreatSword.Mid = set_combine(sets.engaged.Haste.Mid, {})
    sets.engaged.Haste.GreatSword.Acc = set_combine(sets.engaged.Haste.Acc, {})

    sets.engaged.Haste.GreatSword.PDT = set_combine(sets.engaged.GreatSword.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.GreatSword.Mid.PDT = set_combine(sets.engaged.GreatSword.Mid.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.GreatSword.Acc.PDT = set_combine(sets.engaged.GreatSword.Acc.PDT, sets.DefensiveHigh)

    -- Ragnarok
    sets.engaged.Ragnarok = set_combine(sets.engaged.GreatSword, {})
    sets.engaged.Ragnarok.Mid = set_combine(sets.engaged.GreatSword.Mid, {})
    sets.engaged.Ragnarok.Acc = set_combine(sets.engaged.GreatSword.Acc, {})
    
    sets.engaged.Ragnarok.PDT = set_combine(sets.engaged.Ragnarok, sets.Defensive)
    sets.engaged.Ragnarok.Mid.PDT = set_combine(sets.engaged.Ragnarok.Mid, sets.Defensive_Mid)
    sets.engaged.Ragnarok.Acc.PDT = set_combine(sets.engaged.Ragnarok.Acc, sets.Defensive_Acc)
    
    -- Caladbolg
    sets.engaged.Caladbolg = set_combine(sets.engaged.GreatSword, {
    })
    sets.engaged.Caladbolg.Mid = set_combine(sets.engaged.GreatSword.Mid, {
    })
    sets.engaged.Caladbolg.Acc = set_combine(sets.engaged.GreatSword.Acc, {
    })
    
    sets.engaged.Caladbolg.PDT = set_combine(sets.engaged.Caladbolg, sets.Defensive)
    sets.engaged.Caladbolg.Mid.PDT = set_combine(sets.engaged.Caladbolg.Mid, sets.Defensive_Mid)
    sets.engaged.Caladbolg.Acc.PDT = set_combine(sets.engaged.Caladbolg.Acc, sets.Defensive_Acc)
    
    sets.engaged.Haste.Caladbolg = set_combine(sets.engaged.Caladbolg, { 
    
    })
    sets.engaged.Haste.Caladbolg.Mid = set_combine(sets.engaged.Caladbolg.Mid, {
    
    })
    sets.engaged.Haste.Caladbolg.Acc = set_combine(sets.engaged.Caladbolg.Acc, {
 
    })

    sets.engaged.Haste.Caladbolg.PDT = set_combine(sets.engaged.Caladbolg.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Caladbolg.Mid.PDT = set_combine(sets.engaged.Caladbolg.Mid.PDT, sets.DefensiveHigh)
    sets.engaged.Haste.Caladbolg.Acc.PDT = set_combine(sets.engaged.Caladbolg.Acc.PDT, sets.DefensiveHigh)
    
    -- dual wield
    sets.engaged.DW = set_combine(sets.engaged, {
     
    })
    sets.engaged.DW.Mid = set_combine(sets.engaged.DW, {
        neck="Abyssal Bead Necklace +2",
    })
    sets.engaged.DW.Acc = set_combine(sets.engaged.DW.Mid, {
    })

    -- single wield (sword + shield possibly)
    sets.engaged.SW = set_combine(sets.engaged, {
        ammo="Yetshila +1",
    })
    sets.engaged.SW.Mid = set_combine(sets.engaged.Mid, {})
    sets.engaged.SW.Acc = set_combine(sets.engaged.Acc, {})

    sets.engaged.Reraise = set_combine(sets.engaged, {

    })

    sets.buff.Souleater = { 
        head="Ig. Burgeonet +3",
    }
    sets.MadrigalBonus = {
        
    }
    -- sets.buff['Last Resort'] = { 
    --     feet="Fallen's Sollerets +1" 
    -- }
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Echo Drops" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    aw_custom_aftermath_timers_precast(spell)
end

function job_post_precast(spell, action, spellMap, eventArgs)
    local recast = windower.ffxi.get_ability_recasts()
    -- Make sure abilities using head gear don't swap 
    if spell.type:lower() == 'weaponskill' then
        -- handle Gavialis Helm
        if use_gavialis then
            if is_sc_element_today(spell) then
                if wsList:contains(spell.english) then
                    equip(sets.WSDayBonus)
                end
            end
        end
        -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end

        -- if spell.english == 'Entropy' and recast[95] == 0 then
        --     eventArgs.cancel = true
        --     send_command('@wait 4.0;input /ja "Consume Mana" <me>')
        --     --windower.chat.input:schedule(1, '/ws "Entropy" <t>')
        --     return
        -- end
        if spell.english == 'Insurgency' then
            if world.time >= (17*60) or world.time <= (7*60) then
                equip(sets.Lugra)
            end
        end

        -- if player.tp > 2999 then
        --     if wsList:contains(spell.english) then
        --         equip(sets.IshvaraLugra)
        --     else
        --         equip(sets.BrutalLugra)
        --     end
        -- else -- use Lugra + moonshade
        --     if world.time >= (17*60) or world.time <= (7*60) then
        --         equip(sets.Lugra)
        --     else
        --         if wsList:contains(spell.english) then
        --             equip(sets.Ishvara)
        --         else
        --             equip(sets.Brutal)
        --         end
        --     end
        -- end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english:startswith('Drain') then
        if player.status == 'Engaged' and state.CastingMode.current == 'Normal' and player.hpp < 70 then
            classes.CustomClass = 'OhShit'
        end
    end

    if (state.HybridMode.current == 'PDT' and state.PhysicalDefenseMode.current == 'Reraise') then
        equip(sets.Reraise)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    aw_custom_aftermath_timers_aftercast(spell)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if state.Buff.Souleater and state.SouleaterMode.value then
            send_command('@wait 1.0;cancel souleater')
            --enable("head")
        end
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.hpp < 50 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    elseif player.mpp < 50 then
        idleSet = set_combine(idleSet, sets.idle.Refresh)
    end
    if state.IdleMode.current == 'Sphere' then
        idleSet = set_combine(idleSet, sets.idle.Sphere)
    end
    if state.HybridMode.current == 'PDT' then
        idleSet = set_combine(idleSet, sets.defense.PDT)
    end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.Buff['Souleater'] then
        meleeSet = set_combine(meleeSet, sets.buff.Souleater)
    end
    --meleeSet = set_combine(meleeSet, select_earring())
    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == "Engaged" then
        --if state.Buff['Last Resort'] then
        --    send_command('@wait 1.0;cancel hasso')
        --end
        -- handle weapon sets
    if remaWeapons:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
    end
        -- if gsList:contains(player.equipment.main) then
        --     state.CombatWeapon:set("GreatSword")
        -- elseif scytheList:contains(player.equipment.main) then
        --     state.CombatWeapon:set("Scythe")
        -- elseif remaWeapons:contains(player.equipment.main) then
        --     state.CombatWeapon:set(player.equipment.main)
        -- else -- use regular set, which caters to Liberator
        --     state.CombatWeapon:reset()
        -- end
        --elseif newStatus == 'Idle' then
        --    determine_idle_group()
    end
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)

    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end

    if S{'madrigal'}:contains(buff:lower()) then
        if buffactive.madrigal and state.OffenseMode.value == 'Acc' then
            equip(sets.MadrigalBonus)
        end
    end
    if S{'haste', 'march', 'embrava', 'geo-haste', 'indi-haste', 'last resort'}:contains(buff:lower()) then
        if (buffactive['Last Resort']) then
            if (buffactive.embrava or buffactive.haste) and buffactive.march then
                state.CombatForm:set("Haste")
                if not midaction() then
                    handle_equipping_gear(player.status)
                end
            end
        else
            if state.CombatForm.current ~= 'DW' and state.CombatForm.current ~= 'SW' then
                state.CombatForm:reset()
            end
            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end
    -- Drain II/III HP Boost. Set SE to stay on.
    -- if buff == "Max HP Boost" and state.SouleaterMode.value then
    --     if gain or buffactive['Max HP Boost'] then
    --         state.SouleaterMode:set(false)
    --     else
    --         state.SouleaterMode:set(true)
    --     end
    -- end
    -- Make sure SE stays on for BW
    if buff == 'Blood Weapon' and state.SouleaterMode.value then
        if gain or buffactive['Blood Weapon'] then
            state.SouleaterMode:set(false)
        else
            state.SouleaterMode:set(true)
        end
    end
    -- AM custom groups
    if buff:startswith('Aftermath') then
        if player.equipment.main == 'Liberator' then
            classes.CustomMeleeGroups:clear()

            if (buff == "Aftermath: Lv.3" and gain) or buffactive['Aftermath: Lv.3'] then
                classes.CustomMeleeGroups:append('AM3')
                add_to_chat(8, '-------------Mythic AM3 UP-------------')
            -- elseif (buff == "Aftermath: Lv.3" and not gain) then
            --     add_to_chat(8, '-------------Mythic AM3 DOWN-------------')
            end

            if not midaction() then
                handle_equipping_gear(player.status)
            end
        else
            classes.CustomMeleeGroups:clear()

            if buff == "Aftermath" and gain or buffactive.Aftermath then
                classes.CustomMeleeGroups:append('AM')
            end

            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end
    
    -- if  buff == "Samurai Roll" then
    --     classes.CustomRangedGroups:clear()
    --     if (buff == "Samurai Roll" and gain) or buffactive['Samurai Roll'] then
    --         classes.CustomRangedGroups:append('SamRoll')
    --     end
       
    -- end

    --if buff == "Last Resort" then
    --    if gain then
    --        send_command('@wait 1.0;cancel hasso')
    --    else
    --        if not midaction() then
    --            send_command('@wait 1.0;input /ja "Hasso" <me>')
    --        end
    --    end
    --end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)

    war_sj = player.sub_job == 'WAR' or false
    get_combat_form()
    get_combat_weapon()
    update_melee_groups()
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
--function th_action_check(category, param)
--    if category == 2 or -- any ranged attack
--        --category == 4 or -- any magic action
--        (category == 3 and param == 30) or -- Aeolian Edge
--        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
--        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
--        then 
--            return true
--    end
--end
-- function get_custom_wsmode(spell, spellMap, default_wsmode)
--     if state.OffenseMode.current == 'Mid' then
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3Mid'
--         end
--     elseif state.OffenseMode.current == 'Acc' then
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3Acc'
--         end
--     else
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3'
--         end
--     end
-- end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function get_combat_form()

    if S{'NIN', 'DNC'}:contains(player.sub_job) and swordList:contains(player.equipment.main) then
        state.CombatForm:set("DW")
    --elseif player.equipment.sub == '' or shields:contains(player.equipment.sub) then
    elseif swordList:contains(player.equipment.main) then
        state.CombatForm:set("SW")
    elseif buffactive['Last Resort'] then
        if (buffactive.embrava or buffactive.haste) and buffactive.march then
            add_to_chat(8, '-------------Delay Capped-------------')
            state.CombatForm:set("Haste")
        else
            state.CombatForm:reset()
        end
    else
        state.CombatForm:reset()
    end
end

function get_combat_weapon()
    state.CombatWeapon:reset()
    if remaWeapons:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
    end
    -- if remaWeapons:contains(player.equipment.main) then
    --     state.CombatWeapon:set(player.equipment.main)
    -- elseif gsList:contains(player.equipment.main) then
    --     state.CombatWeapon:set("GreatSword")
    -- elseif scytheList:contains(player.equipment.main) then
    --     state.CombatWeapon:set("Scythe")
    -- end
end

function aw_custom_aftermath_timers_precast(spell)
    if spell.type == 'WeaponSkill' then
        info.aftermath = {}

        local mythic_ws = "Insurgency"

        info.aftermath.weaponskill = mythic_ws
        info.aftermath.duration = 0

        info.aftermath.level = math.floor(player.tp / 1000)
        if info.aftermath.level == 0 then
            info.aftermath.level = 1
        end

        if spell.english == mythic_ws and player.equipment.main == 'Liberator' then
            -- nothing can overwrite lvl 3
            if buffactive['Aftermath: Lv.3'] then
                return
            end
            -- only lvl 3 can overwrite lvl 2
            if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
                return
            end

            if info.aftermath.level == 1 then
                info.aftermath.duration = 90
            elseif info.aftermath.level == 2 then
                info.aftermath.duration = 120
            else
                info.aftermath.duration = 180
            end
        end
    end
end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
    if not spell.interrupted and spell.type == 'WeaponSkill' and
        info.aftermath and info.aftermath.weaponskill == spell.english and info.aftermath.duration > 0 then

        local aftermath_name = 'Aftermath: Lv.'..tostring(info.aftermath.level)
        send_command('timers d "Aftermath: Lv.1"')
        send_command('timers d "Aftermath: Lv.2"')
        send_command('timers d "Aftermath: Lv.3"')
        send_command('timers c "'..aftermath_name..'" '..tostring(info.aftermath.duration)..' down abilities/aftermath'..tostring(info.aftermath.level)..'.png')

        info.aftermath = {}
    end
end

function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current
    msg = msg .. ', Hybrid: '..state.HybridMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.CombatForm.current ~= '' then 
        msg = msg .. ', Form: ' .. state.CombatForm.current 
    end
    if state.CombatWeapon.current ~= '' then 
        msg = msg .. ', Weapon: ' .. state.CombatWeapon.current 
    end
    if state.CapacityMode.value then
        msg = msg .. ', Capacity: ON, '
    end
    if state.SouleaterMode.value then
        msg = msg .. ', SE Cancel, '
    end
    -- if state.LastResortMode.value then
    --     msg = msg .. ', LR Defense, '
    -- end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(123, msg)
    eventArgs.handled = true
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
end

-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Dark Magic' and absorbs:contains(spell.english) then
        return 'Absorb'
    end
    -- if spell.type == 'Trust' then
    --     return 'Trust'
    -- end
end

function select_earring()
    if world.time >= (17*60) or world.time <= (7*60) then
        return sets.Lugra
    else
        return sets.Brutal
    end
end

function update_melee_groups()

    classes.CustomMeleeGroups:clear()
    -- mythic AM	
    if player.equipment.main == 'Liberator' then
        if buffactive['Aftermath: Lv.3'] then
            classes.CustomMeleeGroups:append('AM3')
        end
    else
        -- relic AM
        if buffactive['Aftermath'] then
            classes.CustomMeleeGroups:append('AM')
        end
        -- if buffactive['Samurai Roll'] then
        --     classes.CustomRangedGroups:append('SamRoll')
        -- end
    end
end

function select_default_macro_book()

        set_macro_page(4, 2)
 
end