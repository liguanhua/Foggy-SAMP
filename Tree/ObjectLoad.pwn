/*#define MAX_GRASS 200001
enum Grass_Info
{
	_ObjectID,
	Float:_X,
	Float:_Y,
	Float:_Z
}
new Grass[MAX_GRASS][Grass_Info];
new Iterator:Grass<MAX_GRASS>;*/

enum RemoveBuild_InFo
{
	_modelid,
	Float:_fX,
	Float:_fY,
	Float:_fZ,
	Float:_fRadius
}
#define MAX_REMOVEBUILD 1000
new RemoveBuild[MAX_REMOVEBUILD][RemoveBuild_InFo];
new Iterator:RemoveBuild<MAX_REMOVEBUILD>;
stock tokenbydelim(strings[], return_str[], delim, start_index)
{
    new x = 0;
    while(strings[start_index] != EOS && strings[start_index] != delim)
    {
        return_str[x] = strings[start_index];
        x ++;
        start_index ++;
    }
    return_str[x] = EOS;
    if(strings[start_index] == EOS) start_index = (-1);
    return start_index;
}
enum
{
    OBJECT_NONE,
	OBJECT_DYNAMIC,
	OBJECT_GENERAL,
	OBJECT_REMOVE,
	OBJECT_DYNAMIC_S
}
stock ClearObjectCodeLine(line[],Type)
{
	switch(Type)
	{
	    case OBJECT_DYNAMIC:strdel(line, 0, 20);
	    case OBJECT_GENERAL:strdel(line, 0, 13);
	    case OBJECT_REMOVE:strdel(line, 0, 23);
	    case OBJECT_DYNAMIC_S:strdel(line, 0, 21);
	}
    return 1;
}
FUNC::GetObjectCodeType(line[])
{
    if(strfind(line, "CreateDynamicObjectS", false) != -1)return OBJECT_DYNAMIC_S;
	if(strfind(line, "CreateDynamicObject", false) != -1)return OBJECT_DYNAMIC;
    if(strfind(line, "CreateObject", false) != -1)return OBJECT_GENERAL;
    if(strfind(line, "RemoveBuildingForPlayer", false) != -1)return OBJECT_REMOVE;
    return OBJECT_NONE;
}
FUNC::LoadObjectMapFromFile()
{
    new AmoutAll=0,RemoveAll=0;
	forex(i,100)
	{
	    formatex64("Maps/%i.pwn",i);
	    if(fexist(string64))
	    {
		    new File:fileHandle = fopen(string64, io_read);
		    if(fileHandle)
		    {
		        new idx,line[64],buf[128],Type,ObjectAmount=0,RemoveAmount=0,Sobjs=0,Smodelid=INVALID_STREAMER_ID;
		        new modelid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz;
		        while(fread(fileHandle, buf))
		        {
		            Type=GetObjectCodeType(buf);
					switch(Type)
					{
					    case OBJECT_DYNAMIC,OBJECT_GENERAL:
					    {
			                if(ClearObjectCodeLine(buf,Type))
			                {
				                idx = 0;
				                idx = tokenbydelim(buf, line, ',', idx);modelid = strval(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));x = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));y = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));z = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));rx = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));ry = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));rz = floatstr(line);
				                CA_CreateDynamicObject_SC(modelid,x,y,z,rx,ry,rz,0,-1,-1,1000.0);
				                ObjectAmount++;
		                    }
					    }
					    case OBJECT_DYNAMIC_S:
					    {
			                if(ClearObjectCodeLine(buf,Type))
			                {
				                idx = 0;
				                idx = tokenbydelim(buf, line, ',', idx);modelid = strval(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));x = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));y = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));z = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));rx = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));ry = floatstr(line);
				                idx = tokenbydelim(buf, line, ',', (idx + 1));rz = floatstr(line);
                                Smodelid=INVALID_STREAMER_ID;
								Smodelid=CreateDynamicObject(modelid,x,y,z,rx,ry,rz,0,-1,-1,500.0,500.0);
								Streamer_SetIntData(STREAMER_TYPE_OBJECT,Smodelid,E_STREAMER_EXTRA_ID,50000+i);
								Sobjs++;
				                ObjectAmount++;
				                //printf("%i",Sobjs);
		                    }
					    }
					    case OBJECT_REMOVE:
					    {
			                if(ClearObjectCodeLine(buf,Type))
			                {
			                    if(Iter_Count(RemoveBuild)<MAX_REMOVEBUILD)
			                    {
					                idx = 0;
					                idx = tokenbydelim(buf, line, ',', idx);
					                idx = tokenbydelim(buf, line, ',', (idx + 1));modelid = strval(line);
					                idx = tokenbydelim(buf, line, ',', (idx + 1));x = floatstr(line);
					                idx = tokenbydelim(buf, line, ',', (idx + 1));y = floatstr(line);
					                idx = tokenbydelim(buf, line, ',', (idx + 1));z = floatstr(line);
					                idx = tokenbydelim(buf, line, ',', (idx + 1));rx = floatstr(line);
                                    new s=Iter_Free(RemoveBuild);
                                    RemoveBuild[s][_modelid]=modelid;
									RemoveBuild[s][_fX]=x;
									RemoveBuild[s][_fY]=y;
									RemoveBuild[s][_fZ]=z;
									RemoveBuild[s][_fRadius]=rx;
									Iter_Add(RemoveBuild,s);
									RemoveAmount++;
								}
				                else
								{
									//printf("超出REMOVEBULID限制");
									RemoveAmount++;
								}
			                }
					    }
					}
				}
		        fclose(fileHandle);
		        printf("%s 共加载OBJ %i 个 REMOVEBUILD %i个",string64,ObjectAmount,RemoveAmount);
                AmoutAll+=ObjectAmount;
                RemoveAll+=RemoveAmount;
			}
		}
	}
	printf("共计OBJ %i 个 REMOVEBUILD %i个",AmoutAll,RemoveAll);
    return 1;
}
FUNC::ObjectLoad_OnPlayerConnect(playerid)
{
	foreach(new i:RemoveBuild)RemoveBuildingForPlayer(playerid,RemoveBuild[i][_modelid],RemoveBuild[i][_fX],RemoveBuild[i][_fY],RemoveBuild[i][_fZ],RemoveBuild[i][_fRadius]);
	return 1;
}
#define GetDynamicObjectPoolSize()				Streamer_GetUpperBound(STREAMER_TYPE_OBJECT)
#define ForDynamicObjects(%1) for(new %1 = 1, p_%1 = GetDynamicObjectPoolSize(); %1 <= p_%1; %1++)
/*enum GrassModel_Info
{
    _Model,
    Float:_FindZ
}
new GrassModel[][GrassModel_Info]=
{
	{819,1.090072},
	{855,1.520003},
	{821,1.549999},
	{822,1.160074},
	{823,2.169927},
	{824,1.399929},
	{826,1.560072},
	{827,3.539929},
	{856,0.255218},
	{874,1.572614}
};*/
FUNC::CreateGrass()
{
/*	forex(i,MAX_GRASS)
	{
	    new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
        GetGrassSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);
        CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
		new RandGrass=random(sizeof(GrassModel));
        Grass[i][_ObjectID]=CreateDynamicObject(GrassModel[RandGrass][_Model],Gpos_X,Gpos_Y,Gpos_Z+GrassModel[RandGrass][_FindZ],0.0,0.0,0.0,0);
        Grass[i][_X]=Gpos_X;
        Grass[i][_Y]=Gpos_Y;
        Grass[i][_Z]=Gpos_Z;
        Iter_Add(Grass,i);
        printf("CreateDynamicObject(%i,%f,%f,%f,0.0,0.0,0.0,0);-%i",GrassModel[RandGrass][_Model],Gpos_X,Gpos_Y,Gpos_Z+GrassModel[RandGrass][_FindZ],i);
	}*/
	return 1;
}
FUNC::GetGrassSpawnPos(&Float:Gpos_X,&Float:Gpos_Y,&Float:Gpos_Z)
{
	GetRandomPointInRectangle(-3000,-3000,3000,3000,Gpos_X,Gpos_Y);
	CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
    while(GetPointCollisionFlags(Gpos_X,Gpos_Y,Gpos_Z)==17||IsGrassSpawnPosInRange(Gpos_X,Gpos_Y,5.0))
	{
 		GetRandomPointInRectangle(-3000,-3000,3000,3000,Gpos_X,Gpos_Y);
		CA_FindZ_For2DCoord(Gpos_X,Gpos_Y,Gpos_Z);
 	}
	return 1;
}
FUNC::RestFactionAreaIDObjs(index)
{
	new Float:_Ox,Float:_Oy,Float:_Oz;
	ForDynamicObjects(i)
	{
	    if(IsValidDynamicObject(i))
		{
		    if(Streamer_GetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_EXTRA_ID)>=50000)
		    {
		        GetDynamicObjectPos(i,_Ox,_Oy,_Oz);
		        if(IsPointInDynamicArea(Faction[index][_Areaid],_Ox,_Oy,_Oz))
		        {
	                Streamer_SetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_WORLD_ID,0);
		        }
	        }
        }
	}
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
			if(IsPlayerInDynamicArea(i,Faction[index][_Areaid]))Streamer_Update(i,STREAMER_TYPE_OBJECT);
	    }
	}
