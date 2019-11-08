FUNC::bool:VerifyInvPVarData(playerid,VarString[])
{
	new BagID,BagKey[37],ItemID;
    if(sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(PlayerInv[playerid],BagID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该物品已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(PlayerInv[playerid][BagID][_InvKey],BagKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(!isequal(PlayerInv[playerid][BagID][_ItemKey],Item[ItemID][_Key],false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#3]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(PlayerInv[playerid][BagID][_Amounts]<=0)
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#4]","该物品已失效,请重新选择","了解","");
	    return false;
	}
	return true;
}

FUNC::OnPlayerClickInvItemBotton(playerid,index)
{
	new BagID=PlayerInvPrevieBox[playerid][index];
	new ItemID=PlayerInv[playerid][BagID][_ItemID];
	formatex32("背包:%s",Item[ItemID][_Name]);
	SCM(playerid,-1,string32);
	formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
	if(VerifyInvPVarData(playerid,string64)==true)
	{
		SetPVarString(playerid,"_Bag_Click_Info",string64);
		ShowAdditionInfo(playerid,ItemID,_SPD_BAG_INFO,"使用","返回");
	}
	return 1;
}
FUNC::RemovePlayerUseItemAttach(playerid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid,9))RemovePlayerAttachedObject(playerid,9);
	Timer:PlayerUseItemAnim[playerid]=NONE;
	return 1;
}
FUNC::PlayerUseAntibiotic(playerid)
{
	PlayerUseItemTimeCount[playerid]++;
    if(PlayerUseItemTimeCount[playerid]>PlayerUseItemTimeTotal[playerid])
    {
        StopPlayerInfection(playerid);
        KillTimer(Timer:PlayerUseItem[playerid]);
		Timer:PlayerUseItem[playerid]=NONE;
    	HidePlayerBuffBar(playerid);
    	return 1;
    }
    else
    {
		if(BuffBarShow[playerid]==true)
		{
			PlayerTextDrawTextSize(playerid, pBuffTimeBarTextDraw[playerid],floatmul(112.500000,floatdiv(PlayerUseItemTimeCount[playerid],PlayerUseItemTimeTotal[playerid])),2.000000);
		    PlayerTextDrawShow(playerid,pBuffTimeBarTextDraw[playerid]);
		}
    }
	return 1;
}
FUNC::PlayerUseMedicle(playerid,Float:amount)
{
	PlayerUseItemTimeCount[playerid]++;
    if(PlayerUseItemTimeCount[playerid]>PlayerUseItemTimeTotal[playerid])
    {
    	KillTimer(Timer:PlayerUseItem[playerid]);
    	Timer:PlayerUseItem[playerid]=NONE;
    	HidePlayerBuffBar(playerid);
    	return 1;
    }
    else
    {
		new Float:pHealth,Float:HealpHealth;
		GetPlayerHealth(playerid,pHealth);
		if(pHealth>=100.0)
		{
	    	KillTimer(Timer:PlayerUseItem[playerid]);
	    	Timer:PlayerUseItem[playerid]=NONE;
	    	HidePlayerBuffBar(playerid);
	    	return 1;
		}
		HealpHealth=floatadd(pHealth,amount);
		if(HealpHealth>100.0)SetPlayerHealth(playerid,100.0);
		else SetPlayerHealth(playerid,HealpHealth);
		if(BuffBarShow[playerid]==true)
		{
			PlayerTextDrawTextSize(playerid, pBuffTimeBarTextDraw[playerid],floatmul(112.500000,floatdiv(PlayerUseItemTimeCount[playerid],PlayerUseItemTimeTotal[playerid])),2.000000);
		    PlayerTextDrawShow(playerid,pBuffTimeBarTextDraw[playerid]);
		}
    }
	return 1;
}
FUNC::ApplyInvItemAnimation(playerid,ItemID)
{
    if(Item[ItemID][_AttachPosID]!=NONE)
	{
	    if(ItemAttachPos[Item[ItemID][_AttachPosID]][_AnimTime]!=0)
	    {
			ApplyAnimation(playerid,ItemAttachPos[Item[ItemID][_AttachPosID]][_Animlib],ItemAttachPos[Item[ItemID][_AttachPosID]][_Animname],4.1,0,0,0,0,ItemAttachPos[Item[ItemID][_AttachPosID]][_AnimTime],1);
		}
	}
	return 1;
}
FUNC::SetPlayerInvItemUseAttach(playerid,ItemID,Index,Boneid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid,Index))RemovePlayerAttachedObject(playerid,Index);
	if(Item[ItemID][_AttachPosID]!=NONE)
	{
	    new attachid=Item[ItemID][_AttachPosID];
	    SetPlayerAttachedObject(playerid,\
		Index,\
		Item[ItemID][_Model],\
		Boneid,\
		ItemAttachPos[attachid][_fOffsetX],\
		ItemAttachPos[attachid][_fOffsetY], \
		ItemAttachPos[attachid][_fOffsetZ], \
		ItemAttachPos[attachid][_fRotX], \
		ItemAttachPos[attachid][_fRotY], \
		ItemAttachPos[attachid][_fRotZ], \
		ItemAttachPos[attachid][_fScaleX], \
		ItemAttachPos[attachid][_fScaleY], \
		ItemAttachPos[attachid][_fScaleZ]);
	}
	else
	{
	    SetPlayerAttachedObject(playerid,\
		Index,\
		Item[ItemID][_Model],\
		Boneid,\
		0.0,\
		0.0, \
		0.0, \
		0.0, \
		0.0, \
		0.0, \
		1.0, \
		1.0, \
		1.0);
	}
	return 1;
}
FUNC::OnPlayerInvItemUse(playerid,index)
{
    new VarString[64];
    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
    if(VerifyInvPVarData(playerid,VarString))
 	{
		new BagID,BagKey[37],ItemID;
		sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
		switch(Item[ItemID][_Type])
		{
		    case ITEM_TYPE_WEAPON:
		    {
		        if(IsPlayerDressWeaponSlotUsed(playerid,Item[ItemID][_WeaponDressSlot]))
				{
					formatex128("该武器的武器槽已被使用,请卸下 %i 号武器再使用",Item[ItemID][_WeaponDressSlot]);
					SCM(playerid,-1,string128);
					return 1;
				}
				else
				{
				    new tItemKey[37],Float:tDurable,tGetTime;
					format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
					tDurable=PlayerInv[playerid][BagID][_Durable];
					tGetTime=PlayerInv[playerid][BagID][_GetTime];
				    if(ReduceAmountForPlayerInv(playerid,tItemKey,1))
				    {
				    	AddItemToPlayerWeapon(playerid,tItemKey,tDurable,tGetTime);
					}
				}
		    }
		    case ITEM_TYPE_ANTIBIOTIC:
		    {
		        if(Item[ItemID][_BuffTime]!=NONE)
		        {
                    if(Timer:PlayerUseItem[playerid]==NONE)
                    {
                        if(ReduceAmountForPlayerInv(playerid,Item[ItemID][_Key],1))
                        {
                            SetPlayerArmedWeapon(playerid,0);
                        	PlayerUseItemTimeCount[playerid]=0;
  							new Times=floatround(floatdiv(floatmul(Item[ItemID][_BuffTime],1000),Item[ItemID][_BuffEffect]));
							PlayerUseItemTimeTotal[playerid]=floatround(floatdiv(floatmul(Item[ItemID][_BuffTime],1000),Times));
//							new Float:Amount=floatdiv(Item[ItemID][_BuffEffect],PlayerUseItemTimeTotal[playerid]);
                        	ShowPlayerBuffBar(playerid,0xFFFF00C8);
                    		Timer:PlayerUseItem[playerid]=SetTimerEx("PlayerUseAntibiotic",Times,true,"i",playerid);

                            SetPlayerInvItemUseAttach(playerid,ItemID,9,6);
                            ApplyInvItemAnimation(playerid,ItemID);
							//SetPlayerAttachedObject(playerid,9,Item[ItemID][_Model],6, 0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0);

                            if(Timer:PlayerUseItemAnim[playerid]!=NONE)KillTimer(Timer:PlayerUseItemAnim[playerid]);
                            Timer:PlayerUseItemAnim[playerid]=NONE;
							Timer:PlayerUseItemAnim[playerid]=SetTimerEx("RemovePlayerUseItemAttach",2000,false,"i",playerid);

                        }
                    }
				}
				else SCM(playerid,-1,"你正在使用其他道具");
		    }
		    case ITEM_TYPE_MEDICAL:
		    {
		        if(Item[ItemID][_BuffTime]!=NONE)
		        {
                    if(Timer:PlayerUseItem[playerid]==NONE)
                    {
                        if(ReduceAmountForPlayerInv(playerid,Item[ItemID][_Key],1))
                        {
                            SetPlayerArmedWeapon(playerid,0);
                        	PlayerUseItemTimeCount[playerid]=0;
  							new Times=floatround(floatdiv(floatmul(Item[ItemID][_BuffTime],1000),Item[ItemID][_BuffEffect]));
							PlayerUseItemTimeTotal[playerid]=floatround(floatdiv(floatmul(Item[ItemID][_BuffTime],1000),Times));
							new Float:Amount=floatdiv(Item[ItemID][_BuffEffect],PlayerUseItemTimeTotal[playerid]);
                        	ShowPlayerBuffBar(playerid,-16776961);
                    		Timer:PlayerUseItem[playerid]=SetTimerEx("PlayerUseMedicle",Times,true,"if",playerid,Amount);

                            SetPlayerInvItemUseAttach(playerid,ItemID,9,6);
                            ApplyInvItemAnimation(playerid,ItemID);
							//SetPlayerAttachedObject(playerid,9,Item[ItemID][_Model],6, 0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0);

                            if(Timer:PlayerUseItemAnim[playerid]!=NONE)KillTimer(Timer:PlayerUseItemAnim[playerid]);
                            Timer:PlayerUseItemAnim[playerid]=NONE;
							Timer:PlayerUseItemAnim[playerid]=SetTimerEx("RemovePlayerUseItemAttach",2000,false,"i",playerid);
						}
					}
                    else SCM(playerid,-1,"你正在使用其他道具");
		        }
		        else
				{
					if(ReduceAmountForPlayerInv(playerid,Item[ItemID][_Key],1))
					{
					    SetPlayerArmedWeapon(playerid,0);
						new Float:pHealth,Float:HealpHealth;
						GetPlayerHealth(playerid,pHealth);
						if(pHealth<100.0)
						{
							HealpHealth=floatadd(pHealth,Item[ItemID][_BuffEffect]);
							if(HealpHealth>100.0)SetPlayerHealth(playerid,100.0);
							else SetPlayerHealth(playerid,HealpHealth);
						}
						
						SetPlayerInvItemUseAttach(playerid,ItemID,9,6);
						ApplyInvItemAnimation(playerid,ItemID);
						
                        if(Timer:PlayerUseItemAnim[playerid]!=NONE)KillTimer(Timer:PlayerUseItemAnim[playerid]);
                        Timer:PlayerUseItemAnim[playerid]=NONE;
						Timer:PlayerUseItemAnim[playerid]=SetTimerEx("RemovePlayerUseItemAttach",2000,false,"i",playerid);
					}
				}
		    }
		    case ITEM_TYPE_FOOD:
		    {
		    }
		    case ITEM_TYPE_EQUIP:
		    {
		        if(IsPlayerDressEquipSlotUsed(playerid,Item[ItemID][_EquipDressSlot]))
				{
					formatex128("该防具的防具槽已被使用,请卸下 %i 号防具再使用",Item[ItemID][_EquipDressSlot]);
					SCM(playerid,-1,string128);
					return 1;
				}
				else
				{
				    new tItemKey[37],Float:tDurable,tGetTime;
					format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
					tDurable=PlayerInv[playerid][BagID][_Durable];
					tGetTime=PlayerInv[playerid][BagID][_GetTime];
				    if(ReduceAmountForPlayerInv(playerid,tItemKey,1))
				    {
				    	AddItemToPlayerEquip(playerid,tItemKey,tDurable,tGetTime);
					}
				}
		    }
		    case ITEM_TYPE_VEHICLETACKLE:
		    {
		    }
		    case ITEM_TYPE_COMMU:
		    {
		        if(IsPlayerDressEquipSlotUsed(playerid,Item[ItemID][_EquipDressSlot]))
				{
					formatex128("该装置的防具槽已被使用,请卸下 %i 号防具再使用",Item[ItemID][_EquipDressSlot]);
					SCM(playerid,-1,string128);
					return 1;
				}
				else
				{
				    new tItemKey[37],Float:tDurable,tGetTime;
					format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
					tDurable=PlayerInv[playerid][BagID][_Durable];
					tGetTime=PlayerInv[playerid][BagID][_GetTime];
				    if(ReduceAmountForPlayerInv(playerid,tItemKey,1))
				    {
				    	AddItemToPlayerEquip(playerid,tItemKey,tDurable,tGetTime);
					}
				}
	    	}
		    case ITEM_TYPE_CRAFT:
		    {
				formatex64("%s 只能用于建造建筑物,请按Y建点击 建造 按钮",Item[ItemID][_Name]);
				SCM(playerid,-1,string64);
		    }
		    case ITEM_TYPE_BOMB:
		    {
		        SPD(playerid,_SPD_BAG_USE_BOMB,DIALOG_STYLE_INPUT,"请设置爆炸倒计时","请选择倒计时时间[单位:秒]","选择","返回");
		    }
		}
 	}
	return 1;
}

