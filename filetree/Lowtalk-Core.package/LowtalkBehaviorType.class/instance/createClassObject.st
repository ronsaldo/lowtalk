as yet unclassified
createClassObject
	| metaInstanceSize |
	metaInstanceSize := self metaClass instanceSize.
	classObject := self createRawObjectOfLayoutType: self metaClass layoutType size: metaInstanceSize.
	compiler registerClassType: self for: classObject.
	compiler registerObject: classObject builder: self.
	bindingVariable ifNotNil: [
		compiler registerVariable: bindingVariable objectInstanceValue: classObject
	] ifNil: [ 
		(thisClass isNotNil and: [ thisClass bindingVariable isNotNil and: [ bindingVariable isNil]]) ifTrue: [ 
			compiler registerVariableName: thisClass bindingVariable forMetaClass: classObject
		].
	].

	compiler objectModel setObject: classObject class: self metaClass classObject.
	
	classObject lowtalkPerform: #importDataFromType: withArguments: { self } types: { compiler objectType } inSuperclass: false node: nil compiler: compiler