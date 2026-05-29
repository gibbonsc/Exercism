<#
.SYNOPSIS
    Implement simple linked list (singly linked list) data structure.

.DESCRIPTION
    Implement two classes: Node and LinkedList
    Node should have these properties:
        - Data, contain the value of the node
        - Next, contain the reference to the next linked Node
    
    LinkedList's constrcutor should be able to accept : zero value, one single value, and an array of values to create the linked list.
    LinkedList should have these methods:
        - Size: returns how many elements in the list
        - Head: returns the current Node that is currently the head of the list.
        - Push: add a new Node to the beginning of the list.
        - Pop : remove a Node from the beginning of the list, returns the value of that Node.
        - Reverse : reverse the order of the list
        - ToArray : returns an array of the list in the correct order.

    Extra: implement enumberable behavior, e.g. can call Foreach-Object on the list. Remove the skipped test to run, only for local environment.

.EXAMPLE
    $list = [LinkedList]::new(@(1, 2, 3))

    $list.Pop()
    Returns: 3

    $list.Push(4)
    $list.ToArray()
    Returns: @(4, 2, 1)
#>
Class Node {
    [Object]$Data
    [Node]$Next = $null

    Node() {
        $this.Data = $null
    }
    Node([object]$o) {
        $this.Data = $o
    }
}

Class LinkedList: System.Collections.IEnumerable {
    [Node]$Next = $null

    LinkedList() {}
    LinkedList([Object]$o) {
        $this.Next = [Node]::new($o)
    }

    Hidden Static Push([LinkedList]$L, [Object]$o) {
        $NewNode = [Node]::new($o)
        $NewNode.Next = $L.Next
        $L.Next = $NewNode
    }
    LinkedList([Object[]]$InitArray) {
        foreach ($Element in $InitArray) {
            [LinkedList]::Push($this, $Element)
        }
    }

    [uint] Size() {
        $DepthCounter = 0
        $NextNode = $this.Next
        while ($null -ne $NextNode) {
            $NextNode = $NextNode.Next
            ++$DepthCounter
        }
        return $DepthCounter
    }

    [Node] Head() {
        if ($null -eq $this.Next) {
            throw "The list is empty"
        }
        else {
            return $this.Next
        }
    }

    Push([Object] $o) {
        [LinkedList]::Push($this, $o)
    }

    [Object] Pop() {
        if ($null -eq $this.Next) {
            Throw "The list is empty"
        }
        $Result = $this.Next.Data
        $this.Next = $this.Next.Next
        return $Result
    }

    [Object[]] ToArray() {
        $Result = @()
        $NextNode = $this.Next
        while ($null -ne $NextNode) {
            $Result += , $NextNode.Data
            $NextNode = $NextNode.Next
        }
        return $Result
    }

    Reverse() {
        if ($null -ne $this.Next) {
            $Objects = $this.ToArray()
            $Reversed = [LinkedList]::new($Objects)
            $this.Next = $Reversed.Head()
        }
    }

    [System.Collections.IEnumerator] GetEnumerator() {
        return $this.ToArray().GetEnumerator();
    }
}
