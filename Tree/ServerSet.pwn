FUNC::ServerSet_OnGameModeInit()
{

	return 1;
}
FUNC::ServerSet_SaveServerRunTime()
{
	if(SeverState[_ServerRun]==true)
	{
	    SeverState[_RunTimes]++;
	    new Query[128];
		format(Query,sizeof(Query),"UPDATE `"MYSQL_SERVER_SET"` SET  `运行时间` = '%i'",SeverState[_RunTimes]);
		mysql_query(Server@Handle,Query,false);
	}
	return 1;
}
FUNC::ServerSet_LoadServerRunTime()
{
	mysql_query(Server@Handle,"SELECT * FROM `"MYSQL_SERVER_SET"`",true);
	SeverState[_RunTimes]=cache_get_field_content_int(0,"运行时间",Server@Handle);
	SeverState[_ServerRun]=false;
	return 1;
}
