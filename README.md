# Multiplayer Game Development Learning Project

## Learning Outcomes:

### Multiplayer:

- Steam Peer to peer Hosting using Steam's API
- Localhost IPv4 Peer to peer Hosting
- Replication of game state between host and clients

* Scene tree
* Syncronized attributes

### Character controller

- Component based movement and interaction system

* Providing reusable components for any character

- Implementation of State Machine and sub- State Machines for character controllers
- States:

* Walk, run, idle, jump, fall and other states

### Design

- Extensive brainstorming of concept
- Case study of effective game design in similar games for well researched decisions
- Structuring game files

## Multiplayer

To achieve multiplayer functionality I have implemented a hosting and joining system utilizing Godot's Multiplayer_Peer-functionality. It can connect hosts using both ENET and Steam. Connecting players with ENET will likely require NAT punch-through. Instead the ENET conneciton mode is used as a localhost. To achieve compatability with Steam's connectivity API I used the Steam Multiplayer Peer library published by expressobits: https://godotengine.org/asset-library/asset/2258

When joining the network_manager.gd initiates the correct multipayer-scene and both hosts connect. When connected, the hosting machine is set as the target of replication, while joining machines will attempt to replicate the target. The replication of the hosting machine's game state is handled by configuring Godot's Synchronizer and MultiplayerRespawn Nodes.

For this learning project, player input and position is being handled locally and replicated to the hosting machine. Which is not safe against attempts to cheat. In a larger scale game where this kind of security is intergral, it can be solved by keeping Authority over position at a hosting server.

## Character Controller

The Character Controller is controlled with a Finite State Machine, with Sub-State-Machines for special States. The State Machine and Sub-State Machine I have implemented are created by TheShaggyDev https://www.youtube.com/watch?v=bNdFXooM1MQ&t=6s. The State Machine passes tick-calls and input-calls down through refrences to each state. It manages which State-refrence it passes the calls to based on what State is the current_state, and what conditions must happen for a change to another state.

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
