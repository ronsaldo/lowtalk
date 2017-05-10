accessing
name
	^ name ifNil: [name := pointed name , ' pointer']