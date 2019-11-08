FUNC::GetCraftVehIDByCraftVehKey(CraftVehKey[])//通过密匙查询汽车表ID
{
	new CraftVehID=NONE;
	foreach(new i:CraftVehicleList)
	{
		if(isequal(CraftVehicleList[i][_Key],CraftVehKey,false))CraftVehID=i;
	}
	return CraftVehID;
}
FUNC::GetNearstVehicleWreckage(playerid)
{
    if(Iter_Count(VehicleWreckage)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:VehicleWreckage)
	{
		if(IsPlayerInDynamicArea(playerid,VehicleWreckage[i][_AreaID]))
		{
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x1, y1, z1);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(VehicleWreckage[i][_X],x1)),2)+floatpower(floatabs(floatsub(VehicleWreckage[i][_Y],y1)),2)+floatpower(floatabs(floatsub(VehicleWreckage[i][_Z],z1)),2));
			if(dis2<dis&&dis2 != -1.00)
			{
				dis=dis2;
				index=i;
			}
		}
	}
	return index;
}
FUNC::CreateVehicleWreckageData(CraftVehKey[],Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz,spawnid)
{
	if(Iter_Count(VehicleWreckage)>=MAX_VEHWRE)
	{
	    formatex80("-cvw error0");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
	new CraftVehID=GetCraftVehIDByCraftVehKey(CraftVehKey);
	if(CraftVehID==NONE)
	{
	    formatex80("-cvw error1");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(VehicleWreckage);
    format(VehicleWreckage[i][_CraftVehKey],UUID_LEN,CraftVehKey);
    UUID(VehicleWreckage[i][_Key], UUID_LEN);
    VehicleWreckage[i][_CraftVehID]=CraftVehID;
    VehicleWreckage[i][_X]=x;
    VehicleWreckage[i][_Y]=y;
    VehicleWreckage[i][_Z]=z;
    VehicleWreckage[i][_RX]=rx;
    VehicleWreckage[i][_RY]=ry;
    VehicleWreckage[i][_RZ]=rz;
    VehicleWreckage[i][_SpawnKey]=spawnid;
    Iter_Add(VehicleWreckage,i);
   	CreateVehicleWreckageModel(i);
	return RETURN_SUCCESS;
}
FUNC::CreateVehicleWreckageModel(index)
{
    VehicleWreckage[index][_ObjectIndex]=CA_CreateDynamicObject_DC(CraftVehicleList[VehicleWreckage[index][_CraftVehID]][_Model],VehicleWreckage[index][_X],VehicleWreckage[index][_Y],VehicleWreckage[index][_Z],VehicleWreckage[index][_RX], VehicleWreckage[index][_RY],VehicleWreckage[index][_RZ],0,.streamdistance = 150.0,.drawdistance = 150.0);
    formatex64("ID:%i\n%s \n汽车残骸",index,VehName[CraftVehicleList[VehicleWreckage[index][_CraftVehID]][_VehicleModel]-400]);
    VehicleWreckage[index][_3DtextID]=CreateDynamic3DTextLabel(string64, -1, VehicleWreckage[index][_X],VehicleWreckage[index][_Y],VehicleWreckage[index][_Z],10.0,.testlos = 0,.worldid = 0);
    VehicleWreckage[index][_AreaID]=CreateDynamicCylinder(VehicleWreckage[index][_X],VehicleWreckage[index][_Y],VehicleWreckage[index][_Z]-2.0,VehicleWreckage[index][_Z]+2.0,3.0,0);
	UpdateStreamer(VehicleWreckage[index][_X],VehicleWreckage[index][_Y],VehicleWreckage[index][_Z],0);
	return RETURN_SUCCESS;
}
FUNC::DestoryVehicleWreckage(index)
{
	if(!Iter_Contains(VehicleWreckage,index))
	{
	    formatex80("%i-dvw error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	DestoryVehicleWreckageModel(index);
	Iter_Remove(VehicleWreckage,index);
 	return RETURN_SUCCESS;
}
FUNC::DestoryVehicleWreckageModel(index)
{
	if(!Iter_Contains(VehicleWreckage,index))
	{
	    formatex80("%i-dvwm error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	CA_DestroyObject_DC(VehicleWreckage[index][_ObjectIndex]);
	VehicleWreckage[index][_ObjectIndex]=INVALID_STREAMER_ID;
	DestroyDynamic3DTextLabel(VehicleWreckage[index][_3DtextID]);
	VehicleWreckage[index][_3DtextID]=Text3D:INVALID_STREAMER_ID;
	DestroyDynamicArea(VehicleWreckage[index][_AreaID]);
	VehicleWreckage[index][_AreaID]=INVALID_STREAMER_ID;
	return RETURN_SUCCESS;
}
/**********************************************************************/
FUNC::CreateVehData(CraftVehKey[],Float:x,Float:y,Float:z,Float:rot,color0,color1,siren,vehplate[],bool:tempveh)
{
	if(Iter_Count(Veh)>=MAX_VEHICLES)
	{
	    formatex80("-cvd error0");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
	new CraftVehID=GetCraftVehIDByCraftVehKey(CraftVehKey);
	if(CraftVehID==NONE)
	{
	    formatex80("-cvd error1");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(Veh);
    format(Veh[i][_CraftVehKey],UUID_LEN,CraftVehKey);
    UUID(Veh[i][_Key], UUID_LEN);
    Veh[i][_X]=x;
    Veh[i][_Y]=y;
    Veh[i][_Z]=z;
    Veh[i][_Rot]=rot;
    Veh[i][_Siren]=siren;
    Veh[i][_Color][0]=color0;
    Veh[i][_Color][1]=color1;
    Veh[i][_Hp]=1000.0;
    Veh[i][_Fuel]=60.0;
    format(Veh[i][_Plate],32,vehplate);
    Veh[i][_CraftVehID]=CraftVehID;
    Veh[i][_Temp]=tempveh;
    Iter_Add(Veh,i);
    
    if(tempveh==false)
    {
	    formatex1024("INSERT INTO `"MYSQL_DB_VEHICLE"`(`密匙`,`汽车Key`,`X坐标`,`Y坐标`,`Z坐标`,`ROT坐标`,`颜色0`,`颜色1`,`车牌`,`警笛`) VALUES ('%s','%s','%f','%f','%f','%f','%i','%i','%s','%i')",Veh[i][_Key],CraftVehKey,x,y,z,rot,color0,color1,vehplate,siren);
	   	mysql_query(Account@Handle,string1024,true);
   	}
   	
   	CreateVehModel(i);
    return 1;
}
FUNC::GetVehIDByVehicleID(vehicleid)
{
	foreach(new i:Veh)
	{
	    if(Veh[i][_VehID]==vehicleid)return i;
	}
	return NONE;
}
FUNC::CreateVehModel(index)
{
    Veh[index][_VehID]=CreateVehicle(CraftVehicleList[Veh[index][_CraftVehID]][_VehicleModel],Veh[index][_X],Veh[index][_Y],Veh[index][_Z],Veh[index][_Rot],Veh[index][_Color][0],Veh[index][_Color][1],-1,Veh[index][_Siren]);
    Veh[index][_AreaID]=CreateDynamicSphere(0.0,0.0,0.0,4.0);
    formatex32("ID:%i\nVehicleID:%i",index,Veh[index][_VehID]);
    Veh[index][_3DtextID]=CreateDynamic3DTextLabel(string32,-1,0.0,0.0,0.0,20.0,INVALID_PLAYER_ID,Veh[index][_VehID]);

    SetVehicleNumberPlate(Veh[index][_VehID],Veh[index][_Plate]);
    SetVehicleToRespawn(Veh[index][_VehID]);
    AttachDynamicAreaToVehicle(Veh[index][_AreaID],Veh[index][_VehID],0.0,0.0,0.0);
	UpdateStreamer(Veh[index][_X],Veh[index][_Y],Veh[index][_Z],0);

	if(Veh[index][_Temp]==false)GobalVeh[Veh[index][_VehID]]=index;
	GobalVehicleFuel[Veh[index][_VehID]]=Veh[index][_Fuel];
	GobalVehicleHP[Veh[index][_VehID]]=Veh[index][_Hp];
    SetVehicleHealth(Veh[index][_VehID],GobalVehicleHP[Veh[index][_VehID]]);
    Veh[index][Timer:_Delete]=NONE;
	return RETURN_SUCCESS;
}
FUNC::DestoryVehModel(index)
{
	if(!Iter_Contains(Veh,index))
	{
	    formatex80("%i-dvm error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	GobalVeh[Veh[index][_VehID]]=NONE;
	GobalVehicleFuel[Veh[index][_VehID]]=0.0;
	GobalVehicleHP[Veh[index][_VehID]]=0.0;
	
	DestroyVehicle(Veh[index][_VehID]);
	Veh[index][_VehID]=INVALID_VEHICLE_ID;
	DestroyDynamicArea(Veh[index][_AreaID]);
	Veh[index][_AreaID]=INVALID_STREAMER_ID;
	DestroyDynamic3DTextLabel(Veh[index][_3DtextID]);
	Veh[index][_3DtextID]=Text3D:INVALID_STREAMER_ID;
	return RETURN_SUCCESS;
}
FUNC::DestoryVeh(index)
{
	if(!Iter_Contains(Veh,index))
	{
	    formatex80("%i-dv error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	if(Veh[index][_Temp]==false)
	{
		formatex128("DELETE FROM `"MYSQL_DB_VEHICLE"` WHERE `"MYSQL_DB_VEHICLE"`.`密匙`='%s'",Veh[index][_Key]);
		mysql_query(Account@Handle,string128,false);
		new Float:x,Float:y,Float:z,Float:a;
		GetVehiclePos(Veh[index][_VehID],x,y,z);
		GetVehicleZAngle(Veh[index][_VehID],a);
		CrateVehWreSpawn(Veh[index][_CraftVehKey],x,y,z-0.3,0.0,a,0.0);
	}
	DestoryVehModel(index);
	Veh[index][Timer:_Delete]=NONE;
	Iter_Remove(Veh,index);
	return RETURN_SUCCESS;
}
CMD:addveh(playerid, params[])
{
	if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<3)return SCM(playerid,-1,"你不是管理员3级");
	SPD(playerid,_SPD_GM_ADD_VEH,DIALOG_STYLE_TABLIST_HEADERS,"添加汽车",ShowCraftVehicles(playerid,DialogPage[playerid]),"确定","取消");
	return 1;
}
FUNC::LoadVehs()//读取汽车
{
    RestVehs();
	formatex128("SELECT * FROM `"MYSQL_DB_VEHICLE"`");
    mysql_tquery(Account@Handle,string128, "OnVehsLoad");
	return 1;
}
FUNC::SaveVehDate(vehicleid)
{
	if(GobalVeh[vehicleid]!=NONE)
	{
		formatex128("UPDATE `"MYSQL_DB_VEHICLE"` SET  `油量`='%f' WHERE  `"MYSQL_DB_VEHICLE"`.`密匙` ='%s'",GobalVehicleFuel[vehicleid],Veh[GobalVeh[vehicleid]][_Key]);
		mysql_query(Account@Handle,string128,false);
		if(GobalVehicleHP[vehicleid]>249.0)
		{
			format(string128,128,"UPDATE `"MYSQL_DB_VEHICLE"` SET  `车血`='%f' WHERE  `"MYSQL_DB_VEHICLE"`.`密匙` ='%s'",GobalVehicleHP[vehicleid],Veh[GobalVeh[vehicleid]][_Key]);
			mysql_query(Account@Handle,string128,false);
		}
	}
	return 1;
}
FUNC::OnVehsLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_VEHICLES)
	    {
            cache_get_field_content(i,"密匙",Veh[i][_Key],Account@Handle,37);
            cache_get_field_content(i,"汽车Key",Veh[i][_CraftVehKey],Account@Handle,37);
	    	Veh[i][_X]=cache_get_field_content_int(i,"X坐标",Account@Handle);
	    	Veh[i][_Y]=cache_get_field_content_float(i,"Y坐标",Account@Handle);
			Veh[i][_Z]=cache_get_field_content_float(i,"Z坐标",Account@Handle);
			Veh[i][_Rot]=cache_get_field_content_float(i,"ROT坐标",Account@Handle);
			Veh[i][_Color][0]=cache_get_field_content_int(i,"颜色0",Account@Handle);
			Veh[i][_Color][1]=cache_get_field_content_int(i,"颜色1",Account@Handle);
			cache_get_field_content(i,"车牌",Veh[i][_Plate],Account@Handle,32);
			Veh[i][_Siren]=cache_get_field_content_int(i,"警笛",Account@Handle);
			Veh[i][_Hp]=cache_get_field_content_float(i,"车血",Account@Handle);
			Veh[i][_Fuel]=cache_get_field_content_float(i,"油量",Account@Handle);
			new GetCraftVehID=GetCraftVehIDByCraftVehKey(Veh[i][_CraftVehKey]);
			if(GetCraftVehID==NONE)
			{
				formatex128("DELETE FROM `"MYSQL_DB_VEHICLE"` WHERE `"MYSQL_DB_VEHICLE"`.`密匙`='%s'",Veh[i][_Key]);
				mysql_query(Account@Handle,string128,false);
				printf("载具密匙-[%s]异常,已删除",Veh[i][_Key]);
			}
			else
			{
			    Veh[i][_CraftVehID]=GetCraftVehID;
			    Veh[i][_Temp]=false;
				Iter_Add(Veh,i);
				printf("载具密匙-[%s][%s]",Veh[i][_Key],VehName[CraftVehicleList[GetCraftVehID][_VehicleModel]-400]);
			}
		}
		else
		{
		    printf("载具溢出");
			break;
		}
	}
	if(Iter_Count(Veh)>0)
	{
	    foreach(new i:Veh)CreateVehModel(i);
	}
	return 1;
}
FUNC::RestVehs()
{
   	Iter_Clear(Veh);
	return 1;
}
