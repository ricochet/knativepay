package function

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"
)

// ValidationRequest represents the incoming validation request
type ValidationRequest struct {
	TransactionID string  `json:"transaction_id"`
	Amount        float64 `json:"amount"`
	Currency      string  `json:"currency"`
	Timestamp     string  `json:"timestamp,omitempty"`
}

// ValidationResponse represents the validation response
type ValidationResponse struct {
	ValidatorID    string `json:"validator_id"`
	TransactionID  string `json:"transaction_id"`
	Valid          bool   `json:"valid"`
	Message        string `json:"message,omitempty"`
	ProcessedAt    string `json:"processed_at"`
	ProcessingTime string `json:"processing_time"`
}

// Handle an HTTP Request.
func Handle(w http.ResponseWriter, r *http.Request) {
	startTime := time.Now()

	// Get validator ID from environment variable
	validatorID := os.Getenv("VALIDATOR_ID")
	if validatorID == "" {
		validatorID = "unknown"
	}

	fmt.Printf("Validator %s received request\n", validatorID)

	// Only accept POST requests with JSON content
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Parse the request body
	var req ValidationRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Add timestamp if not provided
	if req.Timestamp == "" {
		req.Timestamp = time.Now().Format(time.RFC3339)
	}

	// Perform validation (simple example)
	valid := true
	message := "Transaction validated successfully"

	// Simple validation rules
	if req.Amount <= 0 {
		valid = false
		message = "Amount must be greater than zero"
	}

	if req.Currency == "" {
		valid = false
		message = "Currency is required"
	}

	// Simulate some processing time
	time.Sleep(100 * time.Millisecond)

	// Create response
	duration := time.Since(startTime)
	resp := ValidationResponse{
		ValidatorID:    validatorID,
		TransactionID:  req.TransactionID,
		Valid:          valid,
		Message:        message,
		ProcessedAt:    time.Now().Format(time.RFC3339),
		ProcessingTime: duration.String(),
	}

	// Return JSON response
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(resp)

	fmt.Printf("Validator %s completed request in %v\n", validatorID, duration)
}
