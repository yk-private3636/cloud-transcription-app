package module

import "regexp"

func ExtractByRegex(input, pattern string) ([]string, error) {
	re, err := regexp.Compile(pattern)

	if err != nil {
		return nil, err
	}

	matches := re.FindAllString(input, -1)

	return matches, nil
}
