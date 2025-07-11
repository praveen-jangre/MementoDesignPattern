# The Memento (A Behavioral Design Pattern)
The Memento design pattern provides a way to capture an object's internal state without violating encapsulation, allowing the object to be restored to this state later.

* Captures and restores an objects's internal state
* Does not violate encapsulation and data hiding


## Use case
* Implement undo mechanisms
* Save snapshots of an object's state
* Restore the object to a previous state

## Benefits
* Allows state preservation and restoration
* Does not violate encapsulation
* Allows for the creation of "save points"

## Structure
* State management separated from the main object functionality

## Pitfalls
* Memory usage
* Performance concerns
* Frequency of state changes
    - frequent snapshots affect performance
    - infrequent saves might miss important states
* Versioning

