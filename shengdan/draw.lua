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

function drawqie()
    local ssprx,sspry,ssprw,ssprh
    if qie.state==qie.allstate.hide then
        ssprx=qie.sspr.hide[1]
        sspry=qie.sspr.hide[2]
        ssprw=qie.sspr.hide[3]
        ssprh=qie.sspr.hide[4]
    elseif qie.state==qie.allstate.look then
        ssprx=qie.sspr.look[1]
        sspry=qie.sspr.look[2]
        ssprw=qie.sspr.look[3]
        ssprh=qie.sspr.look[4]
    elseif qie.state==qie.allstate.run then
        qie.frame=flr(time()*6)%#qie.sspr.run+1
        ssprx=qie.sspr.run[qie.frame][1]
        sspry=qie.sspr.run[qie.frame][2]
        ssprw=qie.sspr.run[qie.frame][3]
        ssprh=qie.sspr.run[qie.frame][4]
    elseif qie.state==qie.allstate.find then
        qie.frame=flr(time()*3)%#qie.sspr.find+1
        ssprx=qie.sspr.find[qie.frame][1]
        sspry=qie.sspr.find[qie.frame][2]
        ssprw=qie.sspr.find[qie.frame][3]
        ssprh=qie.sspr.find[qie.frame][4]
    elseif qie.state==qie.allstate.trans then
        qie.frame=flr(time()*3)%#qie.sspr.trans+1
        ssprx=qie.sspr.trans[qie.frame][1]
        sspry=qie.sspr.trans[qie.frame][2]
        ssprw=qie.sspr.trans[qie.frame][3]
        ssprh=qie.sspr.trans[qie.frame][4]
    elseif qie.state==qie.allstate.fright then
        qie.frame=flr(time()*3)%#qie.sspr.fright+1
        ssprx=qie.sspr.fright[qie.frame][1]
        sspry=qie.sspr.fright[qie.frame][2]
        ssprw=qie.sspr.fright[qie.frame][3]
        ssprh=qie.sspr.fright[qie.frame][4]
    elseif qie.state==qie.allstate.escape then
        qie.frame=flr(time()*6)%#qie.sspr.escape+1
        ssprx=qie.sspr.escape[qie.frame][1]
        sspry=qie.sspr.escape[qie.frame][2]
        ssprw=qie.sspr.escape[qie.frame][3]
        ssprh=qie.sspr.escape[qie.frame][4]
    end
    palt(12,true)
    palt(0,false)
    sspr(ssprx,sspry,ssprw,ssprh,qie.x,qie.y,ssprw,ssprh,flip_qie(qie.dire))
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
    if #giftpackage.gifts_t>=7 and #giftpackage.gifts_t<16 then
        spr(giftpackage.spr[2],giftpackage.x,giftpackage.y,2,2)
    elseif #giftpackage.gifts_t>=16 and #giftpackage.gifts_t<24 then
        spr(giftpackage.spr[3],giftpackage.x,giftpackage.y,2,2)
    elseif #giftpackage.gifts_t>=24 then
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
    --企鹅绘制
    drawqie()
    --测试礼物袋和企鹅的碰撞
    --rect(giftpackage.x+6,giftpackage.y,giftpackage.x+9,giftpackage.y+16,13)
    --if qie.state==qie.allstate.run then
        --rect(qie.x, qie.y, qie.x+qie.sspr.run[qie.frame][3], qie.y+qie.sspr.run[qie.frame][4],13)
    --end

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
   
    if #gifts_trans>0 then
        for g in all(gifts_trans) do
            spr(g.spr,g.x,g.y)
        end
    end
    if #qie.trans_gifts_table>0 then
        for g in all(qie.trans_gifts_table) do
            spr(g.spr,g.x,g.y)
        end
    end
    

    --礼物ui
    spr(13,2,80)
    rect(5,77,7,45,13)
    line(6,76,6,76-#giftpackage.gifts_t,ui_c)
    --倒计时ui
    spr(14,118,80)
    rect(121,77,123,45,13)
    line(122,76,122,76-min(30,flr(gametime)),time_c)
end


function draw_end()
    --胜利
    if #giftpackage.gifts_t>=30 then 
        cls(1)
        rle1(win1,2,0)
        rle1(win2,2,24)
        rle1(win3,2,48)
        rle1(win4,2,72)
        rle1(win5,2,96)
        rle1(win6,2,120)
    elseif qie.findgifts>=5 then
        cls(0)
        rle1(lose_qiewin1,2,0)
        rle1(lose_qiewin2,2,24)
        rle1(lose_qiewin3,2,48)
        rle1(lose_qiewin4,2,72)
        rle1(lose_qiewin5,2,96)
    else
        rle1(lose1,2,0)
        rle1(lose2,2,24)
        rle1(lose3,2,48)
        rle1(lose4,2,72)
    end
    --提示重新开始
    print("press ⬆️ to restart",27,118,blink())
end