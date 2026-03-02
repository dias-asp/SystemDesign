package interfaces

type Compensatable interface {
	Do(int) error
	Compensate(int)
}
