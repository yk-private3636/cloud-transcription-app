package module

import (
	"bytes"
	"io"
	"log"
	"os"
)

func Content(fileName string) []byte {
	file, err := os.Open("event.json")

	if err != nil {
		log.Fatal(err.Error())
	}

	defer file.Close()

	var buf bytes.Buffer

	_, err = io.Copy(&buf, file)

	if err != nil {
		log.Fatal(err.Error())
	}

	return buf.Bytes()
}
