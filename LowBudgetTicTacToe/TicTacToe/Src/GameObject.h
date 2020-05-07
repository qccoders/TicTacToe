#pragma once

#include "Game.h"

class GameObject 
{
public:

	GameObject(const char* texturesheet, SDL_Renderer* ren, int x, int y, int w, int h);
	~GameObject();

	virtual void Update();
	void Render();

private:
	SDL_Texture* objTexture;
	SDL_Renderer* renderer;

protected:
	SDL_Rect srcRect, destRect;

	int xpos;
	int ypos;

	int width;
	int height;
};