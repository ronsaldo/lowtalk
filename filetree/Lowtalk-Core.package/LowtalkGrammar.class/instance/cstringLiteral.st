expressions
cstringLiteral
	^ self token: 'c''' asParser , (($\ asParser, #any asParser) / $' asParser negate) star , $' asParser