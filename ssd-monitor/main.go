package main

import (
	"log"
	"time"
)

func main() {
	t := time.NewTicker(5 * time.Second)

	for {
		log.Println("SSD OK")
		<-t.C
	}
}
