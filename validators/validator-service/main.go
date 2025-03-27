package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func main() {
	validatorID := os.Getenv("VALIDATOR_ID")
	if validatorID == "" {
		validatorID = "unknown"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		startTime := time.Now()
		log.Printf("Received request at validator-%s", validatorID)

		// Return response
		duration := time.Since(startTime)
		response := fmt.Sprintf("Validator %s processed request in %v", validatorID, duration)
		w.Write([]byte(response))

		log.Printf("Completed request at validator-%s in %v", validatorID, duration)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Validator %s starting on port %s", validatorID, port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
