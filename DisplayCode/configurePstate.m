function configurePstate(modID)

switch modID
    case 'PG'
        configurePstate_perGrater
    case 'FG'
        configurePstate_flashGrater
    case 'RD'
        configurePstate_Rain
    case 'FN'
        configurePstate_Noise
    case 'MP'
        configurePstate_Mapper
    case 'CM'
        configurePstate_RandomDots2
    case 'RS'
        configurePstate_RandomDots
    case 'PP'
        configurePstate_perGrater
    case 'LM'
        configurePstate_lumSquare
        
end     