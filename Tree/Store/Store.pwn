FUNC::OnPlayerEnterStoreArea(playerid,index)
{
    if(Iter_Contains(Stores,index))
    {
        if(Iter_Count(Stores)>0)SCM(playerid,-1,"请在步行状态按 F键 来购买商品");
        else SCM(playerid,-1,"该商店暂时没有商品可售");
    }
    return 1;
}
FUNC::Store_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_SECONDARY_ATTACK))
    {
        if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
        {
            if(GetTickCount()-PlayerStoreDalay[playerid]>=1000)
	        {
	            PlayerStoreDalay[playerid]=GetTickCount();
	            new index=GetNearstStore(playerid);
	            if(index!=NONE)
				{
				    ShowPlayerStoreTextDraw(playerid,index);
				}
			}
        }
    }
    return 1;
}
FUNC::GetNearstStore(playerid)
{
    if(Iter_Count(Stores)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:Stores)
	{
		if(IsPlayerInDynamicArea(playerid,Stores[i][_Areaid]))
		{
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x1, y1, z1);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(Stores[i][_Pos][0],x1)),2)+floatpower(floatabs(floatsub(Stores[i][_Pos][1],y1)),2)+floatpower(floatabs(floatsub(Stores[i][_Pos][2],z1)),2));
			if(dis2<dis&&dis2 != -1.00)
			{
				dis=dis2;
				index=i;
			}
		}
	}
	return index;
}
FUNC::CreateStore(playerid,model,skinid,storename[],mapmodel,Float:posx,Float:posy,Float:posz,Float:posa)
{
	if(Iter_Count(Stores)>=MAX_STORES)
	{
	    formatex80("%i-cs error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(Stores);
    UUID(Stores[i][_Key], UUID_LEN);
    Stores[i][_Pos][0]=posx;
    Stores[i][_Pos][1]=posy;
    Stores[i][_Pos][2]=posz;
    Stores[i][_Pos][3]=posa;
    Stores[i][_AcotrSkin]=skinid;
    Stores[i][_MapModel]=mapmodel;
    format(Stores[i][_Name],64,storename);
    Stores[i][_Model]=model;
    formatex512("INSERT INTO `"MYSQL_DB_STORE"`(`密匙`,`皮肤ID`,`模型ID`,`名称`,`地图图标`,`X`,`Y`,`Z`,`A`) VALUES ('%s','%i','%i','%s','%i','%f','%f','%f','%f')",Stores[i][_Key],Stores[i][_AcotrSkin],Stores[i][_Model],storename,mapmodel,Stores[i][_Pos][0],Stores[i][_Pos][1],Stores[i][_Pos][2],Stores[i][_Pos][3]);
   	mysql_query(Account@Handle,string512,false);
	Iter_Add(Stores,i);
	CreateStoreModel(i);
    return RETURN_SUCCESS;
}
FUNC::DestoryStore(index)
{
	if(!Iter_Contains(PickUp,index))
	{
	    formatex80("%i-ds error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	formatex64(Stores[index][_Key]);
	
    DestoryStoreModel(index);

	formatex128("DELETE FROM `"MYSQL_DB_STORESELL"` WHERE `"MYSQL_DB_STORESELL"`.`商店密匙`='%s'",Stores[index][_Key]);
	mysql_query(Account@Handle,string128,false);
    
	formatex128("DELETE FROM `"MYSQL_DB_STORE"` WHERE `"MYSQL_DB_STORE"`.`密匙`='%s'",Stores[index][_Key]);
	mysql_query(Account@Handle,string128,false);
	
	Iter_Clear(StoreSells[index]);
    Iter_Remove(Stores,index);
	return 1;
}
FUNC::DestoryStoreModel(index)
{
    if(Stores[index][_Acotrid]!=INVALID_STREAMER_ID)DestroyDynamicActor(Stores[index][_Acotrid]);
    Stores[index][_Acotrid]=INVALID_STREAMER_ID;
    if(Stores[index][_BoothObjid]!=INVALID_STREAMER_ID)DestroyDynamicObject(Stores[index][_BoothObjid]);
    Stores[index][_BoothObjid]=INVALID_STREAMER_ID;
    if(Stores[index][_Areaid]!=INVALID_STREAMER_ID)DestroyDynamicArea(Stores[index][_Areaid]);
    Stores[index][_Areaid]=INVALID_STREAMER_ID;
    if(Stores[index][_Textid]!=Text3D:INVALID_STREAMER_ID)DestroyDynamic3DTextLabel(Stores[index][_Textid]);
    Stores[index][_Textid]=Text3D:INVALID_STREAMER_ID;
    if(Stores[index][_Mapid]!=INVALID_STREAMER_ID)DestroyDynamicMapIcon(Stores[index][_Mapid]);
    Stores[index][_Mapid]=INVALID_STREAMER_ID;
    forex(i,MAX_STORE_SELLS)
    {
        if(Stores[index][_ItemObjid][i]!=INVALID_STREAMER_ID)DestroyDynamicObject(Stores[index][_ItemObjid][i]);
        Stores[index][_ItemObjid][i]=INVALID_STREAMER_ID;
    }
    return 1;
}
FUNC::CreateStoreModel(index)
{
    CA_FindZ_For2DCoord(Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][2]);
    Stores[index][_Acotrid]=CreateDynamicActor(Stores[index][_AcotrSkin],Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][2]+1.0,Stores[index][_Pos][3],true,50.0,0,0,-1,50.0);
    new Float:objx=Stores[index][_Pos][0],Float:objy=Stores[index][_Pos][1];
    GetAngleDistancePoint(Stores[index][_Pos][3],0.25,objx,objy);
    Stores[index][_BoothObjid]=CreateDynamicObject(Stores[index][_Model],objx,objy,Stores[index][_Pos][2]+1.170001,0.0,0.0,Stores[index][_Pos][3]-174.1682,0,0,1-1,50.0);
	Stores[index][_Areaid]=CreateDynamicCylinder(Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][2]-0.5,Stores[index][_Pos][2]+3.0,3.5,0,0,-1);
    formatex64("%s\nID:%i",Stores[index][_Name],index);
    Stores[index][_Textid]=CreateDynamic3DTextLabel(string64,-1,Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][2]+2.2,50.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1);
    Stores[index][_Mapid]=CreateDynamicMapIcon(Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][2],Stores[index][_MapModel],0,0,-1,-1,300.0,MAPICON_GLOBAL);

	forex(i,MAX_STORE_SELLS)Stores[index][_ItemObjid][i]=INVALID_STREAMER_ID;

	if(Iter_Count(StoreSells[index])>0)
	{
	    GetPointInFront2D(Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][3],0.8,objx,objy);
	    new Float:itemobjx,Float:itemobjy;
	    forex(s,6)
	    {
	        if(Iter_Contains(StoreSells[index],s))
	        {
		        if(StoreSells[index][s][_ItemID]!=NONE)
		        {
		        	GetPointInFront2D(objx,objy,Stores[index][_Pos][3]+99.531781,1.5-s*0.3,itemobjx,itemobjy);
		       		Stores[index][_ItemObjid][s]=CreateDynamicObject(Item[StoreSells[index][s][_ItemID]][_Model],itemobjx,itemobjy,Stores[index][_Pos][2]+0.828840,86.100090,-89.999984,Stores[index][_Pos][3]-170.968201,0,0,1-1,15.0);
  				}
   		    }
	    }
	    loop(s,6,MAX_STORE_SELLS)
	    {
	        if(Iter_Contains(StoreSells[index],s))
	        {
		        if(StoreSells[index][s][_ItemID]!=NONE)
		        {
		        	GetPointInFront2D(objx,objy,Stores[index][_Pos][3]+99.531781,1.2-s*0.3,itemobjx,itemobjy);
		       		Stores[index][_ItemObjid][s]=CreateDynamicObject(Item[StoreSells[index][s][_ItemID]][_Model],itemobjx,itemobjy,Stores[index][_Pos][2]+0.828840,86.100090,-89.999984,Stores[index][_Pos][3]-170.968201,0,0,1-1,15.0);
	        	}
			}
	    }
    }
    UpdateStreamer(Stores[index][_Pos][0],Stores[index][_Pos][1],Stores[index][_Pos][2],0,0);
	return RETURN_SUCCESS;
}
FUNC::LoadStores()//读取商店
{
    RestStores();
    RestStoreSells();
	formatex128("SELECT * FROM `"MYSQL_DB_STORE"`");
    mysql_tquery(Account@Handle,string128, "OnStoresLoad");
	return 1;
}
FUNC::RestStoreSells()
{
   	forex(i,MAX_STORES)Iter_Clear(StoreSells[i]);
	return 1;
}
FUNC::OnStoresLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_STORES)
	    {
            cache_get_field_content(i,"密匙",Stores[i][_Key],Account@Handle,37);
	    	Stores[i][_AcotrSkin]=cache_get_field_content_int(i,"皮肤ID",Account@Handle);
	    	cache_get_field_content(i,"名称",Stores[i][_Name],Account@Handle,37);
	    	Stores[i][_MapModel]=cache_get_field_content_int(i,"地图图标",Account@Handle);
	    	Stores[i][_Model]=cache_get_field_content_int(i,"模型ID",Account@Handle);
			Stores[i][_Pos][0]=cache_get_field_content_float(i,"X",Account@Handle);
			Stores[i][_Pos][1]=cache_get_field_content_float(i,"Y",Account@Handle);
			Stores[i][_Pos][2]=cache_get_field_content_float(i,"Z",Account@Handle);
			Stores[i][_Pos][3]=cache_get_field_content_float(i,"A",Account@Handle);
			Iter_Add(Stores,i);
			printf("系统商店密匙-[%s]",Stores[i][_Key]);
		}
		else
		{
		    printf("系统商店溢出");
			break;
		}
	}
	if(Iter_Count(Stores)>0)
	{
	    foreach(new i:Stores)
		{
		    formatex128("SELECT * FROM `"MYSQL_DB_STORESELL"` WHERE `商店密匙`='%s'",Stores[i][_Key]);
			mysql_query(Account@Handle,string128,true);
			forex(s,cache_num_rows())
			{
			    if(s<MAX_STORE_SELLS)
			    {
			        cache_get_field_content(s,"密匙",StoreSells[i][s][_Key],Account@Handle,37);
			        cache_get_field_content(s,"商店密匙",StoreSells[i][s][_StoreKey],Account@Handle,37);
			        cache_get_field_content(s,"道具密匙",StoreSells[i][s][_ItemKey],Account@Handle,37);
			        StoreSells[i][s][_Amount]=cache_get_field_content_int(s,"数量",Account@Handle);
			        StoreSells[i][s][_Durable]=cache_get_field_content_float(s,"耐久",Account@Handle);
                    StoreSells[i][s][_Price]=cache_get_field_content_int(s,"售价",Account@Handle);
					new GetItemID=GetItemIDByItemKey(StoreSells[i][s][_ItemKey]);
					if(GetItemID==NONE)
			    	{
			    	    StoreSells[i][s][_ItemID]=NONE;
			    	    formatex128("DELETE FROM `"MYSQL_DB_STORESELL"` WHERE `"MYSQL_DB_INVENTORY"`.`密匙` ='%s'",StoreSells[i][s][_Key]);
						mysql_query(Account@Handle,string128,false);
						printf("商店密匙-[%s],商店售品密匙-[%s] 物品密匙-[%s]异常,已删除",StoreSells[i][s][_StoreKey],StoreSells[i][s][_Key],StoreSells[i][s][_ItemKey]);
			    	}
			    	else
			    	{
			    	    StoreSells[i][s][_ItemID]=GetItemID;
						Iter_Add(StoreSells[i],s);
						printf("商店密匙-[%s],售品名称-[%s]",StoreSells[i][s][_StoreKey],Item[StoreSells[i][s][_ItemID]][_Name]);
					}
			    }
			}
			CreateStoreModel(i);
        }
	}
	return 1;
}

