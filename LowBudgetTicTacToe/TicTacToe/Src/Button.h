#pragma once
#include "GameObject.h"

class Button : public GameObject {
public:
	using GameObject::GameObject;
	void OnClick(void (*ActivateFunction)());
	void Update() override;

private:
	void (*WhenClick)();
};
