as yet unclassified
convertDebugSourceFile: aSourceCollection
	| sourceRef |
	^ debugSourceFileDictionary at: aSourceCollection ifAbsentPut: [ 
		sourceRef := aSourceCollection name asFileReference.
		SLVMDebugSourceFile new
			directory: sourceRef parent fullName;
			name: sourceRef basename
	]