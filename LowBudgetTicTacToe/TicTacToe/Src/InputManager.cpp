#include "InputManager.h"
#include "Game.h"
#include "SDL.h"
#include <iostream>

int InputManager::mouseX = 0;
int InputManager::mouseY = 0;
bool InputManager::isMouseJustDown = false;
bool InputManager::isMouseJustUp = false;

void InputManager::Reset()
{
	isMouseJustDown = false;
	isMouseJustUp = false;
}

void InputManager::Update(SDL_Event event) 
{
	switch (event.type) {
		case SDL_MOUSEBUTTONDOWN:
			isMouseJustDown = true;
			break;
		case SDL_MOUSEBUTTONUP:
			isMouseJustUp = true;
			break;
			
		default:
			break;
	}

	SDL_GetMouseState(&mouseX, &mouseY);
}