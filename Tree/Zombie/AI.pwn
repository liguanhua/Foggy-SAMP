new PlayerText:GetOutKeyCircleTextDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:GetOutKeyTextDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new GetOutKeyTextAlpha[MAX_PLAYERS]= {NONE, ...};
new Timer:GetOutKeyTime[MAX_PLAYERS]= {NONE, ...};
new GetOutKeyTimeCount[MAX_PLAYERS]= {0, ...};
new bool:GetOutKeyShow[MAX_PLAYERS]= {false, ...};
/************************************************************************/
FUNC::Zombie_OnGameModeInit()
{

	return 1;
}
FUNC::Zombie_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_CROUCH))
    {
        if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
        {
			new index=GetNearstZombie(playerid);
			if(index!=NONE)
			{
			    if(Iter_Count(ZombieBag[index])>0)ShowPlayerZombieBagTextDraw(playerid,index);
			}
        }
	}
	return 1;
}
FUNC::GetNearstZombie(playerid)
{
    if(Iter_Count(Zombies)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:Zombies)
	{
		if(IsPlayerInDynamicArea(playerid,Zombies[i][_zPAreaID]))
		{
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x1, y1, z1);
			new Float:Ax1, Float:Ay1, Float:Az1;
			GetActorPos(Zombies[i][_zActorID],Ax1,Ay1,Az1);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(Ax1,x1)),2)+floatpower(floatabs(floatsub(Ay1,y1)),2)+floatpower(floatabs(floatsub(Az1,z1)),2));
			if(dis2<dis&&dis2 != -1.00)
			{
				dis=dis2;
				index=i;
			}
		}
	}
	return index;
}
FUNC::OnPlayerClickZBagItemBotton(playerid,zombieid,index)
{
	new BagID=PlayerZombieBagPrevieBox[playerid][index];
	new ItemID=ZombieBag[zombieid][BagID][_ItemID];
	formatex32("物品:%s",Item[ItemID][_Name]);
	SCM(playerid,-1,string32);
	formatex64("%i,%s,%i,%i",BagID,ZombieBag[zombieid][BagID][_ZombieBagKey],ItemID,zombieid);
	if(VerifyZombieBagPVarData(playerid,string64)==true)
	{
		/*SetPVarString(playerid,"_ZombieBag_Click_Info",string64);
		formatex64("%s",Item[ItemID][_Name]);
		SPD(playerid,_SPD_ZOMBIEBAG_INFO,DIALOG_STYLE_LIST,string64,PLAYER_BAG_USE_PANEL,"选择","返回");
*/
        SetPVarString(playerid,"_ZombieBag_Click_Info",string64);
        ShowAdditionInfo(playerid,ItemID,_SPD_ZOMBIEBAG_INFO,"捡取","返回");
	}
	return 1;
}
FUNC::bool:VerifyZombieBagPVarData(playerid,VarString[])
{
	new BagID,BagKey[37],ItemID,Zombieid;
    if(sscanf(VarString, "p<,>is[37]ii",BagID,BagKey,ItemID,Zombieid))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(ZombieBag[Zombieid],BagID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该物品已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(ZombieBag[Zombieid][BagID][_ZombieBagKey],BagKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(!isequal(ZombieBag[Zombieid][BagID][_ItemKey],Item[ItemID][_Key],false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#3]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(ZombieBag[Zombieid][BagID][_Amounts]<=0)
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#4]","该物品已失效,请重新选择","了解","");
	    return false;
	}
	return true;
}
/************************************************************************/
FUNC::GetZombieSpawnPos(&Float:Gpos_X,&Float:Gpos_Y,&Float:Gpos_Z)//计算获取僵尸出生POS
{
	GetRandomPointInRectangle(-3000,-3000,3000,3000,Gpos_X,Gpos_Y);
	CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
    while(GetPointCollisionFlags(Gpos_X,Gpos_Y,Gpos_Z)==17||!IsPointInGround(Gpos_X,Gpos_Y,Gpos_Z,false,10.0)||IsZombieSpawnPosInRange(Gpos_X,Gpos_Y,150.0)/*||IsPosInFactionArea(Gpos_X,Gpos_Y,Gpos_Z)*/)
    {
 		GetRandomPointInRectangle(-3000,-3000,3000,3000,Gpos_X,Gpos_Y);
		CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
 	}
	return 1;
}
FUNC::IsPosInSafeArea(Float:xx,Float:yy,Float:zz)//POS是否在安全区
{
	/*forex(i,sizeof(SafeZone))*/
	loop(i,5,sizeof(SafeZone))if(IsPointInDynamicArea(SafeZone[i][_sAreaID], xx, yy, zz))return 1;
	return 0;
}
FUNC::IsPlayerInSafeArea(playerid)//玩家是否在安全区
{
	loop(i,5,sizeof(SafeZone))if(IsPlayerInDynamicArea(playerid,SafeZone[i][_sAreaID]))return 1;
	return 0;
}
FUNC::IsZombieSpawnPosInRange(Float:xx,Float:yy,Float:range)//出生点某范围内是否有其他僵尸出生点
{
	if(Iter_Count(Zombies)>0)
	{
	    new Float:ZombiePos[3];
	    foreach(new i:Zombies)
	    {
	    	FCNPC_GetPosition(Zombies[i][_zNpcid],ZombiePos[0],ZombiePos[1],ZombiePos[2]);
	        new Float:distancez=GetDistanceBetweenPoints2D(Zombies[i][_zSpawn][0],Zombies[i][_zSpawn][1],xx,yy);
	        if(distancez<range)return 1;
	    }
    }
    else return 0;
	return 0;
}
FUNC::CreateZombie()//创建僵尸
{
    forex(i,MAX_ZOMBIES)
    {
    	formatex32("Zombie%i",1+i);
    	Zombies[i][_zNpcid]=FCNPC_Create(string32);
    	UUID(Zombies[i][_zKey], UUID_LEN);
    	SetPlayerColor(Zombies[i][_zNpcid],255);
    	new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
    	GetZombieSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);
    	new SkinID=Randoms(1, 15);
    	Zombies[i][_zSkin]=20000+SkinID;
		FCNPC_Spawn(Zombies[i][_zNpcid],Zombies[i][_zSkin], Gpos_X,Gpos_Y,Gpos_Z+0.5);
		SetPlayerSkin(Zombies[i][_zNpcid],Zombies[i][_zSkin]);
 		FCNPC_SetPosition(Zombies[i][_zNpcid],Gpos_X,Gpos_Y,Gpos_Z+0.5);
 		Zombies[i][_zHp]=200.0;
 		Zombies[i][_zMHp]=200.0;
		FCNPC_SetHealth(Zombies[i][_zNpcid],Zombies[i][_zHp]);
		FCNPC_SetArmour(Zombies[i][_zNpcid],0);
		FCNPC_SetVirtualWorld(Zombies[i][_zNpcid],0);
		FCNPC_SetInterior(Zombies[i][_zNpcid],0);
		FCNPC_SetAngle(Zombies[i][_zNpcid], 88);
		//FCNPC_SetFightingStyle(Zombies[i][_zNpcid], FightingStyle[random(sizeof(FightingStyle))]);
		
		Zombies[i][_zLookrange]=80.0/*RandomFloat(70.0,100.0)*/;
		Zombies[i][_zSpawn][0]=Gpos_X;
		Zombies[i][_zSpawn][1]=Gpos_Y;
		Zombies[i][_zSpawn][2]=Gpos_Z;
		Zombies[i][_zState]=ZOMBIE_STATE_NONE;
		Zombies[i][_zAniming]=false;
		Zombies[i][_zAreaID]=CreateDynamicSphere(0.0,0.0,0.0,Zombies[i][_zLookrange],0);
		Zombies[i][_zPAreaID]=CreateDynamicSphere(0.0,0.0,0.0,2.0,0);
		Zombies[i][_zHpText]=CreateProgressBar3D(0.0,0.0,0.1,BAR_3D_LAYOUT_THIN,0xC0C0C0C8,0x400040C8,Zombies[i][_zHp],Zombies[i][_zMHp],20.0,Zombies[i][_zNpcid],.testlos = 1);
   		AttachDynamicAreaToPlayer(Zombies[i][_zAreaID],Zombies[i][_zNpcid]);
   		AttachDynamicAreaToPlayer(Zombies[i][_zPAreaID],Zombies[i][_zNpcid]);

        Zombies[i][_zActorID]=INVALID_STREAMER_ID;
        Zombies[i][Timer:_zActorTimer]=NONE;
        Zombies[i][_zTarget]=NONE;
        Zombies[i][_zWalktick]=0;
        Zombies[i][_zAlertPlayerid]=NONE;
        Zombies[i][_zAngry]=false;
        Zombies[i][_zAlertDelay]=GetTickCount();
        Zombies[i][_zRunAway]=false;
        Zombies[i][_zRunAwayDelay]=GetTickCount();
		Zombies[i][_zExecute]=true;
        Zombies[i][_zAttackVeh]=NONE;
        Zombies[i][_zAttackVehDalay]=GetTickCount();
        Iter_Add(Zombies,i);
        Iter_Clear(ZombieBag[i]);
	}
    return 1;
}
/*FUNC::IsPosFacingPos(Float:pX, Float:pY, Float:pZ, Float:pAng,Float:X, Float:Y, Float:Z)//POS位置玩家是否面对另外POS位置玩家
{
    new Float:angleBetweenPoints = atan2(pX - X, pY - Y);
	new Float:angleDifference = angleBetweenPoints - pAng;
	if(angleDifference > 180.0)angleDifference -= 360.0;
	if(angleDifference < -180.0)angleDifference += 360.0;
    angleDifference = floatabs(angleDifference);
    printf("angleDifference:%f",angleDifference);
	if(angleDifference <= 200.0)return 1;
	return 1;
}*/
FUNC::IsPosFacingPos(Float:pX, Float:pY, Float:pZ, Float:pAng,Float:X, Float:Y, Float:Z)//POS位置玩家是否面对另外POS位置玩家
{
	new Float:ang,Float:lastang;
	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	if(X > pX)ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);
	lastang=floatsub(ang,pAng);
	/*if(lastang <= 40)return 1;
	if(lastang >= 300)return 1;*/
	if(lastang <= 50)return 1;
	if(lastang >= 290)return 1;
	return 0;
}
FUNC::IsNPCFacingPlayer(npcid,playerid)//NPC是否面对玩家
{
	if(!ValidZombieTargetPlayer(playerid)) return 0;
	new Float:pX, Float:pY, Float:pZ, Float:pAng,
		Float:X, Float:Y, Float:Z, Float:ang,Float:lastang;
	GetPlayerPos(playerid, X, Y, Z);
	FCNPC_GetPosition(npcid, pX, pY, pZ);
	pAng=FCNPC_GetAngle(npcid);
	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	if(X > pX)ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);
	lastang=floatsub(ang,pAng);
	if(lastang <= 40)return 1;
	if(lastang >= 300)return 1;
	return 0;
}
FUNC::IsPlayerHidden(playerid)//玩家是否隐匿
{
	new index = GetPlayerAnimationIndex(playerid);
	if(index == 1274 || index == 1159)return 1;
	return 0;
}
FUNC::IsPlayerTwitch(playerid)//玩家是否抽搐
{
	new index = GetPlayerAnimationIndex(playerid);
	if(index == 1189 || index == 1231|| index == 1232|| index == 1233|| index == 1133|| index == 386)return 1;
	return 0;
}
FUNC::ValidZombieTargetPlayer(playerid)//是否是僵尸可用目标
{
	if(playerid==INVALID_PLAYER_ID)return 0;
    if(!IsPlayerConnected(playerid))return 0;
    if(IsPlayerNPC(playerid))return 0;
    if(playerid>=MAX_PLAYERS||playerid<0)return 0;
    if(Account[playerid][_Login]==false)return 0;
	if(Account[playerid][_Spawn]==false)return 0;
	return 1;
}
FUNC::GetZombieNearstPlayer(index)//获取某僵尸符合条件最近的玩家
{
	new Float:ZombieX,Float:ZombieY,Float:ZombieZ,Float:ZombieA,Float:PlayerX,Float:PlayerY,Float:PlayerZ,Float:distance;
    FCNPC_GetPosition(Zombies[index][_zNpcid],ZombieX,ZombieY,ZombieZ);
    ZombieA=FCNPC_GetAngle(Zombies[index][_zNpcid]);
    new playerlist[MAX_PLAYERS],playercount=0;
    forex(i,MAX_PLAYERS)playerlist[i]=NONE;
	foreach(new i:Player)
	{
	    if(ValidZombieTargetPlayer(i))
	    {
		    if(IsPlayerInDynamicArea(i,Zombies[index][_zAreaID])/*&&!IsPlayerInFactionArea(i)*/&&GetPlayerCollisionFlags(i)!=17)
		    {
		    	if(GetPlayerZombieTargets(i,index)<5)
		    	{
		    	    PlayerX=PlayerPos[i][0], PlayerY=PlayerPos[i][1], PlayerZ=PlayerPos[i][2];
			        distance=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX, PlayerY, PlayerZ);//激励计算
	                if(IsPosFacingPos(ZombieX,ZombieY,ZombieZ,ZombieA,PlayerX,PlayerY,PlayerZ))//面向计算
	                {
						if(!IsBetweenPointToPointIsWall(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ))//是否隔墙
	                    {
							playerlist[playercount]=i;
	                        playercount++;
						}
						else
						{
						    if(distance<5.0)
						    {
								playerlist[playercount]=i;
		                        playercount++;
						    }
						}
					}
	    			else
	       			{
					    if(distance<10.0)
					    {
					        if(!IsPlayerHidden(i))
					        {
								playerlist[playercount]=i;
		                        playercount++;
	                        }
					    }
	          		}
	          	}
			}
		}
	}
	new _pid=NONE;
	if(playercount>0)
	{
		new Float:_dis=99999.99;
		forex(i,playercount)
		{
		    if(ValidZombieTargetPlayer(playerlist[i]))
		    {
                PlayerX=PlayerPos[playerlist[i]][0], PlayerY=PlayerPos[playerlist[i]][1], PlayerZ=PlayerPos[playerlist[i]][2];
				distance=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX, PlayerY, PlayerZ);
				if(distance<_dis&&distance != -1.00)
				{
					_dis=distance;
					_pid=playerlist[i];
				}
		    }
		}
	}
	return _pid;
}
FUNC::GetZombiePosNearstPlayerPos(index,Float:ZombieX,Float:ZombieY,Float:ZombieZ,Float:ZombieA)//获取某僵尸POS符合条件最近的玩家POS
{
	new Float:PlayerX,Float:PlayerY,Float:PlayerZ,Float:distance;
    new playerlist[MAX_PLAYERS],playercount=0;
    forex(i,MAX_PLAYERS)playerlist[i]=NONE;
	foreach(new i:Player)
	{
	    if(ValidZombieTargetPlayer(i))
	    {
		    if(IsPlayerInDynamicArea(i,Zombies[index][_zAreaID])/*&&!IsPlayerInFactionArea(i)*/&&GetPlayerCollisionFlags(i)!=17)
		    {
		    	if(GetPlayerZombieTargets(i,index)<5)
		    	{
			        PlayerX=PlayerPos[i][0], PlayerY=PlayerPos[i][1], PlayerZ=PlayerPos[i][2];
			        distance=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX, PlayerY, PlayerZ);

					new bool:InVehicle=false;
					if(IsPlayerInAnyVehicle(i))
					{
						new vehicleid=GetPlayerVehicleID(i);
						new engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
						if(engine==1)InVehicle=true;
					}
					if(distance<=Zombies[index][_zLookrange])
                    {
                        if(InVehicle==true)
                        {
							playerlist[playercount]=i;
	                        playercount++;
                        }
                        else
                        {
							if(IsPosFacingPos(ZombieX,ZombieY,ZombieZ,ZombieA,PlayerX,PlayerY,PlayerZ))
			                {
								if(!IsBetweenPointToPointIsWall(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ))
			                    {
									playerlist[playercount]=i;
			                        playercount++;
								}
								else
								{
								    if(distance<8.0)
								    {
										playerlist[playercount]=i;
				                        playercount++;
								    }
								}
							}
			    			else
			       			{
							    if(distance<10.0)
							    {
							        if(!IsPlayerHidden(i))
							        {
										playerlist[playercount]=i;
				                        playercount++;
			                        }
							    }
			          		}
						}
	          		}
	          	}
			}
		}
	}
	new _pid=NONE;
	if(playercount>0)
	{
		new Float:_dis=99999.99;
		forex(i,playercount)
		{
		    if(ValidZombieTargetPlayer(playerlist[i]))
		    {
		        PlayerX=PlayerPos[playerlist[i]][0], PlayerY=PlayerPos[playerlist[i]][1], PlayerZ=PlayerPos[playerlist[i]][2];
				distance=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX, PlayerY, PlayerZ);
				if(distance<_dis&&distance != -1.00)
				{
					_dis=distance;
					_pid=playerlist[i];
				}
		    }
		}
	}
	return _pid;
}
FUNC::GetPlayerZombieTargets(playerid,zombieid)//获取锁定某玩家的僵尸数量
{
    new Amount=0;
    foreach(new i:Zombies)
    {
        if(Zombies[i][_zExecute]==false)continue;
        if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)continue;
        if(Zombies[i][_zTarget]!=NONE)
        {
        	if(zombieid==i)if(Zombies[i][_zTarget]==playerid)return 1;
            if(Zombies[i][_zTarget]==playerid)Amount++;
        }
    }
    return Amount;
}
FUNC::GetNpcZombieIndex(npcid)
{
	foreach(new i:Zombies)
	{
	    if(Zombies[i][_zNpcid]==npcid)
	    {
	        return i;
	    }
	}
	return NONE;
}
public FCNPC_OnDeath(npcid, killerid, reason)
{
	new ZombieID=GetNpcZombieIndex(npcid);
    if(ZombieID!=NONE)
    {
    	if(Zombies[ZombieID][_zExecute]==true)
        {
			if(Zombies[ZombieID][_zState]!=ZOMBIE_STATE_DEATH)
			{
			    new Float:ZombieX,Float:ZombieY,Float:ZombieZ,Float:ZombieA;
      			FCNPC_GetPosition(Zombies[ZombieID][_zNpcid],ZombieX,ZombieY,ZombieZ);
       			ZombieA=FCNPC_GetAngle(Zombies[ZombieID][_zNpcid]);
        		ChangeZombieState(ZombieID,ZOMBIE_STATE_DEATH,NONE,ZombieX,ZombieY,ZombieZ,ZombieA,0.0,0.0,0.0,NONE);
			}
		}
	}
	return 1;
}
FUNC::Zombie_OnReachDestination(npcid)
{
 /*   new ZombieID=GetNpcZombieIndex(npcid);
    if(ZombieID!=NONE)
    {
        if(Zombies[ZombieID][_zExecute]==true)
        {
			if(Zombies[ZombieID][_zState]==ZOMBIE_STATE_NORMAL)
			{
				FCNPC_ClearAnimations(npcid);
				FCNPC_ApplyAnimation(npcid,"PED","idlestance_old",4.1,1,1,1,1,1);
			}
		}
    }*/
	return 1;
}
FUNC::Zombie_OnSpawn(npcid)
{
	new ZombieID=GetNpcZombieIndex(npcid);
    if(ZombieID!=NONE)
    {
        PreloadNpcAnims(npcid);
    }
    return 1;
}
FUNC::Zombie_OnUpdate(npcid)
{
    if(SeverState[_ServerRun]==false)return 1;
	new ZombieID=GetNpcZombieIndex(npcid);
    if(ZombieID!=NONE)
    {
   		if(Zombies[ZombieID][_zExecute]==true)
       	{
			if(Zombies[ZombieID][_zState]!=ZOMBIE_STATE_DEATH)
			{
	       	    if(Zombies[ZombieID][_zAngry]==false)
	       	    {
					if(GetTickCount()-Zombies[ZombieID][_zAlertDelay]>=10000)
					{
					    Zombies[ZombieID][_zAlertPlayerid]=NONE;
					    Zombies[ZombieID][_zAlertDelay]=GetTickCount();
					}
				}
				else
				{
					if(GetTickCount()-Zombies[ZombieID][_zAlertDelay]>=20000)
					{
						Zombies[ZombieID][_zAlertPlayerid]=NONE;
					    Zombies[ZombieID][_zAlertDelay]=GetTickCount();
					    Zombies[ZombieID][_zAngry]=false;
					}
				}
				if(Zombies[ZombieID][_zRunAway]==true)
				{
				    if(GetTickCount()-Zombies[ZombieID][_zRunAwayDelay]>=10000)
				    {
						Zombies[ZombieID][_zRunAway]=false;
					    Zombies[ZombieID][_zAlertDelay]=GetTickCount();
				    }
				}
			}
       	}
    }
	return 1;
}

