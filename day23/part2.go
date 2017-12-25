package main

import "fmt"

func main() {
	b := (99 * 100) + 100000
	c := b + 17000
	h := 0

	for b <= c {
		d := 2

		for d != b {
			if b%d == 0 {
				h++
				break
			}

			d++
		}

		b += 17
	}

	fmt.Println(h)
}
