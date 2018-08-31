Class {
	#name : #LowtalkClassInstaller,
	#superclass : #PharoClassInstaller,
	#category : #'Lowtalk-ClassInstaller'
}

{ #category : #migrating }
LowtalkClassInstaller >> migrateClasses: old to: new using: anInstanceModification [
	instanceModification := anInstanceModification.
	old ifEmpty:  [ ^ self ].
	[
		1 to: old size do: [ :index |
			self updateClass: (old at: index) to: (new at: index)].
		old elementsForwardIdentityTo: new.
	] valueUnpreemptively
]
