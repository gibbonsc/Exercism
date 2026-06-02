class Node {
    [object] $Content = $null
    [Node] $Next = $null
    [Node] $Prev = $null

    Node() {
    }
    Node([object] $O) { $this.Content = $O }
}

class LinkedList {
    [int] $Count
    [Node] $Head

    LinkedList() {
        $this.Count = 0
        $this.Head = $null
    }

    Push($value) {
        $this.Count++
        $NewNode = [Node]::new($value)
        if ($null -eq $this.Head) {
            $NewNode.Next = $NewNode
            $NewNode.Prev = $NewNode
            $this.Head = $NewNode
        }
        else {
            $NewNode.Next = $this.Head #a
            $NewNode.Prev = $this.Head.Prev #b
            $this.Head.Prev.Next = $NewNode #c
            $this.Head.Prev = $NewNode #d
            <# visualization of nontrivial push operation
                push (thr)
                   1a  2   3
                C: one two thr
                N: 2   3   1c
                P: 3b  1   2

                push (fou)
                   1   2   3   4
                C: one two thr fou
                N: 2   3   4c  1a
                P: 4d  1   2   3b
            #>
        }
    }

    [object] Pop() {
        if ($null -eq $this.Head) { throw "List is empty" }
        $this.Count--
        $Last = $this.Head.Prev
        if (0 -eq $this.Count) {
            $this.Head = $null
        }
        else {
            $Last.Prev.Next = $this.Head #a
            $this.Head.Prev = $Last.Prev #b
            <# visualization of nontrivial pop
                push (fou)
                   1   2   3   4
                C: one two thr fou
                N: 2   3   4a  1
                P: 4b  1   2   3

                pop
                   1   2   3
                C: one two thr
                N: 2   3   1a
                P: 3b  1   2
            #>
        }
        return $Last.Content
    }

    Unshift($value) {
        $this.Count++
        $NewNode = [Node]::new($value)
        if ($null -eq $this.Head) {
            $NewNode.Next = $NewNode
            $NewNode.Prev = $NewNode
            $this.Head = $NewNode
        }
        else {
            $NewNode.Next = $this.Head.Prev.Next #a
            $NewNode.Prev = $this.Head.Prev #b
            $this.Head.Prev = $NewNode #c
            $this.Head.Next = $NewNode #d
            $this.Head = $NewNode #e
            <# visualization of nontrivial unshift
                unshift(thr)
                   3   2   1
                C: thr two one
                N: 2   1   3a
                P: 1b  3   2

                unshift(fou)
                   4e  3   2   1
                C: fou thr two one
                N: 3a  2   1   4c
                P: 1b  4d  3   2
            #>
        }
    }

    [object] Shift() {
        if ($null -eq $this.Head) { throw "List is empty" }
        $this.Count--
        $First = $this.Head
        if (0 -eq $this.Count) {
            $this.Head = $null
        }
        else {
            $First.Prev.Next = $First.Next #a
            $First.Next.Prev = $First.Prev #b
            $this.Head = $First.Next
            <# visualization of nontrivial shift
                unshift(fou)
                   4   3   2   1
                C: fou thr two one
                N: 3   2   1   4a
                P: 1   4b  3   2

                shift(fou)
                   3c  2   1
                C: thr two one
                N: 2   1   3a
                P: 1b  3   2
            #>
        }
        return $First.Content
    }

    Delete($value) {
    if ($null -eq $this.Head) { throw "List is empty" }
        $Cursor = $this.Head
        $Specimen = $Cursor.Content
        while ($Value -ne $Specimen -and $Cursor.Next -ne $this.Head ) {
            $Cursor = $Cursor.Next
            $Specimen = $Cursor.Content
        }
        if ($Specimen -eq $Value) {
            if ($Cursor -eq $this.Head) {
                $this.Shift() | Out-Null
            }
            else {
                $this.Count--
                $Cursor.Prev.Next = $Cursor.Next #a
                $Cursor.Next.Prev = $Cursor.Prev #b
            }
            <# visualization of nontrivial delete
                unshift(fou)
                   4   3   2   1
                C: fou thr two one
                N: 3a  2   1   4
                P: 1   4   3b  2

                delete (thr)
                   4   2   1
                C: fou two one
                N: 2a  1   4
                P: 1   4b  2
            #>
        }
    }
}

<#
.SYNOPSIS
    Implement a linked list.

.DESCRIPTION
    The linked list is a fundamental data structure in computer science, often used in the implementation of other data structures.
    As the name suggests, it is a list of nodes that are linked together.
    In a 'doubly linked list', each node links to both the node that comes before, as well as the node that comes after.

    The class to represent the linked list should support these operations:
    - Push    : accept a value, append it to the end of the list.
    - Pop     : remove a value of the end of the list, return it.
    - Unshift : accept a value, append it to the front of the list.
    - Shift   : remove a value from the front of the list, return it.
    - Delete  : accept a value, remove the first occurence of it in the list.

    The class should also have a 'Count' property to reflect the current length of the list.
    Any attempt of removal operation on an empty list should throw an error.

.EXAMPLE
    $linked = [LinkedList]::new()

    $linked.Push(5)
    $linked.Unshift(7)
    $linked.Push(8)

    $linked.Pop()
    Returns: 8

    $linked.Count
    Returns: 2
#>
