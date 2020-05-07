#pragma once
#include "Game.h"

class TextureManager {
public:
	static SDL_Texture* LoadTexture(const char* filename, SDL_Renderer* ren);
};