FUNC::OnPlayerInvItemDrop(playerid,index)
{
    new VarString[64];
    GetPVarString(playerid,"_Bag_Click_Info",VarString,64);
    if(VerifyInvPVarData(playerid,VarString))
 	{
		new BagID,BagKey[37],ItemID;
		sscanf(VarString, "p<,>is[37]i",BagID,BagKey,ItemID);
		if(PlayerInv[playerid][BagID][_Amounts]>1&&Item[ItemID][_Overlap]==1)
		{
	    	formatex64("你的背包有多个 %s ,请输入丢弃的数量",Item[ItemID][_Name]);
	    	SPD(playerid,_SPD_BAG_DROP_AMOUNT,DIALOG_STYLE_INPUT,"请输入数量",string64,"选择","返回");
		}
		else
		{
			new tItemKey[37],Float:tDurable;
			format(tItemKey,sizeof(tItemKey),"%s",Item[ItemID][_Key]);
			tDurable=PlayerInv[playerid][BagID][_Durable];
		    if(ReduceAmountForPlayerInv(playerid,tItemKey,1))
		    {
		        new Float:InFrontPlayerPos[3];
		        /*if(Item[ItemID][_Overlap]==true)
		        {
		        	GetPlayerPos(playerid,PlayerPos[0],PlayerPos[1],PlayerPos[2]);
		        	new HaveSame=GetPlayerRangeSameItemPickup(playerid,tItemKey,3.5);
		        	if(HaveSame!=NONE)UpdatePickUpAmount(HaveSame,PickUp[HaveSame][_Amounts]+1);
					else
					{
				    	GetPointInFrontOfPlayer(playerid,PlayerPos[0],PlayerPos[1],3.0);
				    	CA_FindZ_For2DCoord(PlayerPos[0],PlayerPos[1],PlayerPos[2]);
				    	CreatePickUpData(tItemKey,1,tDurable,PlayerPos[0],PlayerPos[1],PlayerPos[2],0.0,0.0,0.0);
					}
		        }
		        else
		        {*/
		        GetRandomXYInFrontOfPlayer(playerid,InFrontPlayerPos[0],InFrontPlayerPos[1],3.0);
   				//GetPointInFrontOfPlayer(playerid,PlayerPos[0],PlayerPos[1],3.0);
	    		CA_FindZ_For2DCoord(InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2]);
                GetPosData(playerid);
				CreatePickUpData(tItemKey,1,tDurable,InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2],0.0,0.0,0.0,PlayerWorld[playerid],PlayerInterior[playerid],1);
	        	//}
			}
		}
 	}
	return 1;
}
FUNC::Float:GetPlayerMaxCapacity(playerid)//获取玩家最大负重
{
    new Float:Capacity=PLAYER_PRIAMRY_CAPACITY;
	Capacity+=Addition[playerid][_Weight];
	//Item[PlayerEquip[playerid][1][_ItemID]][_BuffEffect];
	printf("MaxCapacity:%f",Capacity);
    return Capacity;
}
FUNC::GetPlayerInvItemAmountByKey(playerid,Key[])
{
	new amount=0;
	foreach(new i:PlayerInv[playerid])
	{
	    if(isequal(PlayerInv[playerid][i][_ItemKey],Key,false))amount+=PlayerInv[playerid][i][_Amounts];
	}
	return amount;
}
FUNC::Float:GetPlayerCurrentCapacity(playerid)//获取玩家当前负重(库存+装备+武器)
{
    new Float:Capacity=0.0;
    if(Iter_Count(PlayerInv[playerid]))
    {
		foreach(new i:PlayerInv[playerid])
	   	{
	   	    Capacity+=Item[PlayerInv[playerid][i][_ItemID]][_Weight]*PlayerInv[playerid][i][_Amounts];
	   	}
   	}
   	printf("CurrentCapacity1:%f",Capacity);
    if(Iter_Count(PlayerEquip[playerid]))
    {
		foreach(new i:PlayerEquip[playerid])
	   	{
	   	    Capacity+=Item[PlayerEquip[playerid][i][_ItemID]][_Weight];
	   	}
   	}
   	printf("CurrentCapacity2:%f",Capacity);
    if(Iter_Count(PlayerWeapon[playerid]))
    {
		foreach(new i:PlayerWeapon[playerid])
	   	{
	   	    Capacity+=Item[PlayerWeapon[playerid][i][_ItemID]][_Weight];
	   	}
   	}
	printf("CurrentCapacity3:%f",Capacity);
   	return Capacity;
}
FUNC::AddItemToPlayerInv(playerid,ItemKey[],Amounts,Float:Durable,GetTime,bool:UseIt)//道具添加到背包
{
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-aitpi error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Amounts<1)return RETURN_SUCCESS;
	if(Iter_Count(PlayerInv[playerid])>=MAX_PLAYER_INV_SLOTS)
	{
	    formatex80("%i-aitpi error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	new bool:Update=false;
	if(Item[ItemID][_Overlap]==1)
   	{
		foreach(new i:PlayerInv[playerid])
	   	{
	   	    if(PlayerInv[playerid][i][_ItemID]==ItemID)
	   	    {
	   	        PlayerInv[playerid][i][_Amounts]+=Amounts;
	   	        if(PlayerInv[playerid][i][_QuickShow]!=NONE)UpdatePlayerQuickSlotAmount(playerid,PlayerInv[playerid][i][_QuickShow],PlayerInv[playerid][i][_Amounts]);
			    formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `物品数量` =  '%i' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_Amounts],PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
		        Update=true;
	   	    }
		}
	}
	if(!Update)
	{
		if(UseIt==true)
		{
            switch(Item[ItemID][_Type])
            {
                case ITEM_TYPE_WEAPON:
                {
                    if(!Iter_Contains(PlayerWeapon[playerid],Item[ItemID][_WeaponDressSlot]))
                    {
                        AddItemToPlayerWeapon(playerid,ItemKey,Durable,GetTime);
                        Amounts--;
                        //return RETURN_SUCCESS;
                    }
                }
                case ITEM_TYPE_EQUIP,ITEM_TYPE_COMMU:
                {
                    if(!Iter_Contains(PlayerEquip[playerid],Item[ItemID][_EquipDressSlot]))
                    {
                        AddItemToPlayerEquip(playerid,ItemKey,Durable,GetTime);
                        Amounts--;
                        //return RETURN_SUCCESS;
                    }
                }
            }
		}
		if(Amounts<=0)return RETURN_SUCCESS;
    	new i=Iter_Free(PlayerInv[playerid]);
    	format(PlayerInv[playerid][i][_AccountKey],UUID_LEN,Account[playerid][_Key]);
    	UUID(PlayerInv[playerid][i][_InvKey], UUID_LEN);
		format(PlayerInv[playerid][i][_ItemKey],UUID_LEN,ItemKey);
    	PlayerInv[playerid][i][_Amounts]=Amounts;
    	PlayerInv[playerid][i][_Durable]=Durable;
    	PlayerInv[playerid][i][_QuickShow]=NONE;
	   	if(GetTime==NONE)PlayerInv[playerid][i][_GetTime]=SERVER_RUNTIMES;
   		else PlayerInv[playerid][i][_GetTime]=GetTime;
    	PlayerInv[playerid][i][_ItemID]=ItemID;
        formatex512("INSERT INTO `"MYSQL_DB_INVENTORY"`(`归属密匙`,`背包密匙`,`物品密匙`,`物品数量`,`物品耐久`,`快捷位`,`获得时间`) VALUES ('%s','%s','%s','%i','%f','%i','%i')",PlayerInv[playerid][i][_AccountKey],PlayerInv[playerid][i][_InvKey],PlayerInv[playerid][i][_ItemKey],PlayerInv[playerid][i][_Amounts],PlayerInv[playerid][i][_Durable],NONE,PlayerInv[playerid][i][_GetTime]);
   		mysql_query(Account@Handle,string512,true);
        Iter_Add(PlayerInv[playerid],i);
	}
	if(InventoryTextDrawShow[playerid]==true)UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
	return RETURN_SUCCESS;
}
FUNC::DeleteAmountForInvByInvKey(playerid,InvKeyKey[],Amounts)//背包道具降低数量
{
    if(Amounts<1)return RETURN_SUCCESS;
    new bool:Update=false;
	foreach(new i:PlayerInv[playerid])
   	{
   	    if(isequal(PlayerInv[playerid][i][_InvKey],InvKeyKey,false))
   	    {
   	        if(PlayerInv[playerid][i][_Amounts]>Amounts)
   	        {
   	            PlayerInv[playerid][i][_Amounts]-=Amounts;
   	            if(PlayerInv[playerid][i][_QuickShow]!=NONE)UpdatePlayerQuickSlotAmount(playerid,PlayerInv[playerid][i][_QuickShow],PlayerInv[playerid][i][_Amounts]);
			    formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `物品数量` =  '%i' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_Amounts],PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
   	        }
   	        else
	   		{
	   		    if(PlayerInv[playerid][i][_QuickShow]!=NONE)UpdatePlayerQuickSlot(playerid,PlayerInv[playerid][i][_QuickShow],NONE);
	   		    formatex256("DELETE FROM `"MYSQL_DB_INVENTORY"` WHERE `背包密匙`='%s'",PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
    			new	cur = i;
   				Iter_SafeRemove(PlayerInv[playerid],cur,i);
 			}
   	        Update=true;
   	        break;
   	    }
   	}
	if(!Update)
	{
	    formatex80("%i-dafpibi error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	else
	{
		if(InventoryTextDrawShow[playerid]==true)UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
	}
	return RETURN_SUCCESS;
}
FUNC::ReduceAmountForPlayerInv(playerid,ItemKey[],Amounts)//背包道具降低数量
{
    new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-rafpi error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(Amounts<1)return RETURN_SUCCESS;
	new bool:Update=false;
	foreach(new i:PlayerInv[playerid])
   	{
   	    if(PlayerInv[playerid][i][_ItemID]==ItemID)
   	    {
   	        if(PlayerInv[playerid][i][_Amounts]>Amounts)
   	        {
   	            PlayerInv[playerid][i][_Amounts]-=Amounts;
   	            if(PlayerInv[playerid][i][_QuickShow]!=NONE)UpdatePlayerQuickSlotAmount(playerid,PlayerInv[playerid][i][_QuickShow],PlayerInv[playerid][i][_Amounts]);
			    formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `物品数量` =  '%i' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_Amounts],PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
   	        }
   	        else
	   		{
	   		    if(PlayerInv[playerid][i][_QuickShow]!=NONE)UpdatePlayerQuickSlot(playerid,PlayerInv[playerid][i][_QuickShow],NONE);
	   		    formatex256("DELETE FROM `"MYSQL_DB_INVENTORY"` WHERE `背包密匙`='%s'",PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
    			new	cur = i;
   				Iter_SafeRemove(PlayerInv[playerid],cur,i);
 			}
   	        Update=true;
   	        break;
   	    }
	}
	if(!Update)
	{
	    formatex80("%i-rafpi error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	else
	{
		if(InventoryTextDrawShow[playerid]==true)UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
	}
	return RETURN_SUCCESS;
}
FUNC::ReduceDurableForPlayerInv(playerid,ItemKey[],Float:Durable)//背包道具降低耐久
{
    new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-rdfpi error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Item[ItemID][_Durable]==0)return RETURN_SUCCESS;
    if(Durable<=0.0)return RETURN_SUCCESS;
	new bool:Update=false;
	foreach(new i:PlayerInv[playerid])
   	{
   	    if(PlayerInv[playerid][i][_ItemID]==ItemID)
   	    {
   	        if(PlayerInv[playerid][i][_Durable]>Durable)
   	        {
   	            PlayerInv[playerid][i][_Durable]-=Durable;
			    formatex256("UPDATE `"MYSQL_DB_INVENTORY"` SET  `物品耐久` =  '%0.1f' WHERE  `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_Durable],PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
   	        }
   	        else
	   		{
	   		    formatex256("DELETE FROM `"MYSQL_DB_INVENTORY"` WHERE `背包密匙`='%s'",PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string256,false);
    			new	cur = i;
   				Iter_SafeRemove(PlayerInv[playerid],cur,i);
 			}
   	        Update=true;
   	    }
	}
	if(!Update)
	{
	    formatex80("%i-rdfpi error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	else
	{
		if(InventoryTextDrawShow[playerid]==true)UpdatePlayerInvPage(playerid,PlayerInvPreviePage[playerid],PlayerInvPrevieSortType[playerid]);
	}
	return RETURN_SUCCESS;
}
FUNC::GetPlayerInvIDByInvKey(playerid,InvKey[])
{
	new InvID=NONE;
	foreach(new i:PlayerInv[playerid])
	{
		if(isequal(PlayerInv[playerid][i][_InvKey],InvKey,false))
		{
			InvID=i;
		}
	}
	return InvID;
}
FUNC::GetItemIDByItemKey(ItemKey[])//通过密匙查询物品ID
{
	new ItemID=NONE;
	foreach(new i:Item)
	{
		if(isequal(Item[i][_Key],ItemKey,false))ItemID=i;
	}
	return ItemID;
}
FUNC::LoadPlayerInventory(playerid)//读取玩家背包
{
	formatex128("SELECT * FROM `"MYSQL_DB_INVENTORY"` WHERE `归属密匙`='%s'",Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,true);
//    mysql_tquery(Account@Handle,string128, "OnPlayerInventoryLoad", "i",playerid);
//	return 1;
//}
//FUNC::OnPlayerInventoryLoad(playerid)
//{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_INV_SLOTS)
	    {
            cache_get_field_content(i,"归属密匙",PlayerInv[playerid][i][_AccountKey],Account@Handle,37);
            cache_get_field_content(i,"背包密匙",PlayerInv[playerid][i][_InvKey],Account@Handle,37);
            cache_get_field_content(i,"物品密匙",PlayerInv[playerid][i][_ItemKey],Account@Handle,37);
	    	PlayerInv[playerid][i][_Amounts]=cache_get_field_content_int(i,"物品数量",Account@Handle);
	    	PlayerInv[playerid][i][_Durable]=cache_get_field_content_float(i,"物品耐久",Account@Handle);
	    	PlayerInv[playerid][i][_QuickShow]=cache_get_field_content_int(i,"快捷位",Account@Handle);
            PlayerInv[playerid][i][_GetTime]=cache_get_field_content_int(i,"获得时间",Account@Handle);
            new GetItemID=GetItemIDByItemKey(PlayerInv[playerid][i][_ItemKey]);
			if(GetItemID==NONE)
	    	{
	    	    formatex128("DELETE FROM `"MYSQL_DB_INVENTORY"` WHERE `"MYSQL_DB_INVENTORY"`.`背包密匙` ='%s'",PlayerInv[playerid][i][_InvKey]);
				mysql_query(Account@Handle,string128,false);
				printf("%s 背包,背包密匙-[%s] 物品密匙-[%s]异常,已删除",Account[playerid][_Name],PlayerInv[playerid][i][_InvKey],PlayerInv[playerid][i][_ItemKey]);
	    	}
	    	else
	    	{
	    	    PlayerInv[playerid][i][_ItemID]=GetItemID;
				Iter_Add(PlayerInv[playerid],i);
				printf("%s 背包,背包密匙-[%s] 物品密匙-[%s] [%s]",Account[playerid][_Name],PlayerInv[playerid][i][_InvKey],PlayerInv[playerid][i][_ItemKey],Item[GetItemID][_Name]);
			}
		}
		else
		{
		    printf("%s 背包溢出",Account[playerid][_Name]);
			break;
		}
	}
	return 1;
}
FUNC::RestPlayerInventory(playerid)
{
   	Iter_Clear(PlayerInv[playerid]);
	return 1;
}
stock ShowPlayerInventoryList(playerid,pager)
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_INV_SLOTS],Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(PlayerInv[playerid]);
	foreach(new i:PlayerInv[playerid])
    {
        HighestTopList(i,PlayerInv[playerid][i][_GetTime],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
	    //DialogBoxSelect[playerid][DialogBoxID[playerid]]=false;
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,PlayerInv[playerid][Project_ID[i]][_InvKey]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "道具名称\t拥有数量\t选择状态\t寄送数量\n");
	strcat(BodyStr, "\t完成选择\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
		    if(DialogBoxInvSelect[playerid][i]==true)
		    {
				format(TempStr,sizeof(TempStr),"%s\t%i\t√\t%i\n",Item[PlayerInv[playerid][index][_ItemID]][_Name],PlayerInv[playerid][index][_Amounts],DialogBoxInvAmount[playerid][i]);
		    }
		    else
		    {
		        format(TempStr,sizeof(TempStr),"%s\t%i\t　\t　\n",Item[PlayerInv[playerid][index][_ItemID]][_Name],PlayerInv[playerid][index][_Amounts]);
		    }
        }
		if(i>=DialogBoxID[playerid])
		{
			end=1;
			break;
		}
		else strcat(BodyStr,TempStr);
	}
	if(!end)strcat(BodyStr, "\t下一页\n");
    return BodyStr;
}
FUNC::GetPlayerInvBoxSelectAmount(playerid)
{
	new Amount=0;
	forex(i,MAX_DIALOG_BOX_ITEMS)
	{
		if(DialogBoxInvSelect[playerid][i]==true)Amount++;
	}
	return Amount;
}


