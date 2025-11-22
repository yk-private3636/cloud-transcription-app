package module

import "time"

func CurrentDateString(timezone, format string) (string, error) {

	loc, err := time.LoadLocation(timezone)

	if err != nil {
		return "", err
	}

	now := time.Now().In(loc).Format(format)

	return now, nil
}