FUNC::RestStores()
{
   	Iter_Clear(Stores);
	return 1;
}
FUNC::AddStoreSellToStore(playerid,storeid,ItemKey[],Amounts,Price,Float:Durable)
{
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-assts error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Iter_Count(StoreSells[storeid])>=MAX_STORE_SELLS)
	{
	    formatex80("%i-assts error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(Amounts<=0)return RETURN_ERROR;
    if(Durable<=0.0)return RETURN_ERROR;
    new i=Iter_Free(StoreSells[storeid]);
    UUID(StoreSells[storeid][i][_Key], UUID_LEN);
    format(StoreSells[storeid][i][_StoreKey],UUID_LEN,Stores[storeid][_Key]);
    format(StoreSells[storeid][i][_ItemKey],UUID_LEN,ItemKey);
    StoreSells[storeid][i][_Amount]=Amounts;
    StoreSells[storeid][i][_Durable]=Durable;
    StoreSells[storeid][i][_Price]=Price;
    StoreSells[storeid][i][_ItemID]=ItemID;
    Iter_Add(StoreSells[storeid],i);
    formatex512("INSERT INTO `"MYSQL_DB_STORESELL"`(`密匙`,`商店密匙`,`道具密匙`,`数量`,`耐久`,`售价`) VALUES ('%s','%s','%s','%i','%f','%i')",StoreSells[storeid][i][_Key],Stores[storeid][_Key],ItemKey,Amounts,Durable,Price);
   	mysql_query(Account@Handle,string512,false);

    forex(s,MAX_STORE_SELLS)
    {
        if(Stores[storeid][_ItemObjid][s]!=INVALID_STREAMER_ID)DestroyDynamicObject(Stores[storeid][_ItemObjid][s]);
        Stores[storeid][_ItemObjid][s]=INVALID_STREAMER_ID;
    }
    new Float:objx=Stores[storeid][_Pos][0],Float:objy=Stores[storeid][_Pos][1];
    GetAngleDistancePoint(Stores[storeid][_Pos][3],0.25,objx,objy);
	if(Iter_Count(StoreSells[storeid])>0)
	{
	    GetPointInFront2D(Stores[storeid][_Pos][0],Stores[storeid][_Pos][1],Stores[storeid][_Pos][3],0.8,objx,objy);
	    new Float:itemobjx,Float:itemobjy;
	    forex(s,6)
	    {
	        if(Iter_Contains(StoreSells[storeid],s))
	        {
		        if(StoreSells[storeid][s][_ItemID]!=NONE)
		        {
		        	GetPointInFront2D(objx,objy,Stores[storeid][_Pos][3]+99.531781,1.5-s*0.3,itemobjx,itemobjy);
		       		Stores[storeid][_ItemObjid][s]=CreateDynamicObject(Item[StoreSells[storeid][s][_ItemID]][_Model],itemobjx,itemobjy,Stores[storeid][_Pos][2]+0.828840,86.100090,-89.999984,Stores[storeid][_Pos][3]-170.968201,0,0,1-1,15.0);
  				}
   		    }
	    }
	    loop(s,6,MAX_STORE_SELLS)
	    {
	        if(Iter_Contains(StoreSells[storeid],s))
	        {
		        if(StoreSells[storeid][s][_ItemID]!=NONE)
		        {
		        	GetPointInFront2D(objx,objy,Stores[storeid][_Pos][3]+99.531781,1.2-s*0.3,itemobjx,itemobjy);
		       		Stores[storeid][_ItemObjid][s]=CreateDynamicObject(Item[StoreSells[storeid][s][_ItemID]][_Model],itemobjx,itemobjy,Stores[storeid][_Pos][2]+0.828840,86.100090,-89.999984,Stores[storeid][_Pos][3]-170.968201,0,0,1-1,15.0);
	        	}
			}
	    }
    }
    UpdateStreamer(Stores[storeid][_Pos][0],Stores[storeid][_Pos][1],Stores[storeid][_Pos][2],0);


	foreach(new s:Player)
	{
	    if(RealPlayer(s))
	    {
	        if(StoreTextDrawShow[s]==true)
	        {
			    if(StoreSellClickID[s]!=NONE)
				{
					PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[s][StoreSellClickID[s]], 2094792749);
			        PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[s][StoreSellClickID[s]]);
				}
				UpdateStoreSellPage(playerid,StoreSellStoreID[s],StoreSellPreviePage[s]);
			}
		}
	}
    return RETURN_SUCCESS;
}