/*	new Float:_Fmaxx,Float:_Fmaxy,Float:_Fminx,Float:_Fminy,Float:_CenterX,Float:_CenterY,Float:_CenterZ;
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MAX_X,_Fmaxx);
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MAX_Y,_Fmaxy);
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MIN_X,_Fminx);
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MIN_Y,_Fminy);
	GetZoneCenterPoint(_Fminx,_Fminy,_Fmaxx,_Fmaxy,_CenterX,_CenterY);
	CA_FindZ_For2DCoord(_CenterX,_CenterY,_CenterZ);
    UpdateStreamer(_CenterX,_CenterY,_CenterZ,0,-1,STREAMER_TYPE_OBJECT);*/
	return 1;
}
FUNC::ClearFactionAreaIDObjs(index)
{
	new Float:_Ox,Float:_Oy,Float:_Oz;
	ForDynamicObjects(i)
	{
	    if(IsValidDynamicObject(i))
		{
		    if(Streamer_GetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_EXTRA_ID)>=50000)
		    {
		        GetDynamicObjectPos(i,_Ox,_Oy,_Oz);
		        if(IsPointInDynamicArea(Faction[index][_Areaid],_Ox,_Oy,_Oz))
		        {
	                Streamer_SetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_WORLD_ID,ZOMBIE_DEATH_WORLD);
				}
	        }
        }
	}
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
			if(IsPlayerInDynamicArea(i,Faction[index][_Areaid]))Streamer_Update(i,STREAMER_TYPE_OBJECT);
	    }
	}
