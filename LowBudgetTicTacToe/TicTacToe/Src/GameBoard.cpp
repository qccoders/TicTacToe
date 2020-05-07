#include "GameBoard.h"
#include "GameObject.h"
#include "GameObjectManager.h"

#include <time.h>
#include <iostream>
#include <stdlib.h>

#include "Button.h"
#include "InputManager.h"

GameBoard* GameBoard::instance;

GameBoard::GameBoard() 
{
	SetMenu();
}

GameBoard::~GameBoard()
{}

void GameBoard::ChooseOPiece()
{
	std::cout << "Player Choose O" << std::endl;
	instance->playerTurn = false;
	instance->playerPiece = 'o';
	instance->aiPiece = 'x';
	
	instance->SetBoard();
}

void GameBoard::ChooseXPiece()
{
	std::cout << "Player Choose X" << std::endl;
	instance->playerTurn = true;
	instance->playerPiece = 'x'; 
	instance->aiPiece = 'o';

	instance->SetBoard();
}

void GameBoard::GoBack()
{
	instance->SetMenu();
}

void GameBoard::Update() 
{
	if (gameIsRunning) 
	{
		if (!playerTurn)
		{
			AIMove();
			playerTurn = true;
		}
		else if (InputManager::isMouseJustDown)
		{
			PlayerMove(InputManager::mouseX, InputManager::mouseY);
		}
	}
}

void GameBoard::PlayerMove(int xpos, int ypos)
{
	if (xpos >= 64 && xpos < 256 && ypos >= 64 && ypos < 256) {
		if (playerTurn)
		{
			int x = (xpos - 64) / 64;
			int y = (ypos - 64) / 64;

			if (PlacePiece(playerPiece, x, y))
			{
				playerTurn = false;
			}
		}
	}
}

bool GameBoard::PlacePiece(char piece, int xIndex, int yIndex)
{
	if (boardState[yIndex][xIndex] == 0) 
	{
		GameObject* pieceObject = nullptr;

		if (piece == 'x')
		{
			pieceObject = new GameObject("Assets/X.png", Game::renderer, xIndex * 64 + 96, yIndex * 64 + 96, 32, 32);
			boardState[yIndex][xIndex] = X_STATE;

			std::cout << "X: " << xIndex << " " << yIndex << std::endl;
		}
		else
		{
			pieceObject = new GameObject("Assets/O.png", Game::renderer, xIndex * 64 + 96, yIndex * 64 + 96, 32, 32);
			boardState[yIndex][xIndex] = O_STATE;
			std::cout << "O: " << xIndex << " " << yIndex << std::endl;
		}
		GameObjectManager::AddGameObject(pieceObject);
		numberOfEmptySlots--;
		CheckWinPattern();
		return true;
	}
	return false;
}

void GameBoard::AIMove()
{
	if (numberOfEmptySlots > 0) {
		int randomNumber = std::rand() % (numberOfEmptySlots);
		//	std::cout << "Random Number: " << randomNumber << std::endl;
		//	std::cout << "Empty Slots: " << numberOfEmptySlots << std::endl;
		int currentNumber = 0;

		for (int y = 0; y < 3; y++)
		{
			for (int x = 0; x < 3; x++)
			{
				if (boardState[y][x] == 0)
				{
					//	std::cout << "State: " << y << " " << x << std::endl;
					if (currentNumber == randomNumber)
					{
						PlacePiece(aiPiece, x, y);
						return;
					}
					currentNumber++;
				}
			}
		}
	}
}

void GameBoard::SetMenu()
{
	GameObjectManager::RemoveAll();

	TitleSign = new GameObject("Assets/Title.png", Game::renderer, 160, 32, 128, 32);
	GameObjectManager::AddGameObject(TitleSign);

	OButton = new Button("Assets/OButton.png", Game::renderer, 160, 230, 32, 32);
	OButton->OnClick(instance->ChooseOPiece);
	GameObjectManager::AddGameObject(OButton);

	XButton = new Button("Assets/XButton.png", Game::renderer, 160, 130, 32, 32);
	XButton->OnClick(instance->ChooseXPiece);
	GameObjectManager::AddGameObject(XButton);

	gameIsRunning = false;
}

void GameBoard::SetBoard()
{
	GameObjectManager::RemoveAll();

	gameIsRunning = true;

	std::srand(time(NULL));

	GameObject* boardTexture = new GameObject("Assets/Board.png", Game::renderer, 160, 160, 96, 96);
	GameObjectManager::AddGameObject(boardTexture);

	BackButton = new Button("Assets/Back.png", Game::renderer, 160, 32, 128, 32);
	BackButton->OnClick(instance->GoBack);
	GameObjectManager::AddGameObject(BackButton);

	for (int x = 0; x < 3; x++)
	{
		for (int y = 0; y < 3; y++)
		{
			boardState[y][x] = 0;
		}
	}

	std::cout << "Game Start" << std::endl;

	numberOfEmptySlots = 9;
}

bool GameBoard::CheckWinCondition(int sum)
{
	if (sum == X_STATE * 3)
	{
		gameIsRunning = false;
		WinSign = new GameObject("Assets/XWin.png", Game::renderer, 160, 288, 128, 32);
		GameObjectManager::AddGameObject(WinSign);
		std::cout << "X WIN" << std::endl;
		return true;
	}
	if (sum == O_STATE * 3)
	{
		gameIsRunning = false;
		WinSign = new GameObject("Assets/OWin.png", Game::renderer, 160, 288, 128, 32);
		GameObjectManager::AddGameObject(WinSign);
		std::cout << "O WIN" << std::endl;
		return true;
	}
	return false;
}

void GameBoard::CheckWinPattern()
{
	int sum = 0;
	for (int y = 0; y < 3; y++)
	{
		for (int x = 0; x < 3; x++)
		{
			sum += boardState[y][x];
		}

		if (CheckWinCondition(sum)) return;
		sum = 0;
	}

	sum = 0;

	for (int x = 0; x < 3; x++)
	{
		for (int y = 0; y < 3; y++)
		{
			sum += boardState[y][x];
		}

		if (CheckWinCondition(sum)) return;
		sum = 0;
	}

	sum = 0;

	for (int x = 0, y = 0; x < 3; x++, y++)
	{
		sum += boardState[y][x];
	}

	if (CheckWinCondition(sum)) return;
	sum = 0;

	for (int x = 0, y = 2; x < 3; x++, y--)
	{
		sum += boardState[y][x];
	}

	if (CheckWinCondition(sum)) return;
	sum = 0;

	if (numberOfEmptySlots == 0)
	{
		gameIsRunning = false;
		WinSign = new GameObject("Assets/Tie.png", Game::renderer, 160, 288, 128, 32);
		GameObjectManager::AddGameObject(WinSign);
		std::cout << "TIE" << std::endl;
		return;
	}

}