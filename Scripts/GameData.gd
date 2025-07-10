#
#
#enum Groups { 
	#Inimigos,
	#Player,
#}
#
#const GroupsName = {
	#Groups.Inimigos: "Inimigos",
	#Groups.Player: "Player",
#}
#
#func GetGroupName(value: int) -> String:
	#return str(GroupsName.get(value, "UNKNOWN"))
