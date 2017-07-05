accessing
name
	^ name ifNil: [ name := classObject lowtalkPerform: #name withArguments: #() inSuperclass: false node: nil compiler: self ]