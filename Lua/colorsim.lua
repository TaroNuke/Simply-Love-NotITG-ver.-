local kinds = {
    'None',
    'Protanopia',
    'Deuteranopia',
    'Tritanopia',
    'Achromatopsia'
}

local colorsim = {
    kind = 'None',
    blend = 1.0,
    sprite = nil
}

function colorsim.initSprite( sprite )
    colorsim.sprite = sprite

    sprite:SetTextureFiltering( true )
    sprite:basezoomx( SCREEN_WIDTH / DISPLAY:GetDisplayWidth() )
    sprite:basezoomy( -SCREEN_HEIGHT / DISPLAY:GetDisplayHeight() )
    sprite:x( SCREEN_CENTER_X )
    sprite:y( SCREEN_CENTER_Y )
    sprite:visible( 0 )
end

function colorsim.uninitSprite()
    colorsim.setKind( 'None' )

    colorsim.sprite = nil
end

function colorsim.setKind( kind )
    local sprite = colorsim.sprite
    local shader = sprite:GetShader()

    local prevKind = colorsim.kind
    colorsim.kind = kind

    if kind ~= 'None' then
        stitch( 'lua.aftoverlay' ):On()
        sprite:SetTexture( stitch( 'lua.aftoverlay' ).texture ) -- deferred just in case
        sprite:visible( 1 )

        shader:uniform1f( 'blend', colorsim.blend )
    else
        stitch( 'lua.aftoverlay' ):Off()
        sprite:visible( 0 )
    end

    shader:clearDefine( 'KIND_' .. string.upper( prevKind ) )
    shader:define( 'KIND_' .. string.upper( kind ) )
end

function colorsim.setBlend( blend )
    local sprite = colorsim.sprite
    local shader = sprite:GetShader()

    colorsim.blend = blend

    if kind ~= 'None' then
        shader:uniform1f( 'blend', blend )
    end
end

return colorsim
