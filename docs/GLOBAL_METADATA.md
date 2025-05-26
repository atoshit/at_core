# Global metadatas list

## at.env
- **Type:** `string`
- **Description:** The current environment
- **Return:** `"client"` or `"server"`

## at.version
- **Type:** `string`
- **Description:** The current version
- **Return:** The current version

## at.lang
- **Type:** `string`
- **Description:** The current language
- **Return:** The current language

## at.debug
- **Type:** `integer`
- **Description:** The current debug mode
- **Return:** `0` or `1`

## at.resource
- **Type:** `string`
- **Description:** The current resource name
- **Return:** The current resource name (by default `at_core`)

## at.modules
- **Type:** `table`
- **Description:** The current modules list loaded
- **Return:** The current modules list loaded `<{[string]: table}>`

## at.configs
- **Type:** `table`
- **Description:** The current configs list loaded
- **Return:** The current configs list loaded `<{[string]: table}>`

## at.locales
- **Type:** `table`
- **Description:** The current languages list loaded
- **Return:** The current languages list loaded `<{[string]: table}>`