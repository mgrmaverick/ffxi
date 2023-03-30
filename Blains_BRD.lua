--------------------------------------------------------------------------
-----------------------     includes      --------------------------------
--------------------------------------------------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
  include('organizer-lib')
end

--------------------------------------------------------------------------
-----------------------     constants      -------------------------------
--------------------------------------------------------------------------
lockstyle_set = "06" -- this one needs to be a string
default_macro_book = 9
default_macro_page = 1

---------------------------------
-- organizer 
---------------------------------
send_command('@input //gs org;wait6; input //gs validate')

--------------------------------------------------------------------------
-----------------------     job setup      -------------------------------
--------------------------------------------------------------------------
function job_setup()
  --todo
end

--------------------------------------------------------------------------
----------------------     user setup      -------------------------------
--------------------------------------------------------------------------
function user_setup() 
  -- built-in state tables
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'Dps', 'DT')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Normal', 'Resistant')
  send_command('bind ^c gs c cycle CastingMode')

  -- custom state tables
  state.SongMode = M{['description'] = 'SongMode', 'Normal', 'Dummy'}--,'Autodummy'}
  send_command('bind ^s gs c cycle SongMode')

  state.LullabyMode = M{['description'] = 'LullabyMode', 'Harp', 'Horn' }
  send_command('bind ^l gs c cycle LullabyMode')

  set_lockstyle()
  select_default_macro_book()
  --dressup()

end

function user_unload()
  send_command('unbind ^i')
  send_command('unbind ^o')
  send_command('unbind ^c')
  send_command('unbind ^s')
  send_command('unbind ^l')
end

