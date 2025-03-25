package function

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

// TestHandle ensures that Handle executes without error and validates correctly
func TestHandle(t *testing.T) {
	// Set environment variable for testing
	os.Setenv("VALIDATOR_ID", "test-validator")

	// Test cases
	testCases := []struct {
		name           string
		requestBody    ValidationRequest
		expectedStatus int
		expectedValid  bool
	}{
		{
			name: "Valid transaction",
			requestBody: ValidationRequest{
				TransactionID: "tx-123456",
				Amount:        100.50,
				Currency:      "USD",
			},
			expectedStatus: http.StatusOK,
			expectedValid:  true,
		},
		{
			name: "Invalid amount",
			requestBody: ValidationRequest{
				TransactionID: "tx-123457",
				Amount:        0,
				Currency:      "USD",
			},
			expectedStatus: http.StatusOK,
			expectedValid:  false,
		},
		{
			name: "Missing currency",
			requestBody: ValidationRequest{
				TransactionID: "tx-123458",
				Amount:        200.75,
				Currency:      "",
			},
			expectedStatus: http.StatusOK,
			expectedValid:  false,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// Create request body
			reqBody, err := json.Marshal(tc.requestBody)
			if err != nil {
				t.Fatalf("Failed to marshal request body: %v", err)
			}

			// Create request and response recorder
			req := httptest.NewRequest(http.MethodPost, "http://example.com/validate", bytes.NewBuffer(reqBody))
			req.Header.Set("Content-Type", "application/json")
			w := httptest.NewRecorder()

			// Call handler
			Handle(w, req)

			// Check status code
			resp := w.Result()
			defer resp.Body.Close()

			if resp.StatusCode != tc.expectedStatus {
				t.Fatalf("Expected status code %d, got %d", tc.expectedStatus, resp.StatusCode)
			}

			// Parse response
			var respBody ValidationResponse
			if err := json.NewDecoder(resp.Body).Decode(&respBody); err != nil {
				t.Fatalf("Failed to decode response body: %v", err)
			}

			// Check validator ID
			if respBody.ValidatorID != "test-validator" {
				t.Errorf("Expected validator ID 'test-validator', got '%s'", respBody.ValidatorID)
			}

			// Check transaction ID
			if respBody.TransactionID != tc.requestBody.TransactionID {
				t.Errorf("Expected transaction ID '%s', got '%s'", tc.requestBody.TransactionID, respBody.TransactionID)
			}

			// Check validation result
			if respBody.Valid != tc.expectedValid {
				t.Errorf("Expected valid=%v, got %v", tc.expectedValid, respBody.Valid)
			}
		})
	}
}

// TestHandleMethodNotAllowed tests that non-POST requests are rejected
func TestHandleMethodNotAllowed(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "http://example.com/validate", nil)
	w := httptest.NewRecorder()

	Handle(w, req)

	resp := w.Result()
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusMethodNotAllowed {
		t.Fatalf("Expected status code %d, got %d", http.StatusMethodNotAllowed, resp.StatusCode)
	}
}
