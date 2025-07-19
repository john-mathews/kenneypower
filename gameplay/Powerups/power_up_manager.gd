extends Node

enum power_up_types {
	BIGGER,
	REPAIR,
	VACCUUM,
	COLD_SHOWER,
	NUKE
}

var available_power_ups := [power_up_types.BIGGER]
var bigger_icon_uid := 'uid://del7xqamxln8u'

var icon_map : Dictionary[power_up_types, String] = {
	power_up_types.BIGGER: bigger_icon_uid
}
