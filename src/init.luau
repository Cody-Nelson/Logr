--!strict

local t = require(script.Parent.t)

local LOG_ID_TO_LEVEL: { string } = table.freeze({
	"All",
	"Debug",
	"Info",
	"Warn",
	"Error",
	"Critical",
	"None",
})

local MESSAGE_HEADER_FORMAT: string = "[%s][%s]" -- [LogLevel][LoggerName] Message

local logLevelToId: { [string]: number } = {}
for levelId: number, level: string in LOG_ID_TO_LEVEL do
	logLevelToId[level] = levelId
end
table.freeze(logLevelToId)

local function IsValidLogLevelName(level: string): (boolean, string)
	return logLevelToId[level] ~= nil,
		`Invalid log level name "{tostring(level)}", must be: {table.concat(LOG_ID_TO_LEVEL, ", ")}`
end

local Logr = {}
Logr.__index = Logr

Logr._defaultLevel = "None"

local tNew = t.tuple(t.string, t.optional(t.string))
function Logr.new(name: string, level: string?)
	assert(tNew(name, level))

	level = level or self._defaultLevel
	assert(IsValidLogLevelName(level :: string))

	local self = setmetatable({}, Logr)
	self.__tostring = function()
		return `Logr<{name}>`
	end

	self.Name = name
	self._logLevel = level :: string
	self._logId = logLevelToId[self._logLevel] :: number

	return self
end

function Logr:GetDefaultLevel(): string
	return self._defaultLevel
end

function Logr:SetDefaultLevel(level: string)
	assert(IsValidLogLevelName(level))

	self._defaultLevel = level
end

function Logr:GetLogLevels()
	return table.clone(LOG_ID_TO_LEVEL)
end

function Logr:GetLogLevelId(): number
	return self._logId
end

function Logr:GetLogLevel(): string
	return self._logLevel
end

local tSetLogLevel = t.tuple(t.every(t.string, IsValidLogLevelName))
function Logr:SetLogLevel(level: string)
	assert(tSetLogLevel(level))

	self._logLevel = level
	self._logId = logLevelToId[level]
end

function Logr:_Write(WriteCallback: (...any) -> ...any, level: string, ...: any)
	if self._logId > logLevelToId[level] then
		return
	end

	WriteCallback(string.format(MESSAGE_HEADER_FORMAT, level, self.Name), ...)
end

function Logr:Debug(...)
	self:_Write(print, "Debug", ...)
end

function Logr:Info(...)
	self:_Write(print, "Info", ...)
end

function Logr:Warn(...)
	self:_Write(warn, "Warn", ...)
end

function Logr:Error(...)
	self:_Write(warn, "Error", ...)
end

function Logr:Critical(...)
	self:_Write(warn, "Critical", ...)
end

return Logr