FUNC::Float:GetZombieMoveSpeed(ZombieID)
{
	new Float:StartSpeed=0.71;
	if(Zombies[ZombieID][_zAlertPlayerid]!=NONE)
	{
		if(Zombies[ZombieID][_zAngry]==true)StartSpeed=floatmul(StartSpeed,1.4);
		else StartSpeed=floatmul(StartSpeed,1.2);
	}
	return StartSpeed;
}
public FCNPC_OnGiveDamage(npcid, damagedid, Float:amount, weaponid, bodypart)
{
    printf("FCNPC_OnGiveDamage %i,%i,%f,%i,%i",npcid, damagedid, Float:amount, weaponid, bodypart);
	if(ValidZombieTargetPlayer(damagedid))
 	{
		new ZombieID=GetNpcZombieIndex(npcid);
 		if(ZombieID!=NONE)
  		{
			if(Zombies[ZombieID][_zAngry])DamagePlayer(damagedid,floatmul(RandomFloat(4.0,8.0),1.4),npcid,weaponid,bodypart);
  			else DamagePlayer(damagedid,RandomFloat(4.0,8.0),npcid,weaponid,bodypart);
  		}
	}
	return 1;
}
FUNC::Zombie_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	printf("Zombie_OnTakeDamage %i,%i,%f,%i,%i",npcid, issuerid, amount, weaponid, bodypart);
	new ZombieID=GetNpcZombieIndex(npcid);
    if(ZombieID!=NONE)
    {
		if(ValidZombieTargetPlayer(issuerid))
	 	{
     		if(Zombies[ZombieID][_zExecute]==true)
        	{
        	    if(Zombies[ZombieID][_zState]!=ZOMBIE_STATE_DEATH)
				{
				    FCNPC_SetHealth(npcid,Zombies[ZombieID][_zHp]);
		        	if(Zombies[ZombieID][_zState]!=ZOMBIE_STATE_NONE&&Zombies[ZombieID][_zState]!=ZOMBIE_STATE_RUNAWAY)
		        	{
			        	Zombies[ZombieID][_zAlertPlayerid]=issuerid;
				        Zombies[ZombieID][_zAlertDelay]=GetTickCount();
				        Zombies[ZombieID][_zAngry]=true;
			        }
					new Float:PlayerX,Float:PlayerY,Float:PlayerZ,Float:ZombieX,Float:ZombieY,Float:ZombieZ;
	    			FCNPC_GetPosition(npcid,ZombieX,ZombieY,ZombieZ);
	    			PlayerX=PlayerPos[issuerid][0], PlayerY=PlayerPos[issuerid][1], PlayerZ=PlayerPos[issuerid][2];
			        new Float:distance=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ);
			        if(weaponid>=0&&weaponid<sizeof(s_WeaponRange)&&IsMeleeWeapon(weaponid))
					{
		    			if(distance>s_WeaponRange[weaponid])return 1;
					}
				    if(weaponid>=0&&weaponid<sizeof(s_WeaponDamage))
					{
					    new Float:percentage=floatdiv(distance,s_WeaponRange[weaponid]);
					    if(percentage>1.0)percentage=1.0;
					    percentage=floatsub(1.0,percentage);
					    formatex32("%f(%f)",percentage,floatmul(s_WeaponDamage[weaponid],percentage));
					    Debug(issuerid,string32);
					    Zombies[ZombieID][_zHp]-=floatdiv(floatmul(s_WeaponDamage[weaponid],percentage),2.0);
    				}
					FCNPC_SetHealth(npcid,Zombies[ZombieID][_zHp]);
	        	    SetProgressBar3DValue(Zombies[ZombieID][_zHpText],Zombies[ZombieID][_zHp]);
		        }
	        }
	    }
        else FCNPC_SetHealth(npcid,Zombies[ZombieID][_zHp]);
    }
	return 1;
}
stock FCNPC_Punch(npcid, Float:x, Float:y, PunchResetDelay = 200)
{
	FCNPC_SetAngleToPos(npcid,x,y);
    FCNPC_SetKeys(npcid,0,0,0x80+4);
    SetTimerEx("ResetNPCKeys", PunchResetDelay, false, "i", npcid);
    return 1;
}
FUNC::ResetNPCKeys(npcid)
{
	FCNPC_SetKeys(npcid,0,0,0);
    return 1;
}
/*stock Float:Zinc_absoluteangle(Float:angle)
{
	while(angle < 0.0)angle += 360.0;
	while(angle > 360.0)angle -= 360.0;
	return angle;
}
stock Float:Zinc_GetAngleToPoint(Float:fPointX, Float:fPointY, Float:fDestX, Float:fDestY)return Zinc_absoluteangle(-(90-(atan2((fDestY - fPointY), (fDestX - fPointX)))));*/
stock ChangeZombieState(zombie,type,ZTargetID,Float:ZombieX,Float:ZombieY,Float:ZombieZ,Float:ZombieA,Float:PlayerX,Float:PlayerY,Float:PlayerZ,vehicleid,Float:distance=0.0)
{
	new i=zombie;
	switch(type)
	{
        case ZOMBIE_STATE_SLEEP:
        {
	        Zombies[i][_zState]=ZOMBIE_STATE_SLEEP;
	        if(FCNPC_IsAttacking(Zombies[i][_zNpcid]))FCNPC_StopAttack(Zombies[i][_zNpcid]);
	        FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
//	        FCNPC_ApplyAnimation(Zombies[i][_zNpcid], "FINALE", "FIN_Land_Die", 4.1, 0, 1, 1, 1,999999);
	        FCNPC_Stop(Zombies[i][_zNpcid]);
			FCNPC_GetPosition(Zombies[i][_zNpcid],Zombies[i][_zSpawn][0],Zombies[i][_zSpawn][1],Zombies[i][_zSpawn][2]);
	        FCNPC_SetVirtualWorld(Zombies[i][_zNpcid],ZOMBIE_DEATH_WORLD);
        }
	    case ZOMBIE_STATE_NORMAL:
	    {
			if(FCNPC_IsAttacking(Zombies[i][_zNpcid]))FCNPC_StopAttack(Zombies[i][_zNpcid]);
            if(Zombies[i][_zAniming]==true)
			{
				FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
				Zombies[i][_zAniming]=false;
			}
			Zombies[i][_zRunAway]=false;
			Zombies[i][_zTarget]=NONE;
			Zombies[i][_zState]=ZOMBIE_STATE_NORMAL;
			if(GetTickCount()>=Zombies[i][_zWalktick])
			{
			    new Float:GoPos[3],GRate=0,GreachTime=0;
  			    GetRandomPointInCircle(ZombieX,ZombieY,RandomFloat(15.0,30.0),GoPos[0],GoPos[1]);
		    	CA_FindZ_For2DCoord(GoPos[0],GoPos[1],GoPos[2]);
			    while(GetPointCollisionFlags(GoPos[0],GoPos[1],GoPos[2])==17||!IsPointInGround(GoPos[0],GoPos[1],GoPos[2],false,1.5)||IsPosInFactionArea(GoPos[0],GoPos[1],GoPos[2])||IsBetweenPointToPointIsWall(ZombieX,ZombieY,ZombieZ,GoPos[0],GoPos[1],GoPos[2]))
			    {
					GetRandomPointInCircle(ZombieX,ZombieY,RandomFloat(15.0,30.0),GoPos[0],GoPos[1]);
					CA_FindZ_For2DCoord(GoPos[0],GoPos[1],GoPos[2]);
					GRate++;
					if(GRate>10)break;
			 	}
            	GreachTime=GetMoveTime(ZombieX,ZombieY,ZombieZ,GoPos[0],GoPos[1],GoPos[2],FCNPC_MOVE_SPEED_WALK,GreachTime);
				FCNPC_GoTo(Zombies[i][_zNpcid],GoPos[0],GoPos[1],GoPos[2]+0.5,FCNPC_MOVE_TYPE_WALK,FCNPC_MOVE_SPEED_WALK,FCNPC_MOVE_MODE_COLANDREAS);
	        	Zombies[i][_zWalktick]=GetTickCount()+GreachTime/6;
			}
	    }
	    case ZOMBIE_STATE_FOLLOW:
	    {
	        if(Zombies[i][_zState]==ZOMBIE_STATE_EAT||Zombies[i][_zState]==ZOMBIE_STATE_NORMAL)FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
	        if(FCNPC_IsAttacking(Zombies[i][_zNpcid]))FCNPC_StopAttack(Zombies[i][_zNpcid]);
			Zombies[i][_zState]=ZOMBIE_STATE_FOLLOW;
			Zombies[i][_zTarget]=ZTargetID;
			Zombies[i][_zWalktick]=0;
			Zombies[i][_zAniming]=true;
			FCNPC_SetAngleToPlayer(Zombies[i][_zNpcid],ZTargetID);
			if(distance>3.5)GetAngleDistancePoint(RandFloat(360.0),4.0,PlayerX,PlayerY);
			else GetAngleDistancePoint(RandFloat(360.0),1.5,PlayerX,PlayerY);
			if(GetPlayerCollisionFlags(ZTargetID)==65&&CA_IsPlayerOnSurface(ZTargetID,3.0)==1)
			{
				FCNPC_GoTo(Zombies[i][_zNpcid],PlayerX,PlayerY,PlayerZ+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_NONE);
				//FCNPC_GoTo(Zombies[i][_zNpcid],PlayerX+RandomFloat(1.0,2.0),PlayerY+RandomFloat(1.0,2.0),PlayerZ+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_NONE);
			}
			else
			{
				FCNPC_GoTo(Zombies[i][_zNpcid],PlayerX,PlayerY,PlayerZ+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_COLANDREAS);
				//FCNPC_GoTo(Zombies[i][_zNpcid],PlayerX+RandomFloat(1.0,2.0),PlayerY+RandomFloat(1.0,2.0),PlayerZ+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_COLANDREAS);
			}
			/*formatex32("ZOMBIE_STATE_FOLLOW - %i",ZTargetID);
			Debug(ZTargetID,string32);*/
	    }
	    case ZOMBIE_STATE_ATTACK:
	    {
	        if(Zombies[i][_zState]==ZOMBIE_STATE_EAT||Zombies[i][_zState]==ZOMBIE_STATE_NORMAL)FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
			Zombies[i][_zState]=ZOMBIE_STATE_ATTACK;
			Zombies[i][_zWalktick]=0;
			//FCNPC_Stop(Zombies[i][_zNpcid]);
			if(vehicleid!=NONE)
			{
				SetNpcToFacePlayer(Zombies[i][_zNpcid],ZTargetID);
				FCNPC_MeleeAttack(Zombies[i][_zNpcid],-1,true);
				//Debug(ZTargetID,"ZOMBIE_STATE_ATTACK-MeleeAttack-vehicle");
				if(Zombies[i][_zAttackVeh]!=vehicleid)
				{
					new Float:vhealth;
					GetVehicleHealth(vehicleid, vhealth);
					vhealth -= RandomFloat(5.0,10.0);
					if (vhealth <= 249.0)
					{
						if (s_VehicleRespawnTimer[vehicleid] == -1)
						{
							vhealth = 249.0;
							s_VehicleRespawnTimer[vehicleid] = SetTimerEx("WC_KillVehicle", 6000, false, "ii", vehicleid, ZTargetID);
						}
					}
					SetVehicleHealth(vehicleid, vhealth);
					Zombies[i][_zAttackVeh]=vehicleid;
					Zombies[i][_zAttackVehDalay]=GetTickCount();
				}
				else
				{
					if(GetTickCount()-Zombies[i][_zAttackVehDalay]>=1000)
					{
						new Float:vhealth;
						GetVehicleHealth(vehicleid, vhealth);
						vhealth -= RandomFloat(5.0,10.0);
						if (vhealth <= 249.0)
						{
							if (s_VehicleRespawnTimer[vehicleid] == -1)
							{
								vhealth = 249.0;
								s_VehicleRespawnTimer[vehicleid] = SetTimerEx("WC_KillVehicle", 6000, false, "ii", vehicleid, ZTargetID);
							}
						}
						SetVehicleHealth(vehicleid, vhealth);
						Zombies[i][_zAttackVeh]=vehicleid;
						Zombies[i][_zAttackVehDalay]=GetTickCount();
					}
				}
			}
			else
			{
				if(GetPlayerCollisionFlags(ZTargetID)==65&&CA_IsPlayerOnSurface(ZTargetID,3.0)==1)
				{
					FCNPC_GoTo(Zombies[i][_zNpcid],PlayerX+RandFloat(0.6),PlayerY+RandFloat(0.6),PlayerZ+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_NONE,.radius = 0.0,.set_angle = false);
				}
				else
				{
					FCNPC_GoTo(Zombies[i][_zNpcid],PlayerX+RandFloat(0.6),PlayerY+RandFloat(0.6),PlayerZ+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_COLANDREAS,.radius = 0.0,.set_angle = false);
				}
				if(IsPlayerCrouching(ZTargetID))
				{
					FCNPC_SetKeys(Zombies[i][_zNpcid],2,0,0);
					FCNPC_Punch(Zombies[i][_zNpcid],PlayerX,PlayerY);
					//Debug(ZTargetID,"ZOMBIE_STATE_ATTACK-Punch-onfoot");
				}
				else
				{
					SetNpcToFacePlayer(Zombies[i][_zNpcid],ZTargetID);
					FCNPC_MeleeAttack(Zombies[i][_zNpcid],-1,true);
					//Debug(ZTargetID,"ZOMBIE_STATE_ATTACK-MeleeAttack-onfoot");
				}
				if(random(15)==1)
				{
		            new Float:Zdistance3D=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ);
		   			new Float:Zdistance2D=GetDistanceBetweenPoints2D(ZombieX,ZombieY,PlayerX,PlayerY);
		   			if((Zdistance3D<0.7||Zdistance2D<0.7)&&PlayerZombies[ZTargetID][_PzEscape]<1)
		   			{
		   			    ChangeZombieState(i,ZOMBIE_STATE_EAT,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,PlayerX,PlayerY,PlayerZ,NONE);
	                    //Debug(ZTargetID,"ZOMBIE_STATE_ATTACK-ZOMBIE_STATE_EAT");
		   			}
	   			}
			}
	    }
	    case ZOMBIE_STATE_EAT:
	    {
	        if(FCNPC_IsAttacking(Zombies[i][_zNpcid]))FCNPC_StopAttack(Zombies[i][_zNpcid]);
			Zombies[i][_zState]=ZOMBIE_STATE_EAT;
			Zombies[i][_zWalktick]=0;
			FCNPC_Stop(Zombies[i][_zNpcid]);
			TogglePlayerControllable(ZTargetID, 0);
			ApplyAnimation(ZTargetID,"PED","BIKE_fallR",4.0,0,1,1,1,1);
			PlayerX=PlayerPos[ZTargetID][0], PlayerY=PlayerPos[ZTargetID][1], PlayerZ=PlayerPos[ZTargetID][2];
			SetPlayerCameraPos(ZTargetID,PlayerX,PlayerY,PlayerZ+4.0);
			SetPlayerCameraLookAt(ZTargetID,PlayerX,PlayerY,PlayerZ,CAMERA_CUT);

			FCNPC_ApplyAnimation(Zombies[i][_zNpcid], "BOMBER", "BOM_PLANT_CROUCH_OUT", 4.1, 1, 0, 0, 0,999999);
            FCNPC_SetAngleToPos(Zombies[i][_zNpcid],PlayerX,PlayerY);
			Zombies[i][_zAniming]=true;
			PlayerZombies[ZTargetID][_PzCatch]=true;
			if(GetOutKeyShow[ZTargetID]==false)
			{
				PlayerZombies[ZTargetID][_PzNeedPressKey]=GetPlayerGetOutZombiesRandomKey();
				ShowPlayerGetOutKeyTextDraw(ZTargetID,PlayerZombies[ZTargetID][_PzNeedPressKey],1000);
				if(Account[ZTargetID][_Infection]==0)
				{
				    Account[ZTargetID][_Infection]=1;
					formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `感染`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",Account[ZTargetID][_Infection],Account[ZTargetID][_Key]);
					mysql_query(Account@Handle,string128,false);
				}
			}
			//Debug(ZTargetID,"ZOMBIE_STATE_EAT");
	    }
	    case ZOMBIE_STATE_RUNAWAY:
	    {
	        if(Zombies[i][_zState]==ZOMBIE_STATE_EAT||Zombies[i][_zState]==ZOMBIE_STATE_NORMAL)FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
	        if(FCNPC_IsAttacking(Zombies[i][_zNpcid]))FCNPC_StopAttack(Zombies[i][_zNpcid]);
            Zombies[i][_zState]=ZOMBIE_STATE_RUNAWAY;
			Zombies[i][_zAlertPlayerid]=NONE;
			Zombies[i][_zAlertDelay]=GetTickCount();
			Zombies[i][_zAngry]=false;
	        new Float:InFrontPos[3],Float:Pangle,GRate=0;
		 	Pangle=PlayerPos[ZTargetID][2];
			GetPointInFront2D(ZombieX,ZombieY,Pangle,100.0,InFrontPos[0],InFrontPos[1]);
	    	CA_FindZ_For2DCoord(InFrontPos[0], InFrontPos[1],InFrontPos[2]);
		    while(GetPointCollisionFlags(InFrontPos[0], InFrontPos[1],InFrontPos[2])==17||!IsPointInGround(InFrontPos[0], InFrontPos[1],InFrontPos[2],false,1.5)||IsPosInFactionArea(InFrontPos[0], InFrontPos[1],InFrontPos[2])||IsBetweenPointToPointIsWall(ZombieX,ZombieY,ZombieZ,InFrontPos[0], InFrontPos[1],InFrontPos[2]))
		    {
    			Pangle=PlayerPos[ZTargetID][2];
				GetPointInFront2D(ZombieX,ZombieY,Pangle,100.0,InFrontPos[0],InFrontPos[1]);
		    	CA_FindZ_For2DCoord(InFrontPos[0], InFrontPos[1],InFrontPos[2]);
				GRate++;
				if(GRate>10)break;
		 	}
	        FCNPC_GoTo(Zombies[i][_zNpcid],InFrontPos[0], InFrontPos[1],InFrontPos[2]+0.5,FCNPC_MOVE_TYPE_RUN,GetZombieMoveSpeed(i),FCNPC_MOVE_MODE_COLANDREAS,.radius = 0.6);
            //Debug(ZTargetID,"ZOMBIE_STATE_RUNAWAY");
	    }
	    case ZOMBIE_STATE_DEATH:
	    {
	        Zombies[i][_zState]=ZOMBIE_STATE_DEATH;
	        if(FCNPC_IsAttacking(Zombies[i][_zNpcid]))FCNPC_StopAttack(Zombies[i][_zNpcid]);
	        FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
//	        FCNPC_ApplyAnimation(Zombies[i][_zNpcid], "FINALE", "FIN_Land_Die", 4.1, 0, 1, 1, 1,999999);
	        FCNPC_Stop(Zombies[i][_zNpcid]);
			FCNPC_GetPosition(Zombies[i][_zNpcid],Zombies[i][_zSpawn][0],Zombies[i][_zSpawn][1],Zombies[i][_zSpawn][2]);
	        FCNPC_SetVirtualWorld(Zombies[i][_zNpcid],ZOMBIE_DEATH_WORLD);
	        Zombies[i][_zAniming]=false;
	        Zombies[i][_zAngry]=false;
	        Zombies[i][_zAlertDelay]=GetTickCount();
	        Zombies[i][_zRunAway]=false;
	        Zombies[i][_zRunAwayDelay]=GetTickCount();
        	Zombies[i][_zTarget]=NONE;
        	Zombies[i][_zActorID]=CreateDynamicActor(Zombies[i][_zSkin],ZombieX,ZombieY,ZombieZ,ZombieA,.worldid=0,.streamdistance=300.0);
        	UpdateStreamer(ZombieX,ZombieY,ZombieZ,0);
            ApplyDynamicActorAnimation(Zombies[i][_zActorID],"FINALE", "FIN_Land_Die", 4.1, 0, 1, 1, 1,999999);
			if(Zombies[i][Timer:_zActorTimer]!=NONE)KillTimer(Zombies[i][Timer:_zActorTimer]);
			Zombies[i][Timer:_zActorTimer]=NONE;
			Zombies[i][Timer:_zActorTimer]=SetTimerEx("ReSpawnZombie",300000,false, "i",i);

			new Amounts=random(5);
            Iter_Clear(ZombieBag[i]);
            if(Amounts>0)
            {
                forex(s,Amounts)
                {
                    new RandItem=Iter_Random(Item);
	    			format(ZombieBag[i][s][_ZombieKey],UUID_LEN,Zombies[i][_zKey]);
	    			UUID(ZombieBag[i][s][_ZombieBagKey], UUID_LEN);
                    format(ZombieBag[i][s][_ItemKey],UUID_LEN,Item[RandItem][_Key]);
                    ZombieBag[i][s][_Amounts]=1;
                    ZombieBag[i][s][_Durable]=100.0;
                    ZombieBag[i][s][_ItemID]=RandItem;
	    			Iter_Add(ZombieBag[i],s);
	    		}
    		}
            
	    }
	}
    return 1;
}
FUNC::ReSpawnZombie(ZombieID)
{
    if(Zombies[ZombieID][_zExecute]==true)
	{
		if(Zombies[ZombieID][_zState]==ZOMBIE_STATE_DEATH)
		{
			/*new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
			GetZombieSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);*/
			FCNPC_Respawn(Zombies[ZombieID][_zNpcid]);
//			FCNPC_Spawn(Zombies[ZombieID][_zNpcid],Zombies[ZombieID][_zSkin], Zombies[ZombieID][_zSpawn][0],Zombies[ZombieID][_zSpawn][1],Zombies[ZombieID][_zSpawn][2]);
			SetPlayerSkin(Zombies[ZombieID][_zNpcid],Zombies[ZombieID][_zSkin]);
 			FCNPC_SetPosition(Zombies[ZombieID][_zNpcid],Zombies[ZombieID][_zSpawn][0],Zombies[ZombieID][_zSpawn][1],Zombies[ZombieID][_zSpawn][2]);
 			Zombies[ZombieID][_zHp]=200.0;
 			Zombies[ZombieID][_zMHp]=200.0;
			FCNPC_SetHealth(Zombies[ZombieID][_zNpcid],Zombies[ZombieID][_zHp]);
			FCNPC_SetArmour(Zombies[ZombieID][_zNpcid],0);
			FCNPC_SetVirtualWorld(Zombies[ZombieID][_zNpcid],0);
			FCNPC_SetInterior(Zombies[ZombieID][_zNpcid],0);
			FCNPC_SetAngle(Zombies[ZombieID][_zNpcid], 88);
			SetProgressBar3DValue(Zombies[ZombieID][_zHpText],Zombies[ZombieID][_zMHp]);
			/*Zombies[ZombieID][_zSpawn][0]=Gpos_X;
			Zombies[ZombieID][_zSpawn][1]=Gpos_Y;
			Zombies[ZombieID][_zSpawn][2]=Gpos_Z;*/
			Zombies[ZombieID][_zState]=ZOMBIE_STATE_NONE;
			Zombies[ZombieID][_zAniming]=false;
   			if(Zombies[ZombieID][_zActorID]!=INVALID_STREAMER_ID)DestroyDynamicActor(Zombies[ZombieID][_zActorID]);
   			Zombies[ZombieID][_zActorID]=INVALID_STREAMER_ID;
   			KillTimer(Zombies[ZombieID][Timer:_zActorTimer]);
	        Zombies[ZombieID][Timer:_zActorTimer]=NONE;
	        Zombies[ZombieID][_zTarget]=NONE;
	        Zombies[ZombieID][_zWalktick]=0;
	        Zombies[ZombieID][_zAlertPlayerid]=NONE;
	        Zombies[ZombieID][_zAngry]=false;
	        Zombies[ZombieID][_zAlertDelay]=GetTickCount();
	        Zombies[ZombieID][_zRunAway]=false;
	        Zombies[ZombieID][_zRunAwayDelay]=GetTickCount();
			Zombies[ZombieID][_zExecute]=true;
	        Zombies[ZombieID][_zAttackVeh]=NONE;
	        Zombies[ZombieID][_zAttackVehDalay]=GetTickCount();
		}
	}
    return 1;
}
stock SetNpcToFacePlayer(npcid, targetid)
{

	new
		Float:pXs,
		Float:pYs,
		Float:pZs,
		Float:Xs,
		Float:Ys,
		Float:ang;
    Xs=PlayerPos[targetid][0],Ys=PlayerPos[targetid][1];
	FCNPC_GetPosition(npcid, pXs, pYs, pZs);

	if( Ys > pYs ) ang = (-acos((Xs - pXs) / floatsqroot((Xs - pXs)*(Xs - pXs) + (Ys - pYs)*(Ys - pYs))) - 90.0);
	else if( Ys < pYs && Xs < pXs ) ang = (acos((Xs - pXs) / floatsqroot((Xs - pXs)*(Xs - pXs) + (Ys - pYs)*(Ys - pYs))) - 450.0);
	else if( Ys < pYs ) ang = (acos((Xs - pXs) / floatsqroot((Xs - pXs)*(Xs - pXs) + (Ys - pYs)*(Ys - pYs))) - 90.0);

	if(Xs > pXs) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

    FCNPC_SetAngle(npcid, ang);
 	return 0;

}
FUNC::GetPlayerZombieAttacks(playerid)//获取攻击某玩家的僵尸数量
{
    new Amount=0;
    foreach(new i:Zombies)
    {
        if(Zombies[i][_zExecute]==false)continue;
	    if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)continue;
        if(Zombies[i][_zTarget]!=NONE)
        {
            if(Zombies[i][_zTarget]==playerid)
			{
			    if(Zombies[i][_zState]==ZOMBIE_STATE_ATTACK||Zombies[i][_zState]==ZOMBIE_STATE_EAT)Amount++;
			}
        }
    }
    return Amount;
}
FUNC::ZombieUpdate()//僵尸更新
{
    if(SeverState[_ServerRun]==false)return 1;
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
		{
			GetPosData(i);
		    if(ValidZombieTargetPlayer(i))
		    {
		        if(PlayerZombies[i][_PzEscape]>0)PlayerZombies[i][_PzEscape]--;
		    }
        }
	}
    foreach(new i:Zombies)
    {
        if(Zombies[i][_zExecute]==false)continue;//僵尸不存在
        if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)continue;//僵尸死亡
		if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)
		{
		    if(Zombies[i][_zAniming]==true)
			{
				FCNPC_ClearAnimations(Zombies[i][_zNpcid]);
				Zombies[i][_zAniming]=false;
			}
			Zombies[i][_zTarget]=NONE;
			continue;
		}
		if(Zombies[i][_zTarget]!=NONE)
		{
		    new ZTargetID=Zombies[i][_zTarget];
		    if(ValidZombieTargetPlayer(ZTargetID))
		    {
			    new Float:ZombieX,Float:ZombieY,Float:ZombieZ,Float:Zdistance3D,Float:Zdistance2D;
	       		FCNPC_GetPosition(Zombies[i][_zNpcid],ZombieX,ZombieY,ZombieZ);
				new Float:PlayerX,Float:PlayerY,Float:PlayerZ,Float:PlayerZcol;
				if(Zombies[i][_zAlertPlayerid]!=NONE)
				{
				    ZTargetID=Zombies[i][_zAlertPlayerid];
				}
                PlayerX=PlayerPos[ZTargetID][0], PlayerY=PlayerPos[ZTargetID][1], PlayerZ=PlayerPos[ZTargetID][2];
   				CA_FindZ_For2DCoord(PlayerX,PlayerY,PlayerZcol);
   				
   				if(ZTargetID!=NONE)
   				{
					if(Zombies[i][_zRunAway]==false)
					{
						if(Zombies[i][_zHp]<=70.0)
						{
						    if(random(5)==1)
						    {
						    //printf("runaway1");
						    	Zombies[i][_zRunAway]=true;
					    		Zombies[i][_zRunAwayDelay]=GetTickCount();
						    	ChangeZombieState(i,ZOMBIE_STATE_RUNAWAY,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,PlayerX,PlayerY,PlayerZ,NONE);
							}
						}
					}
					else
					{
					    ChangeZombieState(i,ZOMBIE_STATE_RUNAWAY,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,PlayerX,PlayerY,PlayerZ,NONE);
                        //printf("runaway2");
						continue;
					}
				}

   				new PFlags=GetPlayerCollisionFlags(ZTargetID);
   				Zdistance3D=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ);
   				Zdistance2D=GetDistanceBetweenPoints2D(ZombieX,ZombieY,PlayerX,PlayerY);

				new TooFar=false;
				if(Zombies[i][_zAlertPlayerid]!=NONE)
				{
					if(Zdistance3D>ZOMBIES_ALERT_RANGE)TooFar=true;
					else TooFar=false;
				}
				else
				{
				    if(Zdistance3D>Zombies[i][_zLookrange]*2)TooFar=true;
					else TooFar=false;
				}
				
   				if(TooFar||/*IsPlayerInFactionArea(ZTargetID)||*/PFlags==17)
   				{
   				    //printf("111111111111111111");
   				    PlayerZombies[ZTargetID][_PzCatch]=false;
					ChangeZombieState(i,ZOMBIE_STATE_NORMAL,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,0.0,0.0,0.0,NONE);
   				}
   				else
   				{
   				    if(!IsPlayerInAnyVehicle(ZTargetID)&&IsBetweenPointToPointIsWall(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ)&&(Zdistance3D>30.0||Zdistance2D>30.0))
   				    {
   				        ChangeZombieState(i,ZOMBIE_STATE_NORMAL,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,0.0,0.0,0.0,NONE);
   				    }
   				    else
   				    {
	           			if((Zdistance3D<2.0||Zdistance2D<2.0)&&PlayerZombies[ZTargetID][_PzEscape]<1)
	           			{
							/*if(GetPlayerZombieAttacks(ZTargetID)>1)
							{*/
							    if(Zombies[i][_zState]!=ZOMBIE_STATE_ATTACK||Zombies[i][_zState]!=ZOMBIE_STATE_EAT)
						        {
								    if(PlayerZombies[ZTargetID][_PzCatch]==false)
								    {
								        //printf("33333333333333");
								        new vehicleid=NONE;
								        if(IsPlayerInAnyVehicle(ZTargetID))vehicleid=GetPlayerVehicleID(ZTargetID);
	                                    ChangeZombieState(i,ZOMBIE_STATE_ATTACK,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,PlayerX,PlayerY,PlayerZ,vehicleid);
								    }
								}
							//}
	           			}
	           			else
	           			{
	           			    //printf("44444444444444444");
	           			    PlayerZombies[ZTargetID][_PzCatch]=false;
	           			    //Debug(ZTargetID,"4444");
							ChangeZombieState(i,ZOMBIE_STATE_FOLLOW,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,PlayerX,PlayerY,PlayerZ,NONE,Zdistance3D);
						}
					}
   				}
		    }
		    else
		    {
      			new Float:ZombieX,Float:ZombieY,Float:ZombieZ;
       			FCNPC_GetPosition(Zombies[i][_zNpcid],ZombieX,ZombieY,ZombieZ);
             	ChangeZombieState(i,ZOMBIE_STATE_NORMAL,ZTargetID,ZombieX,ZombieY,ZombieZ,0.0,0.0,0.0,0.0,NONE);
		    }
		}
		else
        {
      		new Float:ZombieX,Float:ZombieY,Float:ZombieZ,Float:ZombieA,ZTargetID/*,Float:ZombieHp=FCNPC_GetHealth(Zombies[i][_zNpcid])*/;
       		FCNPC_GetPosition(Zombies[i][_zNpcid],ZombieX,ZombieY,ZombieZ);
       		ZombieA=FCNPC_GetAngle(Zombies[i][_zNpcid]);
       		ZTargetID=GetZombiePosNearstPlayerPos(i,ZombieX,ZombieY,ZombieZ,ZombieA);
			if(Zombies[i][_zAlertPlayerid]!=NONE)
			{
			    ZTargetID=Zombies[i][_zAlertPlayerid];
			}
			if(ZTargetID!=NONE&&ValidZombieTargetPlayer(ZTargetID))
			{
			    new Float:PlayerX,Float:PlayerY,Float:PlayerZ,Float:PlayerZcol;
				PlayerX=PlayerPos[ZTargetID][0], PlayerY=PlayerPos[ZTargetID][1], PlayerZ=PlayerPos[ZTargetID][2];
   				CA_FindZ_For2DCoord(PlayerX,PlayerY,PlayerZcol);
   				new Float:Zdistance3D=GetDistanceBetweenPoints3D(ZombieX,ZombieY,ZombieZ,PlayerX,PlayerY,PlayerZ);
   				//Debug(ZTargetID,"5555");
			    ChangeZombieState(i,ZOMBIE_STATE_FOLLOW,ZTargetID,ZombieX,ZombieY,ZombieZ,ZombieA,PlayerX,PlayerY,PlayerZ,NONE,Zdistance3D);
			}
			else
			{
                ChangeZombieState(i,ZOMBIE_STATE_NORMAL,ZTargetID,ZombieX,ZombieY,ZombieZ,ZombieA,0.0,0.0,0.0,NONE);
			}
		}
    }
    foreach(new i:Zombies)
    {
        if(Zombies[i][_zExecute]==false)continue;
        if(Zombies[i][_zState]==ZOMBIE_STATE_NORMAL||Zombies[i][_zState]==ZOMBIE_STATE_RUNAWAY||Zombies[i][_zState]==ZOMBIE_STATE_EAT)
        {
            if(Zombies[i][_zHp]<Zombies[i][_zMHp])
            {
                Zombies[i][_zHp]+=0.1;
				if(Zombies[i][_zHp]>Zombies[i][_zMHp])Zombies[i][_zHp]=Zombies[i][_zMHp];
                FCNPC_SetHealth(Zombies[i][_zNpcid],Zombies[i][_zHp]);
                SetProgressBar3DValue(Zombies[i][_zHpText],Zombies[i][_zHp]);
            }
        }
    }
    return 1;
}
FUNC::Zombie_OnPlayerPressGetOutKey(playerid,OPU_Keys,OPU_Ud,OPU_Lr)
{
    if(ValidZombieTargetPlayer(playerid))
    {
		if(PlayerZombies[playerid][_PzCatch]==true)
	   	{
	    	switch(GetOutZombiesKeys[PlayerZombies[playerid][_PzNeedPressKey]][_GetOutKeyUl])
	     	{
	      		case 0:
	            {
	            	if(OPU_Keys==0&&OPU_Ud==GetOutZombiesKeys[PlayerZombies[playerid][_PzNeedPressKey]][_GetOutValue]&&OPU_Lr==0)
	             	{
	             	    FinishPlayerGetOutKeyTextDraw(playerid);
			            PlayerZombies[playerid][_PzEscape]=6;
			            TogglePlayerControllable(playerid, 1);
			            SetCameraBehindPlayer(playerid);
			            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 1);
			            PlayerZombies[playerid][_PzCatch]=false;
					}
	    		}
	      		case 1:
	        	{
	         		if(OPU_Keys==0&&OPU_Ud==0&&OPU_Lr==GetOutZombiesKeys[PlayerZombies[playerid][_PzNeedPressKey]][_GetOutValue])
	           		{
	           		    FinishPlayerGetOutKeyTextDraw(playerid);
			            PlayerZombies[playerid][_PzEscape]=6;
			            TogglePlayerControllable(playerid, 1);
			            SetCameraBehindPlayer(playerid);
			            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 1);
			            PlayerZombies[playerid][_PzCatch]=false;
					}
				}
	   		}
		}
	}
    return 1;
}
stock GetPlayerGetOutZombiesRandomKey()
{
	new RandKey=random(sizeof(GetOutZombiesKeys));
	return RandKey;
}
/********************************************************************************/
FUNC::Zombie_OnPlayerConnect(playerid)
{
	PlayerZombies[playerid][_PzCatch]=false;
	PlayerZombies[playerid][_PzEscape]=0;
	PlayerZombies[playerid][_PzNeedPressKey]=NONE;
	PlayerZombies[playerid][_PzAlertZombieDelay]=GetTickCount();

	GetOutKeyTextAlpha[playerid]=NONE;
	GetOutKeyTimeCount[playerid]=0;
	if(Timer:GetOutKeyTime[playerid]!=NONE)
	{
	    KillTimer(Timer:GetOutKeyTime[playerid]);
	    Timer:GetOutKeyTime[playerid]=NONE;
	}
	GetOutKeyShow[playerid]=false;
	if(GetOutKeyTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid,GetOutKeyTextDraw[playerid]);
		GetOutKeyTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	}
	CreatePlayerGetOutKeyTextDraw(playerid);
	return 1;
}
FUNC::Zombie_OnPlayerDisconnect(playerid, reason)
{
	PlayerZombies[playerid][_PzCatch]=false;
	PlayerZombies[playerid][_PzEscape]=0;
	PlayerZombies[playerid][_PzNeedPressKey]=NONE;
	PlayerZombies[playerid][_PzAlertZombieDelay]=GetTickCount();
	
	GetOutKeyTextAlpha[playerid]=NONE;
	GetOutKeyTimeCount[playerid]=0;
	if(Timer:GetOutKeyTime[playerid]!=NONE)
	{
	    KillTimer(Timer:GetOutKeyTime[playerid]);
	    Timer:GetOutKeyTime[playerid]=NONE;
	}
	GetOutKeyShow[playerid]=false;
	if(GetOutKeyTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid,GetOutKeyTextDraw[playerid]);
		GetOutKeyTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	}
	if(GetOutKeyCircleTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid,GetOutKeyCircleTextDraw[playerid]);
		GetOutKeyCircleTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}
