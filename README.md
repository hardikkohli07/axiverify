# AXI4 Crossbar & Interconnect Verification

A scalable **UVM-based verification environment** for a **4×4 AXI4 multi-master/multi-slave crossbar interconnect**, designed to verify protocol correctness, arbitration, routing, ordering, and transaction integrity. The verification environment leverages **SystemVerilog**, **UVM**, **SystemVerilog Assertions (SVA)**, and **coverage-driven verification** to validate complex concurrent traffic scenarios.

## Overview

AXI4 interconnects are critical components in modern SoCs, enabling multiple masters to communicate simultaneously with multiple slaves while maintaining protocol compliance and transaction ordering.

This project develops a reusable UVM verification environment capable of generating concurrent traffic from multiple initiators, verifying dynamic routing decisions, handling out-of-order responses, and ensuring compliance with the AXI4 specification under realistic system workloads.

---

## Features

- ✅ Scalable 4×4 AXI4 crossbar verification
- ✅ Multi-master, multi-slave transaction generation
- ✅ Reusable UVM agent architecture
- ✅ Configuration using `uvm_config_db`
- ✅ Concurrent random traffic generation
- ✅ Scoreboard supporting out-of-order response matching
- ✅ Multi-path routing verification
- ✅ 20+ SystemVerilog Assertions (SVA)
- ✅ Functional coverage-driven verification
- ✅ Protocol compliance validation

---

## DUT Architecture

```
              +------------------------------------+
              |        AXI4 Crossbar               |
              |                                    |
 Master 0 --->|                                    |---> Slave 0
 Master 1 --->|        Arbitration & Routing       |---> Slave 1
 Master 2 --->|                                    |---> Slave 2
 Master 3 --->|                                    |---> Slave 3
              +------------------------------------+
```

The interconnect supports:

- Multiple concurrent AXI masters
- Multiple independent slave interfaces
- Address-based routing
- Arbitration between competing masters
- Independent Read and Write channels
- Outstanding transactions
- Out-of-order response handling

---

## UVM Verification Architecture

```
                 +----------------------+
                 |      UVM Test        |
                 +----------+-----------+
                            |
                 Virtual Sequence
                            |
          +-----------------+------------------+
          |                                    |
   Master Agents (4)                    Slave Agents (4)
          |                                    |
          +-----------------+------------------+
                            |
                       AXI4 Crossbar
                            |
          +-----------------+------------------+
          |                                    |
     Functional Coverage               Scoreboard
                                               |
                                 Transaction Matching
```

---

## Verification Components

### AXI Master Agent

- Driver
- Sequencer
- Monitor

Generates constrained-random AXI4 traffic including:

- Single transfers
- Incrementing bursts
- Wrapping bursts
- Concurrent transactions
- Outstanding requests

---

### AXI Slave Agent

Implements configurable slave responses with support for:

- Variable latency
- Back pressure
- Error responses
- Out-of-order completions

---

### Scoreboard

The scoreboard performs:

- Request-response matching
- Out-of-order response tracking
- Multi-path routing validation
- Address decoding verification
- Data integrity checking
- Transaction ID matching

---

### Configuration Database

The environment is fully parameterized using **`uvm_config_db`**, allowing configurable:

- Number of masters
- Number of slaves
- Address maps
- Outstanding transaction depth
- Burst configurations
- Response delays

This enables scalable reuse across different AXI-based designs.

---

## SystemVerilog Assertions (SVA)

More than **20 concurrent assertions** were implemented to verify critical AXI protocol properties, including:

### Handshake Protocol

- VALID remains asserted until READY
- READY/VALID handshake correctness
- Stable control signals during transfer

### Address Channel

- Stable address while VALID is asserted
- Correct burst parameters
- Proper transaction ID propagation

### Data Channel

- Correct WLAST timing
- Read data stability
- Data transfer legality

### Response Channel

- Response ID correctness
- BRESP/RRESP validity
- Response ordering

### General Protocol Checks

- No illegal state transitions
- Outstanding transaction consistency
- Reset behavior
- Channel independence

---

## Functional Coverage

Coverage models were developed for:

### Burst Coverage

- FIXED bursts
- INCR bursts
- WRAP bursts
- Burst lengths
- Burst sizes

### Transaction Coverage

- Read transactions
- Write transactions
- Outstanding requests
- Multiple simultaneous masters

### ID Coverage

- Transaction IDs
- Response IDs
- Outstanding ID combinations

### Routing Coverage

- Master-to-slave paths
- Address regions
- Arbitration outcomes

### Flow Control Coverage

- READY deassertion
- Back pressure
- Stall cycles
- Variable latency

Cross coverage ensures verification across combinations of:

- Burst type × Burst length
- Master × Slave routing
- Transaction ID × Response ID
- Back pressure × Outstanding transactions

---

## Verification Scenarios

The following scenarios were exercised:

- Single master to single slave
- Multiple masters targeting one slave
- One master accessing multiple slaves
- Concurrent read and write traffic
- Heavy contention
- Random address routing
- Out-of-order responses
- Back pressure conditions
- Maximum burst transfers
- Outstanding transaction limits
- Reset during active transfers
- Long randomized regressions

---

## Technologies Used

| Category | Tools / Languages |
|----------|-------------------|
| RTL Verification | SystemVerilog |
| Verification Methodology | UVM |
| Assertions | SystemVerilog Assertions (SVA) |
| Functional Verification | Coverage-Driven Verification |
| Bus Protocol | AXI4 |
| Configuration | `uvm_config_db` |

---

## Repository Structure

```
rtl/
│── axi4_crossbar.sv
│── arbiter.sv
│── address_decoder.sv
│── routing_logic.sv

verification/
│── agents/
│── sequences/
│── environment/
│── scoreboard/
│── assertions/
│── coverage/
│── tests/

README.md
```

---

## Verification Results

- Verified concurrent operation of a **4×4 AXI4 multi-master/multi-slave interconnect**
- Successfully validated arbitration and address-based routing
- Correctly handled out-of-order responses using transaction ID matching
- Integrated **20+ SystemVerilog Assertions** covering critical AXI protocol requirements
- Achieved **100% functional coverage** across critical protocol compliance scenarios, including burst sizes, transaction IDs, routing paths, and back pressure conditions
- Completed randomized regression testing under concurrent traffic and high-contention workloads

---

## Future Improvements

- Add AXI QoS arbitration verification
- Integrate UVM Register Abstraction Layer (RAL)
- Support AXI4-Lite and AXI5 variants
- Add formal verification for arbitration fairness
- Automate regression using Python/Tcl
- Add protocol error injection sequences

---

## Resume Highlights

- Built a **scalable UVM verification environment** for a **4×4 AXI4 multi-master/multi-slave interconnect**, leveraging `uvm_config_db` for reusable configuration and a transaction-level scoreboard to verify out-of-order responses and multi-path routing.
- Integrated **20+ SystemVerilog Assertions (SVA)** to verify AXI4 protocol handshakes, ordering rules, and channel correctness.
- Developed a **coverage-driven verification strategy** achieving **100% functional coverage** across critical protocol scenarios, including burst types, burst sizes, transaction IDs, routing paths, and back pressure conditions.
