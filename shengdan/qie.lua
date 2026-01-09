function qiestate()
    local switchstate={
        hide=function()
            if #giftpackage.gifts_t>0 and (p.x>90 or p.x<30) then --地上有礼物
                qie.hidelook_t+=1
                if qie.hidelook_t>=40 then
                    qie.state=qie.allstate.look
                end
            else
                qie.hidelook_t=0
                qie.look_t=0
            end
        end,
        look=function()
            qie.y=114
            qie.hidelook_t=0
            if p.x>90 then
                qie.x=0
                qie.dire=5
                qie.look_t+=1
                if qie.look_t>=40 then
                    qie.state=qie.allstate.run
                    qie.x=-8
                end
            elseif p.x<30 then
                qie.x=125
                qie.dire=1
                qie.look_t+=1
                if qie.look_t>=40 then
                    qie.state=qie.allstate.run
                    
                end
            else
                qie.state=qie.allstate.hide
            end
        end,
        run=function()
            qie.look_t=0
            qie.y=119 --移动时默认位置
            if qie.dire==5 and not qie.isclose then
                qie.x+=qie.run_spd
            elseif qie.dire==1 and not qie.isclose then
                qie.x-=qie.run_spd
            end
            if abs(qie.x-p.x)<=30 and p.state!=p.allstate.trans then --如果距离靠近并且玩家不是在搬运状态
                qie.isclose=true
            end
            if qie.isclose then
                if qie.x<p.x then
                    qie.x-=qie.run_spd
                    qie.dire=1
                elseif qie.x>p.x then
                    qie.x+=qie.run_spd
                    qie.dire=5
                end
            end
            if qie.x<-10 or qie.x>138 then
                qie.state=qie.allstate.hide
                qie.isclose=false
            end
            if collide(qie.x,qie.y,qie.sspr.run[qie.frame][3],qie.sspr.run[qie.frame][4],giftpackage.x+6,giftpackage.y,3,16) then
                qie.state=qie.allstate.find
                qie.x=60
                qie.y=114
            end
            --如果直接碰到地面上的礼物，直接搬走
            --[[
            for g in all(gifts_ground) do
                if collide(qie.x,qie.y,qie.sspr.run[qie.frame][3],qie.sspr.run[qie.frame][4],g.x,g.y,5,4) then
                    del(gifts_ground,g)
                end
            end]]
        end,
        find=function()
            --卡时间
            qie.find_t+=1
            if qie.find_t>=60 then
                qie.find_t=0
                qie.y=115
                qie.transgifts=mid(1,4,(flr(rnd(#giftpackage.gifts_t)))) --随机获得礼物袋中的礼物，最多不超过4个
                qie.state=qie.allstate.trans
                --giftpackage.count-=qie.transgifts
            end
            --修改翻找的方向，便于精灵反转
            if qie.x>p.x then
                qie.dire=5
            elseif qie.x<p.x then
                qie.dire=1
            end
        end,
        trans=function()
            if qie.dire==5 then
                qie.x+=qie.trans_spd
            elseif qie.dire==1 then
                qie.x-=qie.trans_spd
            end

            --如果被玩家抓到会受到惊吓
            if collide(qie.x,qie.y,qie.sspr.trans[qie.frame][3],qie.sspr.trans[qie.frame][4],p.x,p.y,10,14) then
                qie.y=114 --修正高度
                qie.state=qie.allstate.fright
            end
            --如果超出范围，回到隐藏状态
            if qie.x< -10 or qie.x>138 then
                --把搬运的礼物给到 找到组，搬运归零
                qie.findgifts+=qie.transgifts
                qie.transgifts=0
                qie.trans_gifts_table={}
                qie.state=qie.allstate.hide
                qie.isclose=false
            end
        end,
        fright=function()
            qie.fright_t+=1
            if qie.fright_t>=30 then
                qie.fright_t=0
                qie.y=119
                qie.state=qie.allstate.escape
                qie.frame=0
            end
        end,
        escape=function()
            if qie.dire==5 then
                qie.x+=qie.escape_spd
            elseif qie.dire==1 then
                qie.x-=qie.escape_spd
            end
            if qie.x< -10 or qie.x>138 then
                qie.state=qie.allstate.hide
            end
        end,
    }
    switchstate[qie.state]()
end