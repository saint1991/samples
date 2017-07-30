package main

import (
	"math"
	"fmt"
)

type Point struct {
	X int
	Y int
}

type ColoredPoint struct {
	Point
	Color string
}

type Path []Point


func (p Point) distanceTo(q Point) float64 {
	return math.Sqrt(math.Pow(float64(p.X) - float64(q.X), 2.0) + math.Pow(float64(p.Y) - float64(q.Y), 2.0))
}

func (p Path) length() int {
	return len(p)
}



func main() {
	p := Point{X: 1.0, Y: 2.0}
	q := Point{X: 3.0, Y: 4.0}
	dist := p.distanceTo(q)
	fmt.Println(dist)

	cp := ColoredPoint{Point: Point{X: 1.0, Y: 2.0}}
	fmt.Println(cp.X, cp.Y)
}
