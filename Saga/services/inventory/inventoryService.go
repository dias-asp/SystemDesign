package inventory

import (
	"errors"
	"fmt"
)

type InventoryService struct {
	amount int
}

func New(amount int) InventoryService {
	return InventoryService{amount}
}

func (inventory *InventoryService) Do(amount int) error {
	if amount > inventory.amount {
		return errors.New("not enough inventory in stock")
	}
	inventory.amount -= amount
	fmt.Printf("Do: New inventory available: %d\n", inventory.amount)
	return nil
}

func (inventory *InventoryService) Compensate(amount int) {
	inventory.amount += amount
	fmt.Printf("Compensate: Inventory restored: %d\n", inventory.amount)
}
