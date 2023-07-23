# Tinycoin

Notes how tinycoin actually works.

# Initialization

1. spin up a number of nodes
    - each node generates an instance of
        - `blockchain` - a list with one initial element (the _Genesis_ block)
        - `nodes_transactions` - a list of transactions this node is doing
        - `peer_nodes` - a set of peers
2. register nodes as peers of each other
    - this updates the `peer_nodes` set

# Creating transactions

In the initial implementation, transactions are made up of

-   `from`: name of the sender
-   `to`: name of the recipient
-   `amount`: amount to be sent

Validation if a transaction is valid is simply checking if the amount is > 1 and if the sender and recipient are not the same person.

Send a transaction with the `/transaction` API call by sending a JSON payload with `from`, `to` and `amount` fields.

## Potential changes to the transactions

Change the `Transactions` class in `transaction.py` to:

-   add additional fields, e.g. a description of the transaction (e.g. a JSON object)
-   Rules to verify the transaction in the `is_valid` method (e.g. if the sender has the correct balance to transfer an amount).

# Proof of work

This does a very simple proof of work and is called by the `/mine` API:

-   increments the `last_proof` parameter by 1
-   checks if the new proof value is divisible by 31 and `last_proof`
-   increments until a result has been found

This could be changed to include a nonce / hash implementation.
