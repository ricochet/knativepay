// This file is used for local development only
// It's not included in the function deployment

package function

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

// Local development entry point
func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", Handle)

	validatorID := os.Getenv("VALIDATOR_ID")
	if validatorID == "" {
		validatorID = "local"
	}

	log.Printf("Validator %s starting on port %s", validatorID, port)
	log.Printf("Server listening on http://localhost:%s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		fmt.Fprintf(os.Stderr, "Error starting server: %v\n", err)
		os.Exit(1)
	}
}
