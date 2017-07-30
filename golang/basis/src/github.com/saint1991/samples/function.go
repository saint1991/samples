package main

import (
	"fmt"
)

func exampleOfNamedReturn() (width, height int) { // named return value `weight` nad `height`
	width = 1
	height = 2
	return // bare return: return values are named so args can be omitted here
}

func exampleOfHigherOrder(base int, operation func(int) int) int {
	return operation(base)
}

func exampleOfVariableLengthArgs(strs ...string) {
	fmt.Println(strs)
}


type toRecover struct {}

func exampleOfPanic() {
	defer func() {
		switch p := recover(); p {
		case nil:
		case toRecover{}:
			fmt.Println("Panic to Recover")
		default:
			panic(p)
		}
	}()

	fmt.Println("Before Panic")
	panic(toRecover{})
}

func main() {
	fmt.Println(exampleOfNamedReturn())
	fmt.Println(exampleOfHigherOrder(4, func(a int) int { // anonymous function
		return a + 20
	}))
	exampleOfVariableLengthArgs("aa", "bb", "cc")
	exampleOfVariableLengthArgs([]string{ "xx", "yy" }...)
	exampleOfPanic()
}
