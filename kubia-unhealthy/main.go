package main

import (
	"log"
	"net/http"
	"os"
	"sync/atomic"
)

func main() {
	hostname, _ := os.Hostname()
	var counter int64

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Received request from ", r.RemoteAddr)
		atomic.AddInt64(&counter, 1)

		if counter > 5 {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte("I'm not well. Please restart me!"))
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("You've hit " + hostname + "\n"))
	})

	log.Print("Kubia server starting...")
	http.ListenAndServe(":8080", nil)
}
