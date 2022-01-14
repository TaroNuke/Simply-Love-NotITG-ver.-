function OptionsRowColorSimKind()
    local Names = {
        'None',
        'Protanopia',
        'Deuteranopia',
        'Tritanopia',
        'Achromatopsia'
    }

    local function Load( self, list, pn )
        local current = stitch( 'lua.colorsim' ).kind
        local isValid = false

        for i, name in ipairs( Names ) do
            list[ i ] = name == current
            isValid = isValid or ( name == current )
        end

        if not isValid then
            list[ 1 ] = true -- None
        end
    end

    local function Save( self, list, pn )
        for i, name in ipairs( Names ) do
            if list[ i ] then
                stitch( 'lua.colorsim' ).setKind( name )
            end
        end
    end

    local Params = {
        Name = "Color Simulation",
        LayoutType = "ShowAllInRow",
        ExportOnChange = true,
    }

    return CreateOptionRow( Params, Names, Load, Save )
end

function OptionsRowColorSimBlend()
    local Names = {}
    local values = {}

    for i = 1, 11 do
        local value = ( i - 1 ) * 0.1
        values[ i ] = value
        Names[ i ] = string.format( '%1.1f', value )
    end

    local function Load( self, list, pn )
        local current = stitch( 'lua.colorsim' ).blend
        local isValid = false

        for i, value in ipairs( values ) do
            list[ i ] = value == current
            isValid = isValid or ( value == current )
        end

        if not isValid then
            list[ 11 ] = true -- 1.0
        end
    end

    local function Save( self, list, pn )
        for i, value in ipairs( values ) do
            if list[ i ] then
                stitch( 'lua.colorsim' ).setBlend( value )
            end
        end
    end

    local Params = {
        Name = "Color Simulation Blend",
        LayoutType = "ShowOneInRow",
        ExportOnChange = true,
    }

    return CreateOptionRow( Params, Names, Load, Save )
end
