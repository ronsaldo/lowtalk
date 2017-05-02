expressions
scientificFloatNumber
	^ self token: ($- asParser optional, #digit asParser plus , $e asParser , $- asParser optional, #digit asParser plus)