package main

import (
	"time"
	"net/http"
)

const layout = "2006-01-02 15:04:05"

func main() {
	http.HandleFunc("/time", func(writer http.ResponseWriter, request *http.Request) {
		l := request.URL.Query().Get("tz")
		location, err := time.LoadLocation(l)
		if err != nil {
			panic(err)
		}
		writer.Write([]byte(time.Now().In(location).Format(layout)))
	})

	http.ListenAndServe(":8080", nil)
}
