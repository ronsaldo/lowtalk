expressions
dottedFloatNumber
	^ self token: ($- asParser optional, #digit asParser plus , $. asParser , #digit asParser plus, ($e asParser , $- asParser optional, #digit asParser plus) optional)