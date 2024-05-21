---@diagnostic disable: undefined-global
--Plugin written by: Tristan Perrot 
-- Modified for ledbars by : Colinx

--Configuration

local page = 13
local pageFoyerLedBar = 13

-- contol the loop with this variable
local mode = 1

-- col speed fader set
local pageColSpeedFader = 2

------------------------- MOTORIZED LIGHTS -------------------------

-- number of groups you want to control (usually the number of different types of lights you have)
---only working on ledbars here so nbLightgroups=1
local nbLightgroups = 1

-- testing this feature
local colorGroupConfig = {1,2,3} -- i want 3 modes for my lights : everything at the same time (1), center and sides (2), each line individually (3)
local nbColorGroups = 2


-- the number in ExecButtons
-- no need for motoreffects because ledbars can't move lol
local ledBarEffects = { { 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144 } }

-- Effects who have impact on position and dimmer are stored at the end of motorEffects and the 1st position in the list needs to be declare
-- position are from 1, #dimEffects
local startOfDimAndPositionEffects = { 6, 9 }

-- The macro number associated with white in your colorpicker 
-- your colors need to be in the color picker 
-- the size of this array needs to equal to nbLightgroups !!
local macroStartColors = { { 108 } , { 48, 60, 72, 84 }, { 48, 60, 72, 84 } } -- numbers listed as follows : extG, milG, milD, extD
------ TODO later : be able to control each line of ledbars individually just like in the colorpicker


---------------- End of configuration ----------------------------------------

-- start of function
function Autoplay()
   if (gma.gui.confirm('Are you sure ?', 'Are you sure you want to start auto-mode ?')) then
      --if (page == 4) then local foyer = true else local foyer = false end

      math.randomseed(os.time())
      gma.feedback('random seed chosen : ' .. os.time())


      -- choose your colorspeed, i like 60 bpm = 27%
      gma.cmd('Fader ' .. pageColSpeedFader .. '.' .. 3 .. ' At 25')
      gma.feedback('Color speed set')


      -- Main loop
      while (gma.show.getvar('AUTOMODE' .. mode) == '1') do
         local runned = {}
         local count = 0

         -- Light groups (= global effects) --
         for i = 1, nbLightgroups, 1 do
            -- lighting effects
            local m = math.random(#ledBarEffects[i])
            gma.cmd('Toggle Executor ' .. page .. '.' .. ledBarEffects[i][m])
            count = count + 1
            runned[count] = ledBarEffects[i][m]
            gma.feedback('Starting ' .. page .. '.' .. ledBarEffects[i][m])

            ------- changing the color (buckle up this is convoluted) -------
            local choice = math.random(1, #colorGroupConfig)

            -- same color everywhere
            if (choice == 1) then
               local c = math.random(0, 11)
               gma.cmd('Goto Macro ' .. macroStartColors[choice][i] + c)
            
            -- center and sides
            elseif (choice == 2) then
               local c = math.random(0, 11)
               if c == 11 then
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][1] + c)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][2] + 0)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][3] + 0)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][4] + c)
               else 
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][1] + c)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][2] + c+1)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][3] + c+1)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][4] + c)
               end
            
            -- each line individually
            elseif (choice == 3) then
               local c = math.random(0, 11)
               if c == 9 then
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][1] + c)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][2] + c+1)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][3] + c+2)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][4] + 0)
               elseif c == 10 then
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][1] + c)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][2] + c+1)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][3] + 0)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][4] + 1)
               elseif c == 11 then
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][1] + c)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][2] + 0)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][3] + 1)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][4] + 2)
               else
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][1] + c)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][2] + c+1)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][3] + c+2)
                  gma.cmd('Goto Macro ' .. macroStartColors[choice][4] + c+3)
               end

            end
         end         

         -- Sleep --
         gma.sleep(math.random(15, 40))

         -- Store the runned effects --
         for key = 1, #runned do
            gma.cmd('Toggle Executor ' .. page .. '.' .. runned[key])
            gma.feedback('Stopping ' .. page .. '.' .. runned[key])
         end
      end

      -- once your autoplay is done we go back to the global default color and the user can turn off all the lights
      for i = 1, nbLightgroups do
         gma.cmd('Goto Macro ' .. macroStartColors[i][1])
      end

      gma.feedback('Finished Autoplay')
   else
      return
   end
end

return Autoplay