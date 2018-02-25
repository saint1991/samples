package main

import (
	"text/template"
	"fmt"
	"os"
)

func templateExample() {

	type Person struct {
		Name string
		Age  int
	}
	tmpl :=
		`Hello {{ .Name }}!!
		Your age is {{ .Age }} aren't you?
		`
	parsed, err := template.New("sample").Parse(tmpl)
	if err != nil {
		fmt.Errorf("parse error %v", err)
	}
	parsed.Execute(os.Stdout, Person{ Name: "homes", Age: 18 })
}

func main() {
	templateExample()
}
