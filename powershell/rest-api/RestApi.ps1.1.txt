Class RestAPI {
    [hashtable[]] $Users

    RestAPI([hashtable]$data) {
        if ($data.ContainsKey("Users")) {
            $this.Users = $data.users
        }
    }

    [hashtable] Get([string] $url, [string] $payload) {
        if ($url -ne '/users') { return @{} }
        elseif ($payload -eq "") { return @{users = $this.Users } }
        else {
            # from JSON payload, extract list of users to retrieve
            $Id = (ConvertFrom-Json $payload -AsHashtable).users
            # retrieve and return those
            $UserMatches = $this.Users | Where-Object {
                $_.name -in $Id
            }
            $Result = @{}
            $Result.users = [hashtable[]]$UserMatches
            return $Result
        }
    }

    [hashtable] Get([string] $url) {
        # with no $payload parameter, retrieve and return all users
        return $this.Get($url, "")
    }

    [hashtable] Post([string] $url, [string] $payload) {
        if ($url -eq '/add') {
            # from JSON payload, get name of new user
            $Id = (ConvertFrom-Json $payload -AsHashtable).user
            $UserMatches = $this.Users | Where-Object {
                $_.name -eq $Id
            }
            # check: the new user's name must be unique
            if ($null -ne $UserMatches) { Throw "User already existed" }
            else {
                $UserToAdd = @{ name = $Id; owes = @{}; owed_by = @{}; balance = 0 }
                $this.Users += , $UserToAdd
                return $UserToAdd
            }
        }
        elseif ($url -ne '/iou') { return @{} }
        else {
            # from JSON payload, find two users and an amount
            $IouParams = (ConvertFrom-Json $payload -AsHashtable)
            $LenderName = $IouParams.lender
            $BorrowerName = $IouParams.borrower
            $Amount = $IouParams.amount

            # select ledger data for both users
            $Lender = $this.Users | Where-Object {
                $_.name -eq $LenderName
            }
            $Borrower = $this.Users | Where-Object {
                $_.name -eq $BorrowerName
            }

            if ($Lender.owes.ContainsKey($BorrowerName) -and
                $Borrower.owed_by.ContainsKey($LenderName))
            {
                # lender owed to borrower; decrease their net "IOU"
                $NewIou = $Lender.owes.$BorrowerName - $Amount
                if ($NewIou -gt 0.0) {
                    # lender's debt now lower, but still owes to borrower
                    $Lender.owes.$BorrowerName = $NewIou
                    $Borrower.owed_by.$LenderName = $NewIou
                }
                else {
                    # lender no longer owes borrower
                    $Lender.owes.Remove($BorrowerName)
                    $Borrower.owed_by.Remove($LenderName)
                    if ($NewIou -lt 0.0) {
                        # lender is now borrower and vice-versa
                        $Lender.owed_by.$BorrowerName = -$NewIou
                        $Borrower.owes.$LenderName = -$NewIou
                    }
                }
            }
            elseif ($Lender.owed_by.ContainsKey($BorrowerName) -and
                $Borrower.owes.ContainsKey($LenderName))
            {
                # borrower's existing debt is now higher
                $Lender.owed_by.$BorrowerName += $Amount
                $Borrower.owes.$LenderName += $Amount
            }
            else {
                # no extant debt between users; create new "IOU" record
                $Lender.owed_by.$BorrowerName = $Amount
                $Borrower.owes.$LenderName = $Amount
            }

            $Lender.balance += $Amount
            $Borrower.balance -= $Amount

            return $this.Get(
                '/users',
                '{"users":["' + $LenderName + '","' + $BorrowerName + '"]}'
            )
        }
    }
}

<#
.SYNOPSIS
Implement a RESTful API for tracking IOUs.

.DESCRIPTION
Implement a RestAPI class that can receives IOUs from POST requests, and able to deliver specified summary information from GET requests.

The class should have the two main methods : 'Get' and 'Post'
- Get method : accept an URL string ("/users") and an optional payload (json string), and it returns an object based on whether payload was provided or not.
- Post method : accept an URL string ("/add" or "/iou") and a payload (json string), it returns an object based on the ULR input.

Please read instructions for more details about the methods, their payload format and their response format.

.EXAMPLE
$data = @{ 
    users = @(
        @{name = "Adam"; owes = @{}; owed_by = @{}; balance = 5.0}
        @{name = "Bob" ; owes = @{}; owed_by = @{}; balance = 3.0}
    ) 
}

$api = [RestAPI]::new($data)

# Get method to retrieve one single user
$api.Get("/users", '{"users":["Adam"]}' )
Returns: @{ users = @(
                @{ name = "Adam"; owes = @{}; owed_by = @{};balance = 5.0 }
            )
        }

# Post method to add a new user
$api.Post("/add", '{"users":["Chuck"]}')
Returns: @{ name = "Chuck"; owes = @{}; owed_by = @{}; balance = 0.0 }
#>
