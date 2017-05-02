expressions
dottedFloatNumber
	^ self token: ($- asParser optional, #digit asParser plus , $. asParser , #digit asParser, ($e asParser , $- asParser optional, #digit asParser plus) optional)