package shipment

import (
	"errors"
	"fmt"
)

type ShipmentService struct {
}

func New() ShipmentService {
	return ShipmentService{}
}

func (inventory *ShipmentService) Do(distance int) error {
	if distance < 0 {
		return errors.New("Distance must be positive")
	}
	fmt.Printf("Do: Distance traveled: %d\n", distance)
	return nil
}

func (inventory *ShipmentService) Compensate(distance int) {
}
