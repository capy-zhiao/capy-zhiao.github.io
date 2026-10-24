---
layout: page
title: LoRaWAN Fuzzer
description: Sends mutated uplinks from a simulated LoRaWAN device to a ChirpStack network server and checks whether a valid downlink comes back.
img: assets/img/projects/thumb_lorawan_fuzzer.png
importance: 4
home_order: 7 # position on the homepage grid (lower comes first)
category: security
github: https://github.com/capy-zhiao/lorawan_note_send
---

[Code on GitHub](https://github.com/capy-zhiao/lorawan_note_send) · Solo project, November 2023 · Built on an open-source LoRaWAN device simulator; the fuzzer, the ChirpStack setup and the guide are mine

{% include figure.liquid loading="eager" path="assets/img/projects/lorawan_fuzz_round.png" title="One fuzzing round" class="img-fluid rounded z-depth-1" %}

<div class="caption">One fuzzing round: the simulated gateway polls the server (PULL DATA), sends the mutated uplink (PUSH DATA), and receives the server's downlink (PULL RESP).</div>

### The problem

LoRaWAN devices reach a network server through gateways, so testing how a server handles unusual traffic needs devices and a gateway. A software device and gateway can send chosen messages on demand, without radio hardware.

### What I built

- A test setup with **ChirpStack** as the network server, and a simulated gateway and over-the-air-activated device registered in it. The simulator (**Python**, adapted from the open-source one) handles the LoRaWAN 1.1 join, payload encryption and message integrity codes, and talks to ChirpStack over the Semtech UDP packet-forwarder protocol.
- A `fuzz` command in **Python**: it takes a seed payload, makes 20 mutated versions (each character is replaced by a random printable one with probability 0.5), and sends each one as a confirmed uplink through the simulated gateway. For every round it records whether a downlink came back and passed its integrity check, and writes the results to a CSV file.
- A step-by-step guide to the setup: configuration, gateway poll, join, uplink and fuzzing.

### Results

In the recorded run, ChirpStack sent back a downlink for all 20 uplinks, and each one passed the integrity check. That is the expected outcome: the payload is mutated before encryption, so every frame reaches ChirpStack well formed. The run shows the setup works end to end; no anomaly was found.

### Limits

Only the application payload is mutated, before encryption. Header fields and MAC commands are not mutated; that would be the next step.
