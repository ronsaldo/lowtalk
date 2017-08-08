accessing
name
	^ name ifNil: [ name := classObject lowtalkPerform: #name withArguments: #() types: #() inSuperclass: false node: nil compiler: compiler ]