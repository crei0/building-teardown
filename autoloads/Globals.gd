extends Node

enum BuildingType {
	EmpireState,
	BigBen,
	OldBridge,
	Basic2x2x4,
}

const EXPLOSION_SCALE: float = 1.5
const INPUT_MOUSE_LEFT: String = "mouse_click_left"
const INPUT_MOUSE_RIGHT: String = "mouse_click_right"
const INPUT_MOUSE_WHEEL_UP: String = "mouse_wheel_up"
const INPUT_MOUSE_WHEEL_DOWN: String = "mouse_wheel_down"

signal wake_up_rigid_bodies
signal building_currently_active_was_changed(building_type: BuildingType)
