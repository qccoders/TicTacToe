#include "Button.h"
#include "InputManager.h"

void Button::OnClick(void (*ActivateFunction)())
{
	WhenClick = ActivateFunction;
}

void Button::Update()
{
	if (InputManager::isMouseJustDown)
	{
		int x = InputManager::mouseX;
		int y = InputManager::mouseY;

		if (x >= xpos && x <= xpos + width && y >= ypos && y <= ypos + height)
		{
			WhenClick();
		}
	}
}