/*	new Float:_Fmaxx,Float:_Fmaxy,Float:_Fminx,Float:_Fminy,Float:_CenterX,Float:_CenterY,Float:_CenterZ;
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MAX_X,_Fmaxx);
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MAX_Y,_Fmaxy);
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MIN_X,_Fminx);
	Streamer_GetFloatData(STREAMER_TYPE_AREA,index,E_STREAMER_MIN_Y,_Fminy);
	GetZoneCenterPoint(_Fminx,_Fminy,_Fmaxx,_Fmaxy,_CenterX,_CenterY);
	CA_FindZ_For2DCoord(_CenterX,_CenterY,_CenterZ);
    UpdateStreamer(_CenterX,_CenterY,_CenterZ,0,-1,STREAMER_TYPE_OBJECT);*/
	return 1;
}
FUNC::ClearFactionAreaObjs()
{
	new Float:_Ox,Float:_Oy,Float:_Oz;
	ForDynamicObjects(i)
	{
	    if(IsValidDynamicObject(i))
		{
		    if(Streamer_GetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_EXTRA_ID)>=50000)
		    {
		        GetDynamicObjectPos(i,_Ox,_Oy,_Oz);
			    foreach(new s:Faction)
			    {
			        if(IsPointInDynamicArea(Faction[s][_Areaid],_Ox,_Oy,_Oz))
			        {
		                Streamer_SetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_WORLD_ID,ZOMBIE_DEATH_WORLD);
			        }
			    }
		    }
		}
	}
	return 1;
}
FUNC::IsGrassSpawnPosInRange(Float:xx,Float:yy,Float:range)
{
/*	if(Iter_Count(Grass)>0)
	{
	    foreach(new i:Grass)
	    {
	        new Float:distancez=GetDistanceBetweenPoints2D(Grass[i][_X],Grass[i][_Y],xx,yy);
	        if(distancez<range)return 1;
	    }
    }
    else return 0;*/
	return 0;
}
