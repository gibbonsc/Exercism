Class CircularBuffer {
    [int[]]$BufState
    [int]$NextReadIndex
    [int]$NextWriteIndex
    [bool]$IsFull

    CircularBuffer([int]$size) {
        $this.BufState = , 0 * $size
        $this.NextReadIndex, $this.NextWriteIndex = 0, 0
        $this.IsFull = $false
    }

    Write([int]$Instance) {
        if ($this.IsFull) {
            throw "BufferError: Circular buffer is full"
        }
        $this.BufState[$this.NextWriteIndex] = $Instance
        $BufSize = $this.BufState.Length
        $this.NextWriteIndex = ($this.NextWriteIndex + 1) % $BufSize
        if ($this.NextReadIndex -eq $this.NextWriteIndex) {
            $this.IsFull = $true
        }
    }

    Overwrite([int]$Instance) {
        $this.BufState[$this.NextWriteIndex] = $Instance
        $BufSize = $this.BufState.Length
        $this.NextWriteIndex = ($this.NextWriteIndex + 1) % $BufSize
        if ($this.IsFull) {
            $this.NextReadIndex = $this.NextWriteIndex;
        }
        if ($this.NextReadIndex -eq $this.NextWriteIndex) {
            $this.IsFull = $true
        }
    }

    Clear() {
        $this.NextReadIndex = $this.NextWriteIndex
        $this.IsFull = $false
    }

    [int] Read() {
        if ($this.NextReadIndex -eq $this.NextWriteIndex -and -not $this.IsFull) {
            throw "BufferError: Circular buffer is empty"
        }
        $this.IsFull = $false
        $Result = $this.BufState[$this.NextReadIndex]
        $BufSize = $this.BufState.Length
        $this.NextReadIndex = ($this.NextReadIndex + 1) % $BufSize
        return $Result
    }
}

<#
.SYNOPSIS
Implement the circular buffer data structure.

.DESCRIPTION
A circular buffer, cyclic buffer or ring buffer is a data structure that uses a single, fixed-size buffer as if it were connected end-to-end.
Please implement the circular buffer class with these methods:
- Write     : write new value into the buffer, raise error if the buffer is full.
- Overwrite : overwrite the oldest element in the buffer if the buffer is full, otherwise behave like write.
- Clear     : clear all elements in the buffer, it is now empty.
- Read      : read the oldest element in the buffer, and return its value.

.EXAMPLE
$buffer = [CircularBuffer]::new(2)

$buffer.Write(1)
$buffer.Read()
Return: 1

$buffer.Write(2)
$buffer.Write(3)
$buffer.Overwrite(5)
$buffer.Read()
Return: 5

$buffer.Clear()
$buffer.Read()
Throw "BufferError: Circular buffer is empty"
#>
