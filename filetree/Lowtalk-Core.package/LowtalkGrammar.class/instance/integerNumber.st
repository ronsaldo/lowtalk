expressions
integerNumber
	^ self token: ($- asParser optional, #digit asParser plus , ($r asParser, (#digit asParser / #letter asParser) plus) optional)