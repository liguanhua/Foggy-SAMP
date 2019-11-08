new WeaponShotDalay[MAX_PLAYERS];
FUNC::Weapon_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(GetTickCount()-WeaponShotDalay[playerid]>=400)
	{
       	new ItemID=GetItemIDbyWeaponID(weaponid);
   		if(ItemID!=NONE)ReduceDurableForPlayerWeaponEx(playerid,ItemID,0.3);
   		WeaponShotDalay[playerid]=GetTickCount();
   	}
    return 1;
}
FUNC::GetItemIDbyWeaponID(weaponid)
{
	foreach(new i:Item)
	{
	    if(Item[i][_WeaponID]==weaponid)return i;
	}
	return NONE;
}
FUNC::bool:IsPlayerDressWeaponSlotUsed(playerid,index)
{
    if(Iter_Contains(PlayerWeapon[playerid],index))return true;
    return false;
}
stock GivePlayerDressWeapon(playerid,weaponshow=NONE)
{
	if(Account[playerid][_Spawn]==true)
	{
		ResetPlayerWeapons(playerid);
		if(Iter_Count(PlayerWeapon[playerid])>0)
		{
			new ArmdWeapon=0;
			for(new i=Iter_End(PlayerWeapon[playerid]);(i=Iter_Prev(PlayerWeapon[playerid],i))!=Iter_Begin(PlayerWeapon[playerid]);)
			{
				GivePlayerWeapon(playerid,Item[PlayerWeapon[playerid][i][_ItemID]][_WeaponID],999999999);
		        ArmdWeapon=Item[PlayerWeapon[playerid][i][_ItemID]][_WeaponID];
			}
			if(weaponshow==NONE)SetPlayerArmedWeapon(playerid,ArmdWeapon);
			else SetPlayerArmedWeapon(playerid,weaponshow);
		}
	}
	return 1;
}
FUNC::AddItemToPlayerWeapon(playerid,ItemKey[],Float:Durable,GetTime)//µÀ¾ßÌí¼Óµ½ÎäÆ÷
{
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-atpw error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	new index=Item[ItemID][_WeaponDressSlot];
	if(Iter_Contains(PlayerWeapon[playerid],index))
	{
	    formatex80("%i-atpw error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Durable<=0.0)return RETURN_SUCCESS;
	if(Iter_Count(PlayerWeapon[playerid])>=MAX_PLAYER_WEAPONS)
	{
	    formatex80("%i-atpw error2",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
   	format(PlayerWeapon[playerid][index][_AccountKey],UUID_LEN,Account[playerid][_Key]);
   	UUID(PlayerWeapon[playerid][index][_WeaponKey], UUID_LEN);
	format(PlayerWeapon[playerid][index][_ItemKey],UUID_LEN,ItemKey);
   	PlayerWeapon[playerid][index][_Durable]=Durable;
   	if(GetTime==NONE)PlayerWeapon[playerid][index][_GetTime]=SERVER_RUNTIMES;
   	else PlayerWeapon[playerid][index][_GetTime]=GetTime;
   	PlayerWeapon[playerid][index][_ItemID]=ItemID;
    formatex512("INSERT INTO `"MYSQL_DB_WEAPON"`(`¹éÊôÃÜ³×`,`ÎäÆ÷ÃÜ³×`,`ÎïÆ·ÃÜ³×`,`ÎäÆ÷ÄÍ¾Ã`,`»ñµÃÊ±¼ä`) VALUES ('%s','%s','%s','%f','%i')",PlayerWeapon[playerid][index][_AccountKey],PlayerWeapon[playerid][index][_WeaponKey],PlayerWeapon[playerid][index][_ItemKey],PlayerWeapon[playerid][index][_Durable],PlayerWeapon[playerid][index][_GetTime]);
	mysql_query(Account@Handle,string512,true);
    Iter_Add(PlayerWeapon[playerid],index);
	if(InventoryTextDrawShow[playerid]==true)UpdatePlayerWeapon(playerid);
	GivePlayerDressWeapon(playerid,Item[PlayerWeapon[playerid][index][_ItemID]][_WeaponID]);
	return RETURN_SUCCESS;
}
FUNC::Float:GetWeaponDurableByWeaponID(playerid,weaponid)
{
	new Float:Durable=100.0;
	foreach(new i:PlayerWeapon[playerid])
	{
	    if(Item[PlayerWeapon[playerid][i][_ItemID]][_WeaponID]==weaponid)Durable=PlayerWeapon[playerid][i][_Durable];
	}
	if(Durable>100.0)Durable=100.0;
	return Durable;
}
FUNC::ReduceDurableForPlayerWeaponEx(playerid,ItemID,Float:Durable)//ÎäÆ÷½µµÍÄÍ¾Ã
{
    new index=Item[ItemID][_WeaponDressSlot];
    if(!Iter_Contains(PlayerWeapon[playerid],index))
	{
	    formatex80("%i-rdfp error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(PlayerWeapon[playerid][index][_ItemID]!=ItemID)
	{
	    formatex80("%i-rdfp error2",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Item[ItemID][_Durable]==0)return RETURN_SUCCESS;
    if(Durable<=0.0)return RETURN_SUCCESS;
    if(PlayerWeapon[playerid][index][_Durable]>Durable)
    {
        
    	PlayerWeapon[playerid][index][_Durable]-=Durable;
    	printf("%f",PlayerWeapon[playerid][index][_Durable]);
    	if(WeaponHudShow[playerid]==true)UpdateWeaponDurable(playerid,Item[ItemID][_WeaponID],PlayerWeapon[playerid][index][_Durable]);
    }
    else
	{
 		formatex256("DELETE FROM `"MYSQL_DB_WEAPON"` WHERE `ÎäÆ÷ÃÜ³×`='%s'",PlayerWeapon[playerid][index][_WeaponKey]);
		mysql_query(Account@Handle,string256,false);
		new	cur = index;
		Iter_SafeRemove(PlayerWeapon[playerid],cur,index);
		GivePlayerDressWeapon(playerid);
	}
	if(InventoryTextDrawShow[playerid]==true)UpdatePlayerWeapon(playerid);
	return RETURN_SUCCESS;
}
FUNC::ReduceDurableForPlayerWeapon(playerid,ItemKey[],Float:Durable)//ÎäÆ÷½µµÍÄÍ¾Ã
{
    new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-rdfp error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    new index=Item[ItemID][_WeaponDressSlot];
    if(!Iter_Contains(PlayerWeapon[playerid],index))
	{
	    formatex80("%i-rdfp error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(PlayerWeapon[playerid][index][_ItemID]!=ItemID)
	{
	    formatex80("%i-rdfp error2",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Item[ItemID][_Durable]==0)return RETURN_SUCCESS;
    if(Durable<=0.0)return RETURN_SUCCESS;
    if(PlayerWeapon[playerid][index][_Durable]>Durable)
    {
    	PlayerWeapon[playerid][index][_Durable]-=Durable;
/*    	formatex256("UPDATE `"MYSQL_DB_WEAPON"` SET  `ÎäÆ÷ÄÍ¾Ã` =  '%0.1f' WHERE  `"MYSQL_DB_WEAPON"`.`ÎäÆ÷ÃÜ³×` ='%s'",PlayerWeapon[playerid][index][_Durable],PlayerWeapon[playerid][index][_WeaponKey]);
		mysql_query(Account@Handle,string256,false);*/
    }
    else
	{
 		formatex256("DELETE FROM `"MYSQL_DB_WEAPON"` WHERE `ÎäÆ÷ÃÜ³×`='%s'",PlayerWeapon[playerid][index][_WeaponKey]);
		mysql_query(Account@Handle,string256,false);
		new	cur = index;
		Iter_SafeRemove(PlayerWeapon[playerid],cur,index);
		GivePlayerDressWeapon(playerid);
	}
	if(InventoryTextDrawShow[playerid]==true)UpdatePlayerWeapon(playerid);
	return RETURN_SUCCESS;
}
FUNC::SavePlayerWeaponDurable(playerid)
{
	foreach(new i:PlayerWeapon[playerid])
	{
		formatex256("UPDATE `"MYSQL_DB_WEAPON"` SET  `ÎäÆ÷ÄÍ¾Ã` =  '%0.1f' WHERE  `"MYSQL_DB_WEAPON"`.`ÎäÆ÷ÃÜ³×` ='%s'",PlayerWeapon[playerid][i][_Durable],PlayerWeapon[playerid][i][_WeaponKey]);
		mysql_query(Account@Handle,string256,false);
	}
	return RETURN_SUCCESS;
}
FUNC::LoadPlayerWeapon(playerid)//¶ÁÈ¡Íæ¼Ò×°±¸
{
	formatex128("SELECT * FROM `"MYSQL_DB_WEAPON"` WHERE `¹éÊôÃÜ³×`='%s'",Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,true);
    //mysql_tquery(Account@Handle,string128, "OnPlayerWeaponLoad", "i",playerid);
//	return 1;
//}
//FUNC::OnPlayerWeaponLoad(playerid)
//{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_WEAPONS)
	    {
	        new strings[37];
	        cache_get_field_content(i,"ÎïÆ·ÃÜ³×",strings,Account@Handle,37);
	        new GetItemID=GetItemIDByItemKey(strings);
	        if(GetItemID==NONE)
			{
			    new strings1[37];
				cache_get_field_content(i,"ÎäÆ÷ÃÜ³×",strings1,Account@Handle,37);
	    	    formatex128("DELETE FROM `"MYSQL_DB_WEAPON"` WHERE `"MYSQL_DB_WEAPON"`.`ÎäÆ÷ÃÜ³×` ='%s'",strings1);
				mysql_query(Account@Handle,string128,false);
				printf("%s ÎäÆ÷,ÎäÆ÷ÃÜ³×-[%s] ÎïÆ·ÃÜ³×-[%s]Òì³£,ÒÑÉ¾³ý",Account[playerid][_Name],strings1,strings);
	    	}
	    	else
	    	{
	    	    new index=Item[GetItemID][_WeaponDressSlot];
	    	    if(Iter_Contains(PlayerWeapon[playerid],index)||index==NONE)
	    	    {
	    	    	new strings1[37];
					cache_get_field_content(i,"ÎäÆ÷ÃÜ³×",strings1,Account@Handle,37);
	    	    	formatex128("DELETE FROM `"MYSQL_DB_WEAPON"` WHERE `"MYSQL_DB_WEAPON"`.`ÎäÆ÷ÃÜ³×` ='%s'",strings1);
					mysql_query(Account@Handle,string128,false);
					printf("%s ÎäÆ÷,ÎäÆ÷ÃÜ³×-[%s] ÎïÆ·ÃÜ³×-[%s]×°±¸Î»ÖØ¸´,ÒÑÉ¾³ý",Account[playerid][_Name],strings1,strings);
	    	    }
	    	    else
	    	    {
            		cache_get_field_content(i,"¹éÊôÃÜ³×",PlayerWeapon[playerid][index][_AccountKey],Account@Handle,37);
            		cache_get_field_content(i,"ÎäÆ÷ÃÜ³×",PlayerWeapon[playerid][index][_WeaponKey],Account@Handle,37);
            		cache_get_field_content(i,"ÎïÆ·ÃÜ³×",PlayerWeapon[playerid][index][_ItemKey],Account@Handle,37);
	    			PlayerWeapon[playerid][index][_Durable]=cache_get_field_content_float(i,"ÎäÆ÷ÄÍ¾Ã",Account@Handle);
            		PlayerWeapon[playerid][index][_GetTime]=cache_get_field_content_int(i,"»ñµÃÊ±¼ä",Account@Handle);
	    	    	PlayerWeapon[playerid][index][_ItemID]=GetItemID;
					Iter_Add(PlayerWeapon[playerid],index);
					printf("%s ÎäÆ÷,ÎäÆ÷ÃÜ³×-[%s] ÎïÆ·ÃÜ³×-[%s] [%s]",Account[playerid][_Name],PlayerWeapon[playerid][index][_WeaponKey],PlayerWeapon[playerid][index][_ItemKey],Item[GetItemID][_Name]);
				}
			}
		}
		else
		{
		    printf("%s ×°±¸Òç³ö",Account[playerid][_Name]);
			break;
		}
	}
	return 1;
}
FUNC::RestPlayerWeapon(playerid)
{
   	Iter_Clear(PlayerWeapon[playerid]);
	return 1;
}
#define GUN_ATTACH_NEAR 	8
#define GUN_ATTACH_FAR 		7
#define GUN_ATTACH_NONE 	NONE
FUNC::GetPlayerGunAttachUnuseSlot(playerid)
{
	loop(i,6,8)
	{
		if(!IsPlayerAttachedObjectSlotUsed(playerid,i))return i;
	}
	return NONE;
}
FUNC::PlayerGunAttach(playerid,weaponid)
{
    loop(i,6,8)if(IsPlayerAttachedObjectSlotUsed(playerid,i))RemovePlayerAttachedObject(playerid,i);
    new count=Iter_Count(PlayerWeapon[playerid]);
	if(count==0)return 1;
	new Rates=0;
	foreach(new i:PlayerWeapon[playerid])
	{
	    if(Item[PlayerWeapon[playerid][i][_ItemID]][_WeaponID]!=weaponid)
	    {
	        new index=GetPlayerGunAttachUnuseSlot(playerid);
	        if(index!=NONE)
	        {
				if(GetWeaponType(Item[PlayerWeapon[playerid][i][_ItemID]][_WeaponID])!=GUN_ATTACH_NONE)
				{
				    if(Rates>=2)return 1;
					SetPlayerWeaponModelGunAttach(playerid,Item[PlayerWeapon[playerid][i][_ItemID]][_WeaponID],index);
				    Rates++;
				}
	        }
	    }
	}
	return 1;
}
FUNC::GetWeaponType(weaponid)
{
	switch(weaponid)
	{
	    case 2..24:return GUN_ATTACH_NEAR;
        case 25..38:return GUN_ATTACH_FAR;
	}
	return GUN_ATTACH_NONE;
}
FUNC::SetPlayerWeaponModelGunAttach(playerid,weaponid,slot)
{
	switch(weaponid)
	{
	    case 2..8:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 9:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1,-0.1169,0.149,0.254,-87.3999,175.2, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 22..24:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 25..27:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 28,29,32:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 30,31:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 33,34:SetPlayerAttachedObject(playerid, slot, GetWeaponModel(weaponid), 1, -0.164999, -0.164000, 0.128999, 1.000000, 49.099983, 3.300002, 1.000000, 1.000000, 1.000000);
	    case 35..37:SetPlayerAttachedObject(playerid, slot, GetWeaponModel(weaponid), 1, 0,-0.179, -0.129, 0, 0, 0, 1.000000, 1.000000, 1.000000);
	    case 38:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1,0.5879,-0.18,0.2109,0,173.6,0, 1.099999, 1.000000, 1.000000);
	    case 10..15:SetPlayerAttachedObject(playerid, slot, GetWeaponModel(weaponid), 7, 0.008000, 0.074999, -0.161999, -87.099845, 157.899917, -169.400009, 1.000000, 1.000000, 1.000000);
	}
	return 1;
}
FUNC::GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:return 331;
		case 2..8:return weaponid+331;
       	case 9:return 341;
		case 10..15:return weaponid+311;
		case 16..18:return weaponid+326;
		case 22..29:return weaponid+324;
		case 30,31:return weaponid+325;
		case 32:return 372;
		case 33..45:return weaponid+324;
		case 46:return 371;
	}
	return 0;
}
