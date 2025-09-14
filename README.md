# Multiplayer Game Development Learning Project

## Learning Outcomes:

### Multiplayer:

- How to set up a Peer to peer system for handling hosting and joining of game instances over the internet using:
  - Steam's Networking API to connect game instances.
  - ENet networking over UDP.
- How to handle Replication and property-Authority so that:
  - The true game state is contained at the hosting machine.
  - The hosting machine's game state is replicated in real time to clients in an effective manner.
  - The client's game state handles the incomming replication from the host without breaking it's own game state.

### Character Controller

- How to set up the framework for an advanced Character Controller using:
  - Reusable components for functionality which can be used for any character, player or NPC.
  - Finite State Machine and Sub State Machines for determining what behaviour and functionality should be excecuted. Example of states:
    * Walk, run, idle, jump, fall and others

### Design
- How to set up a clear and effective folder structure for assets, scripts and scenes.
- How to set up Scenes and Nodes to maintain ease of reuse for several purposes.


## Multiplayer

To achieve multiplayer functionality I have implemented a hosting and joining system utilizing Godot's Multiplayer_Peer-functionality. It can connect hosts using both ENET and Steam. Connecting players with ENET will likely require NAT punch-through. Instead the ENET conneciton mode is used as a localhost. To achieve compatability with Steam's connectivity API I used the Steam Multiplayer Peer library published by expressobits: https://godotengine.org/asset-library/asset/2258
<img width="801" height="581" alt="image" src="https://github.com/user-attachments/assets/9fc4d159-56a9-45a3-a19f-d75fc0ec6b15" />

When joining the network_manager.gd initiates the correct multipayer-scene and both hosts connect. When connected, the hosting machine is set as the target of replication, while joining machines will attempt to replicate the target. The replication of the hosting machine's game state is handled by configuring Godot's Synchronizer and MultiplayerRespawn Nodes.
<img width="795" height="599" alt="image" src="https://github.com/user-attachments/assets/858cf6a6-0bd8-40c8-a93a-25fec288bee7" />
<img width="789" height="592" alt="image" src="https://github.com/user-attachments/assets/46e0d0fe-766c-4be8-80eb-0c7b0fade9a6" />

For this learning project, player input and position is being handled locally and replicated to the hosting machine. Which is not safe against attempts to cheat. In a larger scale game where this kind of security is intergral, it can be solved by keeping Authority over position at a hosting server.

## Character Controller

The Character Controller is controlled with a Finite State Machine, with Sub-State-Machines for special States. The State Machine and Sub-State Machine I have implemented are created by TheShaggyDev https://www.youtube.com/watch?v=bNdFXooM1MQ&t=6s. The State Machine passes tick-calls and input-calls down through refrences to each state. It manages which State-refrence it passes the calls to based on what State is the current_state, and what conditions must happen for a change to another state.
<img width="869" height="771" alt="image" src="https://github.com/user-attachments/assets/c0908ebb-d72a-468a-9dba-7f72fb276fd1" />

In order to create reusable behaviour for my characters, I have implemented components as Interfaces (although Godot does not have Interfaces in this version, I use inheritance of Classes to act like an Interface). There is a component for looking, moving, interacting and being interactable, which can be inherited to create components specialized to the specific characters.

Currenlty the State Machine can hold the following states:

- Idle
- Walking
- Running
- Jumping
- Falling
- Computer (State for interacting with an in-game computer with sub-states)
  - Computer_enter
  - Computer_focus
  - Computer_idle
  - Computer_leave
