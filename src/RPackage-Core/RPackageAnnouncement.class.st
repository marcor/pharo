"
Common superclass for package related announcements
"
Class {
	#name : #RPackageAnnouncement,
	#superclass : #SystemAnnouncement,
	#instVars : [
		'package'
	],
	#category : #'RPackage-Core-Announcements'
}

{ #category : #'instance creation' }
RPackageAnnouncement class >> to: aPackage [

	^ self new package: aPackage
]

{ #category : #testing }
RPackageAnnouncement >> affectsPackages [

	^true
]

{ #category : #accessing }
RPackageAnnouncement >> package [

	^ package
]

{ #category : #accessing }
RPackageAnnouncement >> package: anObject [

	package := anObject
]
