###Design pattern in ruby

####Instroduction

When I reading *Head First Design Patter*, I wonder that how to rewrite the project in this book in ruby.

####1.Strategy Pattern

#####Problem description

Class Duck has many subclasses whose have different behavior in `fly()` and `pquack()`, the simple inheritance makes many repeat code.

#####Soultion

1. Collect the behavior things from class Duck to reduce repeat code.

2. Delegate the behaviour to specific class to keep class Duck stable.

