package main

import (
	"SystemDesign/Saga/orchestrator"
)

func main() {
	orchestrator := orchestrator.Init(100)

	orchestrator.Execute(10, 100, 100)
	orchestrator.Execute(10, -100, 100)
	orchestrator.Execute(10, 100, -100)
	orchestrator.Execute(100, 100, 100)
}
