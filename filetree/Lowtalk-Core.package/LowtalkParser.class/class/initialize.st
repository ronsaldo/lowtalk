initialization
initialize
	CEscapeSequenceMap := Dictionary newFromPairs: { 
		$a . 16r07 asCharacter. "Alert"
		$b . 16r08 asCharacter. "Backspace"
		$f . 16r0C asCharacter. "Form feed"
		$n . Character lf.
		$r . Character cr.
		$t . Character tab.
		$v . 16r0B asCharacter. "Vertical tab"
		$e . 16r1B asCharacter. "Escape"
	}