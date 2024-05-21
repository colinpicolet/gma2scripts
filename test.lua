---@diagnostic disable: undefined-global

Check=0
if Check==1 then 
    local macro=48 
    gma.feedback('macro is : '..macro)
    local rd = math.random(0,11)
    gma.feedback('random number : '..rd)
    local offset=5
    local var = (rd+offset)%11
    gma.feedback('variable is : '..var)
    gma.cmd('Goto Macro '..macro+var)
    gma.feedback('color has been changed')
end