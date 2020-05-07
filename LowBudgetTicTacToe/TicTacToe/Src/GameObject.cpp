#include "GameObject.h"
#include "TextureManager.h"

GameObject::GameObject(const char* texturesheet, SDL_Renderer* ren, int x, int y, int w, int h)
{
	renderer = ren;
	objTexture = TextureManager::LoadTexture(texturesheet, ren);

	xpos = x - w;
	ypos = y - h;

	srcRect.h = h;
	srcRect.w = w;
	srcRect.x = 0;
	srcRect.y = 0;

	destRect.w = srcRect.w * 2;
	destRect.h = srcRect.h * 2;

	width = w * 2;
	height = h * 2;

	destRect.x = xpos;
	destRect.y = ypos;
}

GameObject::~GameObject()
{}

void GameObject::Update()
{
}

void GameObject::Render()
{
	SDL_RenderCopy(renderer, objTexture, &srcRect, &destRect);
}