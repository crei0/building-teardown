# Building teardown experiment

Inspired by [Creating fully destructible cities while maintaining 60FPS](https://www.gamedeveloper.com/design/creating-fully-destructible-cities-while-maintaining-60fps)

This is a simplified implementation of the link above using Godot, built as a proof of concept.
The main purpose is to make explosions (using the mouse) in certain locations of the buildings and with that causing the collapse of the building.

# Credits

- André Guedes (2025)

# Sound Effect(s):

- [Sound Effect by LoLa Joy from Pixabay](https://pixabay.com/sound-effects/bomb-explosion-2-381970/)

# TODO:

## Proof of concept

* [x] Move explosion to world tree,
* [x] Make the explosion work
* [x] 3D Model the Empire state building blocks
* [x] Press left click and hold to generate area of explosion
* [x] Release left click to explode area
* [x] Change explosion to use an Area2D?
* [x] Improve visuals of building
* [x] Improve visuals of explosion
	* https://www.youtube.com/watch?v=RtJJVjjM_-Q 
* [x] Reposition the camera at the start, so that the camera is centered on the Building's AABB
* [x] Fix finding neighbours not working
* [x] Fix UV mapping not being correctly exported? (for BigBen blocks)
* [x] Fix building changing not clearing the container
* [x] Change color of block depending on the damage
* [x] Fix explosion animation not playing on left click release
* [x] On building change/reload explosions need to disappear instantly
* [x] Change zoom level depending on the size of the building
* [x] Interpolate zoom changes
* [x] Check if Empire state collection is working correctly (pinjoints working)?
* [x] Clicking outside "map" makes an explosion at root origin
* [ ] Test explosion sound
* [ ] Publish repository to GitHub
* [ ] Export for the web to GitHub Pages

## Maybe someday

* [ ] Damage when collisions between blocks happen
* [ ] Damage when collisions between a block and the floor happens
* [ ] Sound effects when blocks collide with floor or each other
* [ ] Create more blocks for the Empire State building (mast/antenna on the top of the building)
* [ ] Make explosion VFX bigger/smaller depending on the `explosion_size_multiplier`