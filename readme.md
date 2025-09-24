# Summary
Inspired by [Creating fully destructible cities while maintaining 60FPS](https://www.gamedeveloper.com/design/creating-fully-destructible-cities-while-maintaining-60fps)

[![Creating fully destructible cities while maintaining 60FPS](http://img.youtube.com/vi/mBJSeVKWPZ4/0.jpg)](https://www.youtube.com/watch?v=mBJSeVKWPZ4)

This is a simplified implementation of the link above using Godot, built as a proof of concept.
The main purpose is to make explosions (using the mouse) in certain locations of the buildings and with that causing the collapse of the building.

# GitHub interactable page
[https://crei0.github.io/building-teardown/](https://crei0.github.io/building-teardown/)

----

# Credits

## Coding/Godot setup/Building textures
- André Guedes

## Texture assets

- [Uses some textures from Kenney's Prototype Textures](https://www.kenney.nl/assets/prototype-textures)

## Sound Effect:

- [Explosion sound Effect by LoLa Joy from Pixabay](https://pixabay.com/sound-effects/bomb-explosion-2-381970/)

----

# Godot

| Key    			| Value  		|
| ----------------- | -------------	|
| Version  			| 4.5    		|
| Physics Engine	| Jolt Physics	|

----

# TODO: Maybe someday

* [ ] Tweak `PinJoint3D`'s parameters for better building collapse (currently when it starts falling, the building floors start getting detached/in layers)
* [ ] Damage when collisions between blocks happen
* [ ] Damage when collisions between a block and the floor happens
* [ ] Sound effects when blocks collide with floor or each other
* [ ] Create more blocks for the Empire State building (mast/antenna on the top of the building)
* [ ] Make explosion VFX bigger/smaller/different depending on the `explosion_size_multiplier`
