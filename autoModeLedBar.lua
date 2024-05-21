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
nblights = 1
---only working on ledbars here so nblights=1

-- the number in ExecButtons
-- no need for motoreffects because ledbars can't move lol
local ledBarEffects = { { 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144 } }

-- Effects who have impact on position and dimmer are stored at the end of motorEffects and the 1st position in the list needs to be declare
-- position are from 1, #dimEffects
local startOfDimAndPositionEffects = { 6, 9 }

-- The macro number associated with white in your colorpicker 
-- your colors need to be in the color picker 
-- the size of this array needs to equal to nblights
local macroStartColors = { 108 }
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

         -- LIGHTS --
         for i = 1, nblights, 1 do
            -- lighting effects
            local m = math.random(#ledBarEffects[i])
            gma.cmd('Toggle Executor ' .. page .. '.' .. ledBarEffects[i][m])
            count = count + 1
            runned[count] = ledBarEffects[i][m]
            gma.feedback('Starting ' .. page .. '.' .. ledBarEffects[i][m])

            -- global color change
            local c = math.random(0, 11)
            gma.cmd('Goto Macro ' .. macroStartColors[i] + c)
         end
         

         -- Sleep --
         gma.sleep(math.random(2, 5)) --math.random(15, 40)

         -- Store the runned effects --
         for key = 1, #runned do
            gma.cmd('Toggle Executor ' .. page .. '.' .. runned[key])
            gma.feedback('Stopping ' .. page .. '.' .. runned[key])
         end
      end

      -- once your autoplay is done we go back to the default color and the user can turn off all the lights
      for i = 1, #macroStartColors do
         gma.cmd('Goto Macro ' .. macroStartColors[i])
      end

      gma.feedback('Finished Autoplay')
   else
      return
   end
end

return Autoplay