FUNC::Zombie_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(GetTickCount()-PlayerZombies[playerid][_PzAlertZombieDelay]>=800)
	{
	    if(ValidZombieTargetPlayer(playerid))
	    {
	    	PlayerZombies[playerid][_PzAlertZombieDelay]=GetTickCount();
			if(Iter_Count(Zombies)>0)
			{
			    new Float:ZombiePos[3],Float:distancez;
			    foreach(new i:Zombies)
			    {
			        if(Zombies[i][_zExecute]==false)continue;//僵尸不存在
        			if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)continue;//僵尸死亡
			        if(Zombies[i][_zState]==ZOMBIE_STATE_FOLLOW||Zombies[i][_zState]==ZOMBIE_STATE_NORMAL)
			        {
				    	FCNPC_GetPosition(Zombies[i][_zNpcid],ZombiePos[0],ZombiePos[1],ZombiePos[2]);
				        distancez=GetDistanceBetweenPoints3D(ZombiePos[0],ZombiePos[1],ZombiePos[2],PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);//距离计算
				        if(distancez<=ZOMBIES_ALERT_RANGE)
				        {
				            Zombies[i][_zAlertPlayerid]=playerid;
				            Zombies[i][_zAlertDelay]=GetTickCount();
				        }
			        }
			    }
		    }
		}
    }
	return 1;
}
/***********************************************************************/
FUNC::CreatePlayerGetOutKeyTextDraw(playerid)
{
	GetOutKeyTextDraw[playerid] = CreatePlayerTextDraw(playerid, 320.933282, 190.988876, "~n~");
	PlayerTextDrawLetterSize(playerid, GetOutKeyTextDraw[playerid], 0.548000, 2.861037);
	PlayerTextDrawAlignment(playerid, GetOutKeyTextDraw[playerid], 2);
	PlayerTextDrawColor(playerid, GetOutKeyTextDraw[playerid], GetOutKeyTextAlpha[playerid]);
	PlayerTextDrawSetShadow(playerid, GetOutKeyTextDraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid, GetOutKeyTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, GetOutKeyTextDraw[playerid], -156);
	PlayerTextDrawFont(playerid, GetOutKeyTextDraw[playerid], 2);
	PlayerTextDrawSetProportional(playerid, GetOutKeyTextDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, GetOutKeyTextDraw[playerid], 0);
	
	GetOutKeyCircleTextDraw[playerid] = CreatePlayerTextDraw(playerid, 299.666748, 186.940643, "mdl-2003:circleround_glass");
	PlayerTextDrawLetterSize(playerid,GetOutKeyCircleTextDraw[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,GetOutKeyCircleTextDraw[playerid], 42.000000, 37.000000);
	PlayerTextDrawAlignment(playerid,GetOutKeyCircleTextDraw[playerid], 1);
	PlayerTextDrawColor(playerid,GetOutKeyCircleTextDraw[playerid], -1);
	PlayerTextDrawSetShadow(playerid,GetOutKeyCircleTextDraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid,GetOutKeyCircleTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid,GetOutKeyCircleTextDraw[playerid], 255);
	PlayerTextDrawFont(playerid,GetOutKeyCircleTextDraw[playerid], 4);
	PlayerTextDrawSetProportional(playerid,GetOutKeyCircleTextDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid,GetOutKeyCircleTextDraw[playerid], 0);
    return 1;
}
FUNC::ShowPlayerGetOutKeyTextDraw(playerid,NeedPressKey,ShowTimes)
{
    GetOutKeyTextAlpha[playerid]=NONE;
    PlayerTextDrawColor(playerid,GetOutKeyCircleTextDraw[playerid], -1);
    PlayerTextDrawShow(playerid,GetOutKeyCircleTextDraw[playerid]);
    PlayerTextDrawSetString(playerid,GetOutKeyTextDraw[playerid],GetOutZombiesKeys[NeedPressKey][_GetOutUnPressKey]);
    PlayerTextDrawColor(playerid, GetOutKeyTextDraw[playerid], GetOutKeyTextAlpha[playerid]);
    PlayerTextDrawShow(playerid, GetOutKeyTextDraw[playerid]);
	if(Timer:GetOutKeyTime[playerid]!=NONE)
	{
	    KillTimer(Timer:GetOutKeyTime[playerid]);
	    Timer:GetOutKeyTime[playerid]=NONE;
	}
	GetOutKeyTimeCount[playerid]=0;
    Timer:GetOutKeyTime[playerid]=SetTimerEx("HidePlayerGetOutKeyTextDraw", floatround(floatdiv(ShowTimes,255)), true, "i", playerid);
    GetOutKeyShow[playerid]=true;
	return 1;
}
FUNC::HidePlayerGetOutKeyTextDraw(playerid)
{
	if(GetOutKeyTimeCount[playerid]<255)
	{
    	GetOutKeyTimeCount[playerid]++;
    	GetOutKeyTextAlpha[playerid]--;
    	PlayerTextDrawColor(playerid, GetOutKeyTextDraw[playerid], GetOutKeyTextAlpha[playerid]);
    	PlayerTextDrawShow(playerid, GetOutKeyTextDraw[playerid]);
    }
    else
    {
     	PlayerTextDrawHide(playerid,GetOutKeyCircleTextDraw[playerid]);
    	PlayerTextDrawHide(playerid,GetOutKeyTextDraw[playerid]);
		GetOutKeyTextAlpha[playerid]=NONE;
		GetOutKeyTimeCount[playerid]=0;
    	KillTimer(Timer:GetOutKeyTime[playerid]);
    	Timer:GetOutKeyTime[playerid]=NONE;
	    GetOutKeyShow[playerid]=false;
    }
    return 1;
}
FUNC::FinishPlayerGetOutKeyTextDraw(playerid)
{
	if(Timer:GetOutKeyTime[playerid]!=NONE)
	{
	    KillTimer(Timer:GetOutKeyTime[playerid]);
	    Timer:GetOutKeyTime[playerid]=NONE;
	}
	PlayerTextDrawColor(playerid, GetOutKeyCircleTextDraw[playerid], -16776961);
	GetOutKeyTextAlpha[playerid]=NONE;
	GetOutKeyTimeCount[playerid]=0;
	PlayerTextDrawColor(playerid, GetOutKeyTextDraw[playerid], GetOutKeyTextAlpha[playerid]);
	PlayerTextDrawShow(playerid, GetOutKeyCircleTextDraw[playerid]);
    PlayerTextDrawShow(playerid, GetOutKeyTextDraw[playerid]);
 	Timer:GetOutKeyTime[playerid]=SetTimerEx("ClosePlayerGetOutKeyTextDraw", 500, true, "i", playerid);
    return 1;
}
FUNC::ClosePlayerGetOutKeyTextDraw(playerid)
{
	if(Timer:GetOutKeyTime[playerid]!=NONE)
	{
	    KillTimer(Timer:GetOutKeyTime[playerid]);
	    Timer:GetOutKeyTime[playerid]=NONE;
	}
	PlayerTextDrawHide(playerid,GetOutKeyCircleTextDraw[playerid]);
   	PlayerTextDrawHide(playerid,GetOutKeyTextDraw[playerid]);
	GetOutKeyTextAlpha[playerid]=NONE;
	GetOutKeyTimeCount[playerid]=0;
	GetOutKeyShow[playerid]=false;
	return 1;
}
NpcPreloadAnimLib(npcid, animlib[])
{
	FCNPC_ApplyAnimation(npcid,animlib,"null",0.0,0,0,0,0,0);
}
stock PreloadNpcAnims(npcid)
{
    NpcPreloadAnimLib(npcid, "PED");
	NpcPreloadAnimLib(npcid, "AIRPORT");
	NpcPreloadAnimLib(npcid, "ATTRACTORS");
	NpcPreloadAnimLib(npcid, "BAR");
	NpcPreloadAnimLib(npcid, "BASEBALL");
	NpcPreloadAnimLib(npcid, "BD_FIRE");
	NpcPreloadAnimLib(npcid, "BEACH");
	NpcPreloadAnimLib(npcid, "BENCHPRESS");
	NpcPreloadAnimLib(npcid, "BF_INJECTION");
	NpcPreloadAnimLib(npcid, "BIKED");
	NpcPreloadAnimLib(npcid, "BIKEH");
	NpcPreloadAnimLib(npcid, "BIKELEAP");
	NpcPreloadAnimLib(npcid, "BIKES");
	NpcPreloadAnimLib(npcid, "BIKEV");
	NpcPreloadAnimLib(npcid, "BIKE_DBZ");
	NpcPreloadAnimLib(npcid, "BMX");
	NpcPreloadAnimLib(npcid, "BOMBER");
	NpcPreloadAnimLib(npcid, "BOX");
	NpcPreloadAnimLib(npcid, "BSKTBALL");
	NpcPreloadAnimLib(npcid, "BUDDY");
	NpcPreloadAnimLib(npcid, "BUS");
	NpcPreloadAnimLib(npcid, "CAMERA");
	NpcPreloadAnimLib(npcid, "CAR");
	NpcPreloadAnimLib(npcid, "CARRY");
	NpcPreloadAnimLib(npcid, "CAR_CHAT");
	NpcPreloadAnimLib(npcid, "CASINO");
	NpcPreloadAnimLib(npcid, "CHAINSAW");
	NpcPreloadAnimLib(npcid, "CHOPPA");
	NpcPreloadAnimLib(npcid, "CLOTHES");
	NpcPreloadAnimLib(npcid, "COACH");
	NpcPreloadAnimLib(npcid, "COLT45");
	NpcPreloadAnimLib(npcid, "COP_AMBIENT");
	NpcPreloadAnimLib(npcid, "COP_DVBYZ");
	NpcPreloadAnimLib(npcid, "CRACK");
	NpcPreloadAnimLib(npcid, "CRIB");
	NpcPreloadAnimLib(npcid, "DAM_JUMP");
	NpcPreloadAnimLib(npcid, "DANCING");
	NpcPreloadAnimLib(npcid, "DEALER");
	NpcPreloadAnimLib(npcid, "DILDO");
	NpcPreloadAnimLib(npcid, "DODGE");
	NpcPreloadAnimLib(npcid, "DOZER");
	NpcPreloadAnimLib(npcid, "DRIVEBYS");
	NpcPreloadAnimLib(npcid, "FAT");
	NpcPreloadAnimLib(npcid, "FIGHT_B");
	NpcPreloadAnimLib(npcid, "FIGHT_C");
	NpcPreloadAnimLib(npcid, "FIGHT_D");
	NpcPreloadAnimLib(npcid, "FIGHT_E");
	NpcPreloadAnimLib(npcid, "FINALE");
	NpcPreloadAnimLib(npcid, "FINALE2");
	NpcPreloadAnimLib(npcid, "FLAME");
	NpcPreloadAnimLib(npcid, "FLOWERS");
	NpcPreloadAnimLib(npcid, "FOOD");
	NpcPreloadAnimLib(npcid, "FREEWEIGHTS");
	NpcPreloadAnimLib(npcid, "GANGS");
	NpcPreloadAnimLib(npcid, "GHANDS");
	NpcPreloadAnimLib(npcid, "GHETTO_DB");
	NpcPreloadAnimLib(npcid, "GOGGLES");
	NpcPreloadAnimLib(npcid, "GRAFFITI");
	NpcPreloadAnimLib(npcid, "GRAVEYARD");
	NpcPreloadAnimLib(npcid, "GRENADE");
	NpcPreloadAnimLib(npcid, "GYMNASIUM");
	NpcPreloadAnimLib(npcid, "HAIRCUTS");
	NpcPreloadAnimLib(npcid, "HEIST9");
	NpcPreloadAnimLib(npcid, "INT_HOUSE");
	NpcPreloadAnimLib(npcid, "INT_OFFICE");
	NpcPreloadAnimLib(npcid, "INT_SHOP");
	NpcPreloadAnimLib(npcid, "JST_BUISNESS");
	NpcPreloadAnimLib(npcid, "KART");
	NpcPreloadAnimLib(npcid, "KISSING");
	NpcPreloadAnimLib(npcid, "KNIFE");
	NpcPreloadAnimLib(npcid, "LAPDAN1");
	NpcPreloadAnimLib(npcid, "LAPDAN2");
	NpcPreloadAnimLib(npcid, "LAPDAN3");
	NpcPreloadAnimLib(npcid, "LOWRIDER");
	NpcPreloadAnimLib(npcid, "MD_CHASE");
	NpcPreloadAnimLib(npcid, "MD_END");
	NpcPreloadAnimLib(npcid, "MEDIC");
	NpcPreloadAnimLib(npcid, "MISC");
	NpcPreloadAnimLib(npcid, "MTB");
	NpcPreloadAnimLib(npcid, "MUSCULAR");
	NpcPreloadAnimLib(npcid, "NEVADA");
	NpcPreloadAnimLib(npcid, "ON_LOOKERS");
	NpcPreloadAnimLib(npcid, "OTB");
	NpcPreloadAnimLib(npcid, "PARACHUTE");
	NpcPreloadAnimLib(npcid, "PARK");
	NpcPreloadAnimLib(npcid, "PAULNMAC");
	NpcPreloadAnimLib(npcid, "PED");
	NpcPreloadAnimLib(npcid, "PLAYER_DVBYS");
	NpcPreloadAnimLib(npcid, "PLAYIDLES");
	NpcPreloadAnimLib(npcid, "POLICE");
	NpcPreloadAnimLib(npcid, "POOL");
	NpcPreloadAnimLib(npcid, "POOR");
	NpcPreloadAnimLib(npcid, "PYTHON");
	NpcPreloadAnimLib(npcid, "QUAD");
	NpcPreloadAnimLib(npcid, "QUAD_DBZ");
	NpcPreloadAnimLib(npcid, "RAPPING");
	NpcPreloadAnimLib(npcid, "RIFLE");
	NpcPreloadAnimLib(npcid, "RIOT");
	NpcPreloadAnimLib(npcid, "ROB_BANK");
	NpcPreloadAnimLib(npcid, "ROCKET");
	NpcPreloadAnimLib(npcid, "RUSTLER");
	NpcPreloadAnimLib(npcid, "RYDER");
	NpcPreloadAnimLib(npcid, "SCRATCHING");
	NpcPreloadAnimLib(npcid, "SHAMAL");
	NpcPreloadAnimLib(npcid, "SHOP");
	NpcPreloadAnimLib(npcid, "SHOTGUN");
	NpcPreloadAnimLib(npcid, "SILENCED");
	NpcPreloadAnimLib(npcid, "SKATE");
	NpcPreloadAnimLib(npcid, "SMOKING");
	NpcPreloadAnimLib(npcid, "SNIPER");
	NpcPreloadAnimLib(npcid, "SPRAYCAN");
	NpcPreloadAnimLib(npcid, "STRIP");
	NpcPreloadAnimLib(npcid, "SUNBATHE");
	NpcPreloadAnimLib(npcid, "SWAT");
	NpcPreloadAnimLib(npcid, "SWEET");
	NpcPreloadAnimLib(npcid, "SWIM");
	NpcPreloadAnimLib(npcid, "SWORD");
	NpcPreloadAnimLib(npcid, "TANK");
	NpcPreloadAnimLib(npcid, "TATTOOS");
	NpcPreloadAnimLib(npcid, "TEC");
	NpcPreloadAnimLib(npcid, "TRAIN");
	NpcPreloadAnimLib(npcid, "TRUCK");
	NpcPreloadAnimLib(npcid, "UZI");
	NpcPreloadAnimLib(npcid, "VAN");
	NpcPreloadAnimLib(npcid, "VENDING");
	NpcPreloadAnimLib(npcid, "VORTEX");
	NpcPreloadAnimLib(npcid, "WAYFARER");
	NpcPreloadAnimLib(npcid, "WEAPONS");
	NpcPreloadAnimLib(npcid, "WUZI");
	NpcPreloadAnimLib(npcid, "WOP");
	NpcPreloadAnimLib(npcid, "GFUNK");
	NpcPreloadAnimLib(npcid, "RUNNINGMAN");
}

