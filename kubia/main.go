package main

import (
	"log"
	"net/http"
	"os"
)

func main() {
	hostname, _ := os.Hostname()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Received request from ", r.RemoteAddr)
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("You've hit " + hostname + "\n"))
	})

	log.Print("Kubia server starting...")
	http.ListenAndServe(":8080", nil)
}
