###Design pattern in ruby

####Instroduction

When I reading *Head First Design Patter*, I wonder that how to rewrite the project in this book in ruby.

###1.Strategy Pattern

####Problem description

Class Duck has many subclasses whose have different behavior in `fly()` and `pquack()`, the simple inheritance makes many repeat code.

####Soultion

1. Collect the behavior things from class Duck to reduce repeat code.

2. Delegate the behaviour to specific class to keep class Duck stable.

###2.Observer Pattern

####Problem description

1. Subject has many observer and some observer may be leave.
2. A subject should notify its observers.
3. Observer should update data on its view when the data is changed.
4. This system should has good expansibility.

####Soultion

1. Use Subject/Observer design pattern.
2. A subject can receive and remove observers and store them in a list.
3. A subject can notify its observers by call their update method.
4. A observer can register one or more subject.
5. A observer should handle the notification to update its data showing in views.

###3.Decorate Pattern

####Problem description

1. A Beverage class has too many subclasses.
2. These subclass has only simple relationship of combination.

###Soultion

Decorate Beverage subclass with other subclasses.

###4.Factory Pattern

####Problem description

A PizzaStore has many kinds of Pizza, so there has big chunk of elsif.

####Soultion

Delegate the Pizza instruction to the a Pizza Factory.


###4.Singleton Pattern

####Problem description

Let a Class has a singleton instance and can not user `MyClass.new`.

####Soultion

Change `MyClass`'s singleton new method as private and call it with in `MyClass`.


