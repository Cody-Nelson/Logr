# Logr
Logr is a structured logging utility library for Lua.

## Functions
### Logr.new
```luau
function Logr.new(name: string, level: string?): Logr
```
> `name` (string): The name of the logger which will be shown in log messages
> 
> `level` (string?): The initial log level of the logger.

Returns a new `Logr`

### Logr:GetDefaultLevel
```luau
function Logr:GetDefaultLevel(): string
```
Returns the current default log level for new loggers.

### Logr:SetDefaultLevel
```luau
function Logr:SetDefaultLevel(level: string)
```
Sets the default log level for new loggers
> `level` (string): The new default log level

### Logr:GetLogLevels

### Logr:GetLogLevelId

### Logr:GetLogLevel

### Logr:SetLogLevel

### Logr:Debug

### Logr:Info

### Logr:Warn

### Logr:Error

### Logr:Critical
