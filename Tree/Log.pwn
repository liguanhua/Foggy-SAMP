FUNC::InsertChatLog(PlayerKey[],PlayerName[],Text[])
{
	new Escape[256];
	mysql_escape_string(Text,Escape);
    formatex512("INSERT INTO `"MYSQL_SERVER_CHAT_LOG"`(`�û��ܳ�`,`�û���`,`����`) VALUES ('%s','%s','%s')",PlayerKey,PlayerName,Escape);
	mysql_query(Log@Handle,string512,false);
   	return 1;
}
FUNC::InsertCheatLog(PlayerKey[],PlayerName[],Text[])
{
    formatex512("INSERT INTO `"MYSQL_SERVER_CHEAT_LOG"`(`�û��ܳ�`,`�û���`,`����`) VALUES ('%s','%s','%s')",PlayerKey,PlayerName,Text);
   	mysql_query(Log@Handle,string512,false);
   	return 1;
   	
}
