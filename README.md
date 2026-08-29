# Modelling and Simulation of Belief System Dynamics on Influence Networks

## Overview

This project investigates **belief dynamics in time-varying social influence networks with logic constraints and stochastic interactions**.

The model combines concepts from classical opinion dynamics models with logical interdependencies between multiple topics. A time-varying social influence network is constructed based on:

* **Homophily and bounded confidence**
* **Opinion similarity**
* **Stochastic interactions**
* **Logical dependencies between topics**

The simulation is implemented in **MATLAB** and examines how different network structures and logic matrix structures influence the long-term evolution of opinions.

## Research Questions

This project investigates the following main question:

> How do time-varying social influence networks, incorporating logical constraints and stochastic interactions, affect opinion dynamics and long-term outcomes?

The study further explores:

1. What types of social influence network structures emerge under homophily and random interactions?
2. How do social influence network structures and logical constraints affect the evolution of opinions over time?

## Methodology

Each agent holds opinions across multiple topics. At each time step, opinions are updated according to social influence from other agents and the agent's logical interdependency structure.

The proposed model incorporates:

* **DeGroot-style social influence**
* **Hegselmann–Krause bounded confidence**
* **Time-varying influence networks**
* **Stochastic interactions between agents**
* **Logic matrices representing dependencies between topics**

The influence weight between agents decreases as the difference between their opinions increases. Agents only influence one another when their opinions satisfy the bounded confidence condition.

The influence network is updated dynamically throughout the simulation.

## Logic Matrix Structures

Three logic interdependency structures are considered:

* **Cascade structure** – Earlier topics influence subsequent topics.
* **Competing structure** – Topics can exert opposing influences on one another.
* **Mixed structure** – Reinforcing and contradictory relationships coexist between topics.

## Simulation Settings

The simulations compare:

* A **static social influence network**
* A **time-varying network with ε = 0.5**
* A **time-varying network with ε = 0.1**

Different population sizes and logic structures are used to investigate consensus, diversity, clustering, and opinion fragmentation.

## Key Findings

The simulation results show that:

* **Homophily plays a central role in network formation.**
* A sufficiently large bounded confidence threshold can allow an initially weakly connected network to evolve into a **strongly connected network**.
* A smaller bounded confidence threshold leads to **network fragmentation and greater opinion diversity**.
* **Stochastic interactions produce oscillatory behaviour** in opinion trajectories.
* The structure of logical interdependencies determines whether opinions tend toward **consensus or persistent diversity**.
* Strongly connected networks allow information to propagate more effectively across agents.

## Repository Structure

```text
Modelling-and-Simulation-of-Belief-System-Dynamics-on-Influence-Networks/
│
├── SRC/
│   ├── MainConstantW.m
│   ├── MainDynamicW.m
│   │
│   └── matrices/
│       └── MATLAB functions and matrices used in the simulations
│
├── Report/
│   └── Belief_System.pdf
│
└── README.md
```

## Source Code

The `SRC` folder contains the MATLAB implementation of the belief dynamics simulations.

### Main Scripts

* [`MainConstantW.m`](https://github.com/Chuafavang/Modelling-and-Simulation-of-Belief-System-Dynamics-on-Influence-Networks/blob/main/MainConstantW.m)
  Runs the simulation using a **constant/static social influence network**.

* [`MainDynamicW.m`](https://github.com/Chuafavang/Modelling-and-Simulation-of-Belief-System-Dynamics-on-Influence-Networks/blob/main/MainDynamicW.m)
  Runs the simulation using a **time-varying social influence network** with bounded confidence and stochastic interactions.

### Supporting Functions

Additional MATLAB functions and matrices are located in the [`matrices`](https://github.com/Chuafavang/Modelling-and-Simulation-of-Belief-System-Dynamics-on-Influence-Networks/tree/main/matrices) folder.

## Report

The complete research report, including the methodology, mathematical formulation, simulation results, discussion, and references, is available here:

📄 [`Belief_System.pdf`](./Report/Belief_System.pdf)

## Requirements

The project was implemented using:

* MATLAB

## Author

**Chuafa Vachoima**


**Project Supervisor:** Dr Mengbin Ye

## References

The project builds upon research in opinion dynamics and belief systems, including:

* DeGroot (1974) – *Reaching a Consensus*
* Hegselmann & Krause (2002) – *Opinion Dynamics and Bounded Confidence Models*
* Ye et al. (2020) – *Consensus and Disagreement of Heterogeneous Belief Systems in Influence Networks*
* Cheng et al. (2025) – *Multidimensional Opinion Dynamics with Heterogeneous Bounded Confidences and Random Interactions*

For the complete list of references, please refer to the project report.
