package main

import (
	"fmt"
)

// Constants also should be a camel case
const pi float64 = 3.141
var global int

// Create type alias with keyword `type`
// In Golang, the type created by `type` keyword is treated as completely different type from original type
type Circumference float64

// init function can be used to initialize package variable
// this is called when a compiler load this package
func init() {
	global = 2
}

// Public function should start with an upper case
func Circumference(r float64) Circumference {
	return float64(2) * pi * r
}

func intExample() int {
	// variables can be declared with `var` keyword
	var a, b = 1, 2
	// c becomes 0
	var c int
	return a + b + c
}

func anotherIntExample() int {
	// := operator declares and substitutes a value at the same time
	a, b := 1, 2
	return a + b
}

func pointerExample() int {
	x := 1
	p := &x
	*p += 1
	return x
}

func UseIntExamples() {
	sum := intExample()
	another := anotherIntExample()
	fmt.Printf("sum and another are %d and %d respectively\n", sum, another)
}

func UsePointerExample() {
	fmt.Printf("the value of x is %d", pointerExample())
}

func main() {
	circumference := Circumference(2)
	fmt.Printf("Circumference: %f\n", circumference)

	UseIntExamples()
	UsePointerExample()
}