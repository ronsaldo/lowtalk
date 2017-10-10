as yet unclassified
selectLayoutClassWithSuperclass: aSuperclass
	layoutType ifNotNil: [
		self halt.
	].

	nativeSlots ifNotEmpty: [
		^ SLVMStructureLayout
	].

	^ aSuperclass classLayout class