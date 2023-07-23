import requests
import logging
import json
import subprocess
from dataclasses import dataclass, field
import random

logger = logging.getLogger(__name__)


@dataclass
class Node:
    container_id: str
    hostname: str
    port: int
    url: str = field(init=False)

    def __post_init__(self):
        self.url = f"http://{self.hostname}:{self.port}"


def parse_raw_nodes(raw_hosts):
    """Parse the output of tc_nodes_up, a string
    with one line per host and comma separated
    container id and network (host + port).

    Example input:
    "57aebfaa6d4a,0.0.0.0:51313->5000/tcp"
    "ed1e3198b99b,0.0.0.0:51314->5000/tcp"
    "a4cdba79d986,0.0.0.0:51315->5000/tcp"
    """
    nodes = dict()
    # split by line breaks
    for line in raw_hosts.strip().split("\n"):
        container, network = line.strip('"').split(",")
        hostname, ports = network.split(":")
        port, _ = ports.split("->")
        nodes[container] = Node(container, hostname, port)

    logging.debug(f"Parsed raw nodes: {nodes}")
    return nodes


def tc_nodes_up():
    """Check if tinycoin nodes are running and return
    a comma separated list of running nodes and their network
    addresses.
    """
    logger.debug("Checking if any tinycoin nodes are running.")
    results = subprocess.run(
        ["docker", "ps", "--filter", "name=tinycoin", '--format="{{.ID}},{{.Ports}}"'],
        capture_output=True,
        encoding="utf-8",
    )

    if results.returncode != 0:
        logger.error(f"docker ps command exited with error: {results}")
        exit(1)
    elif not results.stdout:
        logger.error(
            "No tinycoin containers running. Please start them with `docker compose up`."
        )
        exit(1)
    elif results.stdout:
        logger.debug(f"Tinycoin nodes found: {results.stdout}")
        return results.stdout


def api_request(method, url, headers={}, data={}):
    """Using requests to make API calls and return results."""
    logging.debug(f"Making request: {method=}, {url=}, {headers=}, {data=}")
    if method == "GET":
        # make a GET request
        r = requests.get(url, headers=headers, data=data)
    elif method == "POST":
        # make a POST request
        r = requests.post(url, headers=headers, data=data)
    else:
        raise NotImplementedError(f"Request method not implemented: {method}")

    logging.debug(f"Received response: {r}")
    # abort if 4xx or 5xx response received
    r.raise_for_status()

    return r


def main():
    # check if tinycoin docker processes are running
    results = tc_nodes_up()

    # create a registry of the nodes
    nodes = parse_raw_nodes(results)

    # try out getting the addresses from each node
    for node in nodes.values():
        url = node.url + "/get_miner_address"
        r = api_request("GET", url)
        logging.debug(f"Retrieved miner address for {node.container_id}: {r.text}")

    # register nodes as peers
    for node in nodes.values():
        url = node.url + "/append_peers"
        headers = {"Content-Type": "application/json"}
        payload = [
            peer.url
            for peer in nodes.values()
            if peer.container_id != node.container_id
        ]
        data = json.dumps(payload)
        r = api_request("POST", url, headers, data)
        logging.debug(f"Appended peers to {node}: {r.text}")

    # retrieve peers of a random node
    node = random.choice(list(nodes.keys()))
    logging.debug(f"Retrieving peers for node {node}")
    url = nodes[node].url + "/peers"
    r = api_request("GET", url)
    logging.debug(f"Peers of node {node}: {r.text}")

    # retrieve all peers of peers of a random node
    node = random.choice(list(nodes.keys()))
    logging.debug(f"Retrieving peers of peers for node {node}")
    url = nodes[node].url + "/connect_to_peers_of_peers"
    r = api_request("GET", url)
    logging.debug(f"Peers of peers of node {node}: {r.text}")

    # create some transactions etc etc etc


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    main()
