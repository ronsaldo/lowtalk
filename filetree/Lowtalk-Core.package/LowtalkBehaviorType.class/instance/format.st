formatting
format
	<compileTime>
	| isize |
	isize := self instanceSize.
	^ compiler objectModel createNamedFormat: self layoutType withInstanceSize: isize