package main

import (
	"bytes"
	"io"
	"log"
	"net/http"
	"os"
	"path"
)

const (
	dataFile = "/var/data/kubia.txt"
	noData   = "No data posted yet"
)

func main() {
	var (
		hostname, _  = os.Hostname()
		postResponse = []byte("Data stored on pod " + hostname + "\n")
		getResponse  = []byte("You've hit " + hostname + "\nData stored on this pod: ")
	)

	if _, err := os.Stat(path.Dir(dataFile)); os.IsNotExist(err) {
		if err := os.MkdirAll(path.Dir(dataFile), 0755); err != nil {
			log.Fatal(err)
		}
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case "POST":
			_, err := writeFile(r)
			if err != nil {
				log.Println("Failed to store data: ", err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}

			log.Print("New data has been received and stored.")
			w.WriteHeader(http.StatusOK)
			w.Write(postResponse)
		case "GET", "HEAD":
			f, err := readFile()
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			defer f.Close()

			w.WriteHeader(http.StatusOK)
			if _, err := w.Write(getResponse); err != nil {
				log.Println("Error writing get response: ", err)
				return
			}

			if _, err := io.Copy(w, f); err != nil {
				log.Println("Error writing file data: ", err)
				return
			}

			if _, err := w.Write([]byte{'\n'}); err != nil {
				log.Println("Error writing get tail: ", err)
				return
			}
		}
	})

	http.ListenAndServe(":8080", nil)
}

func writeFile(r *http.Request) (int64, error) {
	f, err := os.Create(dataFile)
	if err != nil {
		return 0, err
	}

	defer f.Close()
	return io.Copy(f, r.Body)
}

type closableBuffer struct {
	*bytes.Buffer
}

func (b *closableBuffer) Close() error {
	return nil
}

func readFile() (io.ReadCloser, error) {
	f, err := os.Open(dataFile)
	if os.IsNotExist(err) {
		return &closableBuffer{bytes.NewBuffer([]byte(noData))}, nil
	}

	if err != nil {
		return nil, err
	}

	return f, nil
}
