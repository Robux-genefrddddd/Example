--!strict

export type BufferReader = typeof(setmetatable(
	{} :: {
		_buffer: buffer,
		_cursor: number,
	},
	{} :: { __index: any }
))

local BufferReader = {}
BufferReader.__index = BufferReader

function BufferReader.new(source: buffer): BufferReader
	local self = setmetatable({}, BufferReader)
	self._buffer = source
	self._cursor = 0
	return self
end

function BufferReader:ReadUint8(): number
	local value = buffer.readu8(self._buffer, self._cursor)
	self._cursor += 1
	return value
end

function BufferReader:ReadUint16(): number
	local value = buffer.readu16(self._buffer, self._cursor)
	self._cursor += 2
	return value
end

function BufferReader:ReadUint32(): number
	local value = buffer.readu32(self._buffer, self._cursor)
	self._cursor += 4
	return value
end

function BufferReader:ReadInt8(): number
	local value = buffer.readi8(self._buffer, self._cursor)
	self._cursor += 1
	return value
end

function BufferReader:ReadInt16(): number
	local value = buffer.readi16(self._buffer, self._cursor)
	self._cursor += 2
	return value
end

function BufferReader:ReadInt32(): number
	local value = buffer.readi32(self._buffer, self._cursor)
	self._cursor += 4
	return value
end

function BufferReader:ReadFloat32(): number
	local value = buffer.readf32(self._buffer, self._cursor)
	self._cursor += 4
	return value
end

function BufferReader:ReadFloat64(): number
	local value = buffer.readf64(self._buffer, self._cursor)
	self._cursor += 8
	return value
end

function BufferReader:ReadBool(): boolean
	return self:ReadUint8() == 1
end

function BufferReader:ReadString(): string
	local length = self:ReadUint16()
	local value = buffer.readstring(self._buffer, self._cursor, length)
	self._cursor += length
	return value
end

function BufferReader:ReadVector3(): Vector3
	local x = self:ReadFloat32()
	local y = self:ReadFloat32()
	local z = self:ReadFloat32()
	return Vector3.new(x, y, z)
end

function BufferReader:HasMore(): boolean
	return self._cursor < buffer.len(self._buffer)
end

return BufferReader
