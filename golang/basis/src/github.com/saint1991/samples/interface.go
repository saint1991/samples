package main

import (
	"strings"
	"strconv"
	"fmt"
)

type Formattable interface {
	Format(pattern string) string
}

type Date struct {
	Year int
	Month int
	Day int
}

func (dt Date) Format(pattern string) string {
	year := strconv.Itoa(dt.Year)
	month := strconv.Itoa(dt.Month)
	day := strconv.Itoa(dt.Day)
	pattern = strings.Replace(pattern, "%Y", year, 1)
	pattern = strings.Replace(pattern, "%M", month, 1)
	pattern = strings.Replace(pattern, "%D", day, 1)
	return pattern
}

func Format(pattern string, target Formattable) string {
	return target.Format(pattern)
}

func main() {
	fmt.Println(Format("%Y-%M-%D", &Date{ Year: 2017, Month:9 , Day: 10}))
}
