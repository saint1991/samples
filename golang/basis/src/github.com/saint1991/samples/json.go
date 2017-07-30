package main

import (
	"encoding/json"
	"fmt"
)

func jsonExample() {
	type Person struct {
		Name   string `json:"name"`
		Age    int    `json:"age"`
		Gender string `json:"gender"`
	}
	j, err := json.Marshal(Person {
		Name: "homes",
		Age: 22,
		Gender: "male",
	})
	if err != nil {
		fmt.Errorf("failed to marshall %v", err)
	}
	fmt.Println(string(j))

	var person Person
	err = json.Unmarshal(j, &person) // for 2nd arg it should be address
	if err != nil {
		fmt.Errorf("failed to unmarshall %v", err)
	}
	fmt.Println(person)
}

func main() {
	jsonExample()
}
