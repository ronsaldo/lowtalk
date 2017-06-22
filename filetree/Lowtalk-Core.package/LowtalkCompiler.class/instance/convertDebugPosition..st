as yet unclassified
convertDebugPosition: aPosition
	^ debugLocationDictionary at: aPosition ifAbsentPut: [ SLVMDebugLocation new
			sourceFile: (self convertDebugSourceFile: aPosition collection);
			startLine: aPosition line;
			startColumn: aPosition column;
			endLine: aPosition endLine;
			endColumn: aPosition endColumn;
			yourself ]