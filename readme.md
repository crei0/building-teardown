# Building teardown experiment

Inspired by [Creating fully destructible cities while maintaining 60FPS](https://www.gamedeveloper.com/design/creating-fully-destructible-cities-while-maintaining-60fps)

# Current state:

**WIP**

# Credits

- André Guedes

# Sound Effect(s):

- [Sound Effect by LoLa Joy from Pixabay](https://pixabay.com/sound-effects/bomb-explosion-2-381970/)

# TODO:

## Phase 1

* [x] Move explosion to world tree,
* [x] Make the explosion work
* [x] 3D Model the Empire state building blocks
* [x] Press left click and hold to generate area of explosion
* [x] Release left click to explode area
* [x] Change explosion to use an Area2D?
* [x] Improve visuals of building
* [x] Improve visuals of explosion
	* - https://www.youtube.com/watch?v=RtJJVjjM_-Q 
- [x] Reposition the camera at the start, so that the camera is centered on the Building's AABB
- [x] Fix finding neighbours not working
- [x] Fix UV mapping not being correctly exported? (for BigBen blocks)
- [x] Fix building changing not clearing the container
- [x] Change color of block depending on the damage
- [x] Fix explosion animation not playing on left click release
- [x] On building change/reload explosions need to disappear instantly
- [ ] Lerp on zoom change
* [ ] Publish repository to GitHub
* [ ] Export for the web to GitHub Pages

## Phase 2

- [ ] Damage when collisions between blocks happen
- [ ] Damage when collisions between a block and the floor happens