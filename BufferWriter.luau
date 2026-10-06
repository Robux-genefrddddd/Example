--!strict
--[[
    BufferWriter.luau
    Author: MrPinPin
    Description: High-performance binary serialization utility for Roblox network replication.
    Architecture: Shared.Network.BufferWriter (OOP metatable pattern)
]]

export type BufferWriter = typeof(setmetatable(
	{} :: {
		_buffer: buffer,
		_cursor: number,
		_capacity: number,
	},
	{} :: { __index: any }
))

local BufferWriter = {}
BufferWriter.__index = BufferWriter

local INITIAL_CAPACITY = 128

function BufferWriter.new(initialCapacity: number?): BufferWriter
	local capacity = initialCapacity or INITIAL_CAPACITY
	local self = setmetatable({}, BufferWriter)
	self._capacity = capacity
	self._buffer = buffer.create(capacity)
	self._cursor = 0
	return self
end

function BufferWriter:_EnsureCapacity(bytesNeeded: number)
	local targetSize = self._cursor + bytesNeeded
	if targetSize > self._capacity then
		local newCapacity = math.max(self._capacity * 2, targetSize)
		local newBuffer = buffer.create(newCapacity)
		buffer.copy(newBuffer, 0, self._buffer, 0, self._cursor)
		self._buffer = newBuffer
		self._capacity = newCapacity
	end
end

function BufferWriter:WriteUint8(value: number)
	self:_EnsureCapacity(1)
	buffer.writeu8(self._buffer, self._cursor, value)
	self._cursor += 1
end

function BufferWriter:WriteUint16(value: number)
	self:_EnsureCapacity(2)
	buffer.writeu16(self._buffer, self._cursor, value)
	self._cursor += 2
end

function BufferWriter:WriteUint32(value: number)
	self:_EnsureCapacity(4)
	buffer.writeu32(self._buffer, self._cursor, value)
	self._cursor += 4
end

function BufferWriter:WriteInt8(value: number)
	self:_EnsureCapacity(1)
	buffer.writei8(self._buffer, self._cursor, value)
	self._cursor += 1
end

function BufferWriter:WriteInt16(value: number)
	self:_EnsureCapacity(2)
	buffer.writei16(self._buffer, self._cursor, value)
	self._cursor += 2
end

function BufferWriter:WriteInt32(value: number)
	self:_EnsureCapacity(4)
	buffer.writei32(self._buffer, self._cursor, value)
	self._cursor += 4
end

function BufferWriter:WriteFloat32(value: number)
	self:_EnsureCapacity(4)
	buffer.writef32(self._buffer, self._cursor, value)
	self._cursor += 4
end

function BufferWriter:WriteFloat64(value: number)
	self:_EnsureCapacity(8)
	buffer.writef64(self._buffer, self._cursor, value)
	self._cursor += 8
end

function BufferWriter:WriteBool(value: boolean)
	self:WriteUint8(if value then 1 else 0)
end

function BufferWriter:WriteString(value: string)
	local length = #value
	self:WriteUint16(length)
	self:_EnsureCapacity(length)
	buffer.writestring(self._buffer, self._cursor, value)
	self._cursor += length
end

function BufferWriter:WriteVector3(vec: Vector3)
	self:WriteFloat32(vec.X)
	self:WriteFloat32(vec.Y)
	self:WriteFloat32(vec.Z)
end

function BufferWriter:Export(): buffer
	local trimmed = buffer.create(self._cursor)
	buffer.copy(trimmed, 0, self._buffer, 0, self._cursor)
	return trimmed
end

return BufferWriter
