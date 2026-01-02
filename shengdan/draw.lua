function draw_menu()
    cls(8)
    rle1(pic1,2,6)
    rle1(pic2,2,30)
    rle1(pic3,2,54)
    rle1(pic4,2,78)
    rle1(pic5,2,102)
    rle1(pic6,2,126)
	print("enter ⬇️ to start",36,110,blink())
end

function drawplayer()--主角绘制
    palt(11,true)
    palt(0,false)
    if p.state == p.allstate.idle then --待机
        sspr(p.sspr.idle[1],p.sspr.idle[2],p.sspr.idle[3],p.sspr.idle[4],p.x,p.y,p.sspr.idle[3],p.sspr.idle[4],flip_P(p.dire))
    elseif p.state == p.allstate.run then --移动
        local frame=flr(time()*6)%#p.sspr.run+1
        sspr(p.sspr.run[frame][1],p.sspr.run[frame][2],p.sspr.run[frame][3],p.sspr.run[frame][4],p.x,p.y,p.sspr.run[frame][3],p.sspr.run[frame][4],flip_P(p.dire))
    elseif p.state == p.allstate.shoot then --射击
        sspr(p.sspr.shoot[1],p.sspr.shoot[2],p.sspr.shoot[3],p.sspr.shoot[4],p.x,p.y,p.sspr.shoot[3],p.sspr.shoot[4],flip_P(p.dire))
    elseif p.state == p.allstate.trans then --搬运礼物
        if p.dire==0 then
            sspr(p.sspr.trans[1][1],p.sspr.trans[1][2],p.sspr.trans[1][3],p.sspr.trans[1][4],p.x,p.y,p.sspr.trans[1][3],p.sspr.trans[1][4],flip_P(p.last_dire))
        else
            local frame=flr(time()*4)%#p.sspr.trans+1
            sspr(p.sspr.trans[frame][1],p.sspr.trans[frame][2],p.sspr.trans[frame][3],p.sspr.trans[frame][4],p.x,p.y,p.sspr.trans[frame][3],p.sspr.trans[frame][4],flip_P(p.last_dire))
        end
    end
    palt()
end

function draw_game()
    cls()
    --背景
    sspr(0,96,128,32,0,88)
    --烟雾
    for s in all(smooke) do
        --fillp(42405)
        circfill(s.x,s.y,s.r,s.spr[s.frame])
        --fillp()
    end
    --房子
    sspr(92,15,36,17,62,103)
    
    --雪花绘制
    for s in all(snow) do
        local is_near_ground =(s.y>100)
        if is_near_ground then
            circfill(s.x,s.y,0,s.c-1)
        else
            circfill(s.x,s.y,0,s.c)
        end
    end

    --地面绘制
    rectfill(0,120,128,128,13)


    --圣诞树绘制
    sspr(0,80,128,16,0,106)

    --鹿和雪橇车
    palt(12,true)
    palt(0,false)
    sspr(70,64,26,11,74,112)
    palt()
   

    --礼物袋绘制
    if giftpackage.count>=7 and giftpackage.count<16 then
        spr(giftpackage.spr[2],giftpackage.x,giftpackage.y,2,2)
    elseif giftpackage.count>=16 and giftpackage.count<24 then
        spr(giftpackage.spr[3],giftpackage.x,giftpackage.y,2,2)
    elseif giftpackage.count>=24 then
        spr(giftpackage.spr[4],giftpackage.x,giftpackage.y,2,2)
        spr(40,giftpackage.x+16,giftpackage.y,2,2)
    else
        spr(giftpackage.spr[1],giftpackage.x,giftpackage.y,2,2)
    end


    --提示箭头(闪烁)
    if p.state==p.allstate.trans and check_close_giftpackage(p) then
        if time()%1<0.5 then
            spr(12,giftpackage.x+3,giftpackage.y-3)
        end
    end
    --玩家绘制
    drawplayer()
    --子弹绘制
    for b in all(bullets) do
        spr(b.spr,b.x,b.y)
    end

    --空中礼物绘制
    giftsdraw()
    --地面礼物绘制
    for g in all(gifts_ground) do
        spr(g.spr,g.x,g.y)
    end
    --搬运礼物绘制
    for i=1,#gifts_trans do
        local x=p.x+3
        local g=gifts_trans[i]
        if p.last_dire==1 then
            x=p.x-1
        else
            x=p.x+6
        end
        spr(g.spr,x,p.y+8-i*4)
    end

    --礼物ui
    spr(13,2,80)
    rect(5,77,7,45,13)
    line(6,76,6,76-giftpackage.count,ui_c)
    --倒计时ui
    spr(14,118,80)
    rect(121,77,123,45,13)
    line(122,76,122,76-min(30,flr(gametime)),time_c)
    --print(gametime,0,0,4)
    --print(giftpackage.count)
end


function draw_end()
    --胜利
    if giftpackage.count>=30 then
        cls(1)
        rle1(win1,2,0)
        rle1(win2,2,24)
        rle1(win3,2,48)
        rle1(win4,2,72)
        rle1(win5,2,96)
        rle1(win6,2,120)
    else
        rle1(lose1,2,0)
        rle1(lose2,2,24)
        rle1(lose3,2,48)
        rle1(lose4,2,72)
    end
    --提示重新开始
    print("press ⬆️ to restart",30,110,blink())

end