FUNC::ReduceStoreSellForStore(playerid,storeid,index,amount)
{
	if(!Iter_Contains(StoreSells[storeid],index))return RETURN_SUCCESS;
	if(StoreSells[storeid][index][_Amount]==0)return RETURN_SUCCESS;
    if(StoreSells[storeid][index][_Amount]<amount)return RETURN_ERROR;
    StoreSells[storeid][index][_Amount]-=amount;
    if(StoreSells[storeid][index][_Amount]<=0)
    {
        if(Stores[storeid][_ItemObjid][index]!=INVALID_STREAMER_ID)DestroyDynamicObject(Stores[storeid][_ItemObjid][index]);
        Stores[storeid][_ItemObjid][index]=INVALID_STREAMER_ID;
		formatex256("DELETE FROM `"MYSQL_DB_STORESELL"` WHERE `密匙`='%s'",StoreSells[storeid][index][_Key]);
		mysql_query(Account@Handle,string256,false);
		new	cur = index;
		Iter_SafeRemove(StoreSells[storeid],cur,index);
    }
	else
	{
	    formatex256("UPDATE `"MYSQL_DB_STORESELL"` SET  `数量` ='%i' WHERE  `"MYSQL_DB_STORESELL"`.`密匙` ='%s'",StoreSells[storeid][index][_Amount],StoreSells[storeid][index][_Key]);
		mysql_query(Account@Handle,string256,false);
	}
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        if(StoreTextDrawShow[i]==true)
	        {
			    if(StoreSellClickID[i]!=NONE)
				{
					PlayerTextDrawColor(playerid, StoreSellBackBottonDraw[i][StoreSellClickID[i]], 2094792749);
			        PlayerTextDrawShow(playerid, StoreSellBackBottonDraw[i][StoreSellClickID[i]]);
				}
				UpdateStoreSellPage(playerid,StoreSellStoreID[i],StoreSellPreviePage[i]);
			}
		}
	}
	return RETURN_SUCCESS;
}
FUNC::OnPlayerClickPlayerSellBotton(playerid,storeid,invid)
{
	new BagID=PlayerSellPrevieBox[playerid][invid];
	new ItemID=PlayerInv[playerid][BagID][_ItemID];
	formatex32("商店显示背包:%s",Item[ItemID][_Name]);
	SCM(playerid,-1,string32);
	formatex64("%i,%s,%i",BagID,PlayerInv[playerid][BagID][_InvKey],ItemID);
	if(VerifyInvPVarData(playerid,string64)==true)
	{
	    if(PlayerInv[playerid][BagID][_Amounts]>1)
	    {
            formatex128("%s 有多个[售价 $%i/件 ],请输入出售的数量",Item[ItemID][_Name],floatround(floatmul(Item[ItemID][_SellPrice],PlayerInv[playerid][BagID][_Durable])));
	    	SPD(playerid,_SPD_PLAYERSELL_AMOUNT,DIALOG_STYLE_INPUT,"出售物品",string128,"购买","不卖了");
        	SetPVarString(playerid,"_Bag_Click_Info",string64);
	    }
	    else
	    {
            formatex128("确定出售 %s [售价 $%i/件 ]?",Item[ItemID][_SellPrice],floatround(floatmul(Item[ItemID][_SellPrice],PlayerInv[playerid][BagID][_Durable])));
	    	SPD(playerid,_SPD_PLAYERSELL_TIP,DIALOG_STYLE_MSGBOX,"出售物品",string128,"好的","不卖了");
	        SetPVarString(playerid,"_Bag_Click_Info",string64);
	    }
	}
	return 1;
}
FUNC::OnPlayerClickStoreSellBotton(playerid,storeid,storesellid)
{
    new index=StoreSellPrevieBox[playerid][storesellid];
    formatex128("%i,%s,%i,%s",storeid,Stores[storeid][_Key],index,StoreSells[storeid][index][_Key]);
	if(VerifyStoreSellPVarData(playerid,string128)==true)
	{
	    if(StoreSells[storeid][index][_Amount]>1&&Item[StoreSells[storeid][index][_ItemID]][_Overlap]==1)
	    {
            formatex64("%s 有多个,请输入购买的数量",Item[StoreSells[storeid][index][_ItemID]][_Name]);
	    	SPD(playerid,_SPD_STORESELL_AMOUNT,DIALOG_STYLE_INPUT,"购买商品",string64,"购买","不买了");
        	SetPVarString(playerid,"_StoreSell_Click_Info",string128);
	    }
	    else
	    {
            formatex64("确定购买 %s ?",Item[StoreSells[storeid][index][_ItemID]][_Name]);
	    	SPD(playerid,_SPD_STORESELL_TIP,DIALOG_STYLE_MSGBOX,"购买商品",string64,"好的","不买了");
	        SetPVarString(playerid,"_StoreSell_Click_Info",string128);
	    }
    }
	return 1;
}
FUNC::bool:VerifyStoreSellPVarData(playerid,VarString[])
{
	new StoreID,StoreKey[37],StoreSellID,StoreSellKey[37];
    if(sscanf(VarString, "p<,>is[37]is[37]",StoreID,StoreKey,StoreSellID,StoreSellKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(Stores,StoreID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该商店已失效,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(StoreSells[StoreID],StoreSellID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该商店物品已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(Stores[StoreID][_Key],StoreKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(!isequal(StoreSells[StoreID][StoreSellID][_Key],StoreSellKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#3]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
    if(StoreSells[StoreID][StoreSellID][_Amount]<=0)
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#4]","该物品已失效,请重新选择","了解","");
	    return false;
	}
	return true;
}
