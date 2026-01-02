
function input_menu()
    if btn(3) then
        _upd=update_game
	    _dra=draw_game
        music(1)
    end
end

function input_game()
    if btnp(0) then --左
        p.dire=1
    elseif btnp(1) then --右
        p.dire=5
    end 
    if (not btn(0) and not btn(1)) or ( btn(0) and btn(1)) then
        p.dire=0
    end
    if btn(4) and p.can_trans and check_trans_gifts_ground(p) then --搬运礼物
        p.is_trans=true
        p.can_trans=false
    end
    if btn(5) then --射击
        p.is_shoot=true
        sfx(5)
    end
    if btnp(3) and p.state==p.allstate.trans and check_close_giftpackage(p) then --打开礼物袋
        p.isgitfsdown=true
    end
end
