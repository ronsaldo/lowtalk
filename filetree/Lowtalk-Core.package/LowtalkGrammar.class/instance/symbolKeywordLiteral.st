expressions
symbolKeywordLiteral
	^ self token: $# asParser, (identifierStart , identifierInner star , $: asParser) plus