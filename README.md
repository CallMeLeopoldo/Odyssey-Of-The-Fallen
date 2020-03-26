# Odyssey-Of-The-Fallen


#Just a quick info about creating classes and subclasses with Middleclass
#When creating a class, do the following:

#1: Create the superclass, having the initialize method (mandatory)

#Example:
#local Person = class("Person")
#function Person:initialize(x,y,w,h)
#	self.x,self.y = x,y
#	self.w, self.h = w,h
#	self.health = 100
#	self.dmgdealing = 1
#end
#return Person


#2: To instantiate the class, all you have to do is:
#		name_of_instance = name_of_class:new()

#Example:
#person = Person:new(10,10,64,64)


#3: To create a subclass, tou must create the subclass in the following way:

#			name_of_subclass = class("name_of_subclass", superclass)
#			or
#			name_of_subclass = superclass:class("name_of_subclass")

#Example:
#local BasicEnemy = class("BasicEnemy", Person)
#or
#local BasicEnemy = Person:class("BasicEnemy")

#4: To instantiate the subclass, just have to instantiate like any other class
#Example:
#enemy = BasicEnemy:new(10,10,64,64)


#Note: When creating a subclass, if you wish to use the superclass constructor,you must
#specify the call for that constructor in the subclass intialize method

#Example:
#function BasicEnemy:initialize(x,y,w,h)
#	Person:initialize(x,y,w,h)
#	self.accuracy = 1
#end 