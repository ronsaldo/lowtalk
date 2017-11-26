writing
writeClasses
	self sortClasses.
	classes do: [ :cls | self writeClass: cls ]