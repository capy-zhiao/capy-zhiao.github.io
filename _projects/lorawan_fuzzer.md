---
layout: page
title: LoRaWAN Fuzzer
description: A fuzzer that sends mutated uplinks from a simulated LoRaWAN device to a ChirpStack network server and records how the server responds.
img: assets/img/projects/thumb_lorawan_fuzzer.png
importance: 4
category: security
github: https://github.com/capy-zhiao/lorawan_note_send
---

[Code on GitHub](https://github.com/capy-zhiao/lorawan_note_send) · Solo project, November 2023 · Built on an open-source LoRaWAN device simulator; the fuzzer, the ChirpStack setup and the guide are mine

{% include figure.liquid loading="eager" path="assets/img/projects/lorawan_fuzz_round.png" title="One fuzzing round" class="img-fluid rounded z-depth-1" %}

<div class="caption">One fuzzing round: the simulated gateway polls the server (PULL DATA), sends the mutated uplink (PUSH DATA), and receives the server's downlink (PULL RESP).</div>

### The problem

LoRaWAN devices reach a network server through gateways, so testing how a server handles unusual traffic needs devices and a gateway. A software device and gateway can send any message on demand.

### What I built

- A test setup with **ChirpStack** as the network server, and a simulated gateway and over-the-air-activated device registered in it. The simulator, in **Python**, handles the LoRaWAN 1.1 join, payload encryption and message integrity codes, and talks to ChirpStack over the Semtech UDP packet-forwarder protocol.
- A `fuzz` command in **Python**: it takes a seed payload, makes 20 mutated versions (each character is replaced by a random printable one with probability 0.5), and sends each one as a confirmed uplink through the simulated gateway. For every round it records whether the server acknowledged the uplink, whether a downlink came back, the downlink type and the device address, and writes the results to a CSV file.
- A step-by-step guide to the setup: configuration, gateway poll, join, uplink and fuzzing.

### Results

In the recorded run, ChirpStack acknowledged all 20 mutated uplinks and answered each with a confirmed downlink.

{% include figure.liquid loading="lazy" path="assets/img/projects/lorawan_fuzz_results.png" title="Fuzzing results" class="img-fluid rounded z-depth-1" zoomable=true %}

<div class="caption">The results file from that run: the mutated payload, gateway acknowledgement, downlink received, downlink type and device address.</div>

### Next step

Only the application payload is mutated so far. Mutating header fields and MAC commands is the next step.
