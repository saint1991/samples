package main

import (
	"fmt"
)

const (
	sunday = iota
	monday
	tuesday
	wednesday
	thursday
	friday
	saturday
)

func constExample() {
	fmt.Printf("Sunday: %d\n", sunday)
	fmt.Printf("Monday: %d\n", monday)
	fmt.Printf("Tuesday: %d\n", tuesday)
	fmt.Printf("Wednesday: %d\n", wednesday)
	fmt.Printf("Thursday: %d\n", thursday)
	fmt.Printf("Friday: %d\n", friday)
	fmt.Printf("Saturday: %d\n", saturday)
}

func main() {
	constExample()
}