accessing
anyIdentifier
	^ (self token: identifierStart ,  identifierInner star , $: asParser not)