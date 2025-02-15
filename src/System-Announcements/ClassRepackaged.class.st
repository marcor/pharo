"
Notify about repackaging of a class
"
Class {
	#name : #ClassRepackaged,
	#superclass : #ClassAnnouncement,
	#instVars : [
		'classRepackaged',
		'newPackage',
		'oldPackage'
	],
	#category : #'System-Announcements-System-Packages'
}

{ #category : #'instance creation' }
ClassRepackaged class >> classRepackaged: aClass oldPackage: oldPackage newPackage: newPackage [
	^self new
			classRepackaged: aClass;
			oldPackage: oldPackage;
			newPackage: newPackage;
			yourself
]

{ #category : #testing }
ClassRepackaged >> affectsMethods [
	"methods belong to class which could be represented by tools as part of method"
	^true
]

{ #category : #testing }
ClassRepackaged >> affectsMethodsDefinedInClass: aClass [

	^classRepackaged == aClass
]

{ #category : #testing }
ClassRepackaged >> affectsMethodsDefinedInPackage: aPackage [

	^oldPackage == aPackage or: [ newPackage == aPackage ]
]

{ #category : #testing }
ClassRepackaged >> affectsMethodsTaggedWith: tagName [
	^classRepackaged tagsForMethods includes: tagName
]

{ #category : #accessing }
ClassRepackaged >> classAffected [

	^ classRepackaged
]

{ #category : #accessing }
ClassRepackaged >> classRepackaged [

	^ classRepackaged
]

{ #category : #accessing }
ClassRepackaged >> classRepackaged: anObject [

	classRepackaged := anObject
]

{ #category : #accessing }
ClassRepackaged >> newPackage [

	^ newPackage
]

{ #category : #accessing }
ClassRepackaged >> newPackage: anObject [

	newPackage := anObject
]

{ #category : #accessing }
ClassRepackaged >> oldPackage [

	^ oldPackage
]

{ #category : #accessing }
ClassRepackaged >> oldPackage: anObject [

	oldPackage := anObject
]

{ #category : #accessing }
ClassRepackaged >> packagesAffected [
	^{oldPackage. newPackage}
]
