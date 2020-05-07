#pragma once
#include "GameObject.h"
#include <vector>
#include <algorithm>

class GameObjectManager {
public:
	static void AddGameObject(GameObject* gameObject);
	static void RemoveGameObject(GameObject* gameObject);
	static void RemoveAll();
	static void Update();
	static void Render();

private:
	static std::vector<GameObject*> gameObjects;
};