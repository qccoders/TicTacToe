#include "Game.h"
#include "GameObjectManager.h"
#include "InputManager.h"
#include "GameBoard.h"

SDL_Renderer* Game::renderer = nullptr;
SDL_Event Game::event;

Game::Game()
{}

Game::~Game()
{}

void Game::init(const char* title, int xpos, int ypos, int width, int height, bool fullscreen)
{
	int flags = 0;
	if (fullscreen) {
		flags = SDL_WINDOW_FULLSCREEN;
	}

	if (SDL_Init(SDL_INIT_EVERYTHING) == 0)
	{
		window = SDL_CreateWindow(title, xpos, ypos, width, height, flags);
		renderer = SDL_CreateRenderer(window, -1, 0);
		if (renderer) {
			SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
		}
		isRunning = true;
	}
	else {
		isRunning = false;
	}

	GameBoard::instance = new GameBoard();
}

void Game::handleEvents() 
{
	InputManager::Reset();

	while (SDL_PollEvent(&event)) {
		switch (event.type) {
			case SDL_QUIT:
				isRunning = false;
				break;
			default:
				break;
		}

		InputManager::Update(event);
	}
}

void Game::update()
{
	GameBoard::instance->Update();
	GameObjectManager::Update();
}

void Game::render()
{
	SDL_RenderClear(renderer);
	GameObjectManager::Render();
	SDL_RenderPresent(renderer);
}

void Game::clean()
{
	SDL_DestroyWindow(window);
	SDL_DestroyRenderer(renderer);
	SDL_Quit();
}