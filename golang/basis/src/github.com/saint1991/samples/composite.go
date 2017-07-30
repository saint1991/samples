package main

import (
	"fmt"
)

func main() {
	fmt.Println("--arrayExample")
	arrayExample()

	fmt.Println("--sliceExample")
	sliceExample()

	fmt.Println("--mapExample")
	mapExample()

	fmt.Println("--structExample")
	structExample()
}

func arrayExample() {
	var arr [3]int
	for k, v := range arr {
		fmt.Printf("%d -> %d\n", k, v)
	}

	literal := [3]int{ 1, 2, 3 }
	for k, v := range literal {
		fmt.Printf("%d -> %d\n", k, v)
	}

	variable_length := [...]int{ 1, 2, 3, 4, 5 }
	for k, v := range variable_length {
		fmt.Printf("%d -> %d\n", k, v)
	}

	if literal == [3]int{ 1, 2, 3 } {
		fmt.Println("literal equals [3]int{ 1, 2, 3 } ")
	}

	kv_literal := [...]int{ 2: 1, 1: 2, 3: 5}
	for k, v := range kv_literal {
		fmt.Printf("%d -> %d\n", k, v)
	}
}


func sliceExample() {
	cardinal := [5]int { 1, 2, 3, 4, 5 }
	slice := cardinal[2:4]

	for k, v := range slice {
		fmt.Printf("%d -> %d\n", k, v)
	}
	cardinal[3] = 10

	for k, v := range slice {
		fmt.Printf("%d -> %d\n", k, v)
	}

	slice[0] = 22
	for k, v := range cardinal {
		fmt.Printf("%d -> %d\n", k, v)
	}

	literal := []int{ 1, 2, 3 }
	fmt.Println(literal)

	made := make([]string, 2)
	made = append(made, "a")
	made = append(made, "b")
	made = append(made, "c")
	made = append(made, "d")
	fmt.Println(made)
}

func mapExample() {
	literal := map[string]int {
		"alice": 27,
		"bob": 18,
	}
	for k, v := range literal {
		fmt.Printf("%s -> %d\n", k, v)
	}

	made := make(map[string]int)
	made["alice"] = 27
	made["bob"] = 18
	for k, v := range made {
		fmt.Printf("%s -> %d\n", k, v)
	}

	delete(made, "alice")
	for k, v := range made {
		fmt.Printf("%s -> %d\n", k, v)
	}

	if a, ok := made["alice"]; !ok {
		a = 100
		fmt.Println(a)
	} else {
		fmt.Println(a)
	}
}



func structExample() {

	type Employee struct {
		ID int
		Name string
		Address string
		Salary int
	}

	emp1 := Employee{
		ID: 1,
		Name: "homes",
		Address: "baker street",
		Salary: 1000,
	}

	fmt.Println(emp1)


	type Circle struct {
		X int
		Y int
		Radius int
	}

	type Wheel struct {
		Circle // anonymous field
		Spoke int
	}

	w := Wheel {
		Circle {X: 1, Y: 2, Radius: 3},
		Spoke: 10,
	}

	x := w.X // anonymous fields can be access its inner field directly
	y := w.Circle.X // it also has the named field Circle
	fmt.Println(x == y)
}
