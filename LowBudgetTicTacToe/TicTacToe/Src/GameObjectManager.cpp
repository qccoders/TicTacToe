#include "GameObjectManager.h"

std::vector<GameObject*> GameObjectManager::gameObjects;

void GameObjectManager::AddGameObject(GameObject* gameObject) 
{
	gameObjects.push_back(gameObject);
}

void GameObjectManager::RemoveGameObject(GameObject* gameObject) 
{
	gameObjects.erase(std::remove(gameObjects.begin(), gameObjects.end(), gameObject), gameObjects.end());
	delete gameObject;
}

void GameObjectManager::RemoveAll()
{
	for (GameObject* gameObject : gameObjects)
	{
		delete gameObject;
	}
	gameObjects.clear();
}

void GameObjectManager::Update() 
{
	for (int i = 0; i < gameObjects.size(); i++) 
	{
		gameObjects[i]->Update();
	}
}

void GameObjectManager::Render()
{
	for (int i = 0; i < gameObjects.size(); i++)
	{
		gameObjects[i]->Render();
	}
}