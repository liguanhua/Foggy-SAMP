FUNC::GetNearstPickUp(playerid)
{
    if(Iter_Count(PickUp)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:PickUp)
	{
		if(IsPlayerInDynamicArea(playerid,PickUp[i][_AreaID]))
		{
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x1, y1, z1);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(PickUp[i][_X],x1)),2)+floatpower(floatabs(floatsub(PickUp[i][_Y],y1)),2)+floatpower(floatabs(floatsub(PickUp[i][_Z],z1)),2));
			if(dis2<dis&&dis2 != -1.00)
			{
				dis=dis2;
				index=i;
			}
		}
	}
	return index;
}
FUNC::PickUp_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_CROUCH))
    {
        if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
        {
	        if(GetTickCount()-PlayerPickUp[playerid][_Dalay]>=1000)
	        {
	            PlayerPickUp[playerid][_Dalay]=GetTickCount();
				new index=GetNearstPickUp(playerid);
				if(index!=NONE)
				{
					if(GetPlayerCurrentCapacity(playerid)+Item[PickUp[index][_ItemID]][_Weight]*PickUp[index][_Amounts]>GetPlayerMaxCapacity(playerid))
	            	{
	                	SCM(playerid,-1,"该物品太重,你的背包放不下");
	                	return true;
	            	}
	            	SetPlayerArmedWeapon(playerid,0);
				    new tItemKey[37],Float:tDurable,tAmounts;
					format(tItemKey,sizeof(tItemKey),"%s",Item[PickUp[index][_ItemID]][_Key]);
					tDurable=PickUp[index][_Durable];
					tAmounts=PickUp[index][_Amounts];
					if(DestoryPickUp(index)==RETURN_SUCCESS)
				    {
				        ApplyAnimation(playerid,"BOMBER", "BOM_PLANT_CROUCH_IN",4.1,0,0,0,0,0,1);
		                AddItemToPlayerInv(playerid,tItemKey,tAmounts,tDurable,SERVER_RUNTIMES,true);
	                    return true;
				    }
				}
	        }
        }
    }
	return false;
}
FUNC::bool:VerifyNearPVarData(playerid,VarString[])
{
	new NearID,NearKey[37],ItemID;
    if(sscanf(VarString, "p<,>is[37]i",NearID,NearKey,ItemID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(PickUp,NearID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该物品已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(PickUp[NearID][_Key],NearKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(!isequal(PickUp[NearID][_ItemKey],Item[ItemID][_Key],false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#3]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(PickUp[NearID][_Amounts]<=0)
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#4]","该物品已失效,请重新选择","了解","");
	    return false;
	}
	return true;
}
FUNC::OnPlayerClickNearItemBotton(playerid,index)
{
	new NearID=PlayerNearPrevieBox[playerid][index];
	new ItemID=PickUp[NearID][_ItemID];
	formatex32("附近:%s",Item[ItemID][_Name]);
	SCM(playerid,-1,string32);
	formatex64("%i,%s,%i",NearID,PickUp[NearID][_Key],ItemID);
	if(VerifyNearPVarData(playerid,string64)==true)
	{
		SetPVarString(playerid,"_Near_Click_Info",string64);
		ShowAdditionInfo(playerid,ItemID,_SPD_NEAR_PICKUP_INFO,"拾取","返回");
	}
    return 1;
}
FUNC::GetPlayerRangeSameItemPickup(playerid,ItemKey[],Float:Range)
{
	foreach(new i:PickUp)
	{
	    if(isequal(PickUp[i][_ItemKey],ItemKey,false))
	    {
	        if(Item[PickUp[i][_ItemID]][_Overlap]==1)
	        {
				if(IsPlayerInRangeOfPoint(playerid,Range,PickUp[i][_X],PickUp[i][_Y],PickUp[i][_Z]))
				{
					return i;
				}
			}
		}
	}
	return NONE;
}
stock CreatePickUpData(ItemKey[],Amounts,Float:Durable,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz,world,interior,saveit,bool:createmodel=true)
{
	if(Iter_Count(PickUp)>=MAX_PICKUP)
	{
	    formatex80("-cpud error0");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("-cpud error1");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(PickUp);
    format(PickUp[i][_ItemKey],UUID_LEN,ItemKey);
    UUID(PickUp[i][_Key], UUID_LEN);
    PickUp[i][_Amounts]=Amounts;
    PickUp[i][_Durable]=Durable;
    PickUp[i][_X]=x;
    PickUp[i][_Y]=y;
    PickUp[i][_Z]=z;
    PickUp[i][_RX]=rx;
    PickUp[i][_RY]=ry;
    PickUp[i][_RZ]=rz;
    PickUp[i][_Interior]=interior;
    PickUp[i][_World]=world;
    PickUp[i][_Saveit]=saveit;
    PickUp[i][_ItemID]=ItemID;

    Iter_Add(PickUp,i);
    
    if(saveit==1)
    {
	    formatex512("INSERT INTO `"MYSQL_DB_PICKUP"`(`密匙`,`道具密匙`,`拾取物数量`,`拾取物耐久`,`X坐标`,`Y坐标`,`Z坐标`,`内饰`,`世界`) VALUES ('%s','%s','%i','%f','%f','%f','%f','%i','%i')",PickUp[i][_Key],PickUp[i][_ItemKey],PickUp[i][_Amounts],PickUp[i][_Durable],PickUp[i][_X],PickUp[i][_Y],PickUp[i][_Z],interior,world);
	   	mysql_query(Account@Handle,string512,false);
   	}
   	if(createmodel==true)
   	{
	    UpdatePlayerNearPrevie(PickUp[i][_Key]);
	   	CreatePickUpModel(i);
   	}
	return RETURN_SUCCESS;
}
FUNC::UpdatePlayerNearPrevie(Key[])
{
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        if(InventoryTextDrawShow[i]==true)
	        {
	            forex(s,PlayerNearPrevieCount[i])
	            {
	                if(!isequal(PlayerNearPrevieBoxKey[i][s],Key,false))
	                {
	                    UpdatePlayerNearPage(i,PlayerNearPreviePage[i]);
	                    break;
	                }
	            }
	        }
	    }
	}
	return 1;
}
FUNC::AddPickUpAmount(index,amount)
{
    PickUp[index][_Amounts]+=amount;
    if(PickUp[index][_Amounts]<=0)DestoryPickUpModel(index);
	else
	{
	    formatex64("%s\n数量:%i",Item[PickUp[index][_ItemID]][_Name],PickUp[index][_Amounts]);
	    UpdateDynamic3DTextLabelText(PickUp[index][_3DtextID],-1,string64);
		formatex128("UPDATE `"MYSQL_DB_PICKUP"` SET  `拾取物数量`='%i' WHERE  `"MYSQL_DB_PICKUP"`.`密匙` ='%s'",PickUp[index][_Amounts],PickUp[index][_Key]);
		mysql_query(Account@Handle,string128,false);
		UpdatePlayerNearPrevie(PickUp[index][_Key]);
	}
	return 1;
}
FUNC::CreatePickUpModel(index)
{
    PickUp[index][_ObjectIndex]=CA_CreateDynamicObject_DC(Item[PickUp[index][_ItemID]][_Model],PickUp[index][_X],PickUp[index][_Y],PickUp[index][_Z],PickUp[index][_RX], PickUp[index][_RY],PickUp[index][_RZ],PickUp[index][_World],PickUp[index][_Interior],.streamdistance = 150.0,.drawdistance = 150.0);
    if(Item[PickUp[index][_ItemID]][_Overlap]==1)
    {
        formatex64("%s\n数量:%i",Item[PickUp[index][_ItemID]][_Name],PickUp[index][_Amounts]);
        PickUp[index][_3DtextID]=CreateDynamic3DTextLabel(string64, -1, PickUp[index][_X],PickUp[index][_Y],PickUp[index][_Z],5.0,.testlos = 0,.worldid = PickUp[index][_World],.interiorid = PickUp[index][_Interior]);
    }
    else
    {
        formatex64("%s\n耐久:%0.1f",Item[PickUp[index][_ItemID]][_Name],PickUp[index][_Durable]);
        PickUp[index][_3DtextID]=CreateDynamic3DTextLabel(string64, -1, PickUp[index][_X],PickUp[index][_Y],PickUp[index][_Z],5.0,.testlos = 0,.worldid = PickUp[index][_World],.interiorid = PickUp[index][_Interior]);
    }
    PickUp[index][_AreaID]=CreateDynamicCylinder(PickUp[index][_X],PickUp[index][_Y],PickUp[index][_Z]-2.0,PickUp[index][_Z]+2.0,3.0,PickUp[index][_World],PickUp[index][_Interior]);
	UpdateStreamer(PickUp[index][_X],PickUp[index][_Y],PickUp[index][_Z],PickUp[index][_World],PickUp[index][_Interior]);
   	printf("CreatePickUpModel %i",index);
	return RETURN_SUCCESS;
}
FUNC::DestoryPickUpModel(index)
{
	if(!Iter_Contains(PickUp,index))
	{
	    formatex80("%i-dpum error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	printf("DestoryPickUpModel %i",index);
	CA_DestroyObject_DC(PickUp[index][_ObjectIndex]);
	PickUp[index][_ObjectIndex]=INVALID_STREAMER_ID;
	DestroyDynamic3DTextLabel(PickUp[index][_3DtextID]);
	PickUp[index][_3DtextID]=Text3D:INVALID_STREAMER_ID;
	DestroyDynamicArea(PickUp[index][_AreaID]);
	PickUp[index][_AreaID]=INVALID_STREAMER_ID;
	return RETURN_SUCCESS;
}
FUNC::DestoryPickUp(index)
{
	if(!Iter_Contains(PickUp,index))
	{
	    formatex80("%i-dpu error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	formatex64(PickUp[index][_Key]);

	DestoryPickUpModel(index);
	
    if(PickUp[index][_Saveit]==1)
    {
		formatex128("DELETE FROM `"MYSQL_DB_PICKUP"` WHERE `"MYSQL_DB_PICKUP"`.`密匙`='%s'",PickUp[index][_Key]);
		mysql_query(Account@Handle,string128,false);
	}

	Iter_Remove(PickUp,index);
	
	UpdatePlayerNearPrevie(string64);
	printf("DestoryPickUp");
	return RETURN_SUCCESS;
}
FUNC::LoadPickUps()//读取拾取物
{
    RestPickUps();
	formatex128("SELECT * FROM `"MYSQL_DB_PICKUP"`");
    mysql_tquery(Account@Handle,string128, "OnPickUpsLoad");
	return 1;
}
FUNC::OnPickUpsLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PICKUP)
	    {
	        new s=Iter_Free(PickUp);
            cache_get_field_content(i,"密匙",PickUp[s][_Key],Account@Handle,37);
            cache_get_field_content(i,"道具密匙",PickUp[s][_ItemKey],Account@Handle,37);
	    	PickUp[s][_Amounts]=cache_get_field_content_int(i,"拾取物数量",Account@Handle);
	    	PickUp[s][_Durable]=cache_get_field_content_float(i,"拾取物耐久",Account@Handle);
			PickUp[s][_X]=cache_get_field_content_float(i,"X坐标",Account@Handle);
			PickUp[s][_Y]=cache_get_field_content_float(i,"Y坐标",Account@Handle);
			PickUp[s][_Z]=cache_get_field_content_float(i,"Z坐标",Account@Handle);
			PickUp[s][_RX]=cache_get_field_content_float(i,"RX坐标",Account@Handle);
			PickUp[s][_RY]=cache_get_field_content_float(i,"RY坐标",Account@Handle);
			PickUp[s][_RZ]=cache_get_field_content_float(i,"RZ坐标",Account@Handle);
			PickUp[s][_Interior]=cache_get_field_content_int(i,"内饰",Account@Handle);
			PickUp[s][_World]=cache_get_field_content_int(i,"世界",Account@Handle);
			new GetItemID=GetItemIDByItemKey(PickUp[s][_ItemKey]);
			if(GetItemID==NONE)
			{
				formatex128("DELETE FROM `"MYSQL_DB_PICKUP"` WHERE `"MYSQL_DB_PICKUP"`.`密匙`='%s'",PickUp[s][_Key]);
				mysql_query(Account@Handle,string128,false);
				printf("拾取物密匙-[%s]异常,已删除",PickUp[s][_Key]);
			}
			else
			{
			    PickUp[s][_Saveit]=1;
			    PickUp[s][_ItemID]=GetItemID;
				Iter_Add(PickUp,s);
				printf("拾取物密匙-[%s][%s]",PickUp[s][_Key],Item[PickUp[s][_ItemID]][_Name]);
			}
		}
		else
		{
		    printf("拾取物溢出");
			break;
		}
	}
	if(Iter_Count(PickUp)>0)
	{
	    printf("GO");
	    foreach(new i:PickUp)CreatePickUpModel(i);
	}
	return 1;
}
FUNC::RestPickUps()
{
   	Iter_Clear(PickUp);
	return 1;
}
/*	new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
	forex(i,MAX_PICKUP-10)
	{
		GetPickUpSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);
		CreatePickUpData(Item[random(sizeof(Item))][_Key],1,100,Gpos_X,Gpos_Y,Gpos_Z+0.2,0.0,0.0,0.0);
	}*/
FUNC::GetPickUpSpawnPos(&Float:Gpos_X,&Float:Gpos_Y,&Float:Gpos_Z)
{
	GetRandomPointInRectangle(-3000,-3000,3000,3000,Gpos_X,Gpos_Y);
	CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
    while(GetPointCollisionFlags(Gpos_X,Gpos_Y,Gpos_Z)==17||!IsPointInGround(Gpos_X,Gpos_Y,Gpos_Z,false,5.0)||IsPickUpSpawnPosInRange(Gpos_X,Gpos_Y,10.0))
    {
 		GetRandomPointInRectangle(-3000,-3000,3000,3000,Gpos_X,Gpos_Y);
		CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
 	}
	return 1;
}
FUNC::IsPickUpSpawnPosInRange(Float:xx,Float:yy,Float:range)//出生点某范围内是否有其他僵尸出生点
{
	if(Iter_Count(PickUp)>0)
	{
	    foreach(new i:PickUp)
	    {
	        new Float:distancez=GetDistanceBetweenPoints2D(PickUp[i][_X],PickUp[i][_Y],xx,yy);
	        if(distancez<range)return 1;
	    }
    }
    else return 0;
	return 0;
}
CMD:randpickup(playerid, params[])
{
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return Debug(playerid,"你不是管理员3级");
	new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
	forex(i,MAX_PICKUP-MAX_PICKUP_SPAWNS)
	{
		GetPickUpSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);
		CreatePickUpData(Item[Iter_Random(Item)][_Key],1,100,Gpos_X,Gpos_Y,Gpos_Z+0.2,0.0,0.0,0.0,0,0,0);
	}
	return 1;
}
