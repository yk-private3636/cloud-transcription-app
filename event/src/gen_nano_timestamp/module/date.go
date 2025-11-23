package module

import (
	"time"
)

func GenerateNanoTimestamp(timezone string) (int64, error) {
	loc, err := time.LoadLocation(timezone)

	if err != nil {
		return 0, err
	}

	return time.Now().In(loc).UnixNano(), nil
}
