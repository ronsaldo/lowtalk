private
styleTable
	"color can be a valid argument to Color class>>colorFrom: , or nil to
	use the editor text color.
	Multiple emphases can be specified using an array e.g. #(bold italic).
	If emphasis is not specified, #normal will be used.
	if pixel height is not specified , then the editor font size will be used.
	
	This style is base on darkula theme from eclipse: http://eclipsecolorthemes.org/?view=theme&id=15515.  
	"
	<styleTable: 'Dark'>

	^ #(
			(searchResultIndication '616161')
			(filteredSearchResultIndication '616161')
			(occurrenceIndication '616161')
			(writeOccurrenceIndication '616161')
			(findScope 'E0E2E4')
			(deletionIndication 'E0E2E4')
			(sourceHoverBackground 'FFFFFF')
			(singleLineComment '7D8C93')
			(multiLineComment '7D8C93')
			(commentTaskTag 'FF8BFF')
			(javadoc '7D8C93')
			(javadocLink '678CB1')
			(javadocTag '006666')
			(javadocKeyword 'A082BD')
			(class '0080FF')
			(interface '3B94ED')
			(method '7EE7FA')
			(methodDeclaration 'A3D2FF')
			(bracket 'E8E2B7')
			(number 'FFE54B')
			(string 'E38C1E')
			(operator 'FAF0AC')
			(keyword '00CC6E')
			(annotation 'B4DD6E')
			(staticMethod 'B4A6FF')
			(localVariable 'A7E2ED')
			(localVariableDeclaration 'A7E2ED')
			(field '678CB1')
			(staticField 'BDA9F5')
			(staticFinalField 'BDA9F5')
			(deprecatedMember 'E0E2E4')
			(enum '0080FF')
			(inheritedMethod '7EE7FA')
			(abstractMethod '7EE7FA')
			(parameterVariable 'E0E2E4')
			(typeArgument 'E0E2E4')
			(typeParameter 'E0E2E4')
			(constant 'A082BD')
			(background '1E1E23')
			(currentLine '2F393C')
			(foreground 'EEEEEE')
			(lineNumber '81969A')
			(selectionBackground '804000')
			(selectionForeground 'E0E2E4')
			
			(identifier '0080FF')
			(symbol 'E38C1E') 
			(callBracket 'FFE54B')
			(methodBracket '7EE7FA')
			(methodHeaderSelector white bold)
			(localDefinition 'A7E2ED')
			(bar white)
	)
