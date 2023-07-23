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

# Mining

The `/mine` API does the following:

-   get the last block of the node's blockchain
-   extract the last proof of work from that block (the proof of work is similar to a nonce)
-   calculate a new proof of work using the last proof of work - **this could be improved by a better proof of work algorithm**
-   reward the mining node by transferring 1 coin to the address of the miner (sender: 'network')
-   create a new block with the current transactions of the node and the new proof (both combined into a `data` object), a new index and timestamp and the hash of the previous block
-   Add the new block to the node's blockchain
-   empty the current list of transactions

# Proof of work

This does a very simple proof of work and is called by the `/mine` API:

-   increments the `last_proof` parameter by 1
-   checks if the new proof value is divisible by 31 and `last_proof`
-   increments until a result has been found

This could be changed to include a nonce / hash implementation.

# Observations

-   the `/consensus` route is never called here - needs to be called whenever a new block was mined? We can probably call consensus on every peer of the peers once a block has been mined
-   mining can be done on one individual node, but should really be done on multiple nodes, who then form a consensus about the blockchain
-   `/consensus` is a very simple implementation, it just takes the longest chain from the node's peers and assigns it to the node's blockchain
-   transactions are never processed - nothing is ever done with them.
    -   how can we find the balance of a miner or person? Assume by calling the `/blocks` route from a node after finding consensus, and then adding up all transactions in there?