function init_gear_sets()
  -- this is the order.  the order is arbitrary, but you should try to keep it consistent
    -- main
    -- sub
    -- range
    -- ammo
    -- head
    -- body
    -- hands
    -- legs
    -- feet
    -- neck 
    -- ear1
    -- ear2
    -- ring1
    -- ring2
    -- back
    -- waist

  --------------------------------------------------------------------------
  -----------------------     idle sets      -------------------------------
  --------------------------------------------------------------------------
  sets.idle = 
  { 
    main={ name="Bihu Knife", augments={'Path: A',}},
    sub="Genmei Shield",
    head="Fili Calot +2",
    body="Fili Hongreline +2",
    hands="Fili Manchettes +2",
    legs="Fili Rhingrave +2",
    feet="Fili Cothurnes +2",
    neck="Elite Royal Collar",
    waist="Flume Belt +1",
    left_ear="Eabani Earring",
    right_ear="Ethereal Earring",
    left_ring="Inyanga Ring",
    right_ring="Defending Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
  } 

  sets.idle.Town = set_combine(sets.idle, {
    range="Daurdabla",
    head="Fili Calot +2",
    body="Fili Hongreline +2",
    hands="Fili Manchettes +2",
    legs="Fili Rhingrave +2",
    feet="Fili Cothurnes +2",
    neck="Mnbw. Whistle +1",
    waist="Flume Belt +1",
    left_ear="Aoidos' Earring",
    right_ear={ name="Fili Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
    left_ring="Kishar Ring",
    right_ring="Defending Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
})

  --------------------------------------------------------------------------
  ---------------------     precast sets      ------------------------------
  --------------------------------------------------------------------------
  -- spells
  sets.precast.FC = 
  { 
    head="Fili Calot +2",
    body="Inyanga Jubbah +2",
    hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -3%','Magic dmg. taken -3%','Song spellcasting time -5%',}},
    legs="Aya. Cosciales +2",
    feet={ name="Telchine Pigaches", augments={'Mag. Evasion+25','Song spellcasting time -7%',}},
    neck="Elite Royal Collar",
    waist="Witful Belt",
    left_ear="Aoidos' Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
}
   

  sets.precast.FC.Cure = sets.precast.FCbibihu
  
  sets.precast.FC.Cura = sets.precast.FC.Cure
  sets.precast.FC.Curaga = sets.precast.FC.Cure

  sets.precast.FC['Enhancing Magic'] = sets.precast.FC.Cure

  sets.precast.FC.BardSong = set_combine(sets.precast.FC, {main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
  sub="Genmei Shield", })

  sets.precast.FC.SongPlaceholder = sets.precast.FC.BardSong

  sets.precast.FC.Dispelga = {
    main="Daybreak",
  }

  -- Waltz set (chr and vit)
  sets.precast.Waltz = {}

  -- job abilities
  sets.precast.JA["Nightingale"]= {feet="bihu slippers +3" }
  sets.precast.JA["Soul Voice"] = {legs="bihu cannions +3"}
  sets.precast.JA["Troubadour"] = {body="bihu justaucorps +3" }

  -- weapon skills

  sets.precast.WS =   { 
    range={ name="Linos", augments={'Attack+15','Weapon skill damage +3%','STR+6 DEX+6',}},
    head={ name="Lustratio Cap", augments={'Attack+15','STR+5','"Dbl.Atk."+2',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
    legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
    neck="Rep. Plat. Medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Rufescent Ring",
    right_ring="Ifrit Ring",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
  } 

  sets.precast.WS["Savage Blade"] = 
  { 
    range={ name="Linos", augments={'Attack+15','Weapon skill damage +3%','STR+6 DEX+6',}},
    head={ name="Lustratio Cap", augments={'Attack+15','STR+5','"Dbl.Atk."+2',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
    legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
    neck="Rep. Plat. Medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Rufescent Ring",
    right_ring="Ifrit Ring",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
  } 

  --------------------------------------------------------------------------
  ---------------------     midcast sets      ------------------------------
  --------------------------------------------------------------------------
  -- General set for recast times.
  sets.midcast.FastRecast = sets.precast.FC

  -- Gear to enhance certain classes of songs.
  sets.midcast.Ballad     = {legs="Fili rhingrave +2" }
  --sets.midcast.Carol    = { hands= "Mousai Gages +1" }
  --sets.midcast.Etude    = { head = "Mousai Turban +1" }
  sets.midcast.HonorMarch = {hands="Fili Manchettes +2"} 
  sets.midcast.Madrigal   = {head="Fili Calot +2",}
  --sets.midcast.Mambo    = { feet = "Mousai Crackows +1" }
  sets.midcast.March      = {hands="Fili Manchettes +2"}
  --sets.midcast.Minne    = { legs = "Mousai Seraweels +1" }
  sets.midcast.Minuet     = {body="Fili Hongreline +2"}
  sets.midcast.Paeon      = {head="Brioso Roundlet +2"}
  --sets.midcast.Threnody = { body = "Mou. Manteel +1" }
  sets.midcast.Operetta   = {neck="Elite royal collar"}

  sets.midcast['Adventurer\'s Dirge'] = { }
  sets.midcast['Foe Sirvente']        = { }
  sets.midcast['Magic Finale']        = { }
  sets.midcast["Sentinel's Scherzo"]  = { }
  sets.midcast["Chocobo Mazurka"]     = { }

  -- For song buffs (duration and AF3 set bonus)
  sets.midcast.SongEnhancing = 
  { 
    head="Fili Calot +2",
    body="Fili Hongreline +2",
    hands="Fili Manchettes +2",
    legs="Inyanga Shalwar +2",
    feet="brioso slippers +3",
    neck="Mnbw. Whistle +1",
    waist="Flume belt +1",
    left_ear="Aoidos' Earring",
    right_ear="Loquac. Earring",
    left_ring={name="Stikini Ring", bag="wardrobe2"},
    right_ring="Defending Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
  }

  -- For song defbuffs (duration primary, accuracy secondary)
  sets.midcast.SongEnfeeble =   
  { 
    main="Daybreak",
    sub="Genmei Shield",
    head="Brioso Roundlet +2",
    body="Fili Hongreline +2",
    hands="Fili Manchettes +2",
    legs="Fili rhingrave +2",
    feet="Brioso Slippers +3",
    neck="Mnbw. Whistle +1",
    waist="Eschan Stone",
    left_ear="Hermetic Earring",
    right_ear={ name="Fili Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+6','Mag. Acc.+6',}},
    left_ring={name="Stikini Ring", bag="wardrobe2"},
    right_ring={name="Stikini Ring", bag="wardrobe1"},
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},

  }

  -- For Horde Lullaby maxiumum AOE range.
  sets.midcast.Lullaby  = set_combine(
    sets.midcast.SongEnfeeble, {  
      legs="Inyanga Shalwar +2",
      hands="Inyan. Dastanas +2",
    }
  )

  ---------------------------------
  -- For song defbuffs (accuracy primary, duration secondary)
  ---------------------------------
  sets.midcast.SongEnfeebleAcc = set_combine(sets.midcast.SongEnfeeble, { })

  sets.midcast.SongPlaceholder = sets.midcast.SongEnhancing

  sets.midcast.Cure = 
  { 
    main="Daybreak",
    sub="Genmei Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Kaykaus Bliaut", augments={'MP+60','"Cure" potency +5%','"Conserve MP"+6',}},
    hands="Inyan. Dastanas +2",
    legs={ name="Vanya Slops", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Henic Torque",
    waist="Bishop's Sash",
    left_ear="Mendi. Earring",
    right_ear="Eabani Earring",
    left_ring="Janniston Ring",
    right_ring={name="Stikini Ring", bag="wardrobe1"},
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
  }

  sets.midcast.Cura   = sets.midcast.Cure
  sets.midcast.Curaga = sets.midcast.Cure

  sets.midcast['Enhancing Magic'] = 
  {}

  sets.midcast['Enfeebling Magic'] = 
    {   
      main="Daybreak",
      sub="Genmei Shield",
      ammo="Pemphredo Tathlum",
      head="Inyanga Tiara +2",
      body="Brioso Justau. +2",
      hands="Inyan. Dastanas +2",
      legs="Brioso Cannions +2",
      feet="Brioso Slippers +3",
      neck="Henic Torque",
      waist="Eschan Stone",
      left_ear="Hermetic Earring",
      right_ear="Eabani Earring",
      left_ring={name="Stikini Ring", bag="wardrobe2"},
      right_ring={name="Stikini Ring", bag="wardrobe1"},
      back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
  }

  sets.midcast.Regen     = set_combine(sets.midcast['Enhancing Magic'], { })
  sets.midcast.Haste     = sets.midcast['Enhancing Magic']
  sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], { })
  sets.midcast.Aquaveil  = set_combine(sets.midcast['Enhancing Magic'], {  })
  sets.midcast.Protect   = set_combine(sets.midcast['Enhancing Magic'], {  })
  sets.midcast.Protectra = sets.midcast.Protect
  sets.midcast.Shell     = sets.midcast.Protect
  sets.midcast.Shellra   = sets.midcast.Shell

  ---------------------------------
  -- melee sets
  ---------------------------------
  -- just stacking STP here.  If we're meleeing, we're just trying to get to Savage Blade
  -- don't put anything in the ammo slot
  sets.engaged = 
  { 
    range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
    head="Aya. Zucchetto +2",
    body="Ayanmo Corazza +2",
    hands="Aya. Manopolas +2",
    legs={ name="Telchine Braconi", augments={'Accuracy+15 Attack+15','"Store TP"+5','STR+7 DEX+7',}},
    feet="Battlecast Gaiters",
    neck={ name="Bard's Charm +1", augments={'Path: A',}},
    waist="Sailfi Belt +1",
    left_ear="Mache Earring",
    right_ear="Suppanomimi",
    left_ring="Chirich Ring",
    right_ring="Chirich Ring",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
  } 

  -- -53% DT.  I commented out the pieces that overcapped me on DT in favor of STP.
  sets.engaged.DT  = set_combine(
    sets.engaged, {  

    }
  ) 
  
  sets.engaged.Dps = set_combine(sets.engaged, { main = "Naegling", sub = "Fusetto +2", })
                               
end

--------------------------------------------------------------------------
---------------------     job functions      -----------------------------
--------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
  equip_ranged(get_instrument(spell))
end

function job_midcast(spell, action, spellMap, eventArgs)
  if spell.type == 'BardSong' then
    local song_class = get_song_class(spell)

    if song_class and sets.midcast[song_class] then
      equip(sets.midcast[song_class])
    end

  end
end

function job_aftercast(spell, action, spellMap, eventArgs)
  enable(range)
  if spell.english:contains('Lullaby') and not spell.interrupted then
    get_lullaby_duration(spell)
  end
end

--------------------------------------------------------------------------
-------------------     utility functions      ---------------------------
--------------------------------------------------------------------------
function equip_ranged(item)
  equip({ range = item })
  disable(range)
end

function get_instrument(spell)
  if spell.name == 'Honor March' then return "Marsyas" end
  if spell.english:contains('Lullaby') then return "Blurred Harp +1" end
  if spell.english:contains('Operetta') then return "Daurdabla" end
  if spell.english:contains('Spirited Etude') then return "Daurdabla" end
  if is_dummy_song() then return "Daurdabla" end
  if state.SongMode.value == 'Normal' then return "Gjallarhorn" end

  return "Gjallarhorn"
end

-- Determine the custom class to use for the given song.
function get_song_class(spell)
  -- Can't use spell.targets:contains() because this is being pulled from resources
  if set.contains(spell.targets, 'Enemy') then
    if state.CastingMode.value == 'Resistant' then return "SongEnfeebleAcc" end
    return "SongEnfeeble"
  end

  if is_dummy_song() then return "SongPlaceholder" end
    
  return "SongEnhancing"
end

function get_lullaby_duration(spell)
  local self = windower.ffxi.get_player()

  local troubadour = false
  local clarioncall = false
  local soulvoice = false
  local marcato = false

  for i,v in pairs(self.buffs) do
    if v == 348 then troubadour = true end
    if v == 499 then clarioncall = true end
    if v == 52 then soulvoice = true end
    if v == 231 then marcato = true end
  end

  local mult = 1

  if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
  if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
  if player.equipment.range == "Marsyas" then mult = mult + 0.5 end

  if player.equipment.main == "Carnwenhan" then mult = mult + 0.5 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
  if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
  if player.equipment.main == "Kali" then mult = mult + 0.05 end
  if player.equipment.sub == "Kali" then mult = mult + 0.05 end
  if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
  if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
  if player.equipment.neck == "Mnbw. Whistle" then mult = mult + 0.2 end
  if player.equipment.neck == "Mnbw. Whistle +1" then mult = mult + 0.3 end
  if player.equipment.body == "Fili Hongreline +2" then mult = mult + 0.12 end
  if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
  if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
  if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
  if player.equipment.feet == "brioso slippers +1" then mult = mult + 0.11 end
  if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
  if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end
  if player.equipment.hands == 'brioso cuffs +2' then mult = mult + 0.1 end
  if player.equipment.hands == 'Brioso Cuffs +2' then mult = mult + 0.1 end
  if player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.2 end

  --JP Duration Gift
  if self.job_points.brd.jp_spent >= 1200 then
    mult = mult + 0.05
  end

  if troubadour then
    mult = mult * 2
  end

  if spell.en == "Foe Lullaby II" or spell.en == "Horde Lullaby II" then
    base = 60
  elseif spell.en == "Foe Lullaby" or spell.en == "Horde Lullaby" then
    base = 30
  end

  totalDuration = math.floor(mult * base)

  -- Job Points Buff
  totalDuration = totalDuration + self.job_points.brd.lullaby_duration
  if troubadour then
    totalDuration = totalDuration + self.job_points.brd.lullaby_duration
    -- adding it a second time if Troubadour up
  end

  if clarioncall then
    if troubadour then
      totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2 * 2)
      -- Clarion Call gives 2 seconds per Job Point upgrade.  * 2 again for Troubadour
    else
      totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2)
      -- Clarion Call gives 2 seconds per Job Point upgrade.
    end
  end

  if marcato and not soulvoice then
    totalDuration = totalDuration + self.job_points.brd.marcato_effect
  end

  -- Create the custom timer
  if spell.english == "Foe Lullaby II" or spell.english == "Horde Lullaby II" then
    send_command('@timers c "Lullaby II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00377.png')
  elseif spell.english == "Foe Lullaby" or spell.english == "Horde Lullaby" then
    send_command('@timers c "Lullaby ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00376.png')
  end
end

function get_player_songs()
  local counter = 0
  local player = windower.ffxi.get_player()
  
  for _, buffCode in pairs(player.buffs) do
    if buffCode >= 195 and buffCode <= 222 then -- see ~\FFXI_Windower\res\buffs.lua for a complete list of buff codes. These are beneficial songs.
      counter = counter + 1
    end
  end

  return counter
end

function is_dummy_song()
  local songs = get_player_songs()
  return state.SongMode.value == 'Dummy' or (songs >= 2 and songs < 4 and state.SongMode.value == 'Autodummy') 
end

--------------------------------------------------------------------------
----------------------     style lock      -------------------------------
--------------------------------------------------------------------------
function set_lockstyle() 
  send_command('@wait 6;input /lockstyleset ' .. lockstyle_set)
end

--------------------------------------------------------------------------
------------------------     macros      ---------------------------------
--------------------------------------------------------------------------
function select_default_macro_book()
  if default_macro_book then
    send_command('@input /macro book ' .. tostring(default_macro_book) .. ';wait .1;input /macro set ' .. tostring(default_macro_page))
    return
  end
  send_command('@input / macro set ' .. tostring(default_macro_page))
end

---------------------------------
-- dressup 
---------------------------------
--function dressup(race, gender, face)
 -- send_command('@input //lua l dressup')
 -- if not race or not gender or not face then send_command('@input //du clear self') return end
  --send_command('@input //du self race ' .. race .. ' ' .. gender)
 --send_command('@wait 2; input //du self face ' .. tostring(face))
--end
