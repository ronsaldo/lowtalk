accessing
addSubclass: aSubclass
	(subclasses includes: aSubclass) ifFalse: [
		subclasses := subclasses copyWith: aSubclass
	]
