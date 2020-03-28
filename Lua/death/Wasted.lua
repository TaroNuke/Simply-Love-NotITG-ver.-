local wasted = {}

function wasted:Setup()
    local aftsprite = self("AftSprite")
    aftsprite:SetTextureFiltering(true)
    aftsprite:basezoomx(SCREEN_WIDTH/DISPLAY:GetDisplayWidth())
    aftsprite:basezoomy(-SCREEN_HEIGHT/DISPLAY:GetDisplayHeight())
    aftsprite:x(SCREEN_CENTER_X)
    aftsprite:y(SCREEN_CENTER_Y)
    aftsprite:GetShader():uniform1f( 'howGray', 1.0 )
    aftsprite:hidden(1)

    if not aftsprite:hascommand("HideAft") then
        aftsprite:addcommand("HideAft", function() 
            stitch("lua.aftoverlay"):Off()
        end)
    end

    self(2):cmd("stretchto,0,0,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,0;")
    self(3):cmd("basezoomx,.8;basezoomy,.8;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y;diffusealpha,0;fadeleft,.1;faderight,.1;")
end

function wasted:Prepare()
    self("AftSprite"):SetTexture(stitch("lua.aftoverlay").texture)
    wasted.Prepare = nil -- No need to set the texture again
end

function wasted:Dead()
    stitch("lua.aftoverlay"):On()
    GAMESTATE:ApplyGameCommand('sound,gta_wasted')

    self("AftSprite"):cmd("hidden,0;diffusealpha,1;sleep,4;linear,1;diffusealpha,0;queuecommand,HideAft")
    self(2):cmd("diffusealpha,1;linear,.5;diffusealpha,0;")
    self(3):cmd("sleep,2.25;diffusealpha,1;zoom,1.1;linear,.3;zoom,1;sleep,2;linear,1;diffusealpha,0;")
end

return wasted
