FUNC::CompositeCraftThingsForPlayer(playerid,index)
{
    if(CraftTextDrawShow[playerid]==true)
    {
		new index1=0,NeedthingKey[37],NeedthingAmount=0,NeedThings[MAX_CRAFT_USE_AMOUNT];
		forex(i,MAX_CRAFT_USE_AMOUNT)NeedThings[i]=0;
	    forex(i,10)
	    {
	    	formatex64("%s",StrtokPack1(CraftItem[index][_NeedThing],index1));
	    	if(strval(string64)!=-1)
	    	{
	    	    new index2=0;
	    	    format(NeedthingKey,sizeof(NeedthingKey),StrtokPack2(string64,index2));
	    	    NeedthingAmount=strval(StrtokPack2(string64,index2));
	    	    forex(s,MAX_CRAFT_USE_AMOUNT)
	    	    {
	    	        formatex32("A008_%03d",s);
	    	        if(isequal(NeedthingKey,string32,false))
					{
						NeedThings[s]+=NeedthingAmount;
					}
	    	    }
	    	}
	    }
	    new HaveThings[MAX_CRAFT_USE_AMOUNT];
		forex(i,MAX_CRAFT_USE_AMOUNT)
		{
		    formatex32("A008_%03d",i);
		    HaveThings[i]=GetPlayerInvItemAmountByKey(playerid,string32);
		}
		new bool:Conditional=true;
	    forex(i,MAX_CRAFT_USE_AMOUNT)
	    {
	        if(NeedThings[i]>0)
			{
		        if(NeedThings[i]>HaveThings[i])
		        {
		            formatex32("A008_%03d",i);
		            formatex64("你还缺少 %i 个 %s",NeedThings[i]-HaveThings[i],Item[GetItemIDByItemKey(string32)][_Name]);
		            SCM(playerid,-1,string64);
		            Conditional=false;
		        }
	        }
	    }
	    if(Conditional==true)
	    {
	        new bool:ReduceSuccess=true;
		    forex(i,MAX_CRAFT_USE_AMOUNT)
		    {
		        if(NeedThings[i]>0)
				{
				    formatex32("A008_%03d",i);
		        	if(ReduceAmountForPlayerInv(playerid,string32,NeedThings[i])!=RETURN_SUCCESS)
		        	{
		        	    ReduceSuccess=false;
		        	}
		        }
			}
			if(ReduceSuccess==true)
			{
	    		SCM(playerid,-1,"合成成功,该建筑品已送入你的建筑背包");
	    		ShowCraftItemHaveThings(playerid);
	    		CreateCraftBulidData(playerid,CraftItem[index][_Key]);
	    		//AddItemToPlayerCraftInv(playerid,CraftItem[index][_Key],1,SERVER_RUNTIMES);
	    	}
	    	else
	    	{
	    	    ShowCraftItemHaveThings(playerid);
			    formatex80("%i-cctfp error0",playerid);
		        Debug(playerid,string80);
				return 1;
	    	}
	    }
    }
	return 1;
}
FUNC::GetCraftItemIDByCraftItemKey(ItemKey[])//通过密匙查询物品ID
{
	new ItemID=NONE;
	foreach(new i:CraftItem)
	{
		if(isequal(CraftItem[i][_Key],ItemKey,false))ItemID=i;
	}
	return ItemID;
}
FUNC::Craft_OnShootDynamicObject(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z)
{
    if(RealPlayer(playerid))
    {
		if(weaponid>=0&&weaponid<sizeof(s_WeaponDamage))
		{
		    new CraftID=GetCraftBulidIDbyObject(objectid);
		    if(CraftID!=NONE)
			{
				CraftBulid[CraftID][_Chp]-=floatdiv(s_WeaponDamage[weaponid],3.0);
			    if(CraftBulid[CraftID][_Chp]<=0.0)DestoryCraftBulid(CraftID);
			    else 
			    {
			        if(IsValidDynamic3DTextLabel(CraftBulid[CraftID][_C3dtext]))
			        {
			        	UpdateCraftBulidText(CraftID);
					}
				}
    			return true;
			}
		}
    }
	return false;
}
FUNC::UpdateCraftBulidText(index)
{
	if(IsValidDynamic3DTextLabel(CraftBulid[index][_C3dtext]))
	{
   		formatex64("%04d\nHP:%0.1f%\n{C0C0C0}%s",index,floatmul(floatdiv(CraftBulid[index][_Chp],CraftBulid[index][_Cmhp]),100),CraftBulid[index][_CName]);
		UpdateDynamic3DTextLabelText(CraftBulid[index][_C3dtext],0x808080C8,string64);
	}
	return 1;
}
/*******************************************************/
FUNC::GetCraftBulidIDbyObject(objectid)
{
 	new ObjectIndex=GetDynamicObjectIndexByObjectID(objectid);
	if(ObjectIndex!=NONE)
	{
		foreach(new i:CraftBulid)
		{
			if(CraftBulid[i][_CobjectIndex]==ObjectIndex)return i;
		}
	}
	return NONE;
}
FUNC::CreateCraftBulidData(playerid,ItemKey[])
{
    new ItemID=GetCraftItemIDByCraftItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-ccb error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Iter_Count(CraftBulid)>=MAX_CRAFTBULIDS)
	{
	    formatex80("%i-ccb error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(CraftBulid);
    format(CraftBulid[i][_CreaterKey],UUID_LEN,Account[playerid][_Key]);
    format(CraftBulid[i][_CraftItemKey],UUID_LEN,ItemKey);
    UUID(CraftBulid[i][_Key], UUID_LEN);
    format(CraftBulid[i][_CName],16,"　");
    
    new Float:InfrontPos[2],Float:PlayerPosZ;
    GetPlayerPos(playerid,InfrontPos[0],InfrontPos[1],PlayerPosZ);
    GetRandomXYInFrontOfPlayer(playerid,InfrontPos[0],InfrontPos[1],3.0);
    CraftBulid[i][_Chp]=100.0;
    CraftBulid[i][_Cmhp]=100.0;
    CraftBulid[i][_CraftWorld]=GetPlayerVirtualWorld(playerid);
    CraftBulid[i][_Cx]=InfrontPos[0];
    CraftBulid[i][_Cy]=InfrontPos[1];
    CraftBulid[i][_Cz]=PlayerPosZ+0.5;
    CraftBulid[i][_Crx]=0.0;
    CraftBulid[i][_Cry]=0.0;
    CraftBulid[i][_Crz]=0.0;
    CraftBulid[i][_Cmove]=0;
    CraftBulid[i][_CDelaymove]=0;
    CraftBulid[i][_Cmx]=0.0;
    CraftBulid[i][_Cmy]=0.0;
    CraftBulid[i][_Cmz]=0.0;
    CraftBulid[i][_Cmrx]=0.0;
    CraftBulid[i][_Cmry]=0.0;
    CraftBulid[i][_Cmrz]=0.0;
    CraftBulid[i][_Cspeed]=0.0;
    CraftBulid[i][_CraftItemID]=ItemID;
    CraftBulid[i][_CcapacityLevel]=0;
    Iter_Add(CraftBulid,i);
    formatex512("INSERT INTO `"MYSQL_DB_CRAFTBULID"`(`密匙`,`创建者密匙`,`建筑表密匙`,`世界`,`X坐标`,`Y坐标`,`Z坐标`,`血量`,`最大血量`) VALUES ('%s','%s','%s','%i','%f','%f','%f','%f','%f')",CraftBulid[i][_Key],CraftBulid[i][_CreaterKey],CraftBulid[i][_CraftItemKey],CraftBulid[i][_CraftWorld],InfrontPos[0],InfrontPos[1],PlayerPosZ+0.5,CraftBulid[i][_Chp],CraftBulid[i][_Cmhp]);
   	mysql_query(Account@Handle,string512,true);
   	CreateCraftBulidModel(i);
	return RETURN_SUCCESS;
}
FUNC::CreateCraftBulidModel(index)
{
    CraftBulid[index][_CobjectIndex]=CA_CreateDynamicObject_DC(\
	CraftItem[CraftBulid[index][_CraftItemID]][_ModelID],\
	 CraftBulid[index][_Cx],\
	 CraftBulid[index][_Cy],\
	 CraftBulid[index][_Cz],\
	 CraftBulid[index][_Crx],\
	 CraftBulid[index][_Cry],\
	 CraftBulid[index][_Crz],\
	 CraftBulid[index][_CraftWorld],\
	 .streamdistance = 300.0);
    formatex64("%04d\nHP:%0.1f%\n{C0C0C0}%s",index,floatmul(floatdiv(CraftBulid[index][_Chp],CraftBulid[index][_Cmhp]),100),CraftBulid[index][_CName]);
    CraftBulid[index][_C3dtext]=CreateDynamic3DTextLabel(string64,\
	0x808080C8,\
	CraftBulid[index][_Cx],\
	CraftBulid[index][_Cy],\
	CraftBulid[index][_Cz],\
	10.0,\
	INVALID_PLAYER_ID,\
	INVALID_VEHICLE_ID,\
	0,\
	CraftBulid[index][_CraftWorld]);
	CraftBulid[index][_CareaID]=CreateDynamicSphere(CraftBulid[index][_Cx],CraftBulid[index][_Cy],CraftBulid[index][_Cz],10.0,CraftBulid[index][_CraftWorld]);
	CraftBulid[index][_CfindareaID]=CreateDynamicSphere(CraftBulid[index][_Cx],CraftBulid[index][_Cy],CraftBulid[index][_Cz],7.0,CraftBulid[index][_CraftWorld]);
    CraftBulid[index][_CMoveAreaID]=CreateDynamicSphere(CraftBulid[index][_Cx],CraftBulid[index][_Cy],CraftBulid[index][_Cz],CraftBulid[index][_Cmdistance],CraftBulid[index][_CraftWorld]);
    CraftBulid[index][_CraftMoveIng]=0;
    CraftBulid[index][Timer:_DelayMove]=NONE;
 	UpdateStreamer(CraftBulid[index][_Cx],CraftBulid[index][_Cy],CraftBulid[index][_Cz],CraftBulid[index][_CraftWorld]);
	return RETURN_SUCCESS;
}
FUNC::DestoryCraftBulidModel(index)
{
	if(!Iter_Contains(CraftBulid,index))
	{
	    formatex80("%i-dcbm error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	CA_DestroyObject_DC(CraftBulid[index][_CobjectIndex]);
	CraftBulid[index][_CobjectIndex]=INVALID_STREAMER_ID;
	DestroyDynamic3DTextLabel(CraftBulid[index][_C3dtext]);
	CraftBulid[index][_C3dtext]=Text3D:INVALID_STREAMER_ID;
	DestroyDynamicArea(CraftBulid[index][_CareaID]);
	CraftBulid[index][_CareaID]=INVALID_STREAMER_ID;
	DestroyDynamicArea(CraftBulid[index][_CfindareaID]);
	CraftBulid[index][_CfindareaID]=INVALID_STREAMER_ID;
	DestroyDynamicArea(CraftBulid[index][_CMoveAreaID]);
	CraftBulid[index][_CMoveAreaID]=INVALID_STREAMER_ID;
    if(CraftBulid[index][Timer:_DelayMove]!=NONE)KillTimer(CraftBulid[index][Timer:_DelayMove]);
    CraftBulid[index][Timer:_DelayMove]=NONE;
	CraftBulid[index][_CraftMoveIng]=0;
	return 1;
}
FUNC::DestoryCraftBulid(index)
{
	if(!Iter_Contains(CraftBulid,index))
	{
	    formatex80("%i-dcb error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	DestoryCraftBulidModel(index);
	
	formatex128("DELETE FROM `"MYSQL_DB_CRAFTBULID"` WHERE `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[index][_Key]);
	mysql_query(Account@Handle,string128,false);
	
	Iter_Remove(CraftBulid,index);
	return RETURN_SUCCESS;
}

FUNC::LoadCraftBulids()//读取建筑
{
    RestCraftBulids();
	formatex128("SELECT * FROM `"MYSQL_DB_CRAFTBULID"`");
    mysql_tquery(Account@Handle,string128, "OnCraftBulidsLoad");
	return 1;
}
FUNC::OnCraftBulidsLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_CRAFTBULIDS)
	    {
            cache_get_field_content(i,"密匙",CraftBulid[i][_Key],Account@Handle,37);
            cache_get_field_content(i,"创建者密匙",CraftBulid[i][_CreaterKey],Account@Handle,37);
            cache_get_field_content(i,"建筑表密匙",CraftBulid[i][_CraftItemKey],Account@Handle,37);
            cache_get_field_content(i,"别名",CraftBulid[i][_CName],Account@Handle,16);

	    	CraftBulid[i][_CraftWorld]=cache_get_field_content_int(i,"世界",Account@Handle);
			CraftBulid[i][_Cx]=cache_get_field_content_float(i,"X坐标",Account@Handle);
			CraftBulid[i][_Cy]=cache_get_field_content_float(i,"Y坐标",Account@Handle);
			CraftBulid[i][_Cz]=cache_get_field_content_float(i,"Z坐标",Account@Handle);
			CraftBulid[i][_Crx]=cache_get_field_content_float(i,"RX坐标",Account@Handle);
			CraftBulid[i][_Cry]=cache_get_field_content_float(i,"RY坐标",Account@Handle);
			CraftBulid[i][_Crz]=cache_get_field_content_float(i,"RZ坐标",Account@Handle);
			CraftBulid[i][_Cmx]=cache_get_field_content_float(i,"移动X坐标",Account@Handle);
			CraftBulid[i][_Cmy]=cache_get_field_content_float(i,"移动Y坐标",Account@Handle);
			CraftBulid[i][_Cmz]=cache_get_field_content_float(i,"移动Z坐标",Account@Handle);
			CraftBulid[i][_Cmrx]=cache_get_field_content_float(i,"移动RX坐标",Account@Handle);
			CraftBulid[i][_Cmry]=cache_get_field_content_float(i,"移动RY坐标",Account@Handle);
			CraftBulid[i][_Cmrz]=cache_get_field_content_float(i,"移动RZ坐标",Account@Handle);
			CraftBulid[i][_Cspeed]=cache_get_field_content_float(i,"速度",Account@Handle);
			CraftBulid[i][_Cmove]=cache_get_field_content_int(i,"是否移动",Account@Handle);
            CraftBulid[i][_CDelaymove]=cache_get_field_content_int(i,"移动延时",Account@Handle);
            CraftBulid[i][_Cmdistance]=cache_get_field_content_float(i,"移动范围",Account@Handle);
			CraftBulid[i][_Chp]=cache_get_field_content_float(i,"血量",Account@Handle);
			CraftBulid[i][_Cmhp]=cache_get_field_content_float(i,"最大血量",Account@Handle);
			CraftBulid[i][_CcapacityLevel]=cache_get_field_content_int(i,"容量等级",Account@Handle);
			CraftBulid[i][_CraftMoveIng]=0;
			CraftBulid[i][Timer:_DelayMove]=NONE;
            new GetItemID=GetCraftItemIDByCraftItemKey(CraftBulid[i][_CraftItemKey]);
			if(GetItemID==NONE)
	    	{
	    	    formatex128("DELETE FROM `"MYSQL_DB_CRAFTBULID"` WHERE `"MYSQL_DB_CRAFTBULID"`.`密匙` ='%s'",CraftBulid[i][_Key]);
				mysql_query(Account@Handle,string128,false);
				printf("建筑密匙-[%s]异常,已删除",CraftBulid[i][_Key]);
	    	}
	    	else
	    	{
	    	    CraftBulid[i][_CraftItemID]=GetItemID;
				Iter_Add(CraftBulid,i);
				printf("建筑密匙-[%s]",CraftBulid[i][_Key]);
				
			}
		}
		else
		{
		    printf("建筑溢出");
			break;
		}
	}
	if(Iter_Count(CraftBulid)>0)
	{
	    foreach(new i:CraftBulid)CreateCraftBulidModel(i);
	}
	SeverState[_ServerRun]=true;
	return 1;
}
FUNC::RestCraftBulids()
{
   	Iter_Clear(CraftBulid);
	return 1;
}
FUNC::bool:VerifyBuildPVarData(playerid,VarString[])
{
	new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
    if(sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","OBJ数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(CraftBulid,BulidID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","OBJ已失效,请重新选择","了解","");
        return false;
	}
/*    if(DomainEnter[playerid][_EditID]!=BulidID)
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","OBJ数据验证失败,请重新选择","了解","");
        return false;
	}*/
    if(!isequal(CraftBulid[BulidID][_Key],CraftBulidKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#3]","OBJ数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}


FUNC::LoadCraftBulidInv()//读取建筑保险箱库存
{
    RestCraftBulidInv();
	formatex128("SELECT * FROM `"MYSQL_DB_CRAFTBULID_INV"`");
    mysql_tquery(Account@Handle,string128, "OnCraftBulidInvLoad");
	return 1;
}
FUNC::OnCraftBulidInvLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_CRAFTBULID_INV_THINGS)
	    {
            cache_get_field_content(i,"密匙",CraftBulidInv[i][_Key],Account@Handle,37);
            cache_get_field_content(i,"建筑密匙",CraftBulidInv[i][_CraftBulidKey],Account@Handle,37);
            cache_get_field_content(i,"道具密匙",CraftBulidInv[i][_ItemKey],Account@Handle,37);
	    	CraftBulidInv[i][_Amounts]=cache_get_field_content_int(i,"数量",Account@Handle);
	    	CraftBulidInv[i][_GetTime]=cache_get_field_content_int(i,"获得时间",Account@Handle);
			CraftBulidInv[i][_Durable]=cache_get_field_content_float(i,"耐久",Account@Handle);
            new GetItemID=GetItemIDByItemKey(CraftBulidInv[i][_ItemKey]);
			if(GetItemID==NONE)
	    	{
	    	    formatex128("DELETE FROM `"MYSQL_DB_CRAFTBULID_INV"` WHERE `"MYSQL_DB_CRAFTBULID_INV"`.`密匙` ='%s'",CraftBulidInv[i][_Key]);
				mysql_query(Account@Handle,string128,false);
				printf("建筑库存密匙-[%s]异常,已删除",CraftBulidInv[i][_Key]);
	    	}
	    	else
	    	{
	    	    CraftBulidInv[i][_ItemID]=GetItemID;
				Iter_Add(CraftBulidInv,i);
				printf("建筑库存密匙-[%s]",CraftBulidInv[i][_Key]);

			}
		}
		else
		{
		    printf("建筑库存溢出");
			break;
		}
	}
	return 1;
}
FUNC::RestCraftBulidInv()
{
   	Iter_Clear(CraftBulidInv);
	return 1;
}
FUNC::CraftBulidStartMove(index)
{
	CA_MoveObject_DC(CraftBulid[index][_CobjectIndex],\
						CraftBulid[index][_Cx],\
						CraftBulid[index][_Cy],\
						CraftBulid[index][_Cz],\
						CraftBulid[index][_Cspeed],\
						CraftBulid[index][_Crx],\
						CraftBulid[index][_Cry],\
						CraftBulid[index][_Crz]);
	CraftBulid[index][_CraftMoveIng]=2;
    if(CraftBulid[index][Timer:_DelayMove]!=NONE)KillTimer(CraftBulid[index][Timer:_DelayMove]);
    CraftBulid[index][Timer:_DelayMove]=NONE;
	return 1;
}
FUNC::AddItemToCraftBulidInv(playerid,bulidid,ItemKey[],Amounts,Float:Durable,GetTime)//道具添加到建筑箱子
{
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-aitcbi error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Amounts<1)return RETURN_SUCCESS;
	if(Amounts>999)return RETURN_ERROR;
	if(Iter_Count(CraftBulidInv)>=MAX_CRAFTBULID_INV_THINGS)
	{
	    formatex80("%i-aitcbi error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    //if(GetCraftBulidInvItemAmounts(bulidid)>CraftItem[CraftBulid[bulidid][_CraftItemID]][_Capacity])return RETURN_ERROR;
	if(GetCraftBulidInvItems(bulidid)>=CraftBulid[bulidid][_CcapacityLevel]*6)return RETURN_ERROR;
	new bool:Update=false;
	if(Item[ItemID][_Overlap]==1)
   	{
		foreach(new i:CraftBulidInv)
	   	{
	   	    if(CraftBulidInv[i][_ItemID]==ItemID)
	   	    {
	   	        if(CraftBulidInv[i][_Amounts]>999)
	   	        {
	   	            return RETURN_ERROR;
	   	        }
	   	        CraftBulidInv[i][_Amounts]+=Amounts;
			    formatex256("UPDATE `"MYSQL_DB_CRAFTBULID_INV"` SET  `数量` =  '%i' WHERE  `"MYSQL_DB_CRAFTBULID_INV"`.`密匙` ='%s'",CraftBulidInv[i][_Amounts],CraftBulidInv[i][_Key]);
				mysql_query(Account@Handle,string256,false);
		        Update=true;
	   	    }
		}
	}
	if(!Update)
	{
		if(Amounts<=0)return RETURN_SUCCESS;
    	new i=Iter_Free(CraftBulidInv);
    	format(CraftBulidInv[i][_CraftBulidKey],UUID_LEN,CraftBulid[bulidid][_Key]);
    	UUID(CraftBulidInv[i][_Key], UUID_LEN);
		format(CraftBulidInv[i][_ItemKey],UUID_LEN,ItemKey);
    	CraftBulidInv[i][_Amounts]=Amounts;
    	CraftBulidInv[i][_Durable]=Durable;
	   	if(GetTime==NONE)CraftBulidInv[i][_GetTime]=SERVER_RUNTIMES;
   		else CraftBulidInv[i][_GetTime]=GetTime;
    	CraftBulidInv[i][_ItemID]=ItemID;
        formatex512("INSERT INTO `"MYSQL_DB_CRAFTBULID_INV"`(`密匙`,`建筑密匙`,`道具密匙`,`数量`,`耐久`,`获得时间`) VALUES ('%s','%s','%s','%i','%f','%i')",\
		CraftBulidInv[i][_Key],\
		CraftBulidInv[i][_CraftBulidKey],\
		CraftBulidInv[i][_ItemKey],\
		CraftBulidInv[i][_Amounts],\
		CraftBulidInv[i][_Durable],\
		CraftBulidInv[i][_GetTime]);
   		mysql_query(Account@Handle,string512,true);
        Iter_Add(CraftBulidInv,i);
	}
    if(StrongBoxTextDrawShow[playerid]==true)
    {
        UpdateStrongBoxPage(playerid,bulidid,1);
    }
	return RETURN_SUCCESS;
}
FUNC::GetCraftBulidInvItems(bulidid)
{
	new Amounts=0;
	foreach(new i:CraftBulidInv)
	{
	    if(isequal(CraftBulidInv[i][_CraftBulidKey],CraftBulid[bulidid][_Key],false))Amounts++;
	}
	return Amounts;
}
FUNC::GetCraftBulidInvItemAmounts(bulidid)
{
	new Amounts=0;
	foreach(new i:CraftBulidInv)
	{
	    if(isequal(CraftBulidInv[i][_CraftBulidKey],CraftBulid[bulidid][_Key],false))
		{
		    Amounts+=CraftBulidInv[i][_Amounts];
		}
	}
	return Amounts;
}
FUNC::ReduceAmountForCraftBulidInv(playerid,bulidid,ItemKey[],Amounts)//背包道具降低数量
{
    new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-rafcbi error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(Amounts<1)return RETURN_SUCCESS;
	new bool:Update=false;
	foreach(new i:CraftBulidInv)
   	{
   	    if(CraftBulidInv[i][_ItemID]==ItemID)
   	    {
   	        if(isequal(CraftBulidInv[i][_CraftBulidKey],CraftBulid[bulidid][_Key],false))
   	        {
	   	        if(CraftBulidInv[i][_Amounts]>Amounts)
	   	        {
	   	            CraftBulidInv[i][_Amounts]-=Amounts;
				    formatex256("UPDATE `"MYSQL_DB_CRAFTBULID_INV"` SET  `数量` =  '%i' WHERE  `"MYSQL_DB_CRAFTBULID_INV"`.`密匙` ='%s'",CraftBulidInv[i][_Amounts],CraftBulidInv[i][_Key]);
					mysql_query(Account@Handle,string256,false);
	   	        }
	   	        else
		   		{
		   		    formatex256("DELETE FROM `"MYSQL_DB_CRAFTBULID_INV"` WHERE `密匙`='%s'",CraftBulidInv[i][_Key]);
					mysql_query(Account@Handle,string256,false);
	    			new	cur = i;
	   				Iter_SafeRemove(CraftBulidInv,cur,i);
	 			}
	   	        Update=true;
   	        }
   	    }
	}
	if(!Update)
	{
	    formatex80("%i-rafcbi error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(StrongBoxTextDrawShow[playerid]==true)
    {
        UpdateStrongBoxPage(playerid,bulidid,1);
    }
	return RETURN_SUCCESS;
}
FUNC::OnPlayerClickStrongBoxBotton(playerid,Bulid,index)
{
	new BulidInv=StrongBoxPrevieBox[playerid][index];
	new ItemID=CraftBulidInv[BulidInv][_ItemID];
    formatex128("%i,%s,%i,%s,%i",Bulid,CraftBulid[Bulid][_Key],BulidInv,CraftBulidInv[BulidInv][_Key],ItemID);
    if(VerifyStrongBoxPVarData(playerid,string128)==true)
    {
       	formatex32("%s",Item[ItemID][_Name]);
	    SPD(playerid,_SPD_STRONGBOX_USE,DIALOG_STYLE_LIST,string32,STRONGBOX_USE_PANEL,"确定","取消");
    	SetPVarString(playerid,"_StrongBox_Click_Info",string128);
    }
	return 1;
}
FUNC::bool:VerifyStrongBoxPVarData(playerid,VarString[])
{
	new BulidID,BulidKey[37],BulidInv,BulidInvKey[37],ItemID;
    if(sscanf(VarString, "p<,>is[37]is[37]i",BulidID,BulidKey,BulidInv,BulidInvKey,ItemID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(CraftBulid,BulidID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该建筑已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(CraftBulid[BulidID][_Key],BulidKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(CraftBulidInv,BulidInv))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#3]","该建筑保险箱项目已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(CraftBulidInv[BulidInv][_Key],BulidInvKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#4]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
FUNC::OnPlayerClickStrongBoxLock(playerid,index)
{
    formatex64("%i,%s",index,CraftBulid[index][_Key]);
	if(VerifyCraftBulidPVarData(playerid,string64)==true)
	{
	    if(CraftBulid[index][_CcapacityLevel]<5)
	    {
			SPD(playerid,_SPD_STRONGBOX_CAP,DIALOG_STYLE_MSGBOX,"开通存储方格","是否开通一排[6位]存储方格","是的","返回");
            SetPVarString(playerid,"_CraftBulid_Click_Info",string64);
	    }
	    else
	    {
            SCM(playerid,-1,"该保险箱格数已全部开通");
	    }
    }
	return 1;
}

FUNC::bool:VerifyCraftBulidPVarData(playerid,VarString[])
{
	new BulidID,BulidKey[37];
    if(sscanf(VarString, "p<,>is[37]",BulidID,BulidKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(CraftBulid,BulidID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该建筑已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(CraftBulid[BulidID][_Key],BulidKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
FUNC::StrBox_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_SECONDARY_ATTACK))
    {
        if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
        {
            if(GetTickCount()-PlayerStrongBoxDalay[playerid]>=1000)
	        {
	            PlayerStrongBoxDalay[playerid]=GetTickCount();
	            new index=GetNearstStrongBox(playerid);
	            if(index!=NONE)
				{
			    	switch(GetPlayerInDomainState(playerid))
					{
					    case PLAYER_DOMAIN_NONE:
						{
						    SCM(playerid,-1,"这不是领地区域");
							return true;
						}
					    case PLAYER_DOMAIN_OTHER:
						{
							SCM(playerid,-1,"这是别人的领地,你不能操作!");
							return true;
						}
					    case PLAYER_DOMAIN_FACTION_FORBID:
						{
						    SCM(playerid,-1,"这是阵营领地,你没有权限操作1!");
							return true;
						}
					    case PLAYER_DOMAIN_FACTION_OTHER:
						{
						    SCM(playerid,-1,"这是阵营领地,你没有权限操作2!");
							return true;
						}
					}
				    ShowPlayerStrongBoxTextDraw(playerid,index);
				}
			}
        }
    }
    return 1;
}
FUNC::GetNearstStrongBox(playerid)
{
    if(Iter_Count(CraftBulid)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:CraftBulid)
	{
	    if(CraftItem[CraftBulid[i][_CraftItemID]][_Type]==CRAFT_TPYE_COFFER)
	    {
			if(IsPlayerInDynamicArea(playerid,CraftBulid[i][_CfindareaID]))
			{
				new Float:x1, Float:y1, Float:z1;
				GetPlayerPos(playerid, x1, y1, z1);
				dis2 = floatsqroot(floatpower(floatabs(floatsub(CraftBulid[i][_Cx],x1)),2)+floatpower(floatabs(floatsub(CraftBulid[i][_Cy],y1)),2)+floatpower(floatabs(floatsub(CraftBulid[i][_Cz],z1)),2));
				if(dis2<dis&&dis2 != -1.00)
				{
					dis=dis2;
					index=i;
				}
			}
		}
	}
	return index;
}
stock ShowPlayerNearStrongBox(playerid,pager)
{
    DialogBoxID[playerid]=1;
	foreach(new i:CraftBulid)
    {
	    if(CraftItem[CraftBulid[i][_CraftItemID]][_Type]==CRAFT_TPYE_COFFER)
	    {
			if(IsPlayerInDynamicArea(playerid,CraftBulid[i][_CfindareaID]))
			{
			    if(i<MAX_DIALOG_BOX_ITEMS)
			    {
					DialogBox[playerid][DialogBoxID[playerid]]=i;
					format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,CraftBulid[i][_Key]);
					DialogBoxID[playerid]++;
				}
			}
		}
    }
    new BodyStr[1024],TempStr[64],end=0,index;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    if(pager<1)pager=1;
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "编号\t可用空间\t距离\t标记名\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			format(TempStr,sizeof(TempStr),"ID:%04d\t%i个\t%0.1f% 米\t%s\n",index,CraftBulid[index][_CcapacityLevel]*6-GetCraftBulidInvItems(index),GetDistanceBetweenPoints2D(PlayerPos[playerid][0],PlayerPos[playerid][1],CraftBulid[index][_Cx],CraftBulid[index][_Cy]),CraftBulid[index][_CName]);
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
