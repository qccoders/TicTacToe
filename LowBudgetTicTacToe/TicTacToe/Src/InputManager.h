#pragma once
#include "SDL.h"

class InputManager
{
public:
	static int mouseX;
	static int mouseY;
	static bool isMouseJustDown;
	static bool isMouseJustUp;

	static void Update(SDL_Event event);
	static void Reset();
};