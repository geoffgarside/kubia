package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sync/atomic"
	"syscall"
)

func main() {
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, os.Interrupt, syscall.SIGTERM)

	http.Handle("/", handler())

	srv := &http.Server{Addr: ":8080"}

	go func() {
		log.Print("Kubia server starting...")
		if err := srv.ListenAndServe(); err != nil {
			log.Fatal(err)
		}
	}()

	<-signals

	if err := srv.Shutdown(context.Background()); err != nil && err != http.ErrServerClosed {
		log.Printf("Error: %v\n", err)
	} else {
		log.Println("Server stopped")
	}
}

func handler() http.Handler {
	hostname, _ := os.Hostname()
	var counter int64

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
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
}
