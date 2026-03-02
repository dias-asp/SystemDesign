package orchestrator

import (
	"SystemDesign/Saga/interfaces"
	"SystemDesign/Saga/services/inventory"
	"SystemDesign/Saga/services/payment"
	"SystemDesign/Saga/services/shipment"
	"fmt"
)

type Orchestrator struct {
	inventoryService inventory.InventoryService
	paymentService   payment.PaymentService
	shipmentService  shipment.ShipmentService
}

func Init(amount int) Orchestrator {
	return Orchestrator{
		inventoryService: inventory.New(amount),
		paymentService:   payment.New(),
		shipmentService:  shipment.New(),
	}
}

type executable struct {
	service interfaces.Compensatable
	value   int
}

func (e executable) execute() error {
	return e.service.Do(e.value)
}
func (e executable) compensate() {
	e.service.Compensate(e.value)
}

func (orchestrator *Orchestrator) Execute(amount int, money int, distance int) {
	fmt.Printf("\n\nExecuting transaction: \namount %d\nmoney %d\ndistance %d\n", amount, money, distance)
	list := []executable{
		{service: &orchestrator.inventoryService, value: amount},
		{service: &orchestrator.paymentService, value: money},
		{service: &orchestrator.shipmentService, value: distance},
	}
	compensate_id := -1
	for i, e := range list {
		if err := e.execute(); err != nil {
			fmt.Printf("ERROR %s\n", err)
			compensate_id = i - 1
			fmt.Printf("Transaction failed on step %d\n", i+1)
			break
		}
	}
	if compensate_id != -1 {
		for i, e := range list {
			if i > compensate_id {
				break
			}
			e.compensate()
		}
		fmt.Println("Transaction compensated successfully")
		return
	}
	fmt.Println("Transaction completed successfully")
}
