package payment

import (
	"errors"
	"fmt"
)

type PaymentService struct {
}

func New() PaymentService {
	return PaymentService{}
}

func (inventory *PaymentService) Do(money int) error {
	if money < 0 {
		return errors.New("Money must be positive")
	}
	fmt.Printf("Do: Money paid: %d\n", money)
	return nil
}

func (inventory *PaymentService) Compensate(money int) {
	fmt.Printf("Compensate: Money refunded: %d\n", money)